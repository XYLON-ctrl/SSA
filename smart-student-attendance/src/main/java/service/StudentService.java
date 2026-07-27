package service;

import dao.StudentDAO;
import dao.StudentDAOImpl;
import dao.AttendanceDAO;
import dao.AttendanceDAOImpl;
import dao.NotificationDAO;
import dao.NotificationDAOImpl;
import dao.LeaveDAO;
import dao.LeaveDAOImpl;

import model.Student;
import model.Subject;
import model.TimetableEntry;
import model.Mark;
import model.DashboardSummary;
import model.SemesterCGPA;

import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StudentService {
    private static final Logger LOGGER = Logger.getLogger(StudentService.class.getName());

    private final StudentDAO studentDAO = new StudentDAOImpl();
    private final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();
    private final LeaveDAO leaveDAO = new LeaveDAOImpl();

    // ==========================================
    // DASHBOARD
    // ==========================================

    public DashboardSummary getDashboardSummary(int userId) {
        DashboardSummary summary = new DashboardSummary();

        try {
            // 1. Fetch Student Profile using login userId
            Student student = studentDAO.getStudentProfile(userId);
            if (student == null) {
                LOGGER.warning("Student profile not found for user ID: " + userId);
                return null;
            }
            summary.setStudent(student);

            // ✅ Extract academic student_id for all academic queries
            int academicStudentId = student.getStudentId();

            // 2. Attendance uses academic student_id
            double attendance = attendanceDAO.getOverallAttendancePercentage(academicStudentId);
            summary.setAttendancePercentage(attendance);

            // 3. Total Subjects Count uses academic student_id
            int totalSubjects = studentDAO.getTotalSubjectsCount(academicStudentId);
            summary.setTotalSubjects(totalSubjects);

            // 4. Current Semester Subjects uses academic student_id
            int currentSemester = student.getCurrentSemester();
            int semesterSubjects = studentDAO.getSubjectsCountBySemester(academicStudentId, currentSemester);
            summary.setSemesterSubjects(semesterSubjects);

            // 5. Today's Classes uses academic student_id
            String todayDay = java.time.LocalDateTime.now().getDayOfWeek().toString();
            int classesToday = studentDAO.getTodayClassesCount(academicStudentId, todayDay);
            summary.setClassesToday(classesToday);

            // 6. Tomorrow's Classes uses academic student_id
            String tomorrowDay = java.time.LocalDateTime.now().plusDays(1).getDayOfWeek().toString();
            int classesTomorrow = studentDAO.getTomorrowClassesCount(academicStudentId, tomorrowDay);
            summary.setClassesTomorrow(classesTomorrow);

            // 7. Notifications use login userId (user table)
            int unreadNotifs = notificationDAO.getUnreadNotificationCount(userId);
            summary.setUnreadNotifications(unreadNotifs);

            // 8. Leaves use academic student_id (leaves table references student_id)
            int pendingLeaves = leaveDAO.getPendingLeaveCount(academicStudentId);
            summary.setPendingLeaves(pendingLeaves);

            int approvedLeaves = leaveDAO.getLeaveCountByStatus(academicStudentId, "APPROVED");
            summary.setApprovedLeaves(approvedLeaves);

            int rejectedLeaves = leaveDAO.getLeaveCountByStatus(academicStudentId, "REJECTED");
            summary.setRejectedLeaves(rejectedLeaves);

            // 9. CGPA uses academic student_id
            List<SemesterCGPA> semesterCgpas = studentDAO.getSemesterWiseCGPAWithSemesterNumber(academicStudentId);
            summary.setSemesterCgpas(semesterCgpas);

            // 10. Credits use academic student_id
            int totalProgramCredits = studentDAO.getTotalPossibleCredits(academicStudentId);
            summary.setTotalProgramCredits(totalProgramCredits);

            int earnedCredits = studentDAO.getTotalCreditsEarned(academicStudentId);
            summary.setEarnedCredits(earnedCredits);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error generating dashboard summary for user ID: " + userId, e);
            return null;
        }

        return summary;
    }

    // ==========================================
    // PROFILE & USER DATA
    // ==========================================

    public Student getStudentProfile(int userId) {
        return studentDAO.getStudentProfile(userId);
    }

    // ✅ ADDED: Was missing — caused "undefined" error in ProfileServlet
    public List<Map<String, Object>> getRecentActivities(int userId) {
        return studentDAO.getRecentActivities(userId);
    }

    // ✅ ADDED: Was missing — caused "undefined" error in EditProfileServlet
    public boolean updateFullProfile(int userId, String gender, String dateOfBirth,
                                     String bloodGroup, String nationality,
                                     String email, String mobileNumber, String alternateMobile,
                                     String permanentAddress, String correspondenceAddress,
                                     String guardianName, String guardianRelationship,
                                     String guardianContact, String guardianAlternateContact,
                                     String guardianEmail, String guardianOccupation) {
        return studentDAO.updateFullProfile(userId, gender, dateOfBirth, bloodGroup, nationality,
                email, mobileNumber, alternateMobile, permanentAddress, correspondenceAddress,
                guardianName, guardianRelationship, guardianContact, guardianAlternateContact,
                guardianEmail, guardianOccupation);
    }

    // ==========================================
    // SUBJECTS & ENROLLMENT
    // ==========================================

    public List<Subject> getEnrolledSubjects(int studentId) {
        return studentDAO.getEnrolledSubjects(studentId);
    }

    public List<Subject> getEnrolledSubjectsBySemester(int studentId, int semester) {
        return studentDAO.getEnrolledSubjectsBySemester(studentId, semester);
    }

    public List<Integer> getAvailableSemesters(int studentId) {
        return studentDAO.getAvailableSemesters(studentId);
    }

    // ==========================================
    // TIMETABLE
    // ==========================================

    public List<TimetableEntry> getWeeklyTimetable(int userId, int semester) {
        if (semester <= 0) {
            Student student = studentDAO.getStudentProfile(userId);
            if (student != null) {
                semester = student.getCurrentSemester();
            }
        }
        // ✅ Use academic student_id for timetable query
        Student student = studentDAO.getStudentProfile(userId);
        int academicStudentId = (student != null) ? student.getStudentId() : userId;
        return studentDAO.getWeeklyTimetable(academicStudentId, semester);
    }

    // ==========================================
    // MARKS & GRADES
    // ==========================================

    public List<Mark> getStudentMarks(int studentId) {
        return studentDAO.getStudentMarks(studentId);
    }

    public List<Mark> getStudentMarksBySemester(int studentId, int semester) {
        return studentDAO.getStudentMarksBySemester(studentId, semester);
    }

    public List<Mark> getStudentMarksByExamType(int studentId, String examType) {
        return studentDAO.getStudentMarksByExamType(studentId, examType);
    }

    public List<Mark> getStudentMarksBySemesterAndExamType(int studentId, int semester, String examType) {
        return studentDAO.getStudentMarksBySemesterAndExamType(studentId, semester, examType);
    }

    public List<Mark> getFilteredMarks(int studentId, int semester, String examType, int subjectId) {
        return studentDAO.getFilteredMarks(studentId, semester, examType, subjectId);
    }
    // ==========================================
    // PERFORMANCE ANALYTICS
    // ==========================================

    public Map<Integer, Double> getSemesterWiseCGPA(int studentId) {
        return studentDAO.getSemesterWiseCGPA(studentId);
    }

    public List<SemesterCGPA> getSemesterWiseCGPAWithSemesterNumber(int studentId) {
        return studentDAO.getSemesterWiseCGPAWithSemesterNumber(studentId);
    }

    // ✅ ADDED: Was missing — caused "undefined" error in AcademicPerformanceServlet
    public Map<Integer, Map<String, Object>> getSemesterExamTotals(int studentId) {
        return studentDAO.getSemesterExamTotals(studentId);
    }

    public int getTotalPossibleCredits(int studentId) {
        return studentDAO.getTotalPossibleCredits(studentId);
    }

    public int getTotalCreditsEarned(int studentId) {
        return studentDAO.getTotalCreditsEarned(studentId);
    }

    public int getClassRank(int studentId, String batch) {
        return studentDAO.getClassRank(studentId, batch);
    }

    public int getTotalStudentsInBatch(String batch) {
        return studentDAO.getTotalStudentsInBatch(batch);
    }
    
    public String getPerformanceChartDataJson(int studentId) {
        LOGGER.info("=== SERVICE: Generating chart JSON for studentId: " + studentId);
        Map<Integer, Double> sgpaMap = studentDAO.getSemesterWiseSGPA(studentId);
        
        LOGGER.info("SERVICE: Received " + sgpaMap.size() + " semesters of data");
        
        StringBuilder labels = new StringBuilder();
        StringBuilder values = new StringBuilder();
        
        for (Map.Entry<Integer, Double> entry : sgpaMap.entrySet()) {
            if (labels.length() > 0) {
                labels.append(",");
                values.append(",");
            }
            labels.append("\"Semester ").append(entry.getKey()).append("\"");
            values.append(entry.getValue());
            LOGGER.info("SERVICE: Added Semester " + entry.getKey() + " with SGPA " + entry.getValue());
        }
        
        String json = String.format("{\"labels\": [%s], \"cgpaValues\": [%s]}", 
                labels.toString(), values.toString());
        
        LOGGER.info("SERVICE: Generated JSON: " + json);
        return json;
    }
}