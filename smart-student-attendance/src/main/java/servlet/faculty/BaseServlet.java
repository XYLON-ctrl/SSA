package servlet.faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Role;
import service.FacultyService;
import dao.FacultyDAO;
import dao.FacultyDAOImpl;

import java.io.IOException;
import java.util.logging.Logger;

public abstract class BaseServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BaseServlet.class.getName());
    private final FacultyDAO facultyDAO = new FacultyDAOImpl();
    
    protected User requireFaculty(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null || user.getRole() != Role.FACULTY) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        
        // ✅ Always fetch and set classAdvisor status for sidebar
        try {
            boolean isClassAdvisor = facultyDAO.isClassAdvisor(user.getUserId());
            request.setAttribute("isClassAdvisor", isClassAdvisor);
        } catch (Exception e) {
            LOGGER.warning("Could not fetch class advisor status: " + e.getMessage());
            request.setAttribute("isClassAdvisor", false);
        }
        
        return user;
    }
    
    // ✅ Helper method to set active page based on URL
    protected void setActivePage(HttpServletRequest request, String pageName) {
        request.setAttribute("activePage", pageName);
    }
}