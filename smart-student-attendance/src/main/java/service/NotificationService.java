package service;

import dao.NotificationDAO;
import dao.NotificationDAOImpl;
import model.Notification;

import java.util.List;
import java.util.logging.Logger;

public class NotificationService {
    private static final Logger LOGGER = Logger.getLogger(NotificationService.class.getName());

    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    /**
     * Feature 3: Get Unread Count (For Sidebar Badge)
     */
    public int getUnreadCount(int userId) {
        return notificationDAO.getUnreadNotificationCount(userId);
    }

    /**
     * Feature 3: Get Recent Notifications (For Dashboard)
     */
    public List<Notification> getRecentNotifications(int userId, int limit) {
        return notificationDAO.getRecentNotifications(userId, limit);
    }

    /**
     * Feature 3: Get All Notifications (For Notifications Page)
     */
    public List<Notification> getAllNotifications(int userId) {
        return notificationDAO.getAllNotifications(userId);
    }

    /**
     * Feature 3: Mark Single Notification as Read
     * The DAO handles the security check (WHERE user_id = ?) to prevent 
     * users from marking other users' notifications as read.
     */
    public void markAsRead(int notificationId, int userId) {
        if (notificationId <= 0 || userId <= 0) {
            LOGGER.warning("Invalid parameters for marking notification as read.");
            return;
        }
        notificationDAO.markAsRead(notificationId, userId);
    }

    /**
     * Feature 3: Mark All Notifications as Read
     */
    public void markAllAsRead(int userId) {
        notificationDAO.markAllAsRead(userId);
        LOGGER.info("All notifications marked as read for user ID: " + userId);
    }
}