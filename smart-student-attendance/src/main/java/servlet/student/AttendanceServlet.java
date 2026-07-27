package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.Student;
import model.SubjectAttendanceDTO;
import model.User;
import service.AttendanceService;
import service.StudentService;

@WebServlet("/student/attendance")
public class AttendanceServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(AttendanceServlet.class.getName());

    private final AttendanceService attendanceService = new AttendanceService();
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        int userId = loggedInUser.getUserId();

        try {
            // ✅ Resolve academic student_id from profile
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                request.setAttribute("errorMessage", "Student profile not found.");
                request.setAttribute("activePage", "attendance");
                request.getRequestDispatcher("/student/attendance.jsp").forward(request, response);
                return;
            }

            int academicStudentId = student.getStudentId();

            // ✅ Use academicStudentId for all attendance queries
            double overallPercentage = attendanceService.getOverallAttendance(academicStudentId);
            
            List<SubjectAttendanceDTO> subjectAttendance = attendanceService.getSubjectWiseAttendance(academicStudentId);
            for (SubjectAttendanceDTO dto : subjectAttendance) {
                dto.setStatus(attendanceService.getAttendanceStatus(dto.getPercentage()));
                dto.setClassesNeeded(attendanceService.getClassesNeededToReachTarget(
                        dto.getAttendedClasses(), dto.getTotalClasses()));
            }

            request.setAttribute("student", student);
            request.setAttribute("overallPercentage", overallPercentage);
            request.setAttribute("subjectAttendance", subjectAttendance);
            request.setAttribute("activePage", "attendance");
            request.getRequestDispatcher("/student/attendance.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading attendance for userId: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load attendance data.");
            request.setAttribute("activePage", "attendance");
            request.getRequestDispatcher("/student/attendance.jsp").forward(request, response);
        }
    }
}