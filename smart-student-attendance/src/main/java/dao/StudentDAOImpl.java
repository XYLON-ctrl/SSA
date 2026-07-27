package dao;

import model.Student;
import model.Subject;
import model.TimetableEntry;
import model.Mark;
import model.SemesterCGPA;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StudentDAOImpl implements StudentDAO {
    private static final Logger LOGGER = Logger.getLogger(StudentDAOImpl.class.getName());

    // ==========================================
    // SECTION 1: PROFILE & USER DATA
    // ==========================================

    @Override
    public Student getStudentProfile(int userId) {
        // ✅ Uses the NEW user_id column to find the student record
        String sql = "SELECT s.*, u.email, u.username FROM students s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE s.user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student profile for userId: " + userId, e);
        }
        return null;
    }

    @Override
    public List<Map<String, Object>> getRecentActivities(int userId) {
        List<Map<String, Object>> activities = new ArrayList<>();
        String sql = "SELECT action_type, timestamp FROM audit_logs WHERE user_id = ? ORDER BY timestamp DESC LIMIT 10";
        java.time.format.DateTimeFormatter dtFormatter =
                java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("action", rs.getString("action_type"));
                    Timestamp ts = rs.getTimestamp("timestamp");
                    activity.put("timestampFormatted",
                            ts != null ? ts.toLocalDateTime().format(dtFormatter) : "Unknown");
                    activities.add(activity);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching recent activities", e);
        }
        return activities;
    }

    @Override
    public boolean updateFullProfile(int userId, String gender, String dateOfBirthStr,
                                     String bloodGroup, String nationality,
                                     String email, String mobileNumber, String alternateMobile,
                                     String permanentAddress, String correspondenceAddress,
                                     String guardianName, String guardianRelationship,
                                     String guardianContact, String guardianAlternateContact,
                                     String guardianEmail, String guardianOccupation) {

        // ✅ Update students table using user_id
        String sqlStudents = "UPDATE students SET gender=?, date_of_birth=?, blood_group=?, nationality=?, " +
                             "mobile_number=?, alternate_mobile=?, permanent_address=?, correspondence_address=?, " +
                             "guardian_name=?, guardian_relationship=?, guardian_contact=?, " +
                             "guardian_alternate_contact=?, guardian_email=?, guardian_occupation=? " +
                             "WHERE user_id = ?";

        String sqlUsers = "UPDATE users SET email=? WHERE user_id = ?";

        Date dob = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                dob = Date.valueOf(dateOfBirthStr.trim());
            } catch (IllegalArgumentException e) {
                LOGGER.warning("Invalid date format for dateOfBirth: " + dateOfBirthStr);
            }
        }

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sqlStudents)) {
                ps.setString(1, gender);
                ps.setDate(2, dob);
                ps.setString(3, bloodGroup);
                ps.setString(4, nationality);
                ps.setString(5, mobileNumber);
                ps.setString(6, alternateMobile);
                ps.setString(7, permanentAddress);
                ps.setString(8, correspondenceAddress);
                ps.setString(9, guardianName);
                ps.setString(10, guardianRelationship);
                ps.setString(11, guardianContact);
                ps.setString(12, guardianAlternateContact);
                ps.setString(13, guardianEmail);
                ps.setString(14, guardianOccupation);
                ps.setInt(15, userId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlUsers)) {
                ps.setString(1, email);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating full profile for userId: " + userId, e);
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { /* ignore */ }
        }
    }

    // ==========================================
    // SECTION 2: SUBJECTS & ENROLLMENT
    // ==========================================

    @Override
    public List<Subject> getEnrolledSubjects(int studentId) {
        List<Subject> subjects = new ArrayList<>();
        // ✅ Academic queries still use student_id
        String sql = "SELECT DISTINCT sub.subject_id, sub.subject_code, sub.subject_name, sub.credits, sec.semester " +
                     "FROM subjects sub " +
                     "JOIN section_subjects ss ON sub.subject_id = ss.subject_id " +
                     "JOIN sections sec ON ss.section_id = sec.section_id " +
                     "JOIN students st ON st.section_id = sec.section_id " +
                     "WHERE st.student_id = ? AND sec.semester = st.current_semester AND sub.is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) subjects.add(mapSubjectWithSemester(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching enrolled subjects", e);
        }
        return subjects;
    }

    @Override
    public List<Subject> getEnrolledSubjectsBySemester(int studentId, int semester) {
        List<Subject> subjects = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT sub.subject_id, sub.subject_name, sub.subject_code, sub.credits, sec.semester " +
            "FROM section_subjects ssub " +
            "JOIN subjects sub ON ssub.subject_id = sub.subject_id " +
            "JOIN sections sec ON ssub.section_id = sec.section_id " +
            "JOIN students st ON st.section_id = sec.section_id " +
            "WHERE st.student_id = ?");
        if (semester > 0) sql.append(" AND sec.semester = ?");
        sql.append(" ORDER BY sub.subject_name");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, studentId);
            if (semester > 0) ps.setInt(2, semester);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) subjects.add(mapSubjectWithSemester(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching enrolled subjects by semester", e);
        }
        return subjects;
    }

    @Override
    public List<Integer> getAvailableSemesters(int studentId) {
        List<Integer> semesters = new ArrayList<>();
        String sql = "SELECT DISTINCT sec.semester FROM sections sec " +
                     "JOIN students st ON st.section_id = sec.section_id " +
                     "WHERE st.student_id = ? ORDER BY sec.semester ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) semesters.add(rs.getInt("semester"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching available semesters", e);
        }
        return semesters;
    }

    @Override
    public int getTotalSubjectsCount(int studentId) {
        String sql = "SELECT COUNT(DISTINCT sub.subject_id) FROM subjects sub " +
                     "JOIN section_subjects ss ON sub.subject_id = ss.subject_id " +
                     "JOIN students st ON st.section_id = ss.section_id " +
                     "WHERE st.student_id = ? AND ss.semester = st.current_semester";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting subjects", e);
        }
        return 0;
    }

    @Override
    public int getSubjectsCountBySemester(int studentId, int semester) {
        String sql = "SELECT COUNT(DISTINCT ss.subject_id) FROM section_subjects ss " +
                     "JOIN students st ON st.section_id = ss.section_id " +
                     "WHERE st.student_id = ? AND ss.semester = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, semester);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting subjects by semester", e);
        }
        return 0;
    }

    @Override
    public Map<Integer, Integer> getSubjectsCountBySemester(int studentId) {
        Map<Integer, Integer> counts = new LinkedHashMap<>();
        String sql = "SELECT ss.semester, COUNT(DISTINCT ss.subject_id) as count " +
                     "FROM section_subjects ss " +
                     "JOIN students st ON st.section_id = ss.section_id " +
                     "WHERE st.student_id = ? GROUP BY ss.semester ORDER BY ss.semester";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) counts.put(rs.getInt("semester"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting subjects by semester (map)", e);
        }
        return counts;
    }

    // ==========================================
    // SECTION 3: TIMETABLE
    // ==========================================

    @Override
    public List<TimetableEntry> getWeeklyTimetable(int studentId, int semester) {
        List<TimetableEntry> entries = new ArrayList<>();
        String sql = "SELECT t.*, s.subject_name, f.full_name as faculty_name " +
                     "FROM timetable t " +
                     "JOIN subjects s ON t.subject_id = s.subject_id " +
                     "LEFT JOIN faculty f ON t.faculty_id = f.faculty_id " +
                     "JOIN students st ON st.section_id = t.section_id " +
                     "WHERE st.student_id = ? AND t.semester = ? AND t.is_active = 1 " +
                     "ORDER BY FIELD(t.day_of_week,'MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY'), t.start_time";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, semester);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimetableEntry entry = new TimetableEntry();
                    entry.setTimetableId(rs.getInt("timetable_id"));
                    entry.setSubjectId(rs.getInt("subject_id"));
                    entry.setSubjectName(rs.getString("subject_name"));
                    entry.setFacultyId(rs.getInt("faculty_id"));
                    entry.setFacultyName(rs.getString("faculty_name"));
                    entry.setDayOfWeek(rs.getString("day_of_week"));
                    entry.setStartTime(rs.getTime("start_time").toLocalTime());
                    entry.setEndTime(rs.getTime("end_time").toLocalTime());
                    entry.setRoomNumber(rs.getString("room_number"));
                    entry.setSemester(rs.getInt("semester"));
                    entries.add(entry);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching timetable", e);
        }
        return entries;
    }

    @Override
    public int getTodayClassesCount(int studentId, String dayOfWeek) {
        String sql = "SELECT COUNT(*) FROM timetable t " +
                     "JOIN students st ON st.section_id = t.section_id " +
                     "WHERE st.student_id = ? AND t.day_of_week = ? AND t.is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, dayOfWeek);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting today's classes", e);
        }
        return 0;
    }

    @Override
    public int getTomorrowClassesCount(int studentId, String dayOfWeek) {
        String sql = "SELECT COUNT(*) FROM timetable t " +
                     "JOIN students st ON st.section_id = t.section_id " +
                     "WHERE st.student_id = ? AND t.day_of_week = ? AND t.is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, dayOfWeek);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting tomorrow's classes", e);
        }
        return 0;
    }

    // ==========================================
    // SECTION 4: MARKS & GRADES
    // ==========================================

    @Override
    public List<Mark> getStudentMarks(int studentId) {
        List<Mark> marks = new ArrayList<>();
        String sql = "SELECT s.subject_name, m.exam_type, m.marks_obtained, m.max_marks " +
                     "FROM marks m JOIN subjects s ON m.subject_id = s.subject_id " +
                     "WHERE m.student_id = ? " +
                     "ORDER BY s.subject_name, CASE m.exam_type WHEN 'INTERNAL' THEN 1 WHEN 'MIDTERM' THEN 2 WHEN 'FINAL' THEN 3 END";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) marks.add(mapMark(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching marks", e);
        }
        return marks;
    }

    @Override
    public List<Mark> getStudentMarksBySemester(int studentId, int semester) {
        List<Mark> marks = new ArrayList<>();
        String sql = "SELECT s.subject_name, m.exam_type, m.marks_obtained, m.max_marks " +
                     "FROM marks m JOIN subjects s ON m.subject_id = s.subject_id " +
                     "JOIN section_subjects ss ON s.subject_id = ss.subject_id " +
                     "JOIN students st ON st.section_id = ss.section_id " +
                     "WHERE st.student_id = ? AND ss.semester = ? " +
                     "ORDER BY s.subject_name, CASE m.exam_type WHEN 'INTERNAL' THEN 1 WHEN 'MIDTERM' THEN 2 WHEN 'FINAL' THEN 3 END";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, semester);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) marks.add(mapMark(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching marks by semester", e);
        }
        return marks;
    }

    @Override
    public List<Mark> getStudentMarksByExamType(int studentId, String examType) {
        List<Mark> marks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.subject_name, m.exam_type, m.marks_obtained, m.max_marks " +
            "FROM marks m JOIN subjects s ON m.subject_id = s.subject_id WHERE m.student_id = ?");
        if (examType != null && !examType.trim().isEmpty()) sql.append(" AND m.exam_type = ?");
        sql.append(" ORDER BY s.subject_name, CASE m.exam_type WHEN 'INTERNAL' THEN 1 WHEN 'MIDTERM' THEN 2 WHEN 'FINAL' THEN 3 END");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, studentId);
            if (examType != null && !examType.trim().isEmpty()) ps.setString(2, examType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) marks.add(mapMark(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching marks by exam type", e);
        }
        return marks;
    }

    @Override
    public List<Mark> getStudentMarksBySemesterAndExamType(int studentId, int semester, String examType) {
        List<Mark> marks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.subject_name, m.exam_type, m.marks_obtained, m.max_marks " +
            "FROM marks m JOIN subjects s ON m.subject_id = s.subject_id " +
            "JOIN section_subjects ss ON s.subject_id = ss.subject_id " +
            "JOIN students st ON st.section_id = ss.section_id " +
            "WHERE st.student_id = ? AND ss.semester = ?");
        if (examType != null && !examType.trim().isEmpty()) sql.append(" AND m.exam_type = ?");
        sql.append(" ORDER BY s.subject_name, CASE m.exam_type WHEN 'INTERNAL' THEN 1 WHEN 'MIDTERM' THEN 2 WHEN 'FINAL' THEN 3 END");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, studentId);
            ps.setInt(2, semester);
            if (examType != null && !examType.trim().isEmpty()) ps.setString(3, examType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) marks.add(mapMark(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching marks by semester and exam type", e);
        }
        return marks;
    }

    @Override
    public List<Mark> getFilteredMarks(int studentId, int semester, String examType, int subjectId) {
        List<Mark> marks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.subject_name, m.exam_type, m.marks_obtained, m.max_marks " +
            "FROM marks m JOIN subjects s ON m.subject_id = s.subject_id " +
            "JOIN section_subjects ss ON s.subject_id = ss.subject_id " +
            "JOIN students st ON st.section_id = ss.section_id WHERE st.student_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(studentId);
        if (semester > 0) { sql.append(" AND ss.semester = ?"); params.add(semester); }
        if (examType != null && !examType.trim().isEmpty()) { sql.append(" AND m.exam_type = ?"); params.add(examType); }
        if (subjectId > 0) { sql.append(" AND m.subject_id = ?"); params.add(subjectId); }
        sql.append(" ORDER BY s.subject_name, CASE m.exam_type WHEN 'INTERNAL' THEN 1 WHEN 'MIDTERM' THEN 2 WHEN 'FINAL' THEN 3 END");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else if (p instanceof String) ps.setString(i + 1, (String) p);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) marks.add(mapMark(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching filtered marks", e);
        }
        return marks;
    }

    @Override
    public int getTotalMarksCount(int studentId) {
        String sql = "SELECT COUNT(*) FROM marks WHERE student_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting total marks", e);
        }
        return 0;
    }

    // ==========================================
    // SECTION 5: PERFORMANCE ANALYTICS
    // ==========================================

    @Override
    public List<SemesterCGPA> getSemesterWiseCGPAWithSemesterNumber(int studentId) {
        List<SemesterCGPA> list = new ArrayList<>();
        String sql = "SELECT ss.semester, (SUM(m.marks_obtained)/SUM(m.max_marks))*100 as percentage " +
                     "FROM marks m JOIN section_subjects ss ON m.subject_id = ss.subject_id " +
                     "JOIN students st ON st.section_id = ss.section_id " +
                     "WHERE st.student_id = ? GROUP BY ss.semester ORDER BY ss.semester ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    double pct = rs.getDouble("percentage");
                    double cgpa = convertPercentageToCGPA(pct);
                    list.add(new SemesterCGPA(rs.getInt("semester"), Math.round(cgpa * 100.0) / 100.0));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching semester wise CGPA", e);
        }
        return list;
    }

    @Override
    public Map<Integer, Double> getSemesterWiseCGPA(int studentId) {
        Map<Integer, Double> result = new LinkedHashMap<>();
        for (SemesterCGPA sc : getSemesterWiseCGPAWithSemesterNumber(studentId)) {
            result.put(sc.getSemester(), sc.getCgpa());
        }
        return result;
    }
    
    @Override
    public Map<Integer, Double> getSemesterWiseSGPA(int studentId) {
        LOGGER.info("=== DAO: Fetching semester SGPA for studentId: " + studentId);
        Map<Integer, Double> sgpaMap = new LinkedHashMap<>();
        String sql = "SELECT sem_1_sgpa, sem_2_sgpa, sem_3_sgpa, sem_4_sgpa, " +
                     "sem_5_sgpa, sem_6_sgpa, sem_7_sgpa, sem_8_sgpa " +
                     "FROM student_semester_performance WHERE student_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LOGGER.info("DAO: Found record for studentId: " + studentId);
                    for (int i = 1; i <= 8; i++) {
                        double val = rs.getDouble("sem_" + i + "_sgpa");
                        LOGGER.info("DAO: Semester " + i + " SGPA: " + val);
                        if (val > 0) {
                            sgpaMap.put(i, val);
                        }
                    }
                    LOGGER.info("DAO: Total semesters with data: " + sgpaMap.size());
                } else {
                    LOGGER.severe("DAO: NO RECORD FOUND for studentId: " + studentId);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "DAO: Error fetching semester SGPA", e);
        }
        return sgpaMap;
    }

    @Override
    public Map<Integer, Map<String, Object>> getSemesterExamTotals(int studentId) {
        Map<Integer, Map<String, Object>> totalsMap = new LinkedHashMap<>();
        String sql = "SELECT ss.semester, COUNT(DISTINCT m.subject_id) as total_subjects, " +
                     "SUM(m.marks_obtained) as total_obtained, SUM(m.max_marks) as total_max " +
                     "FROM marks m JOIN subjects sub ON m.subject_id = sub.subject_id " +
                     "JOIN section_subjects ss ON sub.subject_id = ss.subject_id " +
                     "JOIN students st ON st.section_id = ss.section_id " +
                     "WHERE st.student_id = ? GROUP BY ss.semester ORDER BY ss.semester";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("totalSubjects", rs.getInt("total_subjects"));
                    data.put("totalObtained", rs.getDouble("total_obtained"));
                    data.put("totalMax", rs.getDouble("total_max"));
                    totalsMap.put(rs.getInt("semester"), data);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching semester exam totals", e);
        }
        return totalsMap;
    }

    @Override
    public int getTotalPossibleCredits(int studentId) {
        String sql = "SELECT SUM(s.credits) as total_credits FROM subjects s " +
                     "WHERE s.subject_id IN (SELECT DISTINCT m.subject_id FROM marks m WHERE m.student_id = ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total_credits");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total possible credits", e);
        }
        return 0;
    }

    @Override
    public int getTotalCreditsEarned(int studentId) {
        String sql = "SELECT SUM(s.credits) as total_credits FROM subjects s " +
                     "WHERE s.subject_id IN (SELECT m.subject_id FROM marks m WHERE m.student_id = ? " +
                     "GROUP BY m.subject_id HAVING AVG((m.marks_obtained/m.max_marks)*100) >= 40)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total_credits");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total credits earned", e);
        }
        return 0;
    }

    @Override
    public int getClassRank(int studentId, String batch) {
        String sql = "SELECT COUNT(DISTINCT s2.student_id) as student_rank FROM students s1 " +
                     "JOIN students s2 ON s1.batch = s2.batch " +
                     "WHERE s1.student_id = ? AND s1.batch = ? " +
                     "AND (s2.cgpa > s1.cgpa OR (s2.cgpa = s1.cgpa AND s2.student_id < s1.student_id))";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, batch);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("student_rank") + 1;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating class rank", e);
        }
        return 0;
    }

    @Override
    public int getTotalStudentsInBatch(String batch) {
        String sql = "SELECT COUNT(*) FROM students WHERE batch = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, batch);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting students in batch", e);
        }
        return 0;
    }
    
    @Override
    public int getTotalStudentCount() {
        String sql = "SELECT COUNT(*) FROM students";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ==========================================
    // HELPER METHODS
    // ==========================================

    private double convertPercentageToCGPA(double percentage) {
        return percentage / 9.5;
    }

    private Student mapStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setUsername(rs.getString("username"));
        s.setEnrollmentNumber(rs.getString("enrollment_number"));
        s.setBranch(rs.getString("branch"));
        s.setDepartment(rs.getString("department"));
        s.setCurrentSemester(rs.getInt("current_semester"));
        s.setCgpa(rs.getDouble("cgpa"));
        s.setBatch(rs.getString("batch"));

        Date admDate = rs.getDate("admission_date");
        if (admDate != null) s.setAdmissionDate(admDate.toLocalDate());

        s.setGender(rs.getString("gender"));

        Date dob = rs.getDate("date_of_birth");
        if (dob != null) s.setDateOfBirth(dob.toLocalDate());

        s.setBloodGroup(rs.getString("blood_group"));
        s.setNationality(rs.getString("nationality"));
        s.setMobileNumber(rs.getString("mobile_number"));
        s.setAlternateMobile(rs.getString("alternate_mobile"));
        s.setPermanentAddress(rs.getString("permanent_address"));
        s.setCorrespondenceAddress(rs.getString("correspondence_address"));
        s.setGuardianName(rs.getString("guardian_name"));
        s.setGuardianRelationship(rs.getString("guardian_relationship"));
        s.setGuardianContact(rs.getString("guardian_contact"));
        s.setGuardianAlternateContact(rs.getString("guardian_alternate_contact"));
        s.setGuardianEmail(rs.getString("guardian_email"));
        s.setGuardianOccupation(rs.getString("guardian_occupation"));
        s.setExpectedGraduationYear(rs.getInt("expected_graduation_year"));
        s.setClassAdvisorId(rs.getInt("class_advisor_id"));
        s.setDepartmentId(rs.getInt("department_id"));
        s.setSectionId(rs.getInt("section_id"));
        s.setActive(rs.getBoolean("is_active"));
        return s;
    }

    private Subject mapSubjectWithSemester(ResultSet rs) throws SQLException {
        Subject sub = new Subject();
        sub.setSubjectId(rs.getInt("subject_id"));
        sub.setSubjectCode(rs.getString("subject_code"));
        sub.setSubjectName(rs.getString("subject_name"));
        sub.setCredits(rs.getInt("credits"));
        try {
            int sem = rs.getInt("semester");
            sub.setSemester(rs.wasNull() ? 0 : sem);
        } catch (SQLException e) {
            sub.setSemester(0);
        }
        return sub;
    }

    private Mark mapMark(ResultSet rs) throws SQLException {
        Mark m = new Mark();
        m.setSubjectName(rs.getString("subject_name"));
        m.setExamType(rs.getString("exam_type"));
        m.setMarksObtained(rs.getDouble("marks_obtained"));
        m.setMaxMarks(rs.getDouble("max_marks"));
        return m;
    }
}