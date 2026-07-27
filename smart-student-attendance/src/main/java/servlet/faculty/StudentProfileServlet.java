package servlet.faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Student;
import model.Subject;
import model.User;
import service.FacultyService;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/faculty/student/profile")
public class StudentProfileServlet extends BaseServlet {

    private static final Logger LOGGER =
            Logger.getLogger(StudentProfileServlet.class.getName());

    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        User user = requireFaculty(request, response);
        if (user == null) {
            return;
        }

        try {
            String studentIdStr = request.getParameter("id");

            if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/faculty/students");
                return;
            }

            int studentId = Integer.parseInt(studentIdStr);

            Student student = facultyService.getStudentById(studentId);

            if (student == null) {
                response.sendRedirect(
                        request.getContextPath() + "/faculty/students");
                return;
            }

            List<Subject> subjects =
                    facultyService.getStudentSubjects(studentId);

            double attendancePercentage =
                    facultyService.getStudentOverallAttendance(studentId);

            request.setAttribute("student", student);
            request.setAttribute("subjects", subjects);
            request.setAttribute("attendancePercentage",
                    attendancePercentage);

            request.setAttribute("approvedLeaves", 0);
            request.setAttribute("pendingLeaves", 0);
            request.setAttribute("rejectedLeaves", 0);
            request.setAttribute("totalLeaves", 0);

            request.setAttribute(
                    "recentActivities",
                    facultyService.getStudentRecentActivities(studentId));

            request.setAttribute("pageTitle", "Student Profile");
            request.setAttribute("activePage", "students");

            request.getRequestDispatcher("/faculty/student/profile.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid student ID: " + e.getMessage());
            response.sendRedirect(
                    request.getContextPath() + "/faculty/students");
        } catch (Exception e) {
            LOGGER.severe("Error loading student profile: "
                    + e.getMessage());
            response.sendRedirect(
                    request.getContextPath() + "/faculty/students");
        }
    }
}