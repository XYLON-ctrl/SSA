package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.Notification;
import model.User;
import service.NotificationService;

@WebServlet("/student/notifications")
public class NotificationServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(NotificationServlet.class.getName());
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        // ✅ Notifications are user-level — userId is correct here
        int userId = loggedInUser.getUserId();

        try {
            List<Notification> notifications = notificationService.getAllNotifications(userId);
            request.setAttribute("notifications", notifications);
            request.setAttribute("activePage", "notifications");
            request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading notifications for userId: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load notifications.");
            request.setAttribute("activePage", "notifications");
            request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        int userId = loggedInUser.getUserId();
        String action = request.getParameter("action");

        try {
            if ("markOne".equals(action)) {
                int notificationId = parseInt(request.getParameter("notificationId"), 0);
                if (notificationId > 0) {
                    notificationService.markAsRead(notificationId, userId);
                    flashSuccess(request, "Notification marked as read.");
                } else {
                    flashError(request, "Invalid notification selected.");
                }
            } else if ("markAll".equals(action)) {
                notificationService.markAllAsRead(userId);
                flashSuccess(request, "All notifications marked as read.");
            } else {
                flashError(request, "Invalid action requested.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing notification action for userId: " + userId, e);
            flashError(request, "Failed to process notification action.");
        }

        response.sendRedirect(request.getContextPath() + "/student/notifications");
    }
}