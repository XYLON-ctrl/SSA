package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.Mark;
import model.Student;
import model.User;
import service.StudentService;

@WebServlet("/student/performance")
public class AcademicPerformanceServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(AcademicPerformanceServlet.class.getName());

    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);
        int userId = loggedInUser.getUserId();
        LOGGER.info("=== SERVLET: Loading performance page for userId: " + userId);

        try {
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                LOGGER.severe("SERVLET: Student profile not found for userId: " + userId);
                request.setAttribute("errorMessage", "Student profile not found.");
                request.getRequestDispatcher("/student/academicPerformance.jsp").forward(request, response);
                return;
            }

            int academicStudentId = student.getStudentId();
            LOGGER.info("SERVLET: Academic studentId: " + academicStudentId);

            // Fetch data
            List<Mark> marks = studentService.getStudentMarks(academicStudentId);
            int totalCredits = studentService.getTotalCreditsEarned(academicStudentId);
            int totalPossibleCredits = studentService.getTotalPossibleCredits(academicStudentId);

            // Class Rank
            String batch = student.getBatch();
            int classRank = 0;
            int totalStudentsInBatch = 0;
            if (batch != null && !batch.trim().isEmpty()) {
                classRank = studentService.getClassRank(academicStudentId, batch);
                totalStudentsInBatch = studentService.getTotalStudentsInBatch(batch);
            }

            // ✅ Generate JSON for Charts
            String chartDataJson = studentService.getPerformanceChartDataJson(academicStudentId);
            LOGGER.info("SERVLET: Chart JSON length: " + chartDataJson.length());
            LOGGER.info("SERVLET: Chart JSON: " + chartDataJson);

            // Set Attributes
            request.setAttribute("student", student);
            request.setAttribute("marks", marks);
            request.setAttribute("totalCredits", totalCredits);
            request.setAttribute("totalPossibleCredits", totalPossibleCredits);
            request.setAttribute("classRank", classRank);
            request.setAttribute("totalStudentsInBatch", totalStudentsInBatch);
            request.setAttribute("chartDataJson", chartDataJson);
            request.setAttribute("activePage", "performance");
            
            LOGGER.info("SERVLET: Forwarding to JSP");
            request.getRequestDispatcher("/student/academicPerformance.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "SERVLET: Error loading academic performance", e);
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "Failed to load academic performance data.");
                request.getRequestDispatcher("/student/academicPerformance.jsp").forward(request, response);
            }
        }
    }
}