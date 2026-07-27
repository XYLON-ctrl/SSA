package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.DashboardSummary;
import model.Notification;
import model.Student;
import model.User;
import service.NotificationService;
import service.StudentService;

@WebServlet("/student/dashboard")
public class DashboardServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());
    private final StudentService studentService = new StudentService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        int userId = loggedInUser.getUserId();

        try {
            // ✅ Fetch profile using login userId
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                LOGGER.severe("Student profile not found for userId: " + userId);
                request.setAttribute("errorMessage", "Student profile not found. Please contact administration.");
                request.setAttribute("activePage", "dashboard");
                request.getRequestDispatcher("/student/studentDashboard.jsp").forward(request, response);
                return;
            }

            // ✅ Dashboard summary uses userId internally to resolve student_id
            DashboardSummary summary = studentService.getDashboardSummary(userId);

            // ✅ Notifications use userId (links to users table)
            List<Notification> recentNotifs = notificationService.getRecentNotifications(userId, 5);

            request.setAttribute("dashboard", summary);
            request.setAttribute("recentNotifications", recentNotifs);
            request.setAttribute("student", student);
            request.setAttribute("activePage", "dashboard");
            request.getRequestDispatcher("/student/studentDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading dashboard for userId: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load dashboard data.");
            request.setAttribute("activePage", "dashboard");
            request.getRequestDispatcher("/student/studentDashboard.jsp").forward(request, response);
        }
    }
}