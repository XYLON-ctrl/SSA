package dao;

import model.OtpRecord;
import util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OtpDAOImpl implements OtpDAO {
    private static final Logger LOGGER = Logger.getLogger(OtpDAOImpl.class.getName());

    @Override
    public OtpRecord getActiveOtp(int userId) {
        String sql = "SELECT * FROM password_reset_otps WHERE user_id = ? AND is_active = TRUE ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapOtp(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching active OTP", e);
        }
        return null;
    }

    @Override
    public void saveOtp(int userId, String otpCode, LocalDateTime expiry) {
        String sql = "INSERT INTO password_reset_otps (user_id, otp_code, expiry_time, attempt_count, is_active) VALUES (?, ?, ?, 0, TRUE)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otpCode);
            ps.setTimestamp(3, Timestamp.valueOf(expiry));
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving OTP", e);
        }
    }

    @Override
    public void invalidateExistingOtps(int userId) {
        String sql = "UPDATE password_reset_otps SET is_active = FALSE WHERE user_id = ? AND is_active = TRUE";
        executeUpdateByUserId(sql, userId);
    }

    @Override
    public void incrementAttemptCount(int otpId) {
        String sql = "UPDATE password_reset_otps SET attempt_count = attempt_count + 1 WHERE otp_id = ?";
        executeUpdateByOtpId(sql, otpId);
    }

    @Override
    public void markOtpAsUsed(int otpId) {
        String sql = "UPDATE password_reset_otps SET is_active = FALSE WHERE otp_id = ?";
        executeUpdateByOtpId(sql, otpId);
    }

    @Override
    public void invalidateOtp(int otpId) {
        String sql = "UPDATE password_reset_otps SET is_active = FALSE WHERE otp_id = ?";
        executeUpdateByOtpId(sql, otpId);
    }

    @Override
    public int getOtpCountInLastHour(int userId) {
        String sql = "SELECT COUNT(*) FROM password_reset_otps WHERE user_id = ? AND created_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking OTP rate limit", e);
        }
        return 0;
    }

    // --- Private Helper Methods ---

    private void executeUpdateByUserId(String sql, int userId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error executing OTP update by User ID", e);
        }
    }

    private void executeUpdateByOtpId(String sql, int otpId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error executing OTP update by OTP ID", e);
        }
    }

    private OtpRecord mapOtp(ResultSet rs) throws SQLException {
        OtpRecord otp = new OtpRecord();
        otp.setOtpId(rs.getInt("otp_id"));
        otp.setUserId(rs.getInt("user_id"));
        otp.setOtpCode(rs.getString("otp_code"));
        otp.setExpiryTime(rs.getTimestamp("expiry_time").toLocalDateTime());
        otp.setAttemptCount(rs.getInt("attempt_count"));
        otp.setActive(rs.getBoolean("is_active"));
        return otp;
    }
}