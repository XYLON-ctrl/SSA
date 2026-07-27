package service;

import util.DatabaseUtil;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuditLogService {
    private static final Logger LOGGER = Logger.getLogger(AuditLogService.class.getName());

    public void logLoginAttempt(Integer userId, String username, String ip, String userAgent, String status) {
        String sql = "INSERT INTO login_audit_logs (user_id, username, ip_address, browser_info, login_status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (userId != null) ps.setInt(1, userId); else ps.setNull(1, Types.INTEGER);
            ps.setString(2, username);
            ps.setString(3, ip);
            ps.setString(4, userAgent != null && userAgent.length() > 250 ? userAgent.substring(0, 250) : userAgent);
            ps.setString(5, status);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to log audit event", e);
        }
    }
}