package servlet;

import exception.*;
import model.User;
import service.AuthService;
import service.RoleBasedRedirectService;
import util.CsrfUtil;
import dao.AttendanceDAO;
import dao.AttendanceDAOImpl;
import dao.AuditLogDAO;
import dao.AuditLogDAOImpl;
import dao.FacultyDAO;
import dao.FacultyDAOImpl;
import dao.StudentDAO;
import dao.StudentDAOImpl;
import dao.SubjectDAO;
import dao.SubjectDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private final AuthService authService = new AuthService();
    private final AuditLogDAO auditLogDAO = new AuditLogDAOImpl();
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private final StudentDAO studentDAO = new StudentDAOImpl();
    private final FacultyDAO facultyDAO = new FacultyDAOImpl();
    private final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
    private final SubjectDAO subjectDAO = new SubjectDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);

            if (session != null) {
                Object loggedInUser = session.getAttribute("loggedInUser");

                if (loggedInUser instanceof User) {
                    auditLogDAO.logAuditAction(
                            ((User) loggedInUser).getUserId(),
                            "User Logout",
                            "User logged out successfully",
                            request.getRemoteAddr());
                }

                session.invalidate();
            }

            request.setAttribute("successMessage",
                    "You have been successfully logged out.");
        }

        HttpSession session = request.getSession(true);

        String csrfToken = java.util.UUID.randomUUID().toString();
        session.setAttribute("CSRF_TOKEN", csrfToken);
        request.setAttribute("csrfToken", csrfToken);

        try {

            // ===== Statistics for Login Page =====
            request.setAttribute("totalStudents",
                    studentDAO.getTotalStudentCount());

            request.setAttribute("totalFaculty",
                    facultyDAO.getTotalFacultyCount());

            request.setAttribute("attendancePercentage",
                    attendanceDAO.getOverallAttendancePercentage() + "%");

            request.setAttribute("activeSubjects",
                    subjectDAO.getActiveSubjectCount());

        } catch (Exception e) {

            LOGGER.log(Level.WARNING,
                    "Failed to load dashboard statistics", e);

            request.setAttribute("totalStudents", 0);
            request.setAttribute("totalFaculty", 0);
            request.setAttribute("attendancePercentage", "0%");
            request.setAttribute("activeCourses", 0);
        }

        request.getRequestDispatcher("/auth/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String csrfToken = request.getParameter("csrf_token");

        if (!CsrfUtil.isValidToken(session, csrfToken)) {
            LOGGER.warning("CSRF validation failed for IP: " + request.getRemoteAddr());
            session = request.getSession(true);
            String newToken = java.util.UUID.randomUUID().toString();
            session.setAttribute("CSRF_TOKEN", newToken);
            request.setAttribute("csrfToken", newToken);
            request.setAttribute("errorMessage", "Security validation failed. Please refresh and try again.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }
        CsrfUtil.removeToken(session);

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));

        try {
            String ip = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");
            
            User user = authService.authenticate(username, password, ip, userAgent);

            if (session != null) {
                session.invalidate();
            }
            session = request.getSession(true);
            
            session.setAttribute("loggedInUser", user);
            session.setMaxInactiveInterval(30 * 60);

            if (rememberMe) {
                authService.setupRememberMe(response, user);
            }

            auditLogDAO.logAuditAction(user.getUserId(), "User Login", 
                "User logged in successfully from " + ip, ip);

            String redirectPath = RoleBasedRedirectService.getDashboardPath(user.getRole());
            response.sendRedirect(request.getContextPath() + redirectPath);

        } catch (AccountLockedException | InvalidCredentialsException e) {
            session = request.getSession(true);
            String newToken = java.util.UUID.randomUUID().toString();
            session.setAttribute("CSRF_TOKEN", newToken);
            request.setAttribute("csrfToken", newToken);
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            
        } catch (SecurityViolationException e) {
            session = request.getSession(true);
            String newToken = java.util.UUID.randomUUID().toString();
            session.setAttribute("CSRF_TOKEN", newToken);
            request.setAttribute("csrfToken", newToken);
            request.setAttribute("errorMessage", "Security violation detected.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            
        } catch (Exception e) {
            session = request.getSession(true);
            String newToken = java.util.UUID.randomUUID().toString();
            session.setAttribute("CSRF_TOKEN", newToken);
            request.setAttribute("csrfToken", newToken);
            LOGGER.log(Level.SEVERE, "Unexpected error during login", e);
            request.setAttribute("errorMessage", "An unexpected system error occurred. Please try later.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }
}