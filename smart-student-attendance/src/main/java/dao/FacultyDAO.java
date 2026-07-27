package dao;

import model.*;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface FacultyDAO {
    // Profile
    Faculty getFacultyProfile(int facultyId);
    boolean updateFacultyProfile(Faculty faculty);
    List<Subject> getAssignedSubjects(int facultyId);
    Map<String, Object> getWorkloadSummary(int facultyId);
    List<Map<String, Object>> getRecentActivities(int facultyId);
    int getFacultyIdByEmail(String email);
    Faculty getFacultyByUserId(int userId); 
    
    // Dashboard
    int getTodayClassesCount(int facultyId, String dayOfWeek);
    int getTotalStudentsTeaching(int facultyId);
    int getPendingLeaveRequestsCount(int facultyId);
    List<TimetableEntry> getTodayTimetable(int facultyId, String dayOfWeek);
    int getTotalFacultyCount();

    
    // Attendance
    boolean markAttendance(int studentId, int subjectId, LocalDate date, String status, int markedBy, String remarks);
    List<Student> getStudentsForAttendance(int subjectId, int sectionId);
    List<AttendanceRecord> getAttendanceRecords(LocalDate date, int subjectId, int sectionId);
    
    // Students & Subjects
    List<Student> getFacultyStudents(int facultyId);
    List<Student> getFacultyStudentsBySection(int facultyId, int sectionId);
    List<Student> searchStudents(int facultyId, String searchQuery);
    List<Subject> getFacultySubjects(int facultyId);
    List<Map<String, Object>> getFacultySections(int facultyId);
    String getStudentAttendancePercentage(int studentId, int subjectId);
    
	 // ==========================================
	 // STUDENT DETAILS (For Faculty View)
	 // ==========================================
	 Student getStudentById(int studentId);
	 List<Subject> getStudentSubjects(int studentId);
	 double getStudentOverallAttendance(int studentId);
	 List<Map<String, Object>> getStudentRecentActivities(int studentId);
	 int getTotalClassesForStudent(int studentId);
	 int getAttendedClassesForStudent(int studentId);
	 List<Map<String, Object>> getSubjectWiseAttendance(int studentId);
	 List<Map<String, Object>> getRecentAttendanceRecords(int studentId);
	 List<Map<String, Object>> getTopAttendanceSubjects(int studentId);
	    
    // Analytics
    int getExcellentAttendanceCount(int facultyId, int subjectId);
    int getAtRiskStudentsCount(int facultyId, int subjectId);
    double getAverageAttendance(int facultyId, int subjectId);
    
    // Timetable
    List<TimetableEntry> getFacultyTimetable(int facultyId);
    
    // Marks
    boolean saveMarks(int studentId, int subjectId, String examType, double marksObtained, double maxMarks, int gradedBy);
    List<Student> getStudentsForMarking(int subjectId, int sectionId);
    List<Map<String, Object>> getExistingMarks(int subjectId, int sectionId, String examType);
    
    // Leave Approval
    List<LeaveRequest> getLeaveRequestsForApproval(int facultyId);
    boolean updateLeaveStatus(int leaveId, String status, int reviewedBy, String remarks);
    boolean isClassAdvisor(int facultyId);
    List<LeaveRequest> getAllLeaveRequestsForAdvisor(int facultyId, String statusFilter);
    Map<String, Integer> getLeaveCountsByStatus(int facultyId);
    Map<String, Object> getAdvisorSectionInfo(int userId);
}