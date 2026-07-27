package servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Department;
import model.Faculty;
import model.User;
import service.AdminService;
import dao.AdminDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/faculty")
public class FacultyServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(FacultyServlet.class.getName());
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        String deptFilter = request.getParameter("department");

        // ✅ Handle toggle action
        if ("toggleStatus".equals(action) && id > 0) {
            toggleFacultyStatus(id);
            response.sendRedirect(request.getContextPath() + "/admin/faculty");
            return;
        }

        if ("edit".equals(action) && id > 0) {
            Faculty faculty = adminService.getFacultyById(id);
            request.setAttribute("editFaculty", faculty);
        }

        List<Faculty> facultyList = adminService.getAllFaculty();
        List<Department> allDepartments = adminService.getAllDepartments();
        
        // Filter to show ONLY ACTIVE departments in dropdown
        List<Department> activeDepartments = new ArrayList<>();
        for (Department dept : allDepartments) {
            if (dept.isActive()) {
                activeDepartments.add(dept);
            }
        }
        
        // Apply department filter if selected
        if (deptFilter != null && !deptFilter.isEmpty() && !deptFilter.equals("all")) {
            try {
                int deptId = Integer.parseInt(deptFilter);
                List<Faculty> filteredList = new ArrayList<>();
                for (Faculty f : facultyList) {
                    if (f.getDepartmentId() == deptId) {
                        filteredList.add(f);
                    }
                }
                facultyList = filteredList;
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid department filter: " + deptFilter);
            }
        }

        // Get next available employee ID to display (read-only)
        String nextEmployeeId = adminService.getNextFacultyEmployeeId();
        
        request.setAttribute("facultyList", facultyList);
        request.setAttribute("departments", activeDepartments);
        request.setAttribute("deptFilter", deptFilter);
        request.setAttribute("nextEmployeeId", nextEmployeeId);

        request.setAttribute("pageTitle", "Manage Faculty");
        setActivePage(request, "faculty");
        request.getRequestDispatcher("/admin/faculty.jsp").forward(request, response);
    }
    
    // ✅ Toggle faculty active/inactive status
    private void toggleFacultyStatus(int facultyId) {
        Faculty faculty = adminService.getFacultyById(facultyId);
        if (faculty != null) {
            faculty.setActive(!faculty.isActive());
            adminService.updateFaculty(faculty);
            LOGGER.info("Faculty " + faculty.getFullName() + " status toggled to: " + faculty.isActive());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/faculty";

        try {
            if ("add".equals(action)) {
                Faculty faculty = buildFacultyFromRequest(request);
                String password = request.getParameter("password");
                
                // Validate uniqueness
                String validationError = adminService.validateFaculty(faculty, 0);
                if (validationError != null) {
                    setErrorMessage(request, validationError);
                } else if (password == null || password.length() < 6) {
                    setErrorMessage(request, "Password must be at least 6 characters.");
                } else if (adminService.addFaculty(faculty, password)) {
                    setSuccessMessage(request, "Faculty added successfully!");
                } else {
                    setErrorMessage(request, "Failed to add faculty. Email may already exist.");
                }
            }
            else if ("update".equals(action)) {

                Faculty faculty = buildFacultyFromRequest(request);

                int id = parseIntOrDefault(request.getParameter("facultyId"), 0);
                faculty.setFacultyId(id);

                // IMPORTANT: Load existing faculty to get user_id
                Faculty existingFaculty = adminService.getFacultyById(id);

                if (existingFaculty == null) {
                    setErrorMessage(request, "Faculty not found.");
                    response.sendRedirect(redirectUrl);
                    return;
                }

                faculty.setUserId(existingFaculty.getUserId());

                LOGGER.info("Updating Faculty ID: " + faculty.getFacultyId()
                        + ", User ID: " + faculty.getUserId());

                String newPassword = request.getParameter("newPassword");

                if (newPassword != null && !newPassword.trim().isEmpty()) {

                    if (newPassword.length() < 6) {
                        setErrorMessage(request,
                                "New password must be at least 6 characters.");
                        response.sendRedirect(redirectUrl);
                        return;
                    }
                }

                if (adminService.updateFaculty(faculty, newPassword)) {

                    if (newPassword != null && !newPassword.trim().isEmpty()) {
                        setSuccessMessage(request,
                                "Faculty updated successfully! Password has been reset.");
                    } else {
                        setSuccessMessage(request,
                                "Faculty updated successfully!");
                    }

                } else {
                    setErrorMessage(request,
                            "Failed to update faculty.");
                }
            }
            else if ("delete".equals(action)) {
                int id = parseIntOrDefault(request.getParameter("facultyId"), 0);
                if (adminService.deleteFaculty(id)) {
                    setSuccessMessage(request, "Faculty permanently deleted!");
                } else {
                    setErrorMessage(request, "Failed to delete faculty.");
                }
            }
            else {
                setErrorMessage(request, "Invalid action.");
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing faculty action: " + e.getMessage());
            setErrorMessage(request, "An error occurred: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private Faculty buildFacultyFromRequest(HttpServletRequest request) {
        Faculty faculty = new Faculty();
        
        faculty.setFullName(request.getParameter("fullName"));
        faculty.setEmail(request.getParameter("email"));
        faculty.setPhoneNumber(request.getParameter("phoneNumber"));
        faculty.setDepartmentId(parseIntOrDefault(request.getParameter("departmentId"), 0));
        faculty.setDesignation(request.getParameter("designation"));
        
        // Employee ID (auto-generated if empty)
        String employeeId = request.getParameter("employeeId");
        if (employeeId != null && !employeeId.trim().isEmpty()) {
            faculty.setEmployeeId(employeeId.trim());
        }
        
        // Capture qualification, experience, and specialization
        faculty.setQualification(request.getParameter("qualification"));
        faculty.setExperienceYears(parseIntOrDefault(request.getParameter("experienceYears"), 0));
        faculty.setSpecialization(request.getParameter("specialization"));
        
        // ✅ Capture active status (checkbox sends "1" when checked, null when unchecked)
        String isActiveStr = request.getParameter("isActive");
        faculty.setActive("1".equals(isActiveStr));
        
        return faculty;
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null || value.isEmpty()) return defaultValue;
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}