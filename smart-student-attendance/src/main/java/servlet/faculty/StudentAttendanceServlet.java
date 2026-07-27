package servlet.faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Student;
import model.User;
import service.FacultyService;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/faculty/student/attendance")
public class StudentAttendanceServlet extends BaseServlet {

    private static final Logger LOGGER =
            Logger.getLogger(StudentAttendanceServlet.class.getName());

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

            double overallAttendance =
                    facultyService.getStudentOverallAttendance(studentId);

            int totalClasses =
                    facultyService.getTotalClassesForStudent(studentId);

            int attendedClasses =
                    facultyService.getAttendedClassesForStudent(studentId);

            request.setAttribute("student", student);
            request.setAttribute("overallAttendance", overallAttendance);
            request.setAttribute("totalClasses", totalClasses);
            request.setAttribute("attendedClasses", attendedClasses);

            request.setAttribute("attendanceTrend", 2.5);
            request.setAttribute("subjectAttendance",
                    facultyService.getSubjectWiseAttendance(studentId));
            request.setAttribute("recentRecords",
                    facultyService.getRecentAttendanceRecords(studentId));

            request.setAttribute("presentDays", attendedClasses);
            request.setAttribute("absentDays",
                    totalClasses - attendedClasses);

            request.setAttribute("medicalLeaves", 0);
            request.setAttribute("lateEntries", 0);

            request.setAttribute("topSubjects",
                    facultyService.getTopAttendanceSubjects(studentId));

            request.setAttribute(
                    "riskLevel",
                    overallAttendance >= 75
                            ? "safe"
                            : (overallAttendance >= 50
                                    ? "warning"
                                    : "critical")
            );

            request.setAttribute("longestStreak", 15);
            request.setAttribute("currentStreak", 5);
            request.setAttribute("bestSubject", "OS");
            request.setAttribute("lowestSubject", "DBMS");

            request.setAttribute("pageTitle", "Student Attendance");
            request.setAttribute("activePage", "students");

            request.getRequestDispatcher("/faculty/student/attendance.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid student ID: " + e.getMessage());
            response.sendRedirect(
                    request.getContextPath() + "/faculty/students");
        } catch (Exception e) {
            LOGGER.severe("Error loading student attendance: "
                    + e.getMessage());
            response.sendRedirect(
                    request.getContextPath() + "/faculty/students");
        }
    }
}