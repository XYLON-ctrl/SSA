package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.LeaveRequest;
import model.Student;
import model.User;
import service.LeaveService;
import service.StudentService;

@WebServlet("/student/leave/history")
public class LeaveHistoryServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(LeaveHistoryServlet.class.getName());
    private final LeaveService leaveService = new LeaveService();
    private final StudentService studentService = new StudentService(); // ✅ Add this

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        int userId = loggedInUser.getUserId();
        
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "ALL";
        } else {
            statusFilter = statusFilter.trim().toUpperCase();
        }

        try {
            // ✅ STEP 1: Resolve academic student_id
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                request.setAttribute("errorMessage", "Student profile not found.");
                request.setAttribute("activePage", "leaveHistory");
                request.getRequestDispatcher("/student/leaveHistory.jsp").forward(request, response);
                return;
            }
            int academicStudentId = student.getStudentId();

            // ✅ STEP 2: Use academicStudentId for leave queries
            List<LeaveRequest> history = leaveService.getLeaveHistoryByStatus(academicStudentId, statusFilter);
            
            int pendingCount = leaveService.getLeaveCountByStatus(academicStudentId, "PENDING");
            int approvedCount = leaveService.getLeaveCountByStatus(academicStudentId, "APPROVED");
            int rejectedCount = leaveService.getLeaveCountByStatus(academicStudentId, "REJECTED");
            int totalCount = history.size();

            request.setAttribute("leaveHistory", history);
            request.setAttribute("currentFilter", statusFilter);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("activePage", "leaveHistory");
            
            request.getRequestDispatcher("/student/leaveHistory.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading leave history for user ID: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load leave history.");
            request.setAttribute("activePage", "leaveHistory");
            request.getRequestDispatcher("/student/leaveHistory.jsp").forward(request, response);
        }
    }
}