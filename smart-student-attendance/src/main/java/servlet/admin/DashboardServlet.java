package servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.AdminService;

import java.io.IOException;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        try {
            Map<String, Integer> stats = adminService.getAdminDashboardStats();
            
            // ✅ Row 1: Departments, Sections, Faculty (with active/total)
            request.setAttribute("totalDepartments", stats.getOrDefault("totalDepartments", 0));
            request.setAttribute("activeDepartments", stats.getOrDefault("activeDepartments", 0));
            
            request.setAttribute("totalSections", stats.getOrDefault("totalSections", 0));
            request.setAttribute("activeSections", stats.getOrDefault("activeSections", 0));
            
            request.setAttribute("totalFaculty", stats.getOrDefault("totalFaculty", 0));
            request.setAttribute("activeFaculty", stats.getOrDefault("activeFaculty", 0));
            
            // ✅ Row 2: Students, Subjects, Timetable (unchanged)
            request.setAttribute("totalStudents", stats.getOrDefault("totalStudents", 0));
            request.setAttribute("totalSubjects", stats.getOrDefault("totalSubjects", 0));
            request.setAttribute("totalTimetableEntries", stats.getOrDefault("totalTimetableEntries", 0));
            
        } catch (Exception e) {
            LOGGER.severe("Error loading admin dashboard: " + e.getMessage());
            setErrorMessage(request, "Failed to load dashboard data.");
        }

        request.setAttribute("pageTitle", "Admin Dashboard");
        setActivePage(request, "dashboard");
        request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
    }
}