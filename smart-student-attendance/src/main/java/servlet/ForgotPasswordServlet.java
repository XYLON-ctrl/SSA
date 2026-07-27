package servlet;

import exception.AccountLockedException;
import exception.AuthenticationException;
import exception.SecurityViolationException;
import model.User;
import service.OtpService;
import dao.UserDAO;
import dao.UserDAOImpl;
import util.CsrfUtil;
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

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();
    private final OtpService otpService = new OtpService();
    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());

    // 15. GET Request: Redirect to JSP if accessed directly
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String identifier = request.getParameter("username"); // Accepts username OR email
        String csrfToken = request.getParameter("csrf_token");

        // 3. CSRF Protection
        if (!CsrfUtil.isValidToken(session, csrfToken)) {
            LOGGER.warning("CSRF validation failed for forgot password. IP: " + request.getRemoteAddr());
            request.setAttribute("errorMessage", "Security validation failed. Please refresh and try again.");
            request.getRequestDispatcher("/auth/forgotPassword.jsp").forward(request, response);
            return;
        }
        CsrfUtil.removeToken(session); // Invalidate token after single use

        // 4. Input Validation
        if (identifier == null || identifier.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your registered email address or username.");
            request.getRequestDispatcher("/auth/forgotPassword.jsp").forward(request, response);
            return;
        }
        identifier = identifier.trim();
        
        if (ValidationUtil.containsMaliciousInput(identifier)) {
            LOGGER.warning("Malicious input detected in forgot password: " + identifier);
            request.setAttribute("errorMessage", "Invalid input detected.");
            request.getRequestDispatcher("/auth/forgotPassword.jsp").forward(request, response);
            return;
        }

        String ip = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");

        try {
            // 6. User Lookup (Never reveal if account exists)
            User user = userDAO.findByUsernameOrEmail(identifier);

            if (user != null) {
                // 7. Account Status Validation
                String status = user.getAccountStatus();
                if ("LOCKED".equalsIgnoreCase(status)) {
                    throw new AccountLockedException("Account is locked.");
                }
                if ("DISABLED".equalsIgnoreCase(status) || "SUSPENDED".equalsIgnoreCase(status)) {
                    throw new AuthenticationException("Account is inactive.");
                }

                // 8 & 9. OTP Generation, Rate Limiting & Email Delivery (Delegated to Service)
                otpService.generateAndSendOtp(user, ip, userAgent);

                // 10. Session Data (Store ONLY identifiers, NEVER the OTP)
                session = request.getSession(true);
                session.setAttribute("passwordResetUserId", user.getUserId());
                session.setAttribute("passwordResetEmail", user.getEmail());
            }

            // 12. Success Flow (Generic message to prevent account enumeration)
            request.setAttribute("successMessage", "If an account matching the provided information exists, a verification code has been sent.");
            response.sendRedirect(request.getContextPath() + "/auth/verifyOtp.jsp");

        } catch (AuthenticationException e) {
            // Security: Do not reveal account status. Show generic success message to prevent enumeration.
            LOGGER.warning("Forgot password attempted on inactive/locked account. Identifier: " + identifier);
            request.setAttribute("successMessage", "If an account matching the provided information exists, a verification code has been sent.");
            response.sendRedirect(request.getContextPath() + "/auth/verifyOtp.jsp");
            
        } catch (SecurityViolationException e) {
            // 5. Rate Limiting Exceeded
            LOGGER.warning("Rate limit exceeded for forgot password. Identifier: " + identifier);
            request.setAttribute("warningMessage", "Too many requests. Please try again later.");
            request.getRequestDispatcher("/auth/forgotPassword.jsp").forward(request, response);
            
        } catch (Exception e) {
            // 13. Failure Handling (Never expose stack traces)
            LOGGER.log(Level.SEVERE, "Unexpected error during forgot password process", e);
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            request.getRequestDispatcher("/auth/forgotPassword.jsp").forward(request, response);
        }
    }
}