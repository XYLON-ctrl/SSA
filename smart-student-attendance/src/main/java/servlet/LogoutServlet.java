package servlet;

import service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    private final AuthService authService = new AuthService();
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        performLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        performLogout(request, response);
    }

    private void performLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // 1. Invalidate the Session
        HttpSession session = request.getSession(false);
        if (session != null) {
            LOGGER.info("User logged out. Session invalidated for IP: " + request.getRemoteAddr());
            session.invalidate();
        }

        // 2. Clear "Remember Me" Cookie from Database and Browser
        authService.clearRememberMeCookie(response);

        // 3. Redirect to Login Page
        // We pass a query parameter so the frontend can display a "Logged out successfully" message
        response.sendRedirect(request.getContextPath() + "/login?logout=success");
    }
}