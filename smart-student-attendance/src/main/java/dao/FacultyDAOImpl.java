package dao;

import model.*;
import util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FacultyDAOImpl implements FacultyDAO {
    private static final Logger LOGGER = Logger.getLogger(FacultyDAOImpl.class.getName());

    // ===== 1. PROFILE =====
    @Override
    public Faculty getFacultyProfile(int facultyId) {
        String sql = "SELECT * FROM faculty WHERE faculty_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Faculty f = new Faculty();
                    f.setFacultyId(rs.getInt("faculty_id"));
                    f.setFullName(rs.getString("full_name"));
                    f.setEmail(rs.getString("email"));
                    f.setPhoneNumber(rs.getString("phone_number"));
                    f.setAlternatePhone(rs.getString("alternate_phone"));
                    f.setOfficeLocation(rs.getString("office_location"));
                    f.setEmployeeId(rs.getString("employee_id"));
                    f.setDepartment(rs.getString("department"));
                    f.setDesignation(rs.getString("designation"));
                    f.setQualification(rs.getString("qualification"));
                    f.setSpecialization(rs.getString("specialization"));
                    f.setExperienceYears(rs.getInt("experience_years"));
                    f.setResearchArea(rs.getString("research_area"));
                    f.setResearchInterests(rs.getString("research_interests"));
                    f.setPublicationsCount(rs.getInt("publications_count"));
                    f.setCertifications(rs.getString("certifications"));
                    f.setGoogleScholar(rs.getString("google_scholar"));
                    f.setLinkedinProfile(rs.getString("linkedin_profile"));
                    f.setOrcidId(rs.getString("orcid_id"));
                    f.setAcademicWebsite(rs.getString("academic_website"));
                    f.setAddress(rs.getString("address"));
                    f.setCity(rs.getString("city"));
                    f.setState(rs.getString("state"));
                    f.setPostalCode(rs.getString("postal_code"));
                    Date joinDate = rs.getDate("joining_date");
                    f.setJoiningDate(joinDate != null ? joinDate.toLocalDate() : null);
                    f.setClassAdvisor(rs.getBoolean("is_class_advisor"));
                    Object advisorId = rs.getObject("advisor_section_id");
                    f.setAdvisorSectionId(advisorId != null ? ((Number) advisorId).intValue() : null);
                    return f;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty profile", e);
        }
        return null;
    }

    @Override
    public boolean updateFacultyProfile(Faculty faculty) {
        String sql = "UPDATE faculty SET full_name=?, email=?, phone_number=?, alternate_phone=?, " +
                     "office_location=?, qualification=?, specialization=?, experience_years=?, " +
                     "research_area=?, research_interests=?, publications_count=?, certifications=?, " +
                     "google_scholar=?, linkedin_profile=?, orcid_id=?, academic_website=?, " +
                     "address=?, city=?, state=?, postal_code=? WHERE faculty_id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, faculty.getFullName());
            ps.setString(2, faculty.getEmail());
            ps.setString(3, faculty.getPhoneNumber());
            ps.setString(4, faculty.getAlternatePhone());
            ps.setString(5, faculty.getOfficeLocation());
            ps.setString(6, faculty.getQualification());
            ps.setString(7, faculty.getSpecialization());
            ps.setInt(8, faculty.getExperienceYears());
            ps.setString(9, faculty.getResearchArea());
            ps.setString(10, faculty.getResearchInterests());
            ps.setInt(11, faculty.getPublicationsCount());
            ps.setString(12, faculty.getCertifications());
            ps.setString(13, faculty.getGoogleScholar());
            ps.setString(14, faculty.getLinkedinProfile());
            ps.setString(15, faculty.getOrcidId());
            ps.setString(16, faculty.getAcademicWebsite());
            ps.setString(17, faculty.getAddress());
            ps.setString(18, faculty.getCity());
            ps.setString(19, faculty.getState());
            ps.setString(20, faculty.getPostalCode());
            ps.setInt(21, faculty.getFacultyId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating faculty profile", e);
        }
        return false;
    }
    
    @Override
    public List<Subject> getAssignedSubjects(int facultyId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT DISTINCT s.subject_id, s.subject_code, s.subject_name, s.credits, " +
                     "sec.semester " +
                     "FROM subjects s " +
                     "JOIN faculty_subjects fs ON s.subject_id = fs.subject_id " +
                     "LEFT JOIN timetable t ON s.subject_id = t.subject_id AND t.faculty_id = ? " +
                     "LEFT JOIN sections sec ON t.section_id = sec.section_id " +
                     "WHERE fs.faculty_id = ? AND s.is_active = 1 " +
                     "ORDER BY sec.semester, s.subject_code";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            ps.setInt(2, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    subjects.add(mapSubjectWithSemester(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching assigned subjects", e);
        }
        return subjects;
    }

    @Override
    public Map<String, Object> getWorkloadSummary(int facultyId) {
        Map<String, Object> summary = new HashMap<>();
        
        String sql1 = "SELECT COUNT(*) as class_count FROM timetable WHERE faculty_id = ? AND is_active = 1";
        String sql2 = "SELECT COUNT(DISTINCT section_id) as section_count FROM faculty_subjects WHERE faculty_id = ?";
        String sql3 = "SELECT COUNT(DISTINCT subject_id) as subject_count FROM faculty_subjects WHERE faculty_id = ?";
        String sql4 = "SELECT COUNT(DISTINCT attendance_date) as session_count FROM attendance_records WHERE marked_by = ?";
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql1)) {
                ps.setInt(1, facultyId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) summary.put("classesPerWeek", rs.getInt("class_count"));
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sql2)) {
                ps.setInt(1, facultyId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) summary.put("sectionsHandling", rs.getInt("section_count"));
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sql3)) {
                ps.setInt(1, facultyId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) summary.put("subjectsAssigned", rs.getInt("subject_count"));
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sql4)) {
                ps.setInt(1, facultyId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) summary.put("attendanceSessions", rs.getInt("session_count"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching workload summary", e);
        }
        
        summary.putIfAbsent("classesPerWeek", 0);
        summary.putIfAbsent("sectionsHandling", 0);
        summary.putIfAbsent("subjectsAssigned", 0);
        summary.putIfAbsent("attendanceSessions", 0);
        
        return summary;
    }

    @Override
    public List<Map<String, Object>> getRecentActivities(int facultyId) {
        List<Map<String, Object>> activities = new ArrayList<>();
        String sql = "SELECT action_type, description, timestamp FROM audit_logs " +
                     "WHERE user_id = ? ORDER BY timestamp DESC LIMIT 10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("actionType", rs.getString("action_type"));
                    activity.put("description", rs.getString("description"));
                    activity.put("timestamp", rs.getTimestamp("timestamp"));
                    activities.add(activity);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching recent activities", e);
        }
        return activities;
    }
    
    
    
    @Override
    public int getFacultyIdByEmail(String email) {

        String sql =
            "SELECT faculty_id " +
            "FROM faculty " +
            "WHERE email = ?";

        try (
            Connection conn = DatabaseUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt("faculty_id");
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                "Error getting faculty id by email", e);
        }

        return -1;
    }
    
    @Override
    public Faculty getFacultyByUserId(int userId) {
        String sql = "SELECT f.*, d.department_name FROM faculty f " +
                     "LEFT JOIN departments d ON f.department_id = d.department_id " +
                     "WHERE f.user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Faculty faculty = mapFaculty(rs);
                    faculty.setDepartment(rs.getString("department_name"));
                    return faculty;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty by user_id", e);
        }
        return null;
    }
    
    // ===== 2. DASHBOARD =====
    @Override
    public int getTodayClassesCount(int facultyId, String dayOfWeek) {
        String sql = "SELECT COUNT(*) FROM timetable WHERE faculty_id = ? AND day_of_week = ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
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
    public int getTotalStudentsTeaching(int facultyId) {
        // ✅ FIXED: Use students.section_id instead of section_students
        String sql = "SELECT COUNT(DISTINCT s.student_id) FROM faculty_subjects fs " +
                     "JOIN students s ON fs.section_id = s.section_id WHERE fs.faculty_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting students", e);
        }
        return 0;
    }

    @Override
    public List<TimetableEntry> getTodayTimetable(int facultyId, String dayOfWeek) {
        List<TimetableEntry> entries = new ArrayList<>();
        String sql = "SELECT t.*, s.subject_name, sec.section_name FROM timetable t " +
                     "JOIN subjects s ON t.subject_id = s.subject_id " +
                     "JOIN sections sec ON t.section_id = sec.section_id " +
                     "WHERE t.faculty_id = ? AND t.day_of_week = ? AND t.is_active = 1 " +
                     "ORDER BY t.start_time";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            ps.setString(2, dayOfWeek);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimetableEntry t = mapTimetableEntry(rs);
                    t.setSectionName(rs.getString("section_name"));
                    entries.add(t);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching today's timetable", e);
        }
        return entries;
    }

    // ===== 3. ATTENDANCE =====
    @Override
    public boolean markAttendance(int studentId, int subjectId, LocalDate date, String status, int markedBy, String remarks) {
        String sql = "INSERT INTO attendance_records (student_id, subject_id, attendance_date, status, marked_by, remarks) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setDate(3, Date.valueOf(date));
            ps.setString(4, status);
            ps.setInt(5, markedBy);
            ps.setString(6, remarks);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking attendance", e);
        }
        return false;
    }

    @Override
    public List<Student> getStudentsForAttendance(int subjectId, int sectionId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT s.student_id, s.full_name, s.enrollment_number " +
                     "FROM students s " +
                     "WHERE s.section_id = ? " +
                     "ORDER BY s.full_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student st = new Student();
                    st.setStudentId(rs.getInt("student_id"));
                    st.setFullName(rs.getString("full_name"));
                    st.setEnrollmentNumber(rs.getString("enrollment_number"));
                    students.add(st);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching students for attendance", e);
        }
        return students;
    }

    @Override
    public List<AttendanceRecord> getAttendanceRecords(LocalDate date, int subjectId, int sectionId) {
        List<AttendanceRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM attendance_records " +
                     "WHERE attendance_date = ? AND subject_id = ? " +
                     "AND student_id IN (SELECT student_id FROM students WHERE section_id = ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(date));
            ps.setInt(2, subjectId);
            ps.setInt(3, sectionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AttendanceRecord ar = new AttendanceRecord();
                    ar.setRecordId(rs.getInt("record_id"));
                    ar.setStudentId(rs.getInt("student_id"));
                    ar.setSubjectId(rs.getInt("subject_id"));
                    ar.setAttendanceDate(rs.getDate("attendance_date").toLocalDate());
                    ar.setStatus(rs.getString("status"));
                    ar.setMarkedBy(rs.getInt("marked_by"));
                    ar.setRemarks(rs.getString("remarks"));
                    records.add(ar);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching attendance records", e);
        }
        return records;
    }

    // ===== 4. STUDENTS & SUBJECTS =====
    @Override
    public List<Student> getFacultyStudents(int facultyId) {
        List<Student> students = new ArrayList<>();
        // ✅ FIXED: Use students.section_id instead of section_students
        String sql = "SELECT DISTINCT s.student_id, s.full_name, s.enrollment_number, " +
                     "s.branch, s.current_semester, u.email " +
                     "FROM students s " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "JOIN faculty_subjects fs ON s.section_id = fs.section_id " +
                     "WHERE fs.faculty_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student st = new Student();
                    st.setStudentId(rs.getInt("student_id"));
                    st.setUserId(rs.getInt("student_id"));
                    st.setFullName(rs.getString("full_name"));
                    st.setEmail(rs.getString("email"));
                    st.setEnrollmentNumber(rs.getString("enrollment_number"));
                    st.setBranch(rs.getString("branch"));
                    st.setCurrentSemester(rs.getInt("current_semester"));
                    students.add(st);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty students", e);
        }
        return students;
    }

    @Override
    public List<Subject> getFacultySubjects(int facultyId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT DISTINCT s.subject_id, s.subject_code, s.subject_name, s.credits " +
                     "FROM subjects s " +
                     "INNER JOIN faculty_subjects fs ON s.subject_id = fs.subject_id " +
                     "WHERE fs.faculty_id = ? " +
                     "ORDER BY s.subject_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setSubjectId(rs.getInt("subject_id"));
                    subject.setSubjectCode(rs.getString("subject_code"));
                    subject.setSubjectName(rs.getString("subject_name"));
                    subject.setCredits(rs.getInt("credits"));
                    subjects.add(subject);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty subjects", e);
        }
        return subjects;
    }

    @Override
    public List<Map<String, Object>> getFacultySections(int facultyId) {
        List<Map<String, Object>> sections = new ArrayList<>();
        String sql = "SELECT DISTINCT sec.section_id, sec.section_name, sec.department, sec.semester " +
                     "FROM sections sec " +
                     "INNER JOIN faculty_subjects fs ON sec.section_id = fs.section_id " +
                     "WHERE fs.faculty_id = ? " +
                     "ORDER BY sec.section_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> section = new HashMap<>();
                    // ✅ Keys must match what JSP expects (${sec.sectionId}, ${sec.sectionName})
                    section.put("sectionId", rs.getInt("section_id"));
                    section.put("sectionName", rs.getString("section_name"));
                    section.put("department", rs.getString("department"));
                    section.put("semester", rs.getInt("semester"));
                    sections.add(section);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty sections", e);
        }
        return sections;
    }
    
    @Override
    public String getStudentAttendancePercentage(int studentId, int subjectId) {
        String sql = "SELECT COUNT(*) as total, " +
                     "SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) as present " +
                     "FROM attendance_records " +
                     "WHERE student_id = ? AND subject_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total");
                    int present = rs.getInt("present");
                    if (total == 0) return "0%";
                    double percentage = (present * 100.0) / total;
                    return String.format("%.1f%%", percentage);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating attendance", e);
        }
        return "0%";
    }
    
    @Override
    public List<Student> getFacultyStudentsBySection(int facultyId, int sectionId) {
        List<Student> students = new ArrayList<>();
        // ✅ FIXED: Use students.section_id directly
        String sql = "SELECT DISTINCT s.student_id, s.full_name, s.enrollment_number, " +
                     "s.branch, s.current_semester, u.email " +
                     "FROM students s " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "JOIN faculty_subjects fs ON s.section_id = fs.section_id " +
                     "WHERE fs.faculty_id = ? AND s.section_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            ps.setInt(2, sectionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student st = new Student();
                    st.setStudentId(rs.getInt("student_id"));
                    st.setUserId(rs.getInt("student_id"));
                    st.setFullName(rs.getString("full_name"));
                    st.setEmail(rs.getString("email"));
                    st.setEnrollmentNumber(rs.getString("enrollment_number"));
                    st.setBranch(rs.getString("branch"));
                    st.setCurrentSemester(rs.getInt("current_semester"));
                    students.add(st);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching students by section", e);
        }
        return students;
    }

    @Override
    public List<Student> searchStudents(int facultyId, String searchQuery) {
        List<Student> students = new ArrayList<>();
        // ✅ FIXED: Use students.section_id directly
        String sql = "SELECT DISTINCT s.student_id, s.full_name, s.enrollment_number, " +
                     "s.branch, s.current_semester, u.email " +
                     "FROM students s " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "JOIN faculty_subjects fs ON s.section_id = fs.section_id " +
                     "WHERE fs.faculty_id = ? AND (s.full_name LIKE ? OR s.enrollment_number LIKE ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            ps.setString(2, "%" + searchQuery + "%");
            ps.setString(3, "%" + searchQuery + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student st = new Student();
                    st.setStudentId(rs.getInt("student_id"));
                    st.setUserId(rs.getInt("student_id"));
                    st.setFullName(rs.getString("full_name"));
                    st.setEmail(rs.getString("email"));
                    st.setEnrollmentNumber(rs.getString("enrollment_number"));
                    st.setBranch(rs.getString("branch"));
                    st.setCurrentSemester(rs.getInt("current_semester"));
                    students.add(st);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching students", e);
        }
        return students;
    }

    @Override
    public int getExcellentAttendanceCount(int facultyId, int subjectId) {
        // ✅ FIXED: Use students.section_id in subquery
        String sql = "SELECT COUNT(*) FROM (" +
                     "SELECT ar.student_id, " +
                     "SUM(CASE WHEN ar.status = 'PRESENT' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as percentage " +
                     "FROM attendance_records ar " +
                     "JOIN students s ON ar.student_id = s.student_id " +
                     "JOIN faculty_subjects fs ON s.section_id = fs.section_id " +
                     "WHERE fs.faculty_id = ? AND ar.subject_id = ? " +
                     "GROUP BY ar.student_id " +
                     "HAVING percentage >= 90" +
                     ") as excellent_students";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting excellent attendance", e);
        }
        return 0;
    }
    
    

    @Override
    public int getAtRiskStudentsCount(int facultyId, int subjectId) {
        // ✅ FIXED: Use students.section_id in subquery
        String sql = "SELECT COUNT(*) FROM (" +
                     "SELECT ar.student_id, " +
                     "SUM(CASE WHEN ar.status = 'PRESENT' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as percentage " +
                     "FROM attendance_records ar " +
                     "JOIN students s ON ar.student_id = s.student_id " +
                     "JOIN faculty_subjects fs ON s.section_id = fs.section_id " +
                     "WHERE fs.faculty_id = ? AND ar.subject_id = ? " +
                     "GROUP BY ar.student_id " +
                     "HAVING percentage < 75" +
                     ") as at_risk_students";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting at risk students", e);
        }
        return 0;
    }

    @Override
    public double getAverageAttendance(int facultyId, int subjectId) {
        // ✅ FIXED: Use students.section_id in subquery
        String sql = "SELECT AVG(percentage) FROM (" +
                     "SELECT ar.student_id, " +
                     "SUM(CASE WHEN ar.status = 'PRESENT' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as percentage " +
                     "FROM attendance_records ar " +
                     "JOIN students s ON ar.student_id = s.student_id " +
                     "JOIN faculty_subjects fs ON s.section_id = fs.section_id " +
                     "WHERE fs.faculty_id = ? AND ar.subject_id = ? " +
                     "GROUP BY ar.student_id" +
                     ") as student_percentages";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double avg = rs.getDouble(1);
                    return rs.wasNull() ? 0.0 : avg;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating average attendance", e);
        }
        return 0.0;
    }
    
    @Override
    public Student getStudentById(int studentId) {
        String sql = "SELECT s.*, u.email FROM students s JOIN users u ON s.student_id = u.user_id WHERE s.student_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student st = new Student();
                    st.setStudentId(rs.getInt("student_id"));
                    st.setUserId(rs.getInt("student_id"));
                    st.setFullName(rs.getString("full_name"));
                    st.setEmail(rs.getString("email"));
                    st.setEnrollmentNumber(rs.getString("enrollment_number"));
                    st.setBranch(rs.getString("branch"));
                    st.setDepartment(rs.getString("department"));
                    st.setCurrentSemester(rs.getInt("current_semester"));
                    st.setCgpa(rs.getDouble("cgpa"));
                    st.setBatch(rs.getString("batch"));
                    Date adDate = rs.getDate("admission_date");
                    st.setAdmissionDate(adDate != null ? adDate.toLocalDate() : null);
                    st.setGender(rs.getString("gender"));
                    Date dob = rs.getDate("date_of_birth");
                    st.setDateOfBirth(dob != null ? dob.toLocalDate() : null);
                    st.setBloodGroup(rs.getString("blood_group"));
                    st.setNationality(rs.getString("nationality"));
                    st.setMobileNumber(rs.getString("mobile_number"));
                    st.setAlternateMobile(rs.getString("alternate_mobile"));
                    st.setPermanentAddress(rs.getString("permanent_address"));
                    st.setCorrespondenceAddress(rs.getString("correspondence_address"));
                    st.setGuardianName(rs.getString("guardian_name"));
                    st.setGuardianRelationship(rs.getString("guardian_relationship"));
                    st.setGuardianContact(rs.getString("guardian_contact"));
                    st.setGuardianAlternateContact(rs.getString("guardian_alternate_contact"));
                    st.setGuardianEmail(rs.getString("guardian_email"));
                    st.setGuardianOccupation(rs.getString("guardian_occupation"));
                    st.setExpectedGraduationYear(rs.getInt("expected_graduation_year"));
                    return st;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student by ID", e);
        }
        return null;
    }

    @Override
    public List<Subject> getStudentSubjects(int studentId) {
        List<Subject> subjects = new ArrayList<>();
        // ✅ FIXED: Use students.section_id directly
        String sql = "SELECT DISTINCT sub.*, sec.semester FROM subjects sub " +
                     "JOIN section_subjects ss ON sub.subject_id = ss.subject_id " +
                     "JOIN sections sec ON ss.section_id = sec.section_id " +
                     "JOIN students st ON st.section_id = sec.section_id " +
                     "WHERE st.student_id = ? " +
                     "AND sec.semester = st.current_semester " +
                     "AND sub.is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    subjects.add(mapSubjectWithSemester(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student subjects", e);
        }
        return subjects;
    }

    @Override
    public double getStudentOverallAttendance(int studentId) {
        String sql = "SELECT SUM(CASE WHEN status IN ('PRESENT', 'LATE') THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0) " +
                     "FROM attendance_records WHERE student_id = ? AND status != 'CANCELLED'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double val = rs.getDouble(1);
                    return rs.wasNull() ? 0.0 : val;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating overall attendance", e);
        }
        return 0.0;
    }

    @Override
    public List<Map<String, Object>> getStudentRecentActivities(int studentId) {
        List<Map<String, Object>> activities = new ArrayList<>();
        String sql = "SELECT action_type, description, timestamp FROM audit_logs WHERE user_id = ? ORDER BY timestamp DESC LIMIT 10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("actionType", rs.getString("action_type"));
                    map.put("description", rs.getString("description"));
                    map.put("timestamp", rs.getTimestamp("timestamp"));
                    activities.add(map);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching recent activities", e);
        }
        return activities;
    }

    @Override
    public int getTotalClassesForStudent(int studentId) {
        String sql = "SELECT COUNT(*) FROM attendance_records WHERE student_id = ? AND status != 'CANCELLED'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting total classes", e);
        }
        return 0;
    }

    @Override
    public int getAttendedClassesForStudent(int studentId) {
        String sql = "SELECT COUNT(*) FROM attendance_records WHERE student_id = ? AND status IN ('PRESENT', 'LATE')";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting attended classes", e);
        }
        return 0;
    }

    @Override
    public List<Map<String, Object>> getSubjectWiseAttendance(int studentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.subject_id, s.subject_code, s.subject_name, COUNT(ar.record_id) as conducted, " +
                     "SUM(CASE WHEN ar.status IN ('PRESENT', 'LATE') THEN 1 ELSE 0 END) as attended " +
                     "FROM attendance_records ar " +
                     "JOIN subjects s ON ar.subject_id = s.subject_id " +
                     "WHERE ar.student_id = ? AND ar.status != 'CANCELLED' " +
                     "GROUP BY s.subject_id, s.subject_code, s.subject_name";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("subjectId", rs.getInt("subject_id"));
                    map.put("subjectCode", rs.getString("subject_code"));
                    map.put("subjectName", rs.getString("subject_name"));
                    int conducted = rs.getInt("conducted");
                    int attended = rs.getInt("attended");
                    double percentage = conducted == 0 ? 0.0 : (attended * 100.0) / conducted;
                    map.put("conducted", conducted);
                    map.put("attended", attended);
                    map.put("percentage", percentage);
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching subject-wise attendance", e);
        }
        return list;
    }

    @Override
    public List<Map<String, Object>> getRecentAttendanceRecords(int studentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT ar.attendance_date, s.subject_name, ar.status " +
                     "FROM attendance_records ar " +
                     "JOIN subjects s ON ar.subject_id = s.subject_id " +
                     "WHERE ar.student_id = ? AND ar.status != 'CANCELLED' " +
                     "ORDER BY ar.attendance_date DESC LIMIT 15";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    java.sql.Date sqlDate = rs.getDate("attendance_date");
                    if (sqlDate != null) {
                        java.time.LocalDate localDate = sqlDate.toLocalDate();
                        map.put("dateFormatted", localDate.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy")));
                    } else {
                        map.put("dateFormatted", "N/A");
                    }
                    map.put("subjectName", rs.getString("subject_name"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching recent attendance records", e);
        }
        return list;
    }

    @Override
    public List<Map<String, Object>> getTopAttendanceSubjects(int studentId) {
        List<Map<String, Object>> subjectAttendance = getSubjectWiseAttendance(studentId);
        subjectAttendance.sort((a, b) -> Double.compare((double) b.get("percentage"), (double) a.get("percentage")));
        
        List<Map<String, Object>> topSubjects = new ArrayList<>();
        int rank = 1;
        for (Map<String, Object> map : subjectAttendance) {
            if (rank > 5) break;
            Map<String, Object> top = new HashMap<>(map);
            top.put("rank", rank++);
            topSubjects.add(top);
        }
        return topSubjects;
    }

    // ===== 5. TIMETABLE =====
    @Override
    public List<TimetableEntry> getFacultyTimetable(int facultyId) {
        List<TimetableEntry> entries = new ArrayList<>();
        String sql = "SELECT t.*, s.subject_name, sec.section_name " +
                     "FROM timetable t " +
                     "JOIN subjects s ON t.subject_id = s.subject_id " +
                     "JOIN sections sec ON t.section_id = sec.section_id " +
                     "WHERE t.faculty_id = ? AND t.is_active = 1 " +
                     "ORDER BY FIELD(t.day_of_week, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'), t.start_time";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimetableEntry t = new TimetableEntry();
                    t.setTimetableId(rs.getInt("timetable_id"));
                    t.setSubjectId(rs.getInt("subject_id"));
                    t.setSubjectName(rs.getString("subject_name"));
                    t.setFacultyId(rs.getInt("faculty_id"));
                    t.setDayOfWeek(rs.getString("day_of_week"));
                    t.setStartTime(rs.getTime("start_time").toLocalTime());
                    t.setEndTime(rs.getTime("end_time").toLocalTime());
                    t.setRoomNumber(rs.getString("room_number"));
                    t.setSectionId(rs.getInt("section_id"));
                    t.setSectionName(rs.getString("section_name"));
                    t.setSemester(rs.getInt("semester"));
                    entries.add(t);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty timetable", e);
        }
        return entries;
    }

    // ===== 6. MARKS =====
    @Override
    public boolean saveMarks(int studentId, int subjectId, String examType, double marksObtained, double maxMarks, int gradedBy) {
        String sql = "INSERT INTO marks (student_id, subject_id, exam_type, marks_obtained, max_marks, graded_by, graded_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setString(3, examType);
            ps.setDouble(4, marksObtained);
            ps.setDouble(5, maxMarks);
            ps.setInt(6, gradedBy);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving marks", e);
        }
        return false;
    }

    @Override
    public List<Student> getStudentsForMarking(int subjectId, int sectionId) {
        return getStudentsForAttendance(subjectId, sectionId);
    }

    @Override
    public List<Map<String, Object>> getExistingMarks(int subjectId, int sectionId, String examType) {
        List<Map<String, Object>> marks = new ArrayList<>();
        String sql = "SELECT m.student_id, s.full_name, m.marks_obtained, m.max_marks " +
                     "FROM marks m " +
                     "JOIN students s ON m.student_id = s.student_id " +
                     "WHERE m.subject_id = ? AND s.section_id = ? AND m.exam_type = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ps.setInt(2, sectionId);
            ps.setString(3, examType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> mark = new HashMap<>();
                    mark.put("studentId", rs.getInt("student_id"));
                    mark.put("studentName", rs.getString("full_name"));
                    mark.put("marksObtained", rs.getDouble("marks_obtained"));
                    mark.put("maxMarks", rs.getDouble("max_marks"));
                    marks.add(mark);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching existing marks", e);
        }
        return marks;
    }
    
    // ===== 7. LEAVE APPROVAL =====
    @Override
    public List<LeaveRequest> getLeaveRequestsForApproval(int facultyId) {
        List<LeaveRequest> requests = new ArrayList<>();
        
        // ✅ FIXED: Direct join through sections.class_advisor_id (no section_students needed)
        String sql = "SELECT l.*, s.full_name AS student_name, u.email AS student_email, " +
                     "s.enrollment_number, s.branch, s.current_semester, " +
                     "sec.section_name " +
                     "FROM leaves l " +
                     "JOIN students s ON l.student_id = s.student_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "JOIN sections sec ON s.section_id = sec.section_id " +
                     "WHERE l.status = 'PENDING' " +
                     "AND sec.class_advisor_id = ? " +
                     "ORDER BY l.applied_on DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LeaveRequest l = new LeaveRequest();
                    l.setLeaveId(rs.getInt("leave_id"));
                    l.setStudentId(rs.getInt("student_id"));
                    l.setStudentName(rs.getString("student_name"));
                    l.setStudentEmail(rs.getString("student_email"));
                    l.setEnrollmentNumber(rs.getString("enrollment_number"));
                    l.setBranch(rs.getString("branch"));
                    l.setCurrentSemester(rs.getInt("current_semester"));
                    l.setSectionName(rs.getString("section_name"));
                    l.setStartDate(rs.getDate("start_date").toLocalDate());
                    l.setEndDate(rs.getDate("end_date").toLocalDate());
                    l.setReason(rs.getString("reason"));
                    l.setStatus(rs.getString("status"));
                    l.setAppliedOn(rs.getTimestamp("applied_on").toLocalDateTime());
                    requests.add(l);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching leave requests", e);
        }
        return requests;
    }

    @Override
    public int getPendingLeaveRequestsCount(int facultyId) {
        // ✅ FIXED: Direct join through sections.class_advisor_id
        String sql = "SELECT COUNT(*) FROM leaves l " +
                     "JOIN students s ON l.student_id = s.student_id " +
                     "JOIN sections sec ON s.section_id = sec.section_id " +
                     "WHERE l.status = 'PENDING' " +
                     "AND sec.class_advisor_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting pending leaves", e);
        }
        return 0;
    }
    
    @Override
    public boolean updateLeaveStatus(int leaveId, String status, int reviewedBy, String remarks) {
        String sql = "UPDATE leaves SET status = ?, reviewed_by = ?, reviewed_at = NOW(), review_remarks = ? WHERE leave_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewedBy);
            ps.setString(3, remarks);
            ps.setInt(4, leaveId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating leave status", e);
        }
        return false;
    }
    
    @Override
    public boolean isClassAdvisor(int facultyId) {
        String sql = "SELECT is_class_advisor FROM faculty WHERE faculty_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("is_class_advisor");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking class advisor status", e);
        }
        return false;
    }
    
    @Override
    public List<LeaveRequest> getAllLeaveRequestsForAdvisor(int facultyId, String statusFilter) {
        List<LeaveRequest> requests = new ArrayList<>();

        // ✅ FIXED: Direct join through sections.class_advisor_id
        String sql = "SELECT l.*, s.full_name AS student_name, u.email AS student_email, " +
                     "s.enrollment_number, s.branch, s.current_semester, " +
                     "f.full_name AS reviewer_name, " +
                     "sec.section_name " +
                     "FROM leaves l " +
                     "JOIN students s ON l.student_id = s.student_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "JOIN sections sec ON s.section_id = sec.section_id " +
                     "LEFT JOIN faculty f ON l.reviewed_by = f.faculty_id " +
                     "WHERE l.status != 'CANCELLED' " +
                     "AND sec.class_advisor_id = ? ";

        if (statusFilter != null && !statusFilter.isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql += "AND l.status = ? ";
        }

        sql += "ORDER BY l.applied_on DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            ps.setInt(paramIndex++, facultyId);

            if (statusFilter != null && !statusFilter.isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
                ps.setString(paramIndex, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LeaveRequest l = new LeaveRequest();
                    l.setLeaveId(rs.getInt("leave_id"));
                    l.setStudentId(rs.getInt("student_id"));
                    l.setStudentName(rs.getString("student_name"));
                    l.setStudentEmail(rs.getString("student_email"));
                    l.setEnrollmentNumber(rs.getString("enrollment_number"));
                    l.setBranch(rs.getString("branch"));
                    l.setCurrentSemester(rs.getInt("current_semester"));
                    l.setSectionName(rs.getString("section_name"));
                    l.setStartDate(rs.getDate("start_date").toLocalDate());
                    l.setEndDate(rs.getDate("end_date").toLocalDate());
                    l.setReason(rs.getString("reason"));
                    l.setStatus(rs.getString("status"));
                    l.setAppliedOn(rs.getTimestamp("applied_on").toLocalDateTime());

                    Object reviewedBy = rs.getObject("reviewed_by");
                    l.setReviewedBy(reviewedBy != null ? ((Number) reviewedBy).intValue() : null);
                    l.setReviewerName(rs.getString("reviewer_name"));

                    Object reviewedAt = rs.getObject("reviewed_at");
                    if (reviewedAt != null) {
                        l.setReviewedAt(((Timestamp) reviewedAt).toLocalDateTime());
                    }

                    l.setReviewRemarks(rs.getString("review_remarks"));
                    requests.add(l);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all leave requests", e);
        }
        return requests;
    }

    @Override
    public Map<String, Integer> getLeaveCountsByStatus(int facultyId) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("ALL", 0);
        counts.put("PENDING", 0);
        counts.put("APPROVED", 0);
        counts.put("REJECTED", 0);

        // ✅ FIXED: Direct join through sections.class_advisor_id
        String sql = "SELECT l.status, COUNT(*) as cnt FROM leaves l " +
                     "JOIN students s ON l.student_id = s.student_id " +
                     "JOIN sections sec ON s.section_id = sec.section_id " +
                     "WHERE sec.class_advisor_id = ? " +
                     "GROUP BY l.status";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                int total = 0;
                while (rs.next()) {
                    String status = rs.getString("status");
                    int cnt = rs.getInt("cnt");
                    counts.put(status, cnt);
                    total += cnt;
                }
                counts.put("ALL", total);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching leave counts", e);
        }
        return counts;
    }
    
    @Override
    public Map<String, Object> getAdvisorSectionInfo(int userId) {
        Map<String, Object> sectionInfo = new HashMap<>();
        String sql = "SELECT section_id, section_name, department, semester, batch " +
                     "FROM sections " +
                     "WHERE class_advisor_id = ? AND is_active = 1";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    sectionInfo.put("sectionId", rs.getInt("section_id"));
                    sectionInfo.put("sectionName", rs.getString("section_name"));
                    sectionInfo.put("department", rs.getString("department"));
                    sectionInfo.put("semester", rs.getInt("semester"));
                    sectionInfo.put("batch", rs.getString("batch"));
                    sectionInfo.put("isAdvisor", true);
                } else {
                    sectionInfo.put("isAdvisor", false);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching advisor section info", e);
            sectionInfo.put("isAdvisor", false);
        }
        
        return sectionInfo;
    }
    
    @Override
    public int getTotalFacultyCount() {
        String sql = "SELECT COUNT(*) FROM faculty";

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
    
 // Get subjects assigned to a specific faculty
    public List<Subject> getSubjectsByFacultyId(int facultyId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT DISTINCT s.* FROM subjects s " +
                     "INNER JOIN faculty_subjects fs ON s.subject_id = fs.subject_id " +
                     "WHERE fs.faculty_id = ? " +
                     "ORDER BY s.subject_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, facultyId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setSubjectId(rs.getInt("subject_id"));
                    subject.setSubjectCode(rs.getString("subject_code"));
                    subject.setSubjectName(rs.getString("subject_name"));
                    subject.setCredits(rs.getInt("credits"));
                    subjects.add(subject);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty subjects", e);
        }
        
        return subjects;
    }

    // Get sections assigned to a specific faculty
    public List<Map<String, Object>> getSectionsByFacultyId(int facultyId) {
        List<Map<String, Object>> sections = new ArrayList<>();
        String sql = "SELECT DISTINCT sec.section_id, sec.section_name, sec.department, sec.semester " +
                     "FROM sections sec " +
                     "INNER JOIN faculty_subjects fs ON sec.section_id = fs.section_id " +
                     "WHERE fs.faculty_id = ? " +
                     "ORDER BY sec.section_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, facultyId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> section = new HashMap<>();
                    section.put("sectionId", rs.getInt("section_id"));
                    section.put("sectionName", rs.getString("section_name"));
                    section.put("department", rs.getString("department"));
                    section.put("semester", rs.getInt("semester"));
                    sections.add(section);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty sections", e);
        }
        
        return sections;
    }

    // ===== HELPER METHODS =====
    private TimetableEntry mapTimetableEntry(ResultSet rs) throws SQLException {
        TimetableEntry t = new TimetableEntry();
        t.setSubjectId(rs.getInt("subject_id"));
        t.setSubjectName(rs.getString("subject_name"));
        t.setFacultyId(rs.getInt("faculty_id"));
        t.setDayOfWeek(rs.getString("day_of_week"));
        t.setStartTime(rs.getTime("start_time").toLocalTime());
        t.setEndTime(rs.getTime("end_time").toLocalTime());
        t.setRoomNumber(rs.getString("room_number"));
        t.setSectionId(rs.getInt("section_id"));
        return t;
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
    
    private Faculty mapFaculty(ResultSet rs) throws SQLException {
        Faculty f = new Faculty();
        
        f.setFacultyId(rs.getInt("faculty_id"));
        f.setUserId(rs.getInt("user_id")); // Maps the new user_id column
        f.setFullName(rs.getString("full_name"));
        f.setEmail(rs.getString("email"));
        f.setPhoneNumber(rs.getString("phone_number"));
        f.setAlternatePhone(rs.getString("alternate_phone"));
        f.setOfficeLocation(rs.getString("office_location"));
        f.setEmployeeId(rs.getString("employee_id"));
        f.setDepartment(rs.getString("department")); // The denormalized department name string
        f.setDesignation(rs.getString("designation"));
        f.setQualification(rs.getString("qualification"));
        f.setSpecialization(rs.getString("specialization"));
        f.setExperienceYears(rs.getInt("experience_years"));
        f.setResearchArea(rs.getString("research_area"));
        f.setResearchInterests(rs.getString("research_interests"));
        f.setPublicationsCount(rs.getInt("publications_count"));
        f.setCertifications(rs.getString("certifications"));
        f.setGoogleScholar(rs.getString("google_scholar"));
        f.setLinkedinProfile(rs.getString("linkedin_profile"));
        f.setOrcidId(rs.getString("orcid_id"));
        f.setAcademicWebsite(rs.getString("academic_website"));
        f.setAddress(rs.getString("address"));
        f.setCity(rs.getString("city"));
        f.setState(rs.getString("state"));
        f.setPostalCode(rs.getString("postal_code"));
        
        // Handle Date safely
        java.sql.Date joinDate = rs.getDate("joining_date");
        f.setJoiningDate(joinDate != null ? joinDate.toLocalDate() : null);
        
        f.setClassAdvisor(rs.getBoolean("is_class_advisor"));
        
        // Handle nullable Integer for advisor_section_id
        Object advisorSectionIdObj = rs.getObject("advisor_section_id");
        f.setAdvisorSectionId(advisorSectionIdObj != null ? ((Number) advisorSectionIdObj).intValue() : null);
        
        // Handle nullable Integer for department_id
        Object deptIdObj = rs.getObject("department_id");
        f.setDepartmentId(deptIdObj != null ? rs.getInt("department_id") : 0);
        
        f.setActive(rs.getBoolean("is_active"));
        
        return f;
    }
    
} // End of class
