package dao;
import model.Notification;
import java.util.List;

public interface NotificationDAO {
    int getUnreadNotificationCount(int userId);
    List<Notification> getRecentNotifications(int userId, int limit);
    List<Notification> getAllNotifications(int userId);
    void markAsRead(int notificationId, int userId);
    void markAllAsRead(int userId);
}