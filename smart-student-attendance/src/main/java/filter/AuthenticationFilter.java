package filter;

import model.User;
import service.AuthService;
import service.RoleBasedRedirectService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.logging.Logger;

// Intercepts all protected role-based directories
@WebFilter(urlPatterns = {"/admin/*", "/faculty/*", "/student/*"})
public class AuthenticationFilter implements Filter {
    
    private final AuthService authService = new AuthService();
    private static final Logger LOGGER = Logger.getLogger(AuthenticationFilter.class.getName());

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean isLoggedIn = false;
        User loggedInUser = null;

        // 1. Check if User is already in Session
        if (session != null && session.getAttribute("loggedInUser") != null) {
            loggedInUser = (User) session.getAttribute("loggedInUser");
            isLoggedIn = true;
        } else {
            // 2. Check for "Remember Me" Cookie (Auto-Login)
            loggedInUser = authService.validateRememberMeCookie(req);
            if (loggedInUser != null) {
                // Recreate session securely
                session = req.getSession(true);
                session.setAttribute("loggedInUser", loggedInUser);
                session.setMaxInactiveInterval(30 * 60);
                isLoggedIn = true;
                LOGGER.info("User " + loggedInUser.getUsername() + " auto-logged in via Remember Me token.");
            }
        }

        if (isLoggedIn) {
            // --- ENTERPRISE FEATURE: Role-Based Access Control (RBAC) ---
            // Ensure the user's role matches the URL they are trying to access
            String requestURI = req.getRequestURI();
            String contextPath = req.getContextPath();
            String path = requestURI.substring(contextPath.length()); // e.g., /admin/dashboard.jsp
            
            // Get the expected path for the user's role (e.g., "/student")
            String userRolePath = "/" + loggedInUser.getRole().name().toLowerCase(); 
            
            // If the URL path does not start with the user's role path (and isn't a common resource)
            if (!path.startsWith(userRolePath) && !path.startsWith("/common/")) {
                LOGGER.warning("Access Denied: User " + loggedInUser.getUsername() + 
                               " (" + loggedInUser.getRole() + ") attempted to access restricted area: " + path);
                
                // Redirect them to their actual dashboard instead of showing an error
                String correctPath = RoleBasedRedirectService.getDashboardPath(loggedInUser.getRole());
                res.sendRedirect(req.getContextPath() + correctPath);
                return; // Stop filter chain
            }

            // User is authenticated AND authorized for this specific URL
            chain.doFilter(request, response);
            
        } else {
            // Not logged in and no valid Remember Me token -> Redirect to Login
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }
}