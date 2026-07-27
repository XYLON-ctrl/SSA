package servlet;

import exception.AuthenticationException;
import exception.SecurityViolationException;
import service.AuthService;
import service.AuditLogService;
import util.CsrfUtil;
import util.PasswordUtil;
import util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    private final AuthService authService = new AuthService();
    private final AuditLogService auditLogService = new AuditLogService();
    private static final Logger LOGGER = Logger.getLogger(ResetPasswordServlet.class.getName());

    // Prevent direct URL access via GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        // 1. Validate Session Recovery State
        if (session == null || session.getAttribute("passwordResetVerified") == null || 
            !(boolean) session.getAttribute("passwordResetVerified")) {
            request.setAttribute("warningMessage", "Your password recovery session has expired. Please start again.");
            response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
            return;
        }

        int userId = (int) session.getAttribute("passwordResetUserId");
        String email = (String) session.getAttribute("passwordResetEmail");
        String ip = getClientIpAddress(request);
        String userAgent = getUserAgent(request);

        try {
            // 2. Retrieve Form Parameters
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            String csrfToken = request.getParameter("csrf_token");

            // 3. CSRF Protection
            if (!CsrfUtil.isValidToken(session, csrfToken)) {
                LOGGER.warning("CSRF validation failed for password reset. IP: " + ip);
                throw new SecurityViolationException("CSRF token mismatch.");
            }
            CsrfUtil.removeToken(session); // Invalidate token after single use

            // 4. Input Validation
            if (newPassword == null || confirmPassword == null || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Password fields cannot be empty.");
                request.getRequestDispatcher("/auth/resetPassword.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match.");
                request.getRequestDispatcher("/auth/resetPassword.jsp").forward(request, response);
                return;
            }

            // 5. Password Policy Enforcement
            // Note: Ensure ValidationUtil.isValidPassword() enforces the full enterprise policy 
            // (min 8 chars, uppercase, lowercase, number, special char, no spaces).
            if (!ValidationUtil.isValidPassword(newPassword)) {
                request.setAttribute("errorMessage", "Password does not meet the security requirements.");
                request.getRequestDispatcher("/auth/resetPassword.jsp").forward(request, response);
                return;
            }

            // 6. Password History Check (Delegated to Service)
            // The service checks if the plain text password matches any of the user's recent password hashes.
            authService.checkPasswordHistory(userId, newPassword);

            // 7. Secure Password Hashing
            String hashedPassword = PasswordUtil.hashPassword(newPassword);

            // 8. Update Password (Delegated to Service)
            authService.resetPassword(userId, hashedPassword);

            // 9. Audit Logging
            auditLogService.logLoginAttempt(userId, email, ip, userAgent, "PASSWORD_RESET");
            LOGGER.info("Password successfully reset for user ID: " + userId);

            // 10. Session Cleanup (Remove recovery state)
            cleanupRecoverySession(session);

            // 11. Optional Session Termination (Force logout all other active sessions)
            boolean terminateOtherSessions = true; // Can be loaded from a config file
            if (terminateOtherSessions) {
                authService.invalidateAllUserSessions(userId);
            }

            // 12. Success Handling
            // Do NOT auto-login the user. Redirect to login page with a success message.
            // We store the message in a NEW session so the login page can display it via EL.
            HttpSession loginSession = request.getSession(true);
            loginSession.setAttribute("successMessage", "Your password has been successfully reset. Please login using your new password.");
            
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (SecurityViolationException e) {
            LOGGER.warning("Security violation during password reset for user ID: " + userId + " - " + e.getMessage());
            request.setAttribute("errorMessage", "Security validation failed. Please restart the recovery process.");
            cleanupRecoverySession(session);
            response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
            
        } catch (AuthenticationException e) {
            // Catches password history violations or account status issues
            LOGGER.warning("Authentication error during password reset for user ID: " + userId + " - " + e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/auth/resetPassword.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Catches ValidationException, DatabaseException, and General Exceptions
            // Never expose stack traces or database errors to the user.
            LOGGER.log(Level.SEVERE, "Unexpected error during password reset for user ID: " + userId, e);
            request.setAttribute("errorMessage", "A system error occurred while updating your password. Please try again later.");
            request.getRequestDispatcher("/auth/resetPassword.jsp").forward(request, response);
        }
    }

    // --- Helper Methods ---

    private void cleanupRecoverySession(HttpSession session) {
        if (session != null) {
            session.removeAttribute("passwordResetUserId");
            session.removeAttribute("passwordResetEmail");
            session.removeAttribute("passwordResetVerified");
            session.removeAttribute("passwordResetVerifiedTime");
            session.removeAttribute("passwordResetToken");
        }
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0];
    }

    private String getUserAgent(HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        return userAgent != null && userAgent.length() > 250 ? userAgent.substring(0, 250) : userAgent;
    }
}