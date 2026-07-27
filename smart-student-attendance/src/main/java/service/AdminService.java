package service;

import dao.AdminDAO;
import dao.AdminDAOImpl;
import model.Department;
import model.Faculty;
import model.Student;
import model.Subject;
import model.TimetableEntry;
import util.PasswordUtil;

import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public class AdminService {
    private static final Logger LOGGER = Logger.getLogger(AdminService.class.getName());
    private final AdminDAO adminDAO = new AdminDAOImpl(); // ✅ This field must exist

    // ===== DEPARTMENT MANAGEMENT =====
    
    public List<Department> getAllDepartments() {
        return adminDAO.getAllDepartments();
    }

    public Department getDepartmentById(int departmentId) {
        return adminDAO.getDepartmentById(departmentId);
    }

    public boolean addDepartment(Department department) {
        if (department.getDepartmentName() == null || department.getDepartmentName().trim().isEmpty()) {
            LOGGER.warning("Department name cannot be empty");
            return false;
        }
        if (department.getDepartmentCode() == null || department.getDepartmentCode().trim().isEmpty()) {
            LOGGER.warning("Department code cannot be empty");
            return false;
        }
        if (!adminDAO.isDepartmentCodeUnique(department.getDepartmentCode(), 0)) {
            LOGGER.warning("Department code already exists: " + department.getDepartmentCode());
            return false;
        }
        return adminDAO.addDepartment(department);
    }

    public boolean updateDepartment(Department department) {
        if (department.getDepartmentId() <= 0) return false;
        if (!adminDAO.isDepartmentCodeUnique(department.getDepartmentCode(), department.getDepartmentId())) {
            LOGGER.warning("Department code already exists: " + department.getDepartmentCode());
            return false;
        }
        return adminDAO.updateDepartment(department);
    }

    public boolean deleteDepartment(int departmentId) {
        return adminDAO.deleteDepartment(departmentId);
    }

    public String validateDepartment(Department department, int excludeId) {
        if (!adminDAO.isDepartmentNameUnique(department.getDepartmentName(), excludeId)) {
            return "Department name '" + department.getDepartmentName() + "' already exists.";
        }
        if (!adminDAO.isDepartmentCodeUnique(department.getDepartmentCode(), excludeId)) {
            return "Department code '" + department.getDepartmentCode() + "' already exists.";
        }
        if (!adminDAO.isHeadOfDepartmentUnique(department.getHeadOfDepartment(), excludeId)) {
            return "Head of Department '" + department.getHeadOfDepartment() + "' is already assigned to another department.";
        }
        if (!adminDAO.isContactEmailUnique(department.getContactEmail(), excludeId)) {
            return "Contact email '" + department.getContactEmail() + "' is already in use.";
        }
        return null; 
    }

    // ===== SECTION MANAGEMENT =====
    
    public List<Map<String, Object>> getAllSections() {
        return adminDAO.getAllSections();
    }

    public Map<String, Object> getSectionById(int sectionId) {
        return adminDAO.getSectionById(sectionId);
    }

    public boolean addSection(String sectionName, int departmentId, int semester, String batch, Integer classAdvisorId) {
        if (sectionName == null || sectionName.trim().isEmpty()) return false;
        if (departmentId <= 0) return false;
        if (semester < 1 || semester > 8) return false;
        if (batch == null || batch.trim().isEmpty()) return false;
        return adminDAO.addSection(sectionName.trim(), departmentId, semester, batch.trim(), classAdvisorId);
    }

    public boolean updateSection(int sectionId, String sectionName, int departmentId, int semester, String batch, Integer classAdvisorId) {
        if (sectionId <= 0) return false;
        return adminDAO.updateSection(sectionId, sectionName, departmentId, semester, batch, classAdvisorId);
    }

    public boolean deleteSection(int sectionId) {
        return adminDAO.deleteSection(sectionId);
    }

    public List<Map<String, Object>> getSectionsByDepartment(int departmentId) {
        return adminDAO.getSectionsByDepartment(departmentId);
    }

    public boolean updateSectionActiveStatus(int sectionId, boolean isActive) {
        return adminDAO.updateSectionActiveStatus(sectionId, isActive);
    }
   
    public String validateSection(String sectionName, int departmentId, int semester, int excludeId) {
        if (!adminDAO.isSectionNameUnique(sectionName, departmentId, semester, excludeId)) {
            return "Section name '" + sectionName + "' already exists for this department and semester.";
        }
        return null;
    }
  
    public String validateFaculty(Faculty faculty, int excludeId) {
        if (!adminDAO.isFacultyEmailUnique(faculty.getEmail(), excludeId)) {
            return "Email '" + faculty.getEmail() + "' is already registered to another faculty member.";
        }
        if (!adminDAO.isFacultyPhoneUnique(faculty.getPhoneNumber(), excludeId)) {
            return "Phone number '" + faculty.getPhoneNumber() + "' is already registered to another faculty member.";
        }
        return null;
    }
    
    // ===== FACULTY MANAGEMENT =====
    
    public List<Faculty> getAllFaculty() {
        return adminDAO.getAllFaculty();
    }

    public Faculty getFacultyById(int facultyId) {
        return adminDAO.getFacultyById(facultyId);
    }

    public boolean addFaculty(Faculty faculty, String rawPassword) {
        if (faculty.getFullName() == null || faculty.getFullName().trim().isEmpty()) return false;
        if (faculty.getEmail() == null || faculty.getEmail().trim().isEmpty()) return false;
        if (rawPassword == null || rawPassword.length() < 6) return false;
        
        String hashedPassword = PasswordUtil.hashPassword(rawPassword);
        return adminDAO.addFaculty(faculty, hashedPassword);
    }

    public boolean updateFaculty(Faculty faculty) {
        if (faculty.getFacultyId() <= 0) return false;
        return adminDAO.updateFaculty(faculty);
    }

    public boolean updateFaculty(Faculty faculty, String newPassword) {
        if (faculty.getFacultyId() <= 0) {
            LOGGER.warning("Invalid faculty ID for update");
            return false;
        }
        
        // Validate faculty data
        if (faculty.getFullName() == null || faculty.getFullName().trim().isEmpty()) {
            LOGGER.warning("Full name cannot be empty");
            return false;
        }
        
        if (faculty.getEmail() == null || faculty.getEmail().trim().isEmpty()) {
            LOGGER.warning("Email cannot be empty");
            return false;
        }
        
        // Hash password only if provided
        String newPasswordHash = null;
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (newPassword.length() < 6) {
                LOGGER.warning("New password must be at least 6 characters");
                return false;
            }
            newPasswordHash = PasswordUtil.hashPassword(newPassword);
        }
        
        return adminDAO.updateFaculty(faculty, newPasswordHash);
    }
    
    public boolean deleteFaculty(int facultyId) {
        return adminDAO.deleteFaculty(facultyId);
    }

    public List<Faculty> getFacultyByDepartment(int departmentId) {
        return adminDAO.getFacultyByDepartment(departmentId);
    }

    public String getNextFacultyEmployeeId() {
        return adminDAO.getNextEmployeeId();
    }
    
    // ===== STUDENT MANAGEMENT =====
    
    public List<Student> getAllStudents() {
        return adminDAO.getAllStudents();
    }

    public Student getStudentById(int studentId) {
        return adminDAO.getStudentById(studentId);
    }

    public boolean addStudent(Student student, String rawPassword) {
        if (student.getFullName() == null || student.getFullName().trim().isEmpty()) return false;
        if (student.getEmail() == null || student.getEmail().trim().isEmpty()) return false;
        if (student.getEnrollmentNumber() == null || student.getEnrollmentNumber().trim().isEmpty()) return false;
        if (rawPassword == null || rawPassword.length() < 6) return false;
        
        if (!adminDAO.isStudentEmailUnique(student.getEmail(), 0)) {
            LOGGER.warning("Email already exists: " + student.getEmail());
            return false;
        }
        
        String hashedPassword = PasswordUtil.hashPassword(rawPassword);
        return adminDAO.addStudent(student, hashedPassword);
    }

    // ✅ OLD METHOD - for backward compatibility
    public boolean updateStudent(Student student) {
        return updateStudent(student, null);
    }

    // ✅ NEW METHOD - with optional password update
    public boolean updateStudent(Student student, String newPassword) {
        if (student.getStudentId() <= 0) {
            LOGGER.warning("Invalid student ID for update");
            return false;
        }
        
        if (student.getFullName() == null || student.getFullName().trim().isEmpty()) {
            LOGGER.warning("Full name cannot be empty");
            return false;
        }
        
        if (student.getEmail() == null || student.getEmail().trim().isEmpty()) {
            LOGGER.warning("Email cannot be empty");
            return false;
        }
        
        // Hash password only if provided
        String newPasswordHash = null;
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (newPassword.length() < 6) {
                LOGGER.warning("New password must be at least 6 characters");
                return false;
            }
            newPasswordHash = PasswordUtil.hashPassword(newPassword);
        }
        
        return adminDAO.updateStudent(student, newPasswordHash);
    }

    public boolean deleteStudent(int studentId) {
        return adminDAO.deleteStudent(studentId);
    }

    public List<Student> getStudentsBySection(int sectionId) {
        return adminDAO.getStudentsBySection(sectionId);
    }

    public String getNextStudentEnrollmentId() {
        return adminDAO.getNextEnrollmentId();
    }
    
    public boolean isStudentEmailUnique(String email, int excludeId) {
        return adminDAO.isStudentEmailUnique(email, excludeId);
    }
    
 // ===== SUBJECT MANAGEMENT =====

    public List<Subject> getAllSubjects() {
        return adminDAO.getAllSubjects();
    }

    public Subject getSubjectById(int subjectId) {
        return adminDAO.getSubjectById(subjectId);
    }

    public String validateSubject(Subject subject, int excludeId) {
        if (subject.getSubjectCode() == null || subject.getSubjectCode().trim().isEmpty()) {
            return "Subject code is required.";
        }
        if (subject.getSubjectName() == null || subject.getSubjectName().trim().isEmpty()) {
            return "Subject name is required.";
        }
        if (subject.getCredits() < 1 || subject.getCredits() > 6) {
            return "Credits must be between 1 and 6.";
        }
        // ✅ REMOVED: Semester validation
        if (!adminDAO.isSubjectCodeUnique(subject.getSubjectCode(), excludeId)) {
            return "Subject code '" + subject.getSubjectCode() + "' already exists.";
        }
        if (!adminDAO.isSubjectNameUnique(subject.getSubjectName(), excludeId)) {
            return "Subject name '" + subject.getSubjectName() + "' already exists.";
        }
        return null;
    }
    
    public boolean addSubject(Subject subject) {
        return adminDAO.addSubject(subject);
    }

    public boolean updateSubject(Subject subject) {
        return adminDAO.updateSubject(subject);
    }

    // ✅ Soft delete (keep for future use if needed)
    public boolean deleteSubject(int subjectId) {
        return adminDAO.deleteSubject(subjectId);
    }

    // ✅ HARD DELETE - permanently removes from database
    public boolean deleteSubjectPermanently(int subjectId) {
        return adminDAO.deleteSubjectPermanently(subjectId);
    }
    
    public List<Subject> getSubjectsByDepartment(int departmentId) {
        return adminDAO.getSubjectsByDepartment(departmentId);
    }

    // ===== TIMETABLE MANAGEMENT =====
    
    public List<TimetableEntry> getAllTimetableEntries() {
        return adminDAO.getAllTimetableEntries();
    }

    public List<TimetableEntry> getTimetableBySection(int sectionId) {
        return adminDAO.getTimetableBySection(sectionId);
    }

    public List<TimetableEntry> getTimetableByFaculty(int facultyId) {
        return adminDAO.getTimetableByFaculty(facultyId);
    }

    public boolean addTimetableEntry(TimetableEntry entry) {
        if (entry.getSubjectId() <= 0 || entry.getFacultyId() <= 0 || entry.getSectionId() <= 0) {
            return false;
        }
        if (entry.getDayOfWeek() == null || entry.getDayOfWeek().trim().isEmpty()) {
            return false;
        }
        if (entry.getStartTime() == null || entry.getEndTime() == null) {
            return false;
        }
        if (!entry.getStartTime().isBefore(entry.getEndTime())) {
            throw new IllegalArgumentException("Start time must be before end time.");
        }

        String sectionConflict = adminDAO.getSectionConflictDetails(
            entry.getSectionId(), entry.getDayOfWeek(),
            entry.getStartTime().toString(), entry.getEndTime().toString(), 0);
        if (sectionConflict != null) {
            throw new IllegalArgumentException(sectionConflict);
        }

        String facultyConflict = adminDAO.getFacultyConflictDetails(
            entry.getFacultyId(), entry.getDayOfWeek(),
            entry.getStartTime().toString(), entry.getEndTime().toString(), 0);
        if (facultyConflict != null) {
            throw new IllegalArgumentException(facultyConflict);
        }

        return adminDAO.addTimetableEntry(entry);
    }

    public boolean updateTimetableEntry(TimetableEntry entry) {
        if (entry.getTimetableId() <= 0) return false;
        if (entry.getSubjectId() <= 0 || entry.getFacultyId() <= 0 || entry.getSectionId() <= 0) return false;
        if (entry.getStartTime() == null || entry.getEndTime() == null) return false;
        if (!entry.getStartTime().isBefore(entry.getEndTime())) {
            throw new IllegalArgumentException("Start time must be before end time.");
        }

        String sectionConflict = adminDAO.getSectionConflictDetails(
            entry.getSectionId(), entry.getDayOfWeek(),
            entry.getStartTime().toString(), entry.getEndTime().toString(), entry.getTimetableId());
        if (sectionConflict != null) {
            throw new IllegalArgumentException(sectionConflict);
        }

        String facultyConflict = adminDAO.getFacultyConflictDetails(
            entry.getFacultyId(), entry.getDayOfWeek(),
            entry.getStartTime().toString(), entry.getEndTime().toString(), entry.getTimetableId());
        if (facultyConflict != null) {
            throw new IllegalArgumentException(facultyConflict);
        }

        return adminDAO.updateTimetableEntry(entry);
    }

    public boolean deleteTimetableEntry(int timetableId) {
        return adminDAO.deleteTimetableEntry(timetableId);
    }

    // ===== DASHBOARD =====
    
    public Map<String, Integer> getAdminDashboardStats() {
        return adminDAO.getAdminDashboardStats();
    }
}