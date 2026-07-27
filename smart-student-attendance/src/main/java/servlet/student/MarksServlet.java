package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.Mark;
import model.Student;
import model.Subject;
import model.User;
import service.StudentService;

@WebServlet("/student/marks")
public class MarksServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(MarksServlet.class.getName());
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        int userId = loggedInUser.getUserId(); // Login ID
        int selectedSemester = parseInt(request.getParameter("semester"), 0);
        int selectedSubjectId = parseInt(request.getParameter("subjectId"), 0);
        String examType = request.getParameter("examType");

        try {
            // ✅ STEP 1: Fetch profile to get the academic student_id
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                request.setAttribute("errorMessage", "Student profile not found.");
                request.setAttribute("activePage", "marks");
                request.getRequestDispatcher("/student/marks.jsp").forward(request, response);
                return;
            }

            int academicStudentId = student.getStudentId(); // ✅ Academic ID for DB queries
            int currentSem = student.getCurrentSemester();
            
            List<Integer> availableSemesters = new ArrayList<>();
            for (int i = 1; i <= currentSem; i++) {
                availableSemesters.add(i);
            }

            // ✅ STEP 2: Use academicStudentId for subject lookups
            List<Subject> availableSubjects;
            if (selectedSemester > 0) {
                availableSubjects = studentService.getEnrolledSubjectsBySemester(academicStudentId, selectedSemester);
            } else {
                availableSubjects = studentService.getEnrolledSubjects(academicStudentId);
            }

            // ✅ STEP 3: Use academicStudentId for marks filtering
            List<Mark> marks = studentService.getFilteredMarks(academicStudentId, selectedSemester, examType, selectedSubjectId);

            request.setAttribute("student", student);
            request.setAttribute("availableSemesters", availableSemesters);
            request.setAttribute("availableSubjects", availableSubjects);
            request.setAttribute("marks", marks);
            request.setAttribute("selectedSubjectId", selectedSubjectId);
            request.setAttribute("selectedSemester", selectedSemester);
            request.setAttribute("selectedExamType", examType != null ? examType : "");
            request.setAttribute("activePage", "marks");
            request.getRequestDispatcher("/student/marks.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading marks for user ID: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load marks data.");
            request.setAttribute("activePage", "marks");
            request.getRequestDispatcher("/student/marks.jsp").forward(request, response);
        }
    }
}