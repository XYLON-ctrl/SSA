package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.UserDAO;
import dao.UserDAOImpl;
import model.Student;
import model.Subject;
import model.User;
import service.StudentService;

@WebServlet("/student/profile")
public class ProfileServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());
    private static final DateTimeFormatter DATETIME_FORMATTER =
            DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    private final StudentService studentService = new StudentService();
    private final UserDAO userDAO = new UserDAOImpl();

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
                LOGGER.severe("Student profile not found for userId: " + userId);
                request.setAttribute("errorMessage", "Student profile not found.");
                request.setAttribute("activePage", "profile");
                request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
                return;
            }

            // ✅ Academic ID for subjects/marks/attendance queries
            int academicStudentId = student.getStudentId();

            // ✅ Enrolled subjects use academic student_id
            List<Subject> subjects = studentService.getEnrolledSubjects(academicStudentId);

            // ✅ Recent activities use userId (audit_logs.user_id)
            List<Map<String, Object>> recentActivities =
                    studentService.getRecentActivities(userId);

            // ✅ Last login uses userId
            LocalDateTime lastLogin = userDAO.getLastLoginTime(userId);
            String lastLoginFormatted = lastLogin != null
                    ? lastLogin.format(DATETIME_FORMATTER) : "Never";

            int profileCompletion = calculateProfileCompletion(student);
            List<String> missingFields = calculateMissingFields(student);

            request.setAttribute("student", student);
            request.setAttribute("subjects", subjects);
            request.setAttribute("recentActivities", recentActivities);
            request.setAttribute("lastLoginTimeFormatted", lastLoginFormatted);
            request.setAttribute("profileCompletion", profileCompletion);
            request.setAttribute("missingFields", missingFields);
            request.setAttribute("activePage", "profile");

            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading profile for userId: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load profile data.");
            request.setAttribute("activePage", "profile");
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
        }
    }

    private int calculateProfileCompletion(Student student) {
        List<String> missingFields = calculateMissingFields(student);
        int totalFields = 8;
        int filledFields = totalFields - missingFields.size();
        return totalFields > 0 ? (filledFields * 100) / totalFields : 0;
    }

    private List<String> calculateMissingFields(Student student) {
        List<String> missingFields = new ArrayList<>();
        if (!isFilled(student.getMobileNumber())) missingFields.add("Mobile Number");
        if (!isFilled(student.getPermanentAddress())) missingFields.add("Permanent Address");
        if (!isFilled(student.getGuardianName())) missingFields.add("Guardian Name");
        if (!isFilled(student.getGuardianContact())) missingFields.add("Guardian Contact");
        if (student.getDateOfBirth() == null) missingFields.add("Date of Birth");
        if (!isFilled(student.getBloodGroup())) missingFields.add("Blood Group");
        if (!isFilled(student.getGender())) missingFields.add("Gender");
        if (!isFilled(student.getAlternateMobile())) missingFields.add("Alternate Mobile");
        return missingFields;
    }

    private boolean isFilled(String value) {
        return value != null && !value.trim().isEmpty();
    }
}