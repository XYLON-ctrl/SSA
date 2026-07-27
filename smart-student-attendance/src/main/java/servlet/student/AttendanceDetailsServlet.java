package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.AttendanceRecord;
import model.Student;
import model.User;
import service.AttendanceService;
import service.StudentService;

@WebServlet("/student/attendance/details")
public class AttendanceDetailsServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(AttendanceDetailsServlet.class.getName());

    private final AttendanceService attendanceService = new AttendanceService();
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        int userId = loggedInUser.getUserId();
        int subjectId = parseInt(request.getParameter("subjectId"), 0);

        LOGGER.info("Loading attendance details for userId: " + userId + ", subjectId: " + subjectId);

        try {
            // ✅ Resolve academic student_id from profile
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                request.setAttribute("errorMessage", "Student profile not found.");
                request.setAttribute("activePage", "attendance");
                request.getRequestDispatcher("/student/attendanceDetails.jsp").forward(request, response);
                return;
            }

            int academicStudentId = student.getStudentId();

            // ✅ Use academicStudentId for attendance details query
            List<AttendanceRecord> dailyRecords = attendanceService.getSubjectAttendanceDetails(academicStudentId, subjectId);

            LOGGER.info("Found " + dailyRecords.size() + " attendance records");

            if (!dailyRecords.isEmpty()) {
                AttendanceRecord first = dailyRecords.get(0);
                LOGGER.info("First record - Subject: " + first.getSubjectName() +
                        ", Date: " + first.getAttendanceDate() +
                        ", Status: " + first.getStatus());
            }

            request.setAttribute("student", student);
            request.setAttribute("dailyRecords", dailyRecords);
            request.setAttribute("subjectId", subjectId);
            request.setAttribute("activePage", "attendance");
            request.getRequestDispatcher("/student/attendanceDetails.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading attendance details for userId: " + userId + ", subjectId: " + subjectId, e);
            request.setAttribute("errorMessage", "Failed to load attendance details: " + e.getMessage());
            request.setAttribute("activePage", "attendance");
            request.getRequestDispatcher("/student/attendanceDetails.jsp").forward(request, response);
        }
    }
}