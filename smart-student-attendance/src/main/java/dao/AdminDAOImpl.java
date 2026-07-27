package dao;

import model.Department;
import model.Faculty;
import model.Student;
import model.Subject;
import model.TimetableEntry;
import util.DatabaseUtil;

import java.sql.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;


public class AdminDAOImpl implements AdminDAO {
    private static final Logger LOGGER = Logger.getLogger(AdminDAOImpl.class.getName());

    // ===== DEPARTMENT MANAGEMENT =====
    
    @Override
    public List<Department> getAllDepartments() {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT * FROM departments ORDER BY department_id ASC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Department dept = new Department();
                dept.setDepartmentId(rs.getInt("department_id"));
                dept.setDepartmentName(rs.getString("department_name"));
                dept.setDepartmentCode(rs.getString("department_code"));
                dept.setHeadOfDepartment(rs.getString("head_of_department"));
                dept.setContactEmail(rs.getString("contact_email"));
                dept.setContactPhone(rs.getString("contact_phone"));
                dept.setActive(rs.getBoolean("is_active"));
                departments.add(dept);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching departments", e);
        }
        return departments;
    }

    @Override
    public Department getDepartmentById(int departmentId) {
        String sql = "SELECT * FROM departments WHERE department_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Department dept = new Department();
                    dept.setDepartmentId(rs.getInt("department_id"));
                    dept.setDepartmentName(rs.getString("department_name"));
                    dept.setDepartmentCode(rs.getString("department_code"));
                    dept.setHeadOfDepartment(rs.getString("head_of_department"));
                    dept.setContactEmail(rs.getString("contact_email"));
                    dept.setContactPhone(rs.getString("contact_phone"));
                    dept.setActive(rs.getBoolean("is_active"));
                    return dept;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching department", e);
        }
        return null;
    }

    @Override
    public boolean addDepartment(Department department) {
        String sql = "INSERT INTO departments (department_name, department_code, head_of_department, contact_email, contact_phone, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, 1)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, department.getDepartmentName());
            ps.setString(2, department.getDepartmentCode());
            ps.setString(3, department.getHeadOfDepartment());
            ps.setString(4, department.getContactEmail());
            ps.setString(5, department.getContactPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding department", e);
        }
        return false;
    }

    @Override
    public boolean updateDepartment(Department department) {
        String sql = "UPDATE departments SET department_name = ?, department_code = ?, " +
                     "head_of_department = ?, contact_email = ?, contact_phone = ?, " +
                     "is_active = ? WHERE department_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, department.getDepartmentName());
            ps.setString(2, department.getDepartmentCode());
            ps.setString(3, department.getHeadOfDepartment());
            ps.setString(4, department.getContactEmail());
            ps.setString(5, department.getContactPhone());
            ps.setBoolean(6, department.isActive()); // ✅ This preserves the status
            ps.setInt(7, department.getDepartmentId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating department", e);
        }
        return false;
    }
    
    @Override
    public boolean deleteDepartment(int departmentId) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // ✅ Delete the department
            String sql = "DELETE FROM departments WHERE department_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, departmentId);
                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    // ✅ Reset AUTO_INCREMENT to max(id) + 1
                    String resetSql = "ALTER TABLE departments AUTO_INCREMENT = 1";
                    try (PreparedStatement resetPs = conn.prepareStatement(resetSql)) {
                        resetPs.executeUpdate();
                    }
                }
                
                conn.commit();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
            LOGGER.log(Level.SEVERE, "Error deleting department", e);
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
        return false;
    }

    @Override
    public boolean isDepartmentCodeUnique(String departmentCode, int excludeId) {
        String sql = "SELECT COUNT(*) FROM departments WHERE department_code = ? AND department_id != ? AND is_active = 1";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, departmentCode);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking department code uniqueness", e);
        }
        return false;
    }

    @Override
    public boolean isDepartmentNameUnique(String departmentName, int excludeId) {
        String sql = "SELECT COUNT(*) FROM departments WHERE department_name = ? AND department_id != ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, departmentName);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking department name uniqueness", e);
        }
        return false;
    }

    @Override
    public boolean isHeadOfDepartmentUnique(String headOfDepartment, int excludeId) {
        if (headOfDepartment == null || headOfDepartment.trim().isEmpty()) {
            return true; // HOD is optional
        }
        String sql = "SELECT COUNT(*) FROM departments WHERE head_of_department = ? AND department_id != ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, headOfDepartment);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking HOD uniqueness", e);
        }
        return false;
    }

    @Override
    public boolean isContactEmailUnique(String contactEmail, int excludeId) {
        if (contactEmail == null || contactEmail.trim().isEmpty()) {
            return true; // Email is optional
        }
        String sql = "SELECT COUNT(*) FROM departments WHERE contact_email = ? AND department_id != ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contactEmail);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking contact email uniqueness", e);
        }
        return false;
    }
    
 // ===== SECTION MANAGEMENT =====
    @Override
    public List<Map<String, Object>> getAllSections() {
        List<Map<String, Object>> sections = new ArrayList<>();
        // ✅ FIXED: Join with users table, not faculty
        String sql = "SELECT s.*, d.department_name, f.full_name AS advisor_name " +
                "FROM sections s " +
                "LEFT JOIN departments d ON s.department_id = d.department_id " +
                "LEFT JOIN faculty f ON s.class_advisor_id = f.faculty_id " +  // ✅ CORRECT
                "ORDER BY s.section_id ASC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> section = new HashMap<>();
                section.put("sectionId", rs.getInt("section_id"));
                section.put("sectionName", rs.getString("section_name"));
                section.put("departmentId", rs.getInt("department_id"));
                section.put("departmentName", rs.getString("department_name"));
                section.put("semester", rs.getInt("semester"));
                section.put("batch", rs.getString("batch"));
                section.put("classAdvisorId", rs.getObject("class_advisor_id") != null ? rs.getInt("class_advisor_id") : null);
                section.put("advisorName", rs.getString("advisor_name"));
                section.put("isActive", rs.getBoolean("is_active"));
                sections.add(section);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching sections", e);
        }
        return sections;
    }

    @Override
    public Map<String, Object> getSectionById(int sectionId) {
    	String sql = "SELECT s.*, d.department_name, f.full_name AS advisor_name " +
    	        "FROM sections s " +
    	        "LEFT JOIN departments d ON s.department_id = d.department_id " +
    	        "LEFT JOIN faculty f ON s.class_advisor_id = f.faculty_id " +  // ✅ CORRECT
    	        "WHERE s.section_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> section = new HashMap<>();
                    section.put("sectionId", rs.getInt("section_id"));
                    section.put("sectionName", rs.getString("section_name"));
                    section.put("departmentId", rs.getInt("department_id"));
                    section.put("departmentName", rs.getString("department_name"));
                    section.put("semester", rs.getInt("semester"));
                    section.put("batch", rs.getString("batch"));
                    section.put("classAdvisorId", rs.getObject("class_advisor_id") != null ? rs.getInt("class_advisor_id") : null);
                    section.put("advisorName", rs.getString("advisor_name"));
                    section.put("isActive", rs.getBoolean("is_active"));
                    return section;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching section", e);
        }
        return null;
    }

    @Override
    public boolean addSection(String sectionName, int departmentId, int semester, String batch, Integer classAdvisorId) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            
            // ✅ Check if faculty is already advisor for another active section
            if (classAdvisorId != null && classAdvisorId > 0) {
                String checkSql = "SELECT COUNT(*) FROM sections WHERE class_advisor_id = ? AND is_active = 1";
                try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                    checkPs.setInt(1, classAdvisorId);
                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            LOGGER.warning("Faculty ID " + classAdvisorId + " is already advisor for another section");
                            return false;
                        }
                    }
                }
            }
            
            // ✅ Get department name
            String deptName = null;
            String lookupSql = "SELECT department_name FROM departments WHERE department_id = ?";
            try (PreparedStatement lookupPs = conn.prepareStatement(lookupSql)) {
                lookupPs.setInt(1, departmentId);
                try (ResultSet rs = lookupPs.executeQuery()) {
                    if (rs.next()) {
                        deptName = rs.getString("department_name");
                    }
                }
            }
            
            if (deptName == null) {
                LOGGER.warning("Department not found for ID: " + departmentId);
                return false;
            }
            
            // ✅ Insert section
            String sql = "INSERT INTO sections (section_name, department_id, department, semester, batch, class_advisor_id, is_active) " +
                         "VALUES (?, ?, ?, ?, ?, ?, 1)";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, sectionName.trim());
                ps.setInt(2, departmentId);
                ps.setString(3, deptName);
                ps.setInt(4, semester);
                ps.setString(5, batch.trim());
                if (classAdvisorId != null) {
                    ps.setInt(6, classAdvisorId);
                } else {
                    ps.setNull(6, Types.INTEGER);
                }
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding section", e);
        }
        return false;
    }

    @Override
    public boolean updateSection(int sectionId, String sectionName, int departmentId, int semester, String batch, Integer classAdvisorId) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            
            // ✅ Check if faculty is already advisor for another active section (excluding current section)
            if (classAdvisorId != null && classAdvisorId > 0) {
                String checkSql = "SELECT COUNT(*) FROM sections WHERE class_advisor_id = ? AND is_active = 1 AND section_id != ?";
                try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                    checkPs.setInt(1, classAdvisorId);
                    checkPs.setInt(2, sectionId);
                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            LOGGER.warning("Faculty ID " + classAdvisorId + " is already advisor for another section");
                            return false;
                        }
                    }
                }
            }
            
            // ✅ Get department name
            String deptName = null;
            String lookupSql = "SELECT department_name FROM departments WHERE department_id = ?";
            try (PreparedStatement lookupPs = conn.prepareStatement(lookupSql)) {
                lookupPs.setInt(1, departmentId);
                try (ResultSet rs = lookupPs.executeQuery()) {
                    if (rs.next()) {
                        deptName = rs.getString("department_name");
                    }
                }
            }
            
            if (deptName == null) {
                LOGGER.warning("Department not found for ID: " + departmentId);
                return false;
            }
            
            // ✅ Update section
            String sql = "UPDATE sections SET section_name = ?, department_id = ?, department = ?, " +
                         "semester = ?, batch = ?, class_advisor_id = ? WHERE section_id = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, sectionName.trim());
                ps.setInt(2, departmentId);
                ps.setString(3, deptName);
                ps.setInt(4, semester);
                ps.setString(5, batch.trim());
                if (classAdvisorId != null) {
                    ps.setInt(6, classAdvisorId);
                } else {
                    ps.setNull(6, Types.INTEGER);
                }
                ps.setInt(7, sectionId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating section", e);
        }
        return false;
    }
    
    @Override
    public boolean deleteSection(int sectionId) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Delete the section
            String sql = "DELETE FROM sections WHERE section_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, sectionId);
                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    // ✅ Reset AUTO_INCREMENT to max(id) + 1
                    String resetSql = "ALTER TABLE sections AUTO_INCREMENT = 1";
                    try (PreparedStatement resetPs = conn.prepareStatement(resetSql)) {
                        resetPs.executeUpdate();
                    }
                }
                
                conn.commit();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
            LOGGER.log(Level.SEVERE, "Error deleting section", e);
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
        return false;
    }

    @Override
    public List<Map<String, Object>> getSectionsByDepartment(int departmentId) {
        List<Map<String, Object>> sections = new ArrayList<>();
        String sql = "SELECT * FROM sections WHERE department_id = ? AND is_active = 1 ORDER BY section_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> section = new HashMap<>();
                    section.put("sectionId", rs.getInt("section_id"));
                    section.put("sectionName", rs.getString("section_name"));
                    section.put("semester", rs.getInt("semester"));
                    section.put("batch", rs.getString("batch"));
                    sections.add(section);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching sections by department", e);
        }
        return sections;
    }
    
    @Override
    public boolean updateSectionActiveStatus(int sectionId, boolean isActive) {
        String sql = "UPDATE sections SET is_active = ? WHERE section_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, sectionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating section active status", e);
        }
        return false;
    }
    
    @Override
    public boolean isSectionNameUnique(String sectionName, int departmentId, int semester, int excludeId) {
        String sql = "SELECT COUNT(*) FROM sections WHERE section_name = ? AND department_id = ? AND semester = ? AND section_id != ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sectionName);
            ps.setInt(2, departmentId);
            ps.setInt(3, semester);
            ps.setInt(4, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking section name uniqueness", e);
        }
        return false;
    }

    @Override
    public boolean isFacultyPhoneUnique(String phoneNumber, int excludeId) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return true; // Phone is optional
        }
        String sql = "SELECT COUNT(*) FROM faculty WHERE phone_number = ? AND faculty_id != ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phoneNumber);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking faculty phone uniqueness", e);
        }
        return false;
    }
    
    // ===== FACULTY MANAGEMENT =====
    
    @Override
    public List<Faculty> getAllFaculty() {
        List<Faculty> facultyList = new ArrayList<>();
        // ✅ ORDER BY employee_id ASC for ascending order (EMP-001, EMP-002, etc.)
        String sql = "SELECT f.*, d.department_name FROM faculty f " +
                     "LEFT JOIN departments d ON f.department_id = d.department_id " +
                     "ORDER BY f.employee_id ASC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Faculty faculty = mapFaculty(rs);
                faculty.setDepartment(rs.getString("department_name"));
                facultyList.add(faculty);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty", e);
        }
        return facultyList;
    }

    @Override
    public Faculty getFacultyById(int facultyId) {
        String sql = "SELECT f.*, d.department_name FROM faculty f " +
                     "LEFT JOIN departments d ON f.department_id = d.department_id " +
                     "WHERE f.faculty_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Faculty faculty = mapFaculty(rs);
                    faculty.setDepartment(rs.getString("department_name"));
                    return faculty;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty", e);
        }
        return null;
    }

    @Override
    public boolean addFaculty(Faculty faculty, String hashedPassword) {
        Connection conn = null;

        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            // STEP 1: Create user account
            String userSql =
                "INSERT INTO users " +
                "(username, email, password_hash, role_id, role, is_active, account_status, failed_attempts) " +
                "VALUES (?, ?, ?, 2, 'FACULTY', 1, 'ACTIVE', 0)";

            int userId;

            try (PreparedStatement userPs =
                         conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {

                userPs.setString(1, faculty.getEmail());
                userPs.setString(2, faculty.getEmail());
                userPs.setString(3, hashedPassword);

                userPs.executeUpdate();

                try (ResultSet rs = userPs.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to generate user ID");
                    }
                }
            }

            // STEP 2: Employee ID
            String employeeId = faculty.getEmployeeId();

            if (employeeId == null || employeeId.trim().isEmpty()) {
                employeeId = "EMP-" + String.format("%03d", userId);
            }

            // STEP 3: Insert faculty record
            String facultySql =
                "INSERT INTO faculty (" +
                "user_id, " +
                "full_name, " +
                "email, " +
                "phone_number, " +
                "department_id, " +
                "designation, " +
                "employee_id, " +
                "qualification, " +
                "experience_years, " +
                "specialization, " +
                "is_active" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement facultyPs =
                         conn.prepareStatement(facultySql)) {

                facultyPs.setInt(1, userId);

                facultyPs.setString(2, faculty.getFullName());
                facultyPs.setString(3, faculty.getEmail());
                facultyPs.setString(4, faculty.getPhoneNumber());

                if (faculty.getDepartmentId() > 0) {
                    facultyPs.setInt(5, faculty.getDepartmentId());
                } else {
                    facultyPs.setNull(5, Types.INTEGER);
                }

                facultyPs.setString(6, faculty.getDesignation());
                facultyPs.setString(7, employeeId);
                facultyPs.setString(8, faculty.getQualification());
                facultyPs.setInt(9, faculty.getExperienceYears());
                facultyPs.setString(10, faculty.getSpecialization());
                facultyPs.setBoolean(11, faculty.isActive());

                facultyPs.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Rollback failed", ex);
                }
            }

            LOGGER.log(Level.SEVERE, "Error adding faculty", e);
            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }
    
    @Override
    public boolean updateFaculty(Faculty faculty, String newPasswordHash) {
        Connection conn = null;

        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            // STEP 1: Update faculty table
            String facultySql =
                "UPDATE faculty SET " +
                "full_name = ?, " +
                "email = ?, " +
                "phone_number = ?, " +
                "department_id = ?, " +
                "designation = ?, " +
                "employee_id = ?, " +
                "qualification = ?, " +
                "experience_years = ?, " +
                "specialization = ?, " +
                "is_active = ? " +
                "WHERE faculty_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(facultySql)) {

                ps.setString(1, faculty.getFullName());
                ps.setString(2, faculty.getEmail());
                ps.setString(3, faculty.getPhoneNumber());

                if (faculty.getDepartmentId() > 0) {
                    ps.setInt(4, faculty.getDepartmentId());
                } else {
                    ps.setNull(4, Types.INTEGER);
                }

                ps.setString(5, faculty.getDesignation());
                ps.setString(6, faculty.getEmployeeId());
                ps.setString(7, faculty.getQualification());
                ps.setInt(8, faculty.getExperienceYears());
                ps.setString(9, faculty.getSpecialization());
                ps.setBoolean(10, faculty.isActive());

                ps.setInt(11, faculty.getFacultyId());

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected == 0) {
                    conn.rollback();
                    LOGGER.warning("No faculty found with ID: " + faculty.getFacultyId());
                    return false;
                }
            }

            // STEP 2: Update users table using USER_ID
            String userSql =
                "UPDATE users SET email = ?, username = ?, is_active = ? " +
                "WHERE user_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(userSql)) {

                ps.setString(1, faculty.getEmail());
                ps.setString(2, faculty.getEmail());
                ps.setBoolean(3, faculty.isActive());

                ps.setInt(4, faculty.getUserId()); // IMPORTANT

                ps.executeUpdate();
            }

            // STEP 3: Update password if provided
            if (newPasswordHash != null && !newPasswordHash.trim().isEmpty()) {

                String passwordSql =
                    "UPDATE users SET password_hash = ? WHERE user_id = ?";

                try (PreparedStatement ps = conn.prepareStatement(passwordSql)) {

                    ps.setString(1, newPasswordHash);
                    ps.setInt(2, faculty.getUserId()); // IMPORTANT

                    ps.executeUpdate();
                }

                LOGGER.info(
                    "Password updated for faculty ID: "
                    + faculty.getFacultyId()
                    + ", user ID: "
                    + faculty.getUserId()
                );
            }

            conn.commit();
            return true;

        } catch (SQLException e) {

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Rollback failed", ex);
                }
            }

            LOGGER.log(Level.SEVERE, "Error updating faculty", e);
            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    // Keep old method for backward compatibility
    @Override
    public boolean updateFaculty(Faculty faculty) {
        return updateFaculty(faculty, null);
    }

    @Override
    public boolean deleteFaculty(int facultyId) {
        String sql = "DELETE FROM faculty WHERE faculty_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, facultyId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting faculty", e);
            return false;
        }
    }
    
    @Override
    public boolean isFacultyEmailUnique(String email, int excludeId) {
        if (email == null || email.trim().isEmpty()) {
            return false; // Email is required
        }
        
        // ✅ Check users table
        String sql1 = "SELECT COUNT(*) FROM users WHERE email = ? AND user_id != ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql1)) {
            ps.setString(1, email);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Email exists in users table
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking email in users table", e);
        }
        
        // ✅ Check faculty table (in case of orphaned records)
        String sql2 = "SELECT COUNT(*) FROM faculty WHERE email = ? AND faculty_id != ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql2)) {
            ps.setString(1, email);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Email exists in faculty table
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking email in faculty table", e);
        }
        
        return true; // Email is unique
    }
    
    @Override
    public String getNextEmployeeId() {
        String sql = "SELECT employee_id FROM faculty WHERE employee_id LIKE 'EMP-%' " +
                     "ORDER BY faculty_id DESC LIMIT 1";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                String lastEmpId = rs.getString("employee_id");
                if (lastEmpId != null && lastEmpId.matches("EMP-\\d{3}")) {
                    // Extract number and increment
                    int lastNumber = Integer.parseInt(lastEmpId.substring(4)); // Remove "EMP-"
                    int nextNumber = lastNumber + 1;
                    return String.format("EMP-%03d", nextNumber);
                }
            }
            
            // If no existing employee or invalid format, start with EMP-001
            return "EMP-001";
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error generating next employee ID", e);
            return "EMP-001";
        }
    }
    
    @Override
    public List<Faculty> getFacultyByDepartment(int departmentId) {
        List<Faculty> facultyList = new ArrayList<>();
        String sql = "SELECT * FROM faculty WHERE department_id = ? AND is_active = 1 ORDER BY full_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    facultyList.add(mapFaculty(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty by department", e);
        }
        return facultyList;
    }

 // ===== STUDENT MANAGEMENT =====

    @Override
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        // ✅ Show ALL students (active + inactive), sorted by enrollment_number ASC
        String sql = "SELECT s.*, d.department_name, sec.section_name FROM students s " +
                     "LEFT JOIN departments d ON s.department_id = d.department_id " +
                     "LEFT JOIN sections sec ON s.section_id = sec.section_id " +
                     "ORDER BY s.enrollment_number ASC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Student student = mapStudent(rs);
                student.setDepartment(rs.getString("department_name"));
                students.add(student);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching students", e);
        }
        return students;
    }

    @Override
    public Student getStudentById(int studentId) {
        String sql = "SELECT s.*, d.department_name, sec.section_name FROM students s " +
                     "LEFT JOIN departments d ON s.department_id = d.department_id " +
                     "LEFT JOIN sections sec ON s.section_id = sec.section_id " +
                     "WHERE s.student_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student student = mapStudent(rs);
                    student.setDepartment(rs.getString("department_name"));
                    return student;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student", e);
        }
        return null;
    }

    @Override
    public boolean addStudent(Student student, String hashedPassword) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // ✅ Fetch department name
            String deptName = getDepartmentNameById(conn, student.getDepartmentId());
            
            String userSql = "INSERT INTO users (username, email, password_hash, role_id, role, is_active, account_status, failed_attempts) " +
                            "VALUES (?, ?, ?, 1, 'STUDENT', 1, 'ACTIVE', 0)";
            int userId;
            try (PreparedStatement userPs = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, student.getEmail());
                userPs.setString(2, student.getEmail());
                userPs.setString(3, hashedPassword);
                userPs.executeUpdate();
                try (ResultSet rs = userPs.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to create user account");
                    }
                }
            }
            
            // ✅ INCLUDE 'department' column in INSERT
            String studentSql = "INSERT INTO students (student_id, full_name, email, enrollment_number, branch, department, " +
                               "current_semester, section_id, department_id, batch, cgpa, is_active) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";
            try (PreparedStatement studentPs = conn.prepareStatement(studentSql)) {
                studentPs.setInt(1, userId);
                studentPs.setString(2, student.getFullName());
                studentPs.setString(3, student.getEmail());
                studentPs.setString(4, student.getEnrollmentNumber());
                studentPs.setString(5, student.getBranch());
                studentPs.setString(6, deptName); // ✅ ADDED
                studentPs.setInt(7, student.getCurrentSemester());
                studentPs.setObject(8, student.getSectionId() > 0 ? student.getSectionId() : null, Types.INTEGER);
                studentPs.setObject(9, student.getDepartmentId() > 0 ? student.getDepartmentId() : null, Types.INTEGER);
                studentPs.setString(10, student.getBatch());
                studentPs.setDouble(11, student.getCgpa());
                studentPs.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding student", e);
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
        return false;
    }

    // ✅ OLD METHOD - backward compatibility
    @Override
    public boolean updateStudent(Student student) {
        return updateStudent(student, null);
    }

    // ✅ NEW METHOD - with optional password update
    @Override
    public boolean updateStudent(Student student, String newPasswordHash) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // ✅ Fetch department name
            String deptName = getDepartmentNameById(conn, student.getDepartmentId());
            
            // ✅ INCLUDE 'department' column in UPDATE
            String studentSql = "UPDATE students SET full_name = ?, email = ?, branch = ?, department = ?, " +
                               "current_semester = ?, section_id = ?, department_id = ?, " +
                               "batch = ?, cgpa = ?, is_active = ? WHERE student_id = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(studentSql)) {
                ps.setString(1, student.getFullName());
                ps.setString(2, student.getEmail());
                ps.setString(3, student.getBranch());
                ps.setString(4, deptName); // ✅ ADDED
                ps.setInt(5, student.getCurrentSemester());
                ps.setObject(6, student.getSectionId() > 0 ? student.getSectionId() : null, Types.INTEGER);
                ps.setObject(7, student.getDepartmentId() > 0 ? student.getDepartmentId() : null, Types.INTEGER);
                ps.setString(8, student.getBatch());
                ps.setDouble(9, student.getCgpa());
                ps.setBoolean(10, student.isActive());
                ps.setInt(11, student.getStudentId());
                
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected == 0) {
                    conn.rollback();
                    LOGGER.warning("No student found with ID: " + student.getStudentId());
                    return false;
                }
            }
            
            // Update users table (using user_id which equals student_id)
            String userSql = "UPDATE users SET email = ?, username = ?, is_active = ? WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                ps.setString(1, student.getEmail());
                ps.setString(2, student.getEmail());
                ps.setBoolean(3, student.isActive());
                ps.setInt(4, student.getStudentId());
                ps.executeUpdate();
            }
            
            if (newPasswordHash != null && !newPasswordHash.trim().isEmpty()) {
                String passwordSql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(passwordSql)) {
                    ps.setString(1, newPasswordHash);
                    ps.setInt(2, student.getStudentId());
                    ps.executeUpdate();
                }
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
            LOGGER.log(Level.SEVERE, "Error updating student", e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }

    @Override
    public boolean deleteStudent(int studentId) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // STEP 1: Delete from users table first (foreign key constraint)
            String deleteUserSql = "DELETE FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteUserSql)) {
                ps.setInt(1, studentId);
                ps.executeUpdate();
            }
            
            // STEP 2: Delete from students table
            String deleteStudentSql = "DELETE FROM students WHERE student_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteStudentSql)) {
                ps.setInt(1, studentId);
                int rowsAffected = ps.executeUpdate();
                
                conn.commit();
                return rowsAffected > 0;
            }
            
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
            LOGGER.log(Level.SEVERE, "Error permanently deleting student", e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }

    @Override
    public List<Student> getStudentsBySection(int sectionId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE section_id = ? AND is_active = 1 ORDER BY full_name";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    students.add(mapStudent(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching students by section", e);
        }
        return students;
    }

    @Override
    public boolean isStudentEmailUnique(String email, int excludeId) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND user_id != ? AND is_active = 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking student email uniqueness", e);
        }
        return false;
    }

    @Override
    public String getNextEnrollmentId() {

        String currentYear = "2024";

        String sql =
            "SELECT MAX(" +
            "CAST(SUBSTRING_INDEX(enrollment_number, '-', -1) AS UNSIGNED)" +
            ") AS max_no " +
            "FROM students " +
            "WHERE enrollment_number LIKE ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "ENR-" + currentYear + "-%");

            try (ResultSet rs = ps.executeQuery()) {

                int nextNo = 1;

                if (rs.next()) {
                    nextNo = rs.getInt("max_no") + 1;
                }

                return String.format(
                        "ENR-%s-%03d",
                        currentYear,
                        nextNo);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Error generating next enrollment ID", e);
        }

        return "ENR-" + currentYear + "-001";
    }
    
 // ===== SUBJECT MANAGEMENT =====

    @Override
    public List<Subject> getAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM subjects ORDER BY subject_code ASC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Subject subject = new Subject();
                subject.setSubjectId(rs.getInt("subject_id"));
                subject.setSubjectCode(rs.getString("subject_code"));
                subject.setSubjectName(rs.getString("subject_name"));
                subject.setCredits(rs.getInt("credits"));
                subject.setDepartmentId(rs.getInt("department_id"));  // ✅ NEW
                subject.setActive(rs.getBoolean("is_active"));
                subjects.add(subject);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching subjects", e);
        }
        return subjects;
    }

    @Override
    public Subject getSubjectById(int subjectId) {
        String sql = "SELECT * FROM subjects WHERE subject_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Subject subject = new Subject();
                    subject.setSubjectId(rs.getInt("subject_id"));
                    subject.setSubjectCode(rs.getString("subject_code"));
                    subject.setSubjectName(rs.getString("subject_name"));
                    subject.setCredits(rs.getInt("credits"));
                    subject.setDepartmentId(rs.getInt("department_id"));  // ✅ NEW
                    subject.setActive(rs.getBoolean("is_active"));
                    return subject;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching subject", e);
        }
        return null;
    }

    @Override
    public boolean addSubject(Subject subject) {
        // ✅ INCLUDE 'department' column
        String sql = "INSERT INTO subjects (subject_code, subject_name, credits, department_id, department, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, 1)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            String deptName = getDepartmentNameById(conn, subject.getDepartmentId());
             
            ps.setString(1, subject.getSubjectCode().trim().toUpperCase());
            ps.setString(2, subject.getSubjectName());
            ps.setInt(3, subject.getCredits());
            ps.setObject(4, subject.getDepartmentId() > 0 ? subject.getDepartmentId() : null, Types.INTEGER);
            ps.setString(5, deptName); // ✅ ADDED
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding subject", e);
        }
        return false;
    }

    @Override
    public boolean updateSubject(Subject subject) {
        // ✅ INCLUDE 'department' column
        String sql = "UPDATE subjects SET subject_code = ?, subject_name = ?, credits = ?, department_id = ?, department = ?, is_active = ? " +
                     "WHERE subject_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            String deptName = getDepartmentNameById(conn, subject.getDepartmentId());
             
            ps.setString(1, subject.getSubjectCode().trim().toUpperCase());
            ps.setString(2, subject.getSubjectName());
            ps.setInt(3, subject.getCredits());
            ps.setObject(4, subject.getDepartmentId() > 0 ? subject.getDepartmentId() : null, Types.INTEGER);
            ps.setString(5, deptName); // ✅ ADDED
            ps.setBoolean(6, subject.isActive());
            ps.setInt(7, subject.getSubjectId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating subject", e);
        }
        return false;
    }

    @Override
    public boolean deleteSubject(int subjectId) {
        // ✅ Soft delete - sets is_active = 0
        String sql = "UPDATE subjects SET is_active = 0 WHERE subject_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting subject", e);
        }
        return false;
    }

    @Override
    public boolean deleteSubjectPermanently(int subjectId) {
        // ✅ HARD DELETE - permanently removes from database
        String sql = "DELETE FROM subjects WHERE subject_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error permanently deleting subject", e);
        }
        return false;
    }

    @Override
    public boolean isSubjectCodeUnique(String subjectCode, int excludeId) {
        if (subjectCode == null || subjectCode.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM subjects WHERE subject_code = ? AND subject_id != ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subjectCode.trim().toUpperCase());
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking subject code uniqueness", e);
        }
        return false;
    }

    @Override
    public boolean isSubjectNameUnique(String subjectName, int excludeId) {
        if (subjectName == null || subjectName.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM subjects WHERE subject_name = ? AND subject_id != ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subjectName);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking subject name uniqueness", e);
        }
        return false;
    }
    
    @Override
    public List<Subject> getSubjectsByDepartment(int departmentId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM subjects WHERE department_id = ? ORDER BY subject_code ASC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setSubjectId(rs.getInt("subject_id"));
                    subject.setSubjectCode(rs.getString("subject_code"));
                    subject.setSubjectName(rs.getString("subject_name"));
                    subject.setCredits(rs.getInt("credits"));
                    
                    try {
                        subject.setDepartmentId(rs.getInt("department_id"));
                    } catch (SQLException e) {
                        subject.setDepartmentId(0);
                    }
                    
                    subject.setActive(rs.getBoolean("is_active"));
                    subjects.add(subject);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching subjects by department", e);
        }
        return subjects;
    }

    // ===== TIMETABLE MANAGEMENT =====
    
    @Override
    public List<TimetableEntry> getAllTimetableEntries() {
        List<TimetableEntry> entries = new ArrayList<>();
        String sql = "SELECT t.*, s.subject_name, sec.section_name, f.full_name as faculty_name " +
                     "FROM timetable t " +
                     "JOIN subjects s ON t.subject_id = s.subject_id " +
                     "JOIN sections sec ON t.section_id = sec.section_id " +
                     "JOIN faculty f ON t.faculty_id = f.faculty_id " +
                     "WHERE t.is_active = 1 " +
                     "ORDER BY FIELD(t.day_of_week, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'), t.start_time";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                TimetableEntry entry = mapTimetableEntry(rs);
                entry.setSubjectName(rs.getString("subject_name"));
                entry.setSectionName(rs.getString("section_name"));
                entry.setFacultyName(rs.getString("faculty_name"));
                entries.add(entry);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching timetable entries", e);
        }
        return entries;
    }

    @Override
    public List<TimetableEntry> getTimetableBySection(int sectionId) {
        List<TimetableEntry> entries = new ArrayList<>();
        String sql = "SELECT t.*, s.subject_name, f.full_name as faculty_name " +
                     "FROM timetable t " +
                     "JOIN subjects s ON t.subject_id = s.subject_id " +
                     "JOIN faculty f ON t.faculty_id = f.faculty_id " +
                     "WHERE t.section_id = ? AND t.is_active = 1 " +
                     "ORDER BY FIELD(t.day_of_week, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'), t.start_time";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimetableEntry entry = mapTimetableEntry(rs);
                    entry.setSubjectName(rs.getString("subject_name"));
                    entry.setFacultyName(rs.getString("faculty_name"));
                    entries.add(entry);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching timetable by section", e);
        }
        return entries;
    }

    @Override
    public List<TimetableEntry> getTimetableByFaculty(int facultyId) {
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
                    TimetableEntry entry = mapTimetableEntry(rs);
                    entry.setSubjectName(rs.getString("subject_name"));
                    entry.setSectionName(rs.getString("section_name"));
                    entries.add(entry);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching timetable by faculty", e);
        }
        return entries;
    }

    @Override
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

        // SECTION CONFLICT CHECK
        String sectionConflict = getSectionConflictDetails(
                entry.getSectionId(), entry.getDayOfWeek(),
                entry.getStartTime().toString(), entry.getEndTime().toString(), 0);

        if (sectionConflict != null) {
            throw new IllegalArgumentException(sectionConflict);
        }

        // FACULTY CONFLICT CHECK
        String facultyConflict = getFacultyConflictDetails(
                entry.getFacultyId(), entry.getDayOfWeek(),
                entry.getStartTime().toString(), entry.getEndTime().toString(), 0);

        if (facultyConflict != null) {
            throw new IllegalArgumentException(facultyConflict);
        }

        // ✅ ACTUAL INSERT - Get semester from section
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            
            int semester = 0;
            String getSemesterSql = "SELECT semester FROM sections WHERE section_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(getSemesterSql)) {
                ps.setInt(1, entry.getSectionId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        semester = rs.getInt("semester");
                    } else {
                        LOGGER.warning("Section not found for ID: " + entry.getSectionId());
                        return false;
                    }
                }
            }
            
            String sql = "INSERT INTO timetable (subject_id, faculty_id, section_id, day_of_week, " +
                         "start_time, end_time, room_number, semester, is_active) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, entry.getSubjectId());
                ps.setInt(2, entry.getFacultyId());
                ps.setInt(3, entry.getSectionId());
                ps.setString(4, entry.getDayOfWeek());
                ps.setTime(5, Time.valueOf(entry.getStartTime()));
                ps.setTime(6, Time.valueOf(entry.getEndTime()));
                ps.setString(7, entry.getRoomNumber() != null ? entry.getRoomNumber() : "");
                ps.setInt(8, semester);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding timetable entry", e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }
    
    @Override
    public boolean updateTimetableEntry(TimetableEntry entry) {
    	
        if (entry.getTimetableId() <= 0) return false;
        
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // ✅ Get semester from section
            int semester = 0;
            String getSemesterSql = "SELECT semester FROM sections WHERE section_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(getSemesterSql)) {
                ps.setInt(1, entry.getSectionId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        semester = rs.getInt("semester");
                    } else {
                        LOGGER.warning("Section not found for ID: " + entry.getSectionId());
                        return false;
                    }
                }
            }
            
            // ✅ Update with semester
            String sql = "UPDATE timetable SET subject_id = ?, faculty_id = ?, section_id = ?, " +
                         "day_of_week = ?, start_time = ?, end_time = ?, room_number = ?, semester = ? " +
                         "WHERE timetable_id = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, entry.getSubjectId());
                ps.setInt(2, entry.getFacultyId());
                ps.setInt(3, entry.getSectionId());
                ps.setString(4, entry.getDayOfWeek());
                ps.setTime(5, Time.valueOf(entry.getStartTime()));
                ps.setTime(6, Time.valueOf(entry.getEndTime()));
                ps.setString(7, entry.getRoomNumber() != null ? entry.getRoomNumber() : "");
                ps.setInt(8, semester);  // ✅ Add semester
                ps.setInt(9, entry.getTimetableId());
                int rowsAffected = ps.executeUpdate();
                conn.commit();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
            LOGGER.log(Level.SEVERE, "Error updating timetable entry: " + e.getMessage(), e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }

    @Override
    public boolean deleteTimetableEntry(int timetableId) {
        String sql = "UPDATE timetable SET is_active = 0 WHERE timetable_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, timetableId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting timetable entry", e);
        }
        return false;
    }

    @Override
    public boolean isTimetableConflict(int sectionId, String dayOfWeek, String startTime, String endTime, int excludeId) {
        String sql = "SELECT COUNT(*) FROM timetable WHERE section_id = ? AND day_of_week = ? AND " +
                     "((start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?)) AND " +
                     "timetable_id != ? AND is_active = 1";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId);
            ps.setString(2, dayOfWeek);
            ps.setTime(3, Time.valueOf(LocalTime.parse(endTime)));
            ps.setTime(4, Time.valueOf(LocalTime.parse(startTime)));
            ps.setTime(5, Time.valueOf(LocalTime.parse(endTime)));
            ps.setTime(6, Time.valueOf(LocalTime.parse(startTime)));
            ps.setInt(7, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking timetable conflict", e);
        }
        return false;
    }
    
    @Override
    public String getSectionConflictDetails(
            int sectionId,
            String dayOfWeek,
            String startTime,
            String endTime,
            int excludeId) {

        String sql =
            "SELECT s.section_name, sub.subject_name, " +
            "t.start_time, t.end_time " +
            "FROM timetable t " +
            "JOIN sections s ON t.section_id = s.section_id " +
            "JOIN subjects sub ON t.subject_id = sub.subject_id " +
            "WHERE t.section_id = ? " +
            "AND t.day_of_week = ? " +
            "AND t.start_time < ? " +
            "AND t.end_time > ? " +
            "AND t.timetable_id != ? " +
            "AND t.is_active = 1 " +
            "LIMIT 1";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sectionId);
            ps.setString(2, dayOfWeek);

            ps.setTime(3,
                    Time.valueOf(java.time.LocalTime.parse(endTime)));

            ps.setTime(4,
                    Time.valueOf(java.time.LocalTime.parse(startTime)));

            ps.setInt(5, excludeId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return "Section "
                            + rs.getString("section_name")
                            + " already has "
                            + rs.getString("subject_name")
                            + " scheduled from "
                            + rs.getTime("start_time")
                            + " to "
                            + rs.getTime("end_time");
                }
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "Error checking section conflict",
                    e);
        }

        return null;
    }
    
    @Override
    public String getFacultyConflictDetails(
            int facultyId,
            String dayOfWeek,
            String startTime,
            String endTime,
            int excludeId) {

        String sql =
            "SELECT f.full_name, " +
            "sub.subject_name, " +
            "s.section_name, " +
            "t.start_time, " +
            "t.end_time " +
            "FROM timetable t " +
            "JOIN faculty f ON t.faculty_id = f.faculty_id " +
            "JOIN subjects sub ON t.subject_id = sub.subject_id " +
            "JOIN sections s ON t.section_id = s.section_id " +
            "WHERE t.faculty_id = ? " +
            "AND t.day_of_week = ? " +
            "AND t.start_time < ? " +
            "AND t.end_time > ? " +
            "AND t.timetable_id != ? " +
            "AND t.is_active = 1 " +
            "LIMIT 1";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, facultyId);
            ps.setString(2, dayOfWeek);

            ps.setTime(3,
                    Time.valueOf(java.time.LocalTime.parse(endTime)));

            ps.setTime(4,
                    Time.valueOf(java.time.LocalTime.parse(startTime)));

            ps.setInt(5, excludeId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                	return "Faculty "
                	        + rs.getString("full_name")
                	        + " already has a scheduled class ("
                	        + rs.getString("subject_name")
                	        + " - Section "
                	        + rs.getString("section_name")
                	        + ") from "
                	        + rs.getTime("start_time")
                	        + " to "
                	        + rs.getTime("end_time")
                	        + ".";
                }
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "Error checking faculty conflict",
                    e);
        }

        return null;
    }

    // ===== DASHBOARD STATISTICS =====
    
    @Override
    public Map<String, Integer> getAdminDashboardStats() {
        Map<String, Integer> stats = new HashMap<>();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // ✅ Departments - both total and active counts
            stats.put("totalDepartments", safeCountAll(conn, "departments"));
            stats.put("activeDepartments", safeCountActive(conn, "departments"));
            
            // ✅ Sections - both total and active counts
            stats.put("totalSections", safeCountAll(conn, "sections"));
            stats.put("activeSections", safeCountActive(conn, "sections"));
            
            // ✅ Faculty - both total and active counts
            stats.put("totalFaculty", safeCountAll(conn, "faculty"));
            stats.put("activeFaculty", safeCountActive(conn, "faculty"));
            
            // Students, Subjects, Timetable - active only (keep current behavior)
            stats.put("totalStudents", safeCountActive(conn, "students"));
            stats.put("totalSubjects", safeCountActive(conn, "subjects"));
            stats.put("totalTimetableEntries", safeCountActive(conn, "timetable"));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching admin dashboard stats", e);
        }
        
        return stats;
    }

    // ✅ NEW: Count ALL rows (no filter)
    private int safeCountAll(Connection conn, String tableName) {
        String sql = "SELECT COUNT(*) FROM " + tableName;
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting all " + tableName, e);
        }
        return 0;
    }

    // ✅ NEW: Count only ACTIVE rows
    private int safeCountActive(Connection conn, String tableName) {
        String sql = "SELECT COUNT(*) FROM " + tableName + " WHERE is_active = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            // Fall back to total count if is_active column doesn't exist
            LOGGER.info("Table " + tableName + " has no is_active column, counting all rows");
            return safeCountAll(conn, tableName);
        }
        return 0;
    }

    // ✅ HELPER: Counts rows, tries is_active=1 first, falls back to COUNT(*)
    private int safeCount(Connection conn, String tableName) {
        // Try with is_active filter first
        String sqlWithActive = "SELECT COUNT(*) FROM " + tableName + " WHERE is_active = 1";
        try (PreparedStatement ps = conn.prepareStatement(sqlWithActive);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            // Column doesn't exist — fall back to total count
            LOGGER.info("Table " + tableName + " has no is_active column, counting all rows");
        }
        
        // Fallback: count all rows
        String sqlTotal = "SELECT COUNT(*) FROM " + tableName;
        try (PreparedStatement ps = conn.prepareStatement(sqlTotal);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting " + tableName, e);
        }
        return 0;
    }

    // ===== HELPER METHODS =====
    
    private Faculty mapFaculty(ResultSet rs) throws SQLException {
        Faculty faculty = new Faculty();

        faculty.setFacultyId(rs.getInt("faculty_id"));
        faculty.setUserId(rs.getInt("user_id"));
        faculty.setFullName(rs.getString("full_name"));
        faculty.setEmail(rs.getString("email"));
        faculty.setPhoneNumber(rs.getString("phone_number"));
        faculty.setDepartmentId(rs.getObject("department_id") != null ? rs.getInt("department_id") : 0);
        faculty.setDesignation(rs.getString("designation"));
        faculty.setEmployeeId(rs.getString("employee_id"));
        faculty.setQualification(rs.getString("qualification"));
        faculty.setExperienceYears(rs.getInt("experience_years"));
        faculty.setSpecialization(rs.getString("specialization"));
        
        // ✅ ADD THIS LINE
        faculty.setActive(rs.getBoolean("is_active"));

        return faculty;
    }

    private Student mapStudent(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setStudentId(rs.getInt("student_id"));
        student.setFullName(rs.getString("full_name"));
        student.setEmail(rs.getString("email"));
        student.setEnrollmentNumber(rs.getString("enrollment_number"));
        student.setBranch(rs.getString("branch"));
        student.setCurrentSemester(rs.getInt("current_semester"));
        student.setSectionId(rs.getObject("section_id") != null ? rs.getInt("section_id") : 0);
        student.setDepartmentId(rs.getObject("department_id") != null ? rs.getInt("department_id") : 0);
        student.setBatch(rs.getString("batch"));
        student.setCgpa(rs.getDouble("cgpa"));
        try {
            student.setActive(rs.getBoolean("is_active"));
        } catch (SQLException e) {
            student.setActive(true); // Default to active if column missing
        }
        
        return student;
    }

    private TimetableEntry mapTimetableEntry(ResultSet rs) throws SQLException {
        TimetableEntry entry = new TimetableEntry();
        entry.setTimetableId(rs.getInt("timetable_id"));
        entry.setSubjectId(rs.getInt("subject_id"));
        entry.setFacultyId(rs.getInt("faculty_id"));
        entry.setSectionId(rs.getInt("section_id"));
        entry.setDayOfWeek(rs.getString("day_of_week"));
        entry.setStartTime(rs.getTime("start_time").toLocalTime());
        entry.setEndTime(rs.getTime("end_time").toLocalTime());
        entry.setRoomNumber(rs.getString("room_number"));
        return entry;
    }
    
 // ✅ HELPER: Fetch department name by ID
    private String getDepartmentNameById(Connection conn, int departmentId) throws SQLException {
        if (departmentId <= 0) return "Unknown";
        String sql = "SELECT department_name FROM departments WHERE department_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("department_name");
                }
            }
        }
        return "Unknown";
    }
}