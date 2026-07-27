package dao;

import model.User;
import model.Role;
import util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAOImpl implements UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAOImpl.class.getName());

    // ==========================================
    // SECTION 1: USER LOOKUP
    // ==========================================

    @Override
    public User findByUsername(String username) {
        String sql = "SELECT u.*, r.role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.role_id " +
                     "WHERE u.username = ?";
        return executeUserQuery(sql, username, null);
    }

    @Override
    public User findByUsernameOrEmail(String identifier) {
        // Searches by username OR email securely using PreparedStatements
        String sql = "SELECT u.*, r.role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.role_id " +
                     "WHERE u.username = ? OR u.email = ?";
        return executeUserQuery(sql, identifier, identifier);
    }

    @Override
    public User findByUserId(int userId) {
        String sql = "SELECT u.*, r.role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.role_id " +
                     "WHERE u.user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user by ID: " + userId, e);
        }
        return null;
    }

    // ==========================================
    // SECTION 2: ACCOUNT SECURITY & LOCKOUT
    // ==========================================

    @Override
    public void incrementFailedAttempts(int userId) {
        String sql = "UPDATE users SET failed_attempts = failed_attempts + 1 WHERE user_id = ?";
        executeUpdate(sql, userId);
    }

    @Override
    public void resetFailedAttempts(int userId) {
        String sql = "UPDATE users SET failed_attempts = 0, account_locked = FALSE, " +
                     "lock_time = NULL WHERE user_id = ?";
        executeUpdate(sql, userId);
    }

    @Override
    public void lockAccount(int userId) {
        String sql = "UPDATE users SET account_locked = TRUE, lock_time = NOW(), " +
                     "account_status = 'LOCKED' WHERE user_id = ?";
        executeUpdate(sql, userId);
    }

    @Override
    public void unlockAccount(int userId) {
        String sql = "UPDATE users SET account_locked = FALSE, lock_time = NULL, " +
                     "failed_attempts = 0, account_status = 'ACTIVE' WHERE user_id = ?";
        executeUpdate(sql, userId);
    }

    @Override
    public boolean verifyPassword(int userId, String plainTextPassword) {
        String sql = "SELECT password_hash FROM users WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    return org.mindrot.jbcrypt.BCrypt.checkpw(plainTextPassword, storedHash);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error verifying password for user ID: " + userId, e);
        }
        return false;
    }

    // ==========================================
    // SECTION 3: PASSWORD MANAGEMENT
    // ==========================================

    @Override
    public void updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating password for user ID: " + userId, e);
        }
    }

    @Override
    public boolean changePassword(int userId, String plainTextPassword) {
        // Hash the plain text password using BCrypt
        String hashedPassword = org.mindrot.jbcrypt.BCrypt.hashpw(
                plainTextPassword,
                org.mindrot.jbcrypt.BCrypt.gensalt(12)
        );

        // Update password and reset lockout fields
        String sql = "UPDATE users SET password_hash = ?, failed_attempts = 0, " +
                     "account_locked = FALSE, lock_time = NULL WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error changing password for user ID: " + userId, e);
            return false;
        }
    }

    // ==========================================
    // SECTION 4: LOGIN AUDIT & LAST LOGIN
    // ==========================================

    @Override
    public void updateLastLogin(int userId) {
        // Insert into login_audit_logs instead of updating users table directly
        String sql = "INSERT INTO login_audit_logs (user_id, login_time, ip_address, login_status) " +
                     "VALUES (?, NOW(), '0:0:0:0:0:0:0:1', 'SUCCESS')";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error updating last login for user ID: " + userId, e);
        }
    }

    @Override
    public LocalDateTime getLastLoginTime(int userId) {
        // Fetch most recent successful login from audit log
        String sql = "SELECT login_time FROM login_audit_logs " +
                     "WHERE user_id = ? AND login_status = 'SUCCESS' " +
                     "ORDER BY login_time DESC LIMIT 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp ts = rs.getTimestamp("login_time");
                    return ts != null ? ts.toLocalDateTime() : null;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching last login time for user ID: " + userId, e);
        }
        return null;
    }

    // ==========================================
    // SECTION 5: REMEMBER ME TOKENS
    // ==========================================

    @Override
    public void saveRememberMeToken(int userId, String token, LocalDateTime expiry) {
        String sql = "INSERT INTO remember_me_tokens (user_id, token, expiry_date) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, Timestamp.valueOf(expiry));
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving remember me token for user ID: " + userId, e);
        }
    }

    @Override
    public User getUserByRememberMeToken(String token) {
        String sql = "SELECT u.*, r.role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.role_id " +
                     "JOIN remember_me_tokens t ON u.user_id = t.user_id " +
                     "WHERE t.token = ? AND t.expiry_date > NOW()";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUser(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by remember me token", e);
        }
        return null;
    }

    @Override
    public void deleteRememberMeToken(String token) {
        String sql = "DELETE FROM remember_me_tokens WHERE token = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting remember me token", e);
        }
    }

    // ==========================================
    // SECTION 6: ROLE-BASED FULL NAME RESOLUTION
    // ==========================================

    @Override
    public String getFullNameByUserIdAndRole(int userId, Role role) {
        if (role == null) return null;

        String sql;
        switch (role) {
            case STUDENT:
                // ✅ FIXED: Query by user_id column (NOT student_id)
                // students.user_id links to users.user_id
                sql = "SELECT full_name FROM students WHERE user_id = ?";
                break;

            case FACULTY:
                // faculty.user_id links to users.user_id
                sql = "SELECT full_name FROM faculty WHERE user_id = ?";
                break;

            case ADMIN:
                // Admin has no separate profile table
                return "Administrator";

            default:
                return null;
        }

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching full name for userId: " + userId + ", role: " + role, e);
        }
        return null;
    }

    // ==========================================
    // SECTION 7: PRIVATE HELPER METHODS
    // ==========================================

    /**
     * Executes a user lookup query with one or two string parameters.
     * Used by findByUsername and findByUsernameOrEmail.
     */
    private User executeUserQuery(String sql, String param1, String param2) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, param1);
            if (param2 != null) ps.setString(2, param2);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error executing user query: " + sql, e);
        }
        return null;
    }

    /**
     * Executes a simple UPDATE statement with a single int parameter (userId).
     * Used by lock/unlock/reset account methods.
     */
    private void executeUpdate(String sql, int userId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error executing update: " + sql, e);
        }
    }

    /**
     * Maps a ResultSet row to a User model object.
     * Assumes the query joins users with roles.
     */
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setRole(Role.fromString(rs.getString("role_name")));
        user.setAccountStatus(rs.getString("account_status"));
        user.setFailedAttempts(rs.getInt("failed_attempts"));
        user.setAccountLocked(rs.getBoolean("account_locked"));
        user.setPasswordHash(rs.getString("password_hash"));

        Timestamp lockTime = rs.getTimestamp("lock_time");
        if (lockTime != null) {
            user.setLockTime(lockTime.toLocalDateTime());
        }

        return user;
    }
}