package servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Role;

import java.io.IOException;
import java.util.logging.Logger;

public abstract class BaseServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BaseServlet.class.getName());

    /**
     * Verifies the user is logged in as ADMIN.
     * Redirects to login if not. Returns null if unauthorized.
     */
    protected User requireAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        
        // ✅ Check both that user exists AND role is ADMIN
        if (user == null || user.getRole() != Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        
        // Transfer flash messages
        if (session != null) {
            String successMsg = (String) session.getAttribute("successMessage");
            String errorMsg = (String) session.getAttribute("errorMessage");
            
            if (successMsg != null) {
                request.setAttribute("successMessage", successMsg);
                session.removeAttribute("successMessage");
            }
            if (errorMsg != null) {
                request.setAttribute("errorMessage", errorMsg);
                session.removeAttribute("errorMessage");
            }
        }
        
        return user;
    }

    /**
     * Helper to store success message in session for redirect-based flow.
     */
    protected void setSuccessMessage(
            HttpServletRequest request,
            String message) {

        request.getSession()
               .setAttribute("successMessage", message);
    }

    /**
     * Helper to store error message in session for redirect-based flow.
     */
    protected void setErrorMessage(
            HttpServletRequest request,
            String message) {

        request.getSession()
               .setAttribute("errorMessage", message);
    }
    /**
     * Helper to set active page for sidebar highlighting.
     */
    protected void setActivePage(HttpServletRequest request, String page) {
        request.setAttribute("activePage", page);
    }
}