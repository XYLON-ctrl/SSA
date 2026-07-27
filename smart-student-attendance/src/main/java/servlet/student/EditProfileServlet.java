package servlet.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.Student;
import model.User;
import service.StudentService;

@WebServlet("/student/edit-profile")
public class EditProfileServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(EditProfileServlet.class.getName());
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        transferFlashMessages(request);

        int userId = loggedInUser.getUserId();

        try {
            Student student = studentService.getStudentProfile(userId);
            if (student == null) {
                request.setAttribute("errorMessage", "Student profile not found.");
                response.sendRedirect(request.getContextPath() + "/student/profile");
                return;
            }

            request.setAttribute("student", student);
            request.setAttribute("activePage", "profile");
            request.getRequestDispatcher("/student/editProfile.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading edit profile for userId: " + userId, e);
            request.setAttribute("errorMessage", "Failed to load profile for editing.");
            response.sendRedirect(request.getContextPath() + "/student/profile");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLoggedInUser(request, response);
        if (loggedInUser == null) return;

        int userId = loggedInUser.getUserId();

        try {
            String gender = request.getParameter("gender");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String bloodGroup = request.getParameter("bloodGroup");
            String nationality = request.getParameter("nationality");
            String email = request.getParameter("email");
            String mobileNumber = request.getParameter("mobileNumber");
            String alternateMobile = request.getParameter("alternateMobile");
            String permanentAddress = request.getParameter("permanentAddress");
            String correspondenceAddress = request.getParameter("correspondenceAddress");
            String guardianName = request.getParameter("guardianName");
            String guardianRelationship = request.getParameter("guardianRelationship");
            String guardianContact = request.getParameter("guardianContact");
            String guardianAlternateContact = request.getParameter("guardianAlternateContact");
            String guardianEmail = request.getParameter("guardianEmail");
            String guardianOccupation = request.getParameter("guardianOccupation");

            // ✅ Use service layer — NOT direct DAO
            boolean updated = studentService.updateFullProfile(
                    userId, gender, dateOfBirth, bloodGroup, nationality,
                    email, mobileNumber, alternateMobile,
                    permanentAddress, correspondenceAddress,
                    guardianName, guardianRelationship, guardianContact,
                    guardianAlternateContact, guardianEmail, guardianOccupation);

            if (updated) {
                flashSuccess(request, "Profile updated successfully!");
            } else {
                flashError(request, "Failed to update profile. Please try again.");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating profile for userId: " + userId, e);
            flashError(request, "An error occurred while updating your profile.");
        }

        response.sendRedirect(request.getContextPath() + "/student/profile");
    }
}