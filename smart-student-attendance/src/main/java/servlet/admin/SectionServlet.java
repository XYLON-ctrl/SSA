package servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Department;
import model.Faculty;
import model.User;
import service.AdminService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/sections")
public class SectionServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(SectionServlet.class.getName());
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        String deptFilter = request.getParameter("department"); // ✅ Get filter parameter

        if ("edit".equals(action) && id > 0) {
            Map<String, Object> section = adminService.getSectionById(id);
            request.setAttribute("editSection", section);
        }

        List<Map<String, Object>> sections = adminService.getAllSections();
        List<Department> allDepartments = adminService.getAllDepartments();
        
        // ✅ Filter to show ONLY ACTIVE departments in dropdown
        List<Department> activeDepartments = new ArrayList<>();
        for (Department dept : allDepartments) {
            if (dept.isActive()) {
                activeDepartments.add(dept);
            }
        }
        
        // ✅ Apply department filter if selected
        if (deptFilter != null && !deptFilter.isEmpty() && !deptFilter.equals("all")) {
            try {
                int deptId = Integer.parseInt(deptFilter);
                List<Map<String, Object>> filteredList = new ArrayList<>();
                for (Map<String, Object> sec : sections) {
                    Object secDeptId = sec.get("departmentId");
                    if (secDeptId != null && ((Number) secDeptId).intValue() == deptId) {
                        filteredList.add(sec);
                    }
                }
                sections = filteredList;
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid department filter: " + deptFilter);
            }
        }
        
        List<model.Faculty> allFaculty = adminService.getAllFaculty();

        request.setAttribute("sections", sections);
        request.setAttribute("departments", activeDepartments); // ✅ Only active departments
        request.setAttribute("allFaculty", allFaculty);
        request.setAttribute("deptFilter", deptFilter == null ? "all" : deptFilter);
        request.setAttribute("pageTitle", "Manage Sections");
        setActivePage(request, "sections");
        request.getRequestDispatcher("/admin/sections.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/sections";

        try {
        	if ("add".equals(action)) {
        	    String sectionName = request.getParameter("sectionName");
        	    int departmentId = parseIntOrDefault(request.getParameter("departmentId"), 0);
        	    int semester = parseIntOrDefault(request.getParameter("semester"), 1);
        	    String batch = request.getParameter("batch");
        	    Integer classAdvisorId = parseNullableInt(request.getParameter("classAdvisorId"));
        	    
        	    // ✅ Validate section name uniqueness
        	    String validationError = adminService.validateSection(sectionName, departmentId, semester, 0);
        	    if (validationError != null) {
        	        setErrorMessage(request, validationError);
        	    } else if (adminService.addSection(sectionName, departmentId, semester, batch, classAdvisorId)) {
        	        setSuccessMessage(request, "Section added successfully!");
        	    } else {
        	        setErrorMessage(request, "Failed to add section. Faculty may already be advisor of another section.");
        	    }
        	}
        	else if ("update".equals(action)) {
        	    int sectionId = parseIntOrDefault(request.getParameter("sectionId"), 0);
        	    String sectionName = request.getParameter("sectionName");
        	    int departmentId = parseIntOrDefault(request.getParameter("departmentId"), 0);
        	    int semester = parseIntOrDefault(request.getParameter("semester"), 1);
        	    String batch = request.getParameter("batch");
        	    Integer classAdvisorId = parseNullableInt(request.getParameter("classAdvisorId"));
        	    String isActiveStr = request.getParameter("isActive");
        	    boolean isActive = "1".equals(isActiveStr);
        	    
        	    // ✅ Validate section name uniqueness (exclude current section)
        	    String validationError = adminService.validateSection(sectionName, departmentId, semester, sectionId);
        	    if (validationError != null) {
        	        setErrorMessage(request, validationError);
        	    } else if (adminService.updateSection(sectionId, sectionName, departmentId, semester, batch, classAdvisorId)) {
        	        adminService.updateSectionActiveStatus(sectionId, isActive);
        	        setSuccessMessage(request, "Section updated successfully!");
        	    } else {
        	        setErrorMessage(request, "Failed to update section. Faculty may already be advisor of another section.");
        	    }
        	}
            else if ("delete".equals(action)) {
                int sectionId = parseIntOrDefault(request.getParameter("sectionId"), 0);
                if (adminService.deleteSection(sectionId)) {
                    setSuccessMessage(request, "Section deleted successfully!");
                } else {
                    setErrorMessage(request, "Failed to delete section.");
                }
            }
            else {
                setErrorMessage(request, "Invalid action.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing section action", e);
            String errorMsg = e.getMessage();
            if (errorMsg != null && errorMsg.contains("already advisor")) {
                setErrorMessage(request, "This faculty member is already assigned as advisor to another section. Please select a different faculty.");
            } else {
                setErrorMessage(request, "An error occurred: " + (errorMsg != null ? errorMsg : "Unknown error"));
            }
        }
        response.sendRedirect(redirectUrl);
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null || value.isEmpty()) return defaultValue;
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private Integer parseNullableInt(String value) {
        if (value == null || value.isEmpty()) return null;
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}