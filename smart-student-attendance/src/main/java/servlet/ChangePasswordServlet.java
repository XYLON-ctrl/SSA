package servlet;

import com.google.gson.Gson;
import dao.UserDAO;
import dao.UserDAOImpl;
import dao.AuditLogDAO;
import dao.AuditLogDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/auth/change-password")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class ChangePasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ChangePasswordServlet.class.getName());
    private final UserDAO userDAO = new UserDAOImpl();
    private final AuditLogDAO auditLogDAO = new AuditLogDAOImpl();  // ✅ Added as class field
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        transferFlashMessages(request, session);
        request.getRequestDispatcher("/auth/changePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        Map<String, Object> jsonResponse = new HashMap<>();
        
        try {
            if (session == null || session.getAttribute("loggedInUser") == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Session expired. Please login again.");
                jsonResponse.put("redirect", request.getContextPath() + "/login");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            int userId = ((model.User) session.getAttribute("loggedInUser")).getUserId();
            
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            
            LOGGER.info("Password change request for user ID: " + userId);
            LOGGER.info("Current password received: " + (currentPassword != null ? "YES (length: " + currentPassword.length() + ")" : "NO"));
            LOGGER.info("New password received: " + (newPassword != null ? "YES (length: " + newPassword.length() + ")" : "NO"));
            
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                LOGGER.warning("Current password is null or empty for user ID: " + userId);
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Current password is required.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            if (newPassword == null || newPassword.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "New password is required.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            if (newPassword.length() < 6) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "New password must be at least 6 characters long.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            if (currentPassword.equals(newPassword)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "New password must be different from your current password.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            if (!userDAO.verifyPassword(userId, currentPassword)) {
                LOGGER.warning("Failed password change attempt for user ID: " + userId + " - Incorrect current password");
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Current password is incorrect.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            boolean updated = userDAO.changePassword(userId, newPassword);
            
            if (updated) {
                LOGGER.info("Password changed successfully for user ID: " + userId);
                
                // ✅ Fixed: Correct audit log entry with proper action type, description, and IP
                auditLogDAO.logAuditAction(userId, "Password Changed", 
                    "User successfully changed their password", request.getRemoteAddr());
                
                session.invalidate();
                
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Password changed successfully. Please login with your new password.");
                jsonResponse.put("redirect", request.getContextPath() + "/login");
            } else {
                LOGGER.warning("Failed to update password for user ID: " + userId);
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Failed to update password. Please try again.");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error changing password", e);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "An unexpected error occurred. Please try again later.");
        }
        
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void transferFlashMessages(HttpServletRequest request, HttpSession session) {
        String errorMessage = (String) session.getAttribute("errorMessage");
        String successMessage = (String) session.getAttribute("successMessage");
        String warningMessage = (String) session.getAttribute("warningMessage");
        
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        if (warningMessage != null) {
            request.setAttribute("warningMessage", warningMessage);
            session.removeAttribute("warningMessage");
        }
    }
}