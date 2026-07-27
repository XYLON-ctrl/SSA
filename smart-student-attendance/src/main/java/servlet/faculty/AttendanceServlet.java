package servlet.faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import service.FacultyService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/faculty/attendance")
public class AttendanceServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(AttendanceServlet.class.getName());
    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = requireFaculty(request, response);
        if (user == null) return;

        Faculty faculty = facultyService.getFacultyByUserId(user.getUserId());
        if (faculty == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        int facultyId = faculty.getFacultyId();
        
        // ✅ Fetch ONLY subjects and sections assigned to this faculty
        request.setAttribute("subjects", facultyService.getFacultySubjects(facultyId));
        request.setAttribute("sections", facultyService.getFacultySections(facultyId));
        
        String subjectIdStr = request.getParameter("subjectId");
        String sectionIdStr = request.getParameter("sectionId");
        String dateStr = request.getParameter("attendanceDate");
        
        if (subjectIdStr != null && sectionIdStr != null && dateStr != null) {
            try {
                int subjectId = Integer.parseInt(subjectIdStr);
                int sectionId = Integer.parseInt(sectionIdStr);
                LocalDate date = LocalDate.parse(dateStr);
                
                request.setAttribute("selectedSubjectId", subjectId);
                request.setAttribute("selectedSectionId", sectionId);
                request.setAttribute("selectedDate", dateStr);
                request.setAttribute("students", facultyService.getStudentsForAttendance(subjectId, sectionId));
                request.setAttribute("existingRecords", facultyService.getAttendanceRecords(date, subjectId, sectionId));
                request.setAttribute("showAttendanceForm", true);
            } catch (Exception e) {
                LOGGER.warning("Invalid parameters for attendance loading");
            }
        }
        
        request.setAttribute("pageTitle", "Mark Attendance");
        request.setAttribute("activePage", "attendance");
        request.getRequestDispatcher("/faculty/attendance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireFaculty(request, response);
        if (user == null) return;

        Faculty faculty = facultyService.getFacultyByUserId(user.getUserId());
        if (faculty == null) { response.sendRedirect(request.getContextPath() + "/faculty/attendance"); return; }
        int facultyId = faculty.getFacultyId();

        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int sectionId = Integer.parseInt(request.getParameter("sectionId"));
            LocalDate date = LocalDate.parse(request.getParameter("attendanceDate"));

            String[] studentIds = request.getParameterValues("studentId");
            String[] statuses = request.getParameterValues("status");
            int count = 0;

            if (studentIds != null && statuses != null) {
                for (int i = 0; i < studentIds.length; i++) {
                    int sId = Integer.parseInt(studentIds[i]);
                    String status = statuses[i];
                    if (status != null && !status.isEmpty()) {
                        if (facultyService.markAttendance(sId, subjectId, date, status, facultyId, null)) {
                            count++;
                        }
                    }
                }
                request.getSession().setAttribute("successMessage", "Attendance saved for " + count + " students!");
            }
        } catch (Exception e) {
            LOGGER.severe("Error saving attendance: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "Failed to save attendance.");
        }

        response.sendRedirect(request.getContextPath() + "/faculty/attendance?subjectId=" + 
            request.getParameter("subjectId") + "&sectionId=" + request.getParameter("sectionId") + 
            "&attendanceDate=" + request.getParameter("attendanceDate"));
    }
}