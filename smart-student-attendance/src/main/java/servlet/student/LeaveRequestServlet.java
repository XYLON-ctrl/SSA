package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.LeaveRequest;
import model.Student;
import model.User;
import service.LeaveService;
import service.StudentService;

@WebServlet("/student/leave/request")
public class LeaveRequestServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(LeaveRequestServlet.class.getName());
    private final LeaveService leaveService = new LeaveService();
    private final StudentService studentService = new StudentService(); // ✅ Added

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        int userId = loggedInUser.getUserId();

        try {
            // ✅ Resolve academic student_id for leave queries
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                request.setAttribute("errorMessage", "Student profile not found.");
                request.setAttribute("activePage", "leaveRequest");
                request.getRequestDispatcher("/student/leaveRequest.jsp").forward(request, response);
                return;
            }

            int academicStudentId = student.getStudentId();

            // ✅ Use academicStudentId for leave history and counts
            List<LeaveRequest> history = leaveService.getLeaveHistory(academicStudentId);
            int[] counts = leaveService.getLeaveSummaryCounts(academicStudentId);

            request.setAttribute("student", student);
            request.setAttribute("leaveHistory", history);
            request.setAttribute("leaveCounts", counts);
            request.setAttribute("activePage", "leaveRequest");
            request.getRequestDispatcher("/student/leaveRequest.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading leave request page for userId: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load leave request data.");
            request.setAttribute("activePage", "leaveRequest");
            request.getRequestDispatcher("/student/leaveRequest.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        int userId = loggedInUser.getUserId();

        try {
            // ✅ CRITICAL FIX: Resolve academic student_id before creating leave
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                flashError(request, "Student profile not found. Cannot submit leave.");
                response.sendRedirect(request.getContextPath() + "/student/leave/request");
                return;
            }

            int academicStudentId = student.getStudentId();

            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String reason = request.getParameter("reason");

            LocalDate startDate = (startDateStr != null && !startDateStr.isBlank())
                    ? LocalDate.parse(startDateStr) : null;
            LocalDate endDate = (endDateStr != null && !endDateStr.isBlank())
                    ? LocalDate.parse(endDateStr) : null;

            LeaveRequest leaveRequest = new LeaveRequest();
            // ✅ FIXED: Set academic student_id, NOT login userId
            leaveRequest.setStudentId(academicStudentId);
            leaveRequest.setStartDate(startDate);
            leaveRequest.setEndDate(endDate);
            leaveRequest.setReason(reason);

            boolean success = leaveService.applyForLeave(leaveRequest);

            if (success) {
                flashSuccess(request, "Leave request submitted successfully.");
            } else {
                flashError(request, "Invalid dates or reason. Please try again.");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing leave request for userId: " + userId, e);
            flashError(request, "An error occurred while processing your request.");
        }

        response.sendRedirect(request.getContextPath() + "/student/leave/request");
    }
}