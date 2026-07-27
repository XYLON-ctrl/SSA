package service;

import dao.FacultyDAO;
import dao.FacultyDAOImpl;
import model.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class FacultyService {
    private final FacultyDAO facultyDAO;

    public FacultyService() {
        this.facultyDAO = new FacultyDAOImpl();
    }

    // ==========================================
    // 1. PROFILE MANAGEMENT
    // ==========================================
    
    public Faculty getFacultyProfile(int facultyId) {
        return facultyDAO.getFacultyProfile(facultyId);
    }

    public boolean updateFacultyProfile(Faculty faculty) {
        return facultyDAO.updateFacultyProfile(faculty);
    }
    
    public List<Subject> getAssignedSubjects(int facultyId) {
        return facultyDAO.getAssignedSubjects(facultyId);
    }

    public Map<String, Object> getWorkloadSummary(int facultyId) {
        return facultyDAO.getWorkloadSummary(facultyId);
    }

    public List<Map<String, Object>> getRecentActivities(int facultyId) {
        return facultyDAO.getRecentActivities(facultyId);
    }
    
    public int getFacultyIdByEmail(String email) {
        return facultyDAO.getFacultyIdByEmail(email);
    }

    public Faculty getFacultyByUserId(int userId) {
        return facultyDAO.getFacultyByUserId(userId);
    }
      
    
    // ==========================================
    // 2. DASHBOARD METRICS
    // ==========================================
    
    public int getTodayClassesCount(int facultyId) {
        String today = LocalDate.now().getDayOfWeek().toString(); // e.g., "MONDAY"
        return facultyDAO.getTodayClassesCount(facultyId, today);
    }

    public int getTotalStudentsTeaching(int facultyId) {
        return facultyDAO.getTotalStudentsTeaching(facultyId);
    }

    public int getPendingLeaveRequestsCount(int facultyId) {
        return facultyDAO.getPendingLeaveRequestsCount(facultyId);
    }

    public List<TimetableEntry> getTodayTimetable(int facultyId) {
        String today = LocalDate.now().getDayOfWeek().toString();
        return facultyDAO.getTodayTimetable(facultyId, today);
    }

    // ==========================================
    // 3. ATTENDANCE MANAGEMENT
    // ==========================================
    
    public List<Student> getStudentsForAttendance(int subjectId, int sectionId) {
        return facultyDAO.getStudentsForAttendance(subjectId, sectionId);
    }

    public List<AttendanceRecord> getAttendanceRecords(LocalDate date, int subjectId, int sectionId) {
        return facultyDAO.getAttendanceRecords(date, subjectId, sectionId);
    }

    public boolean markAttendance(int studentId, int subjectId, LocalDate date, String status, int markedBy, String remarks) {
        return facultyDAO.markAttendance(studentId, subjectId, date, status, markedBy, remarks);
    }

    // ==========================================
    // 4. STUDENTS & SUBJECTS
    // ==========================================
    
    public List<Student> getFacultyStudents(int facultyId) {
        return facultyDAO.getFacultyStudents(facultyId);
    }

    public List<Subject> getFacultySubjects(int facultyId) {
        return facultyDAO.getFacultySubjects(facultyId);
    }

    public List<Map<String, Object>> getFacultySections(int facultyId) {
        return facultyDAO.getFacultySections(facultyId);
    }
    
    public String getStudentAttendancePercentage(int studentId, int subjectId) {
        return facultyDAO.getStudentAttendancePercentage(studentId, subjectId);
    }

	 // ===== NEW: Students by Section =====
	 public List<Student> getFacultyStudentsBySection(int facultyId, int sectionId) {
	     return facultyDAO.getFacultyStudentsBySection(facultyId, sectionId);
	 }
	
	 // ===== NEW: Search Students =====
	 public List<Student> searchStudents(int facultyId, String searchQuery) {
	     return facultyDAO.searchStudents(facultyId, searchQuery);
	 }
	
	 // ===== NEW: Analytics =====
	 public int getExcellentAttendanceCount(int facultyId, int subjectId) {
	     return facultyDAO.getExcellentAttendanceCount(facultyId, subjectId);
	 }
	
	 public int getAtRiskStudentsCount(int facultyId, int subjectId) {
	     return facultyDAO.getAtRiskStudentsCount(facultyId, subjectId);
	 }
	
	 public double getAverageAttendance(int facultyId, int subjectId) {
	     return facultyDAO.getAverageAttendance(facultyId, subjectId);
	 }

    // ==========================================
    // 5. TIMETABLE
    // ==========================================
    
    public List<TimetableEntry> getFacultyTimetable(int facultyId) {
        return facultyDAO.getFacultyTimetable(facultyId);
    }

    // ==========================================
    // 6. MARKS MANAGEMENT
    // ==========================================
    
    public boolean saveMarks(int studentId, int subjectId, String examType, double marksObtained, double maxMarks, int gradedBy) {
        return facultyDAO.saveMarks(studentId, subjectId, examType, marksObtained, maxMarks, gradedBy);
    }

    public List<Student> getStudentsForMarking(int subjectId, int sectionId) {
        return facultyDAO.getStudentsForMarking(subjectId, sectionId);
    }

    public List<Map<String, Object>> getExistingMarks(int subjectId, int sectionId, String examType) {
        return facultyDAO.getExistingMarks(subjectId, sectionId, examType);
    }


    // ==========================================
    // 7. LEAVE APPROVAL (For Class Advisors)
    // ==========================================
    
    public List<LeaveRequest> getLeaveRequestsForApproval(int facultyId) {
        return facultyDAO.getLeaveRequestsForApproval(facultyId);
    }

    public boolean approveLeave(int leaveId, int facultyId, String remarks) {
        return facultyDAO.updateLeaveStatus(leaveId, "APPROVED", facultyId, remarks);
    }

    public boolean rejectLeave(int leaveId, int facultyId, String remarks) {
        return facultyDAO.updateLeaveStatus(leaveId, "REJECTED", facultyId, remarks);
    }
    
 // ==========================================
 // 8. STUDENT DETAILS (For Faculty View)
 // ==========================================

	 public Student getStudentById(int studentId) {
	     return facultyDAO.getStudentById(studentId);
	 }
	
	 public List<Subject> getStudentSubjects(int studentId) {
	     return facultyDAO.getStudentSubjects(studentId);
	 }
	
	 public double getStudentOverallAttendance(int studentId) {
	     return facultyDAO.getStudentOverallAttendance(studentId);
	 }
	
	 public List<Map<String, Object>> getStudentRecentActivities(int studentId) {
	     return facultyDAO.getStudentRecentActivities(studentId);
	 }
	
	 public int getTotalClassesForStudent(int studentId) {
	     return facultyDAO.getTotalClassesForStudent(studentId);
	 }
	
	 public int getAttendedClassesForStudent(int studentId) {
	     return facultyDAO.getAttendedClassesForStudent(studentId);
	 }
	
	 public List<Map<String, Object>> getSubjectWiseAttendance(int studentId) {
	     return facultyDAO.getSubjectWiseAttendance(studentId);
	 }
	
	 public List<Map<String, Object>> getRecentAttendanceRecords(int studentId) {
	     return facultyDAO.getRecentAttendanceRecords(studentId);
	 }
	
	 public List<Map<String, Object>> getTopAttendanceSubjects(int studentId) {
	     return facultyDAO.getTopAttendanceSubjects(studentId);
	 }
	 
	// Add these methods to FacultyService

	 public List<LeaveRequest> getAllLeaveRequestsForAdvisor(int facultyId, String statusFilter) {
	     return facultyDAO.getAllLeaveRequestsForAdvisor(facultyId, statusFilter);
	 }

	 public Map<String, Integer> getLeaveCountsByStatus(int facultyId) {
	     return facultyDAO.getLeaveCountsByStatus(facultyId);
	 }
	 
	 public Map<String, Object> getAdvisorSectionInfo(int userId) {
		    return facultyDAO.getAdvisorSectionInfo(userId);
		}
}