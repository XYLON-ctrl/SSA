package service;

import dao.UserDAO;
import dao.UserDAOImpl;
import exception.*;
import model.User;
import util.PasswordUtil;
import util.ValidationUtil;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.time.LocalDateTime;
import java.util.UUID;
import java.util.logging.Logger;

public class AuthService {
    private static final Logger LOGGER = Logger.getLogger(AuthService.class.getName());
    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final int LOCKOUT_DURATION_MINUTES = 15;
    private static final int REMEMBER_ME_DAYS = 30;

    private final UserDAO userDAO = new UserDAOImpl();
    private final AuditLogService auditLogService = new AuditLogService();

    // ===== AUTHENTICATION =====
    
    public User authenticate(String username, String password, String ipAddress, String userAgent) 
            throws AuthenticationException, SecurityViolationException {
        
        // 1. Input Validation
        if (!ValidationUtil.isValidUsername(username) || !ValidationUtil.isValidPassword(password)) {
            throw new InvalidCredentialsException("Invalid input format.");
        }
        if (ValidationUtil.containsMaliciousInput(username)) {
            LOGGER.warning("Security violation: Malicious input detected for username: " + username);
            throw new SecurityViolationException("Invalid input detected.");
        }

        // 2. Fetch User
        User user = userDAO.findByUsername(username);
        if (user == null) {
            auditLogService.logLoginAttempt(null, username, ipAddress, userAgent, "FAILED");
            throw new InvalidCredentialsException("Invalid credentials.");
        }

        // 3. Check Account Status
        if ("DISABLED".equalsIgnoreCase(user.getAccountStatus())) {
            throw new AuthenticationException("Your account has been disabled. Contact administration.");
        }

        // 4. Check Account Lock & Auto-Unlock
        if (user.isAccountLocked()) {
            if (user.getLockTime() != null && 
                user.getLockTime().plusMinutes(LOCKOUT_DURATION_MINUTES).isBefore(LocalDateTime.now())) {
                userDAO.unlockAccount(user.getUserId());
                LOGGER.info("Account auto-unlocked for user: " + username);
            } else {
                auditLogService.logLoginAttempt(user.getUserId(), username, ipAddress, userAgent, "LOCKED");
                throw new AccountLockedException("Account is locked. Try again after " + 
                    LOCKOUT_DURATION_MINUTES + " minutes.");
            }
        }

        // 5. Verify Password — ✅ Use verifyPassword() instead of checkPassword()
        if (!PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
            int newAttempts = user.getFailedAttempts() + 1;
            userDAO.incrementFailedAttempts(user.getUserId());
            
            if (newAttempts >= MAX_FAILED_ATTEMPTS) {
                userDAO.lockAccount(user.getUserId());
                LOGGER.severe("Account locked due to max failed attempts: " + username);
                auditLogService.logLoginAttempt(user.getUserId(), username, ipAddress, userAgent, "LOCKED");
                throw new AccountLockedException("Too many failed attempts. Account locked for " + 
                    LOCKOUT_DURATION_MINUTES + " minutes.");
            }
            
            auditLogService.logLoginAttempt(user.getUserId(), username, ipAddress, userAgent, "FAILED");
            LOGGER.warning("Failed login attempt for user: " + username + ". Attempts: " + newAttempts);
            throw new InvalidCredentialsException("Invalid credentials. Attempts remaining: " + 
                (MAX_FAILED_ATTEMPTS - newAttempts));
        }

     // 6. Success
        userDAO.resetFailedAttempts(user.getUserId());
        userDAO.updateLastLogin(user.getUserId());
        auditLogService.logLoginAttempt(user.getUserId(), username, ipAddress, userAgent, "SUCCESS");
        LOGGER.info("Successful login for user: " + username);

        // Fetch fresh user data with full name
        User loggedInUser = userDAO.findByUsername(username);

        String fullName = userDAO.getFullNameByUserIdAndRole(
        	    loggedInUser.getUserId(), 
        	    loggedInUser.getRole()
        	);
        
        loggedInUser.setFullName(fullName);

        return loggedInUser;
    }

    // ===== REMEMBER ME =====
    
    public void setupRememberMe(HttpServletResponse response, User user) {
        String token = UUID.randomUUID().toString();
        userDAO.saveRememberMeToken(user.getUserId(), token, LocalDateTime.now().plusDays(REMEMBER_ME_DAYS));
        
        Cookie cookie = new Cookie("remember_me", token);
        cookie.setHttpOnly(true);
        cookie.setSecure(true);
        cookie.setPath("/");
        cookie.setMaxAge(REMEMBER_ME_DAYS * 24 * 60 * 60);
        response.addCookie(cookie);
    }

    public User validateRememberMeCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember_me".equals(cookie.getName())) {
                    String token = cookie.getValue();
                    User user = userDAO.getUserByRememberMeToken(token);
                    if (user != null) {
                        userDAO.deleteRememberMeToken(token); // Prevent reuse
                        return user;
                    }
                }
            }
        }
        return null;
    }

    public void clearRememberMeCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie("remember_me", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    // ===== PASSWORD MANAGEMENT =====
    public void checkPasswordHistory(int userId, String plainTextPassword) throws AuthenticationException {
        User user = userDAO.findByUserId(userId);
        if (user == null) {
            throw new AuthenticationException("User account not found.");
        }

        if (PasswordUtil.verifyPassword(plainTextPassword, user.getPasswordHash())) {
            throw new AuthenticationException("You cannot reuse your current password.");
        }
    } 

    public void resetPassword(int userId, String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters.");
        }
       
        String hashedPassword = PasswordUtil.hashPassword(plainTextPassword);
        userDAO.updatePassword(userId, hashedPassword);
        LOGGER.info("Password successfully updated in database for user ID: " + userId);
    }

    public void invalidateAllUserSessions(int userId) {
        LOGGER.info("All active sessions flagged for invalidation for user ID: " + userId);
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) 
            throws AuthenticationException {
        User user = userDAO.findByUserId(userId);
        if (user == null) {
            throw new AuthenticationException("User account not found.");
        }

        // Verify old password
        if (!PasswordUtil.verifyPassword(oldPassword, user.getPasswordHash())) {
            throw new AuthenticationException("Current password is incorrect.");
        }

        // Ensure new password is different from old
        if (PasswordUtil.verifyPassword(newPassword, user.getPasswordHash())) {
            throw new AuthenticationException("New password must be different from current password.");
        }

        // Validate new password strength
        if (!ValidationUtil.isValidPassword(newPassword)) {
            throw new AuthenticationException("New password does not meet security requirements.");
        }

        // Hash and update
        String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
        userDAO.updatePassword(userId, hashedNewPassword);
        
        // Invalidate sessions for security
        invalidateAllUserSessions(userId);
        
        LOGGER.info("Password changed successfully for user ID: " + userId);
        return true;
    }
}