package servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Department;
import model.User;
import service.AdminService;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/departments")
public class DepartmentServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(DepartmentServlet.class.getName());
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        // Handle specific actions
        String action = request.getParameter("action");
        int id = parseIntOrDefault(request.getParameter("id"), 0);

        if ("edit".equals(action) && id > 0) {
            Department dept = adminService.getDepartmentById(id);
            request.setAttribute("editDepartment", dept);
        }

        List<Department> departments = adminService.getAllDepartments();
        request.setAttribute("departments", departments);

        request.setAttribute("pageTitle", "Manage Departments");
        setActivePage(request, "departments");
        request.getRequestDispatcher("/admin/departments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/departments";

        try {
        	if ("add".equals(action)) {
        	    Department dept = new Department();
        	    dept.setDepartmentName(request.getParameter("departmentName"));
        	    dept.setDepartmentCode(request.getParameter("departmentCode"));
        	    dept.setHeadOfDepartment(request.getParameter("headOfDepartment"));
        	    dept.setContactEmail(request.getParameter("contactEmail"));
        	    dept.setContactPhone(request.getParameter("contactPhone"));
        	    
        	    // ✅ Validate uniqueness
        	    String validationError = adminService.validateDepartment(dept, 0);
        	    if (validationError != null) {
        	        setErrorMessage(request, validationError);
        	    } else if (adminService.addDepartment(dept)) {
        	        setSuccessMessage(request, "Department added successfully!");
        	    } else {
        	        setErrorMessage(request, "Failed to add department.");
        	    }
        	}
        	else if ("update".equals(action)) {
        	    int id = parseIntOrDefault(request.getParameter("departmentId"), 0);
        	    Department dept = new Department();
        	    dept.setDepartmentId(id);
        	    dept.setDepartmentName(request.getParameter("departmentName"));
        	    dept.setDepartmentCode(request.getParameter("departmentCode"));
        	    dept.setHeadOfDepartment(request.getParameter("headOfDepartment"));
        	    dept.setContactEmail(request.getParameter("contactEmail"));
        	    dept.setContactPhone(request.getParameter("contactPhone"));
        	    
        	    // ✅ Get isActive parameter
        	    String isActiveStr = request.getParameter("isActive");
        	    dept.setActive(isActiveStr != null && "1".equals(isActiveStr));
        	    
        	    // ✅ Validate uniqueness (exclude current department)
        	    String validationError = adminService.validateDepartment(dept, id);
        	    if (validationError != null) {
        	        setErrorMessage(request, validationError);
        	    } else if (adminService.updateDepartment(dept)) {
        	        setSuccessMessage(request, "Department updated successfully!");
        	    } else {
        	        setErrorMessage(request, "Failed to update department.");
        	    }
        	}
            else if ("delete".equals(action)) {
                int id = parseIntOrDefault(request.getParameter("departmentId"), 0);
                if (id > 0 && adminService.deleteDepartment(id)) {
                    setSuccessMessage(request, "Department deleted successfully!");
                } else {
                    setErrorMessage(request, "Failed to delete department.");
                }
            }
            else {
                setErrorMessage(request, "Invalid action.");
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing department action: " + e.getMessage());
            setErrorMessage(request, "An error occurred: " + e.getMessage());
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
}