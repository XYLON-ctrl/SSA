package dao;

import model.Role;
import model.User;
import java.time.LocalDateTime;

public interface UserDAO {
    User findByUsername(String username);
    User findByUsernameOrEmail(String identifier); 
    void updateLastLogin(int userId);
    void incrementFailedAttempts(int userId);
    void resetFailedAttempts(int userId);
    void lockAccount(int userId);
    void unlockAccount(int userId);
    void saveRememberMeToken(int userId, String token, LocalDateTime expiry);
    User getUserByRememberMeToken(String token);
    void deleteRememberMeToken(String token);
    User findByUserId(int userId);
    void updatePassword(int userId, String hashedPassword);
    boolean verifyPassword(int userId, String plainTextPassword);
    boolean changePassword(int userId, String plainTextPassword);
    String getFullNameByUserIdAndRole(int userId, Role role);
    LocalDateTime getLastLoginTime(int userId);
}