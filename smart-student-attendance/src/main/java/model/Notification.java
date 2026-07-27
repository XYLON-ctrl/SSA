package model;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Notification {
    private int notificationId;
    private String title;
    private String message;
    private boolean isRead;
    private LocalDateTime createdAt;
    private static final DateTimeFormatter DATE_TIME_FORMATTER = 
            DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public boolean isRead() { return isRead; }
    public boolean getIsRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getCreatedAtFormatted() {
            return createdAt != null ? createdAt.format(DATE_TIME_FORMATTER) : "Unknown";
    }
}