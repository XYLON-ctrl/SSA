package servlet.faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import service.FacultyService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/faculty/dashboard")
public class DashboardServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());
    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadDashboardData(request, response);
        request.getRequestDispatcher("/faculty/facultyDashboard.jsp").forward(request, response);
    }

    // ✅ NEW: Handle inline approve/reject from dashboard
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = requireFaculty(request, response);
        if (user == null) return;

        String leaveAction = request.getParameter("leaveAction");
        
        // Only process if it's a leave action from dashboard
        if ("approve".equals(leaveAction) || "reject".equals(leaveAction)) {
            try {
            	int leaveId = Integer.parseInt(request.getParameter("leaveId"));

            	Faculty faculty = facultyService.getFacultyProfile(user.getUserId());
            	if (faculty == null) {
            	    request.setAttribute("errorMessage", "Faculty profile not found.");
            	    loadDashboardData(request, response);
            	    request.getRequestDispatcher("/faculty/facultyDashboard.jsp").forward(request, response);
            	    return;
            	}

            	int facultyId = faculty.getFacultyId();
            	boolean success;
                
                if ("approve".equals(leaveAction)) {
                    success = facultyService.approveLeave(leaveId, facultyId, "Approved from dashboard");
                    if (success) {
                        request.setAttribute("successMessage", "Leave request approved successfully!");
                    } else {
                        request.setAttribute("errorMessage", "Failed to approve leave request.");
                    }
                } else {
                    success = facultyService.rejectLeave(leaveId, facultyId, "Rejected from dashboard");
                    if (success) {
                        request.setAttribute("successMessage", "Leave request rejected successfully!");
                    } else {
                        request.setAttribute("errorMessage", "Failed to reject leave request.");
                    }
                }
            } catch (Exception e) {
                LOGGER.severe("Error processing leave action: " + e.getMessage());
                request.setAttribute("errorMessage", "Error processing leave action.");
            }
        }

        // Reload dashboard data and forward (NOT redirect)
        loadDashboardData(request, response);
        request.getRequestDispatcher("/faculty/facultyDashboard.jsp").forward(request, response);
    }

    // ✅ Extracted common data loading logic
    private void loadDashboardData(HttpServletRequest request, HttpServletResponse response) {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (user == null) return;

        int facultyId = facultyService.getFacultyIdByEmail(user.getEmail());

        try {
            Faculty profile = facultyService.getFacultyProfile(facultyId);
            request.setAttribute("profile", profile);

            request.setAttribute("todayClasses", facultyService.getTodayClassesCount(facultyId));
            request.setAttribute("totalStudents", facultyService.getTotalStudentsTeaching(facultyId));
            request.setAttribute("pendingLeaves", facultyService.getPendingLeaveRequestsCount(facultyId));
            request.setAttribute("todayTimetable", facultyService.getTodayTimetable(facultyId));

            Map<String, Object> workload = facultyService.getWorkloadSummary(facultyId);
            request.setAttribute("workload", workload);

            request.setAttribute("assignedSubjects", facultyService.getAssignedSubjects(facultyId));
            request.setAttribute("recentActivities", facultyService.getRecentActivities(facultyId));
            request.setAttribute("pendingLeaveRequests", facultyService.getLeaveRequestsForApproval(facultyId));
            request.setAttribute("todayDate", new java.util.Date());

        } catch (Exception e) {
            LOGGER.severe("Error loading dashboard: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to load dashboard data.");
        }

        request.setAttribute("pageTitle", "Dashboard");
        request.setAttribute("activePage", "dashboard");
    }
}