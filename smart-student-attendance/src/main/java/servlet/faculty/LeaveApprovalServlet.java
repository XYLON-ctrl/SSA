package servlet.faculty;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.LeaveRequest;
import model.User;
import service.FacultyService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/faculty/leave-approval")
public class LeaveApprovalServlet extends BaseServlet {
    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireFaculty(request, response);
        if (user == null) return;
        
        Map<String, Object> sectionInfo = facultyService.getAdvisorSectionInfo(user.getUserId());
        boolean isAdvisor = (sectionInfo != null && sectionInfo.get("sectionName") != null);
        request.setAttribute("sectionInfo", sectionInfo);
        request.setAttribute("isClassAdvisor", isAdvisor);
        

        int facultyId = facultyService.getFacultyIdByEmail(user.getEmail());

        // Get filter parameter (default: ALL)
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "ALL";
        }

        // Fetch filtered leave requests
        List<LeaveRequest> allLeaves = facultyService.getAllLeaveRequestsForAdvisor(facultyId, statusFilter);
        request.setAttribute("allLeaves", allLeaves);

        // Fetch counts for filter badges
        Map<String, Integer> leaveCounts = facultyService.getLeaveCountsByStatus(facultyId);
        request.setAttribute("leaveCounts", leaveCounts);

        // Pass current filter to JSP
        request.setAttribute("currentFilter", statusFilter);

        request.setAttribute("pageTitle", "Leave Approvals");
        request.setAttribute("activePage", "leaveApproval");
        request.getRequestDispatcher("/faculty/facultyLeaveApproval.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = requireFaculty(request, response);
        if (user == null) return;

        int facultyId = facultyService.getFacultyIdByEmail(user.getEmail());

        int leaveId = Integer.parseInt(request.getParameter("leaveId"));
        String action = request.getParameter("action");
        String remarks = request.getParameter("remarks");

        boolean success = false;

        if ("approve".equals(action)) {
            success = facultyService.approveLeave(
                    leaveId,
                    facultyId,
                    remarks
            );
        } else if ("reject".equals(action)) {
            success = facultyService.rejectLeave(
                    leaveId,
                    facultyId,
                    remarks
            );
        }

        if (success) {
            request.getSession().setAttribute(
                    "successMessage",
                    "Leave request " +
                    ("approve".equals(action) ? "approved" : "rejected") +
                    " successfully!"
            );
        } else {
            request.getSession().setAttribute(
                    "errorMessage",
                    "Failed to update leave request."
            );
        }

        // Preserve filter after action
        String currentFilter = request.getParameter("status");
        if (currentFilter == null || currentFilter.trim().isEmpty()) {
            currentFilter = "ALL";
        }

        response.sendRedirect(
                request.getContextPath()
                + "/faculty/leave-approval?status="
                + currentFilter
        );
    }
}