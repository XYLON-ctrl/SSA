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

import model.Student;
import model.TimetableEntry;
import model.User;
import service.StudentService;

@WebServlet("/student/timetable")
public class TimetableServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(TimetableServlet.class.getName());
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        int userId = loggedInUser.getUserId();

        try {
            // ✅ Fetch profile using login userId
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                request.setAttribute("errorMessage", "Student profile not found.");
                request.setAttribute("activePage", "timetable");
                request.getRequestDispatcher("/student/timetable.jsp").forward(request, response);
                return;
            }

            // ✅ Extract academic student_id for timetable query
            int academicStudentId = student.getStudentId();
            int semester = student.getCurrentSemester();

            // ✅ Pass academicStudentId (NOT userId) to timetable service
            List<TimetableEntry> timetable = studentService.getWeeklyTimetable(academicStudentId, semester);

            request.setAttribute("student", student);
            request.setAttribute("timetable", timetable);
            request.setAttribute("todayDay", LocalDate.now().getDayOfWeek().name());
            request.setAttribute("activePage", "timetable");
            request.getRequestDispatcher("/student/timetable.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading timetable for userId: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load timetable data.");
            request.setAttribute("activePage", "timetable");
            request.getRequestDispatcher("/student/timetable.jsp").forward(request, response);
        }
    }
}