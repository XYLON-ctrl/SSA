package servlet;

import exception.InvalidOtpException;
import exception.OtpExpiredException;
import exception.TooManyAttemptsException;
import service.AuditLogService;
import service.OtpService;
import util.CsrfUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/VerifyOtp")
public class VerifyOtpServlet extends HttpServlet {

    private final OtpService otpService = new OtpService();
    private final AuditLogService auditLogService = new AuditLogService();
    private static final Logger LOGGER = Logger.getLogger(VerifyOtpServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Prevent direct URL access
        response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        // 1. Session Validation
        if (session == null || session.getAttribute("passwordResetUserId") == null) {
            request.setAttribute("warningMessage", "Recovery session expired. Please start again.");
            request.getRequestDispatcher("/auth/forgotPassword.jsp").forward(request, response);
            return;
        }

        int userId = (int) session.getAttribute("passwordResetUserId");
        String email = (String) session.getAttribute("passwordResetEmail");
        String otpCode = request.getParameter("otpCode");
        String csrfToken = request.getParameter("csrf_token");

        // 2. CSRF Validation
        if (!CsrfUtil.isValidToken(session, csrfToken)) {
            LOGGER.warning("CSRF validation failed for OTP verification. IP: " + getClientIpAddress(request));
            invalidateRecoverySession(session);
            request.setAttribute("errorMessage", "Security validation failed. Please start the recovery process again.");
            request.getRequestDispatcher("/auth/forgotPassword.jsp").forward(request, response);
            return;
        }
        CsrfUtil.removeToken(session); // Invalidate token after single use

        // 3. OTP Input Validation (Strict: exactly 6 numeric digits)
        if (otpCode == null || !otpCode.matches("\\d{6}")) {
            request.setAttribute("errorMessage", "Please enter a valid 6-digit numeric verification code.");
            request.getRequestDispatcher("/auth/verifyOtp.jsp").forward(request, response);
            return;
        }

        String ip = getClientIpAddress(request);
        String userAgent = getUserAgent(request);

        try {
            // 4. Delegate to Service Layer for Verification
            otpService.verifyOtp(userId, otpCode);

            // 5. Success Flow
            session.setAttribute("passwordResetVerified", true);
            session.setAttribute("passwordResetVerifiedTime", System.currentTimeMillis());
            session.removeAttribute("failedOtpAttempts");
            
            // Generate secure token for the actual password reset step
            String resetToken = UUID.randomUUID().toString();
            session.setAttribute("passwordResetToken", resetToken);

            auditLogService.logLoginAttempt(userId, email, ip, userAgent, "PASSWORD_RESET_OTP_VERIFIED");
            LOGGER.info("OTP verified successfully for user ID: " + userId);

            response.sendRedirect(request.getContextPath() + "/auth/resetPassword.jsp");

        } catch (OtpExpiredException e) {
            auditLogService.logLoginAttempt(userId, email, ip, userAgent, "OTP_EXPIRED");
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/auth/verifyOtp.jsp").forward(request, response);
            
        } catch (InvalidOtpException e) {
            auditLogService.logLoginAttempt(userId, email, ip, userAgent, "OTP_VERIFICATION_FAILED");
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/auth/verifyOtp.jsp").forward(request, response);
            
        } catch (TooManyAttemptsException e) {
            auditLogService.logLoginAttempt(userId, email, ip, userAgent, "OTP_LOCKED");
            invalidateRecoverySession(session); // Lockout: clear session data
            request.setAttribute("warningMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during OTP verification", e);
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            request.getRequestDispatcher("/auth/verifyOtp.jsp").forward(request, response);
        }
    }

    // --- Helper Methods ---

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

    private void invalidateRecoverySession(HttpSession session) {
        if (session != null) {
            session.removeAttribute("passwordResetUserId");
            session.removeAttribute("passwordResetEmail");
            session.removeAttribute("passwordResetVerified");
            session.removeAttribute("passwordResetVerifiedTime");
            session.removeAttribute("passwordResetToken");
        }
    }
}