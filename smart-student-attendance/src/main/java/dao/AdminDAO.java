package dao;

import model.Department;
import model.Faculty;
import model.Student;
import model.Subject;
import model.TimetableEntry;

import java.util.List;
import java.util.Map;


public interface AdminDAO {
    
    // ===== DEPARTMENT MANAGEMENT =====
    List<Department> getAllDepartments();
    Department getDepartmentById(int departmentId);
    boolean addDepartment(Department department);
    boolean updateDepartment(Department department);
    boolean deleteDepartment(int departmentId);
    boolean isDepartmentCodeUnique(String departmentCode, int excludeId);
    boolean isDepartmentNameUnique(String departmentName, int excludeId);
    boolean isHeadOfDepartmentUnique(String headOfDepartment, int excludeId);
    boolean isContactEmailUnique(String contactEmail, int excludeId);
    
    // ===== SECTION MANAGEMENT =====
    List<Map<String, Object>> getAllSections();
    Map<String, Object> getSectionById(int sectionId);
    boolean addSection(String sectionName, int departmentId, int semester, String batch, Integer classAdvisorId);
    boolean updateSection(int sectionId, String sectionName, int departmentId, int semester, String batch, Integer classAdvisorId);
    boolean deleteSection(int sectionId);
    List<Map<String, Object>> getSectionsByDepartment(int departmentId);
    boolean updateSectionActiveStatus(int sectionId, boolean isActive);
    boolean isSectionNameUnique(String sectionName, int departmentId, int semester, int excludeId);
    
    // ===== FACULTY MANAGEMENT =====
    List<Faculty> getAllFaculty();
    Faculty getFacultyById(int facultyId);
    boolean addFaculty(Faculty faculty, String hashedPassword);
    boolean updateFaculty(Faculty faculty);
    boolean updateFaculty(Faculty faculty, String newPasswordHash);
    boolean deleteFaculty(int facultyId);
    boolean isFacultyEmailUnique(String email, int excludeId);
    boolean isFacultyPhoneUnique(String phoneNumber, int excludeId);
    List<Faculty> getFacultyByDepartment(int departmentId);
    String getNextEmployeeId();
    
    // ===== STUDENT MANAGEMENT =====
    List<Student> getAllStudents();
    Student getStudentById(int studentId);
    boolean addStudent(Student student, String hashedPassword);
    boolean updateStudent(Student student);                          // ✅ OLD
    boolean updateStudent(Student student, String newPasswordHash);  // ✅ NEW
    boolean deleteStudent(int studentId);
    List<Student> getStudentsBySection(int sectionId);
    boolean isStudentEmailUnique(String email, int excludeId);
    String getNextEnrollmentId();
    
 // ===== SUBJECT MANAGEMENT =====
    List<Subject> getAllSubjects();
    Subject getSubjectById(int subjectId);
    boolean addSubject(Subject subject);
    boolean updateSubject(Subject subject);
    boolean deleteSubject(int subjectId);           // Soft delete
    boolean deleteSubjectPermanently(int subjectId); // Hard delete
    boolean isSubjectCodeUnique(String subjectCode, int excludeId);
    boolean isSubjectNameUnique(String subjectName, int excludeId);
    List<Subject> getSubjectsByDepartment(int departmentId);
    
    // ===== TIMETABLE MANAGEMENT =====
    List<TimetableEntry> getAllTimetableEntries();
    List<TimetableEntry> getTimetableBySection(int sectionId);
    List<TimetableEntry> getTimetableByFaculty(int facultyId);
    boolean addTimetableEntry(TimetableEntry entry);
    boolean updateTimetableEntry(TimetableEntry entry);
    boolean deleteTimetableEntry(int timetableId);
    boolean isTimetableConflict(int sectionId, String dayOfWeek, String startTime, String endTime, int excludeId);
    String getSectionConflictDetails(int sectionId, String dayOfWeek, String startTime, String endTime, int excludeId);
    String getFacultyConflictDetails(int facultyId, String dayOfWeek, String startTime, String endTime, int excludeId);
    
    // ===== DASHBOARD =====
    Map<String, Integer> getAdminDashboardStats();
	
}