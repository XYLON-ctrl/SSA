package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;  // ✅ ADD THIS
import util.DatabaseUtil;

public class AuditLogDAOImpl implements AuditLogDAO {
    private static final Logger LOGGER = Logger.getLogger(AuditLogDAOImpl.class.getName());  // ✅ ADD THIS

    @Override
    public void logAuditAction(int userId, String actionType, String description, String ipAddress) {
        String sql = "INSERT INTO audit_logs (user_id, action_type, description, ip_address, timestamp) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, actionType);
            ps.setString(3, description);
            ps.setString(4, ipAddress);
            ps.setTimestamp(5, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to log audit action: " + actionType + " for user ID: " + userId, e);
        }
    }
}