package servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Department;
import model.Subject;
import model.User;
import service.AdminService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/subjects")
public class SubjectServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(SubjectServlet.class.getName());
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        String deptFilter = request.getParameter("department");

        if ("edit".equals(action) && id > 0) {
            Subject subject = adminService.getSubjectById(id);
            request.setAttribute("editSubject", subject);
        }

        List<Subject> subjects = adminService.getAllSubjects();
        
        // ✅ Fetch only ACTIVE departments for dropdown and filter
        List<Department> allDepartments = adminService.getAllDepartments();
        List<Department> activeDepartments = new ArrayList<>();
        for (Department dept : allDepartments) {
            if (dept.isActive()) {
                activeDepartments.add(dept);
            }
        }

        // ✅ FIX: Apply department filter if selected
        if (deptFilter != null && !deptFilter.isEmpty() && !deptFilter.equals("all")) {
            try {
                int deptId = Integer.parseInt(deptFilter);
                List<Subject> filteredList = new ArrayList<>();
                for (Subject s : subjects) {
                    // ✅ ACTUALLY CHECK if subject belongs to selected department
                    if (s.getDepartmentId() == deptId) {
                        filteredList.add(s);
                    }
                }
                subjects = filteredList;
                LOGGER.info("Filtered subjects for department ID: " + deptId + ", found: " + filteredList.size());
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid department filter: " + deptFilter);
            }
        }

        request.setAttribute("subjects", subjects);
        request.setAttribute("departments", activeDepartments);
        request.setAttribute("deptFilter", deptFilter);
        request.setAttribute("pageTitle", "Manage Subjects");
        setActivePage(request, "subjects");
        request.getRequestDispatcher("/admin/subjects.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/subjects";

        try {
            if ("add".equals(action)) {
                Subject subject = buildSubjectFromRequest(request);
                
                String validationError = adminService.validateSubject(subject, 0);
                if (validationError != null) {
                    setErrorMessage(request, validationError);
                } else if (adminService.addSubject(subject)) {
                    setSuccessMessage(request, "Subject added successfully!");
                } else {
                    setErrorMessage(request, "Failed to add subject.");
                }
            }
            else if ("update".equals(action)) {
                Subject subject = buildSubjectFromRequest(request);
                int id = parseIntOrDefault(request.getParameter("subjectId"), 0);
                subject.setSubjectId(id);
                
                // ✅ Get active status
                String isActiveStr = request.getParameter("isActive");
                subject.setActive("1".equals(isActiveStr));
                
                String validationError = adminService.validateSubject(subject, id);
                if (validationError != null) {
                    setErrorMessage(request, validationError);
                } else if (adminService.updateSubject(subject)) {
                    setSuccessMessage(request, "Subject updated successfully!");
                } else {
                    setErrorMessage(request, "Failed to update subject.");
                }
            }
            else if ("delete".equals(action)) {
                int id = parseIntOrDefault(request.getParameter("subjectId"), 0);
                // ✅ HARD DELETE - permanently removes from database
                if (adminService.deleteSubjectPermanently(id)) {
                    setSuccessMessage(request, "Subject permanently deleted!");
                } else {
                    setErrorMessage(request, "Failed to delete subject.");
                }
            }
            else {
                setErrorMessage(request, "Invalid action.");
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing subject action: " + e.getMessage());
            setErrorMessage(request, "An error occurred: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private Subject buildSubjectFromRequest(HttpServletRequest request) {
        Subject subject = new Subject();
        subject.setSubjectCode(request.getParameter("subjectCode"));
        subject.setSubjectName(request.getParameter("subjectName"));
        subject.setCredits(parseIntOrDefault(request.getParameter("credits"), 3));
        // ✅ Get department ID
        subject.setDepartmentId(parseIntOrDefault(request.getParameter("departmentId"), 0));
        return subject;
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