package servlet.faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Faculty;
import model.Subject;
import model.User;
import service.FacultyService;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/faculty/profile")
public class ProfileServlet extends BaseServlet {

    private static final Logger LOGGER =
            Logger.getLogger(ProfileServlet.class.getName());

    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        User user = requireFaculty(request, response);
        if (user == null) return;

        try {

            // ✅ Get actual faculty ID from logged-in user
            int facultyId = facultyService.getFacultyIdByEmail(user.getEmail());

            if (facultyId <= 0) {
                request.setAttribute("errorMessage",
                        "Faculty profile not found.");
                request.getRequestDispatcher("/faculty/facultyProfile.jsp")
                       .forward(request, response);
                return;
            }

            // Fetch faculty profile
            Faculty profile = facultyService.getFacultyProfile(facultyId);
            request.setAttribute("profile", profile);

            // Fetch assigned subjects
            List<Subject> assignedSubjects =
                    facultyService.getAssignedSubjects(facultyId);
            request.setAttribute("assignedSubjects", assignedSubjects);

            // Fetch workload summary
            Map<String, Object> workload =
                    facultyService.getWorkloadSummary(facultyId);
            request.setAttribute("workload", workload);

            // Fetch recent activities
            List<Map<String, Object>> recentActivities =
                    facultyService.getRecentActivities(facultyId);
            request.setAttribute("recentActivities", recentActivities);

            request.setAttribute("pageTitle", "My Profile");
            request.setAttribute("activePage", "profile");

        } catch (Exception e) {
            LOGGER.severe("Error loading faculty profile: " + e.getMessage());
            request.setAttribute("errorMessage",
                    "Failed to load profile data.");
        }

        request.getRequestDispatcher("/faculty/facultyProfile.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        User user = requireFaculty(request, response);
        if (user == null) return;

        try {

            // ✅ Get actual faculty ID
            int facultyId = facultyService.getFacultyIdByEmail(user.getEmail());

            Faculty faculty = facultyService.getFacultyProfile(facultyId);

            if (faculty == null) {
                request.setAttribute("errorMessage",
                        "Faculty profile not found.");
                doGet(request, response);
                return;
            }

            faculty.setFacultyId(facultyId);
            faculty.setFullName(request.getParameter("fullName"));
            faculty.setEmail(request.getParameter("email"));
            faculty.setPhoneNumber(request.getParameter("phoneNumber"));
            faculty.setOfficeLocation(request.getParameter("officeLocation"));
            faculty.setQualification(request.getParameter("qualification"));
            faculty.setSpecialization(request.getParameter("specialization"));
            faculty.setResearchArea(request.getParameter("researchArea"));
            faculty.setPublicationsCount(
                    parseInt(request.getParameter("publicationsCount"), 0));
            faculty.setCertifications(request.getParameter("certifications"));

            String joiningDateStr =
                    request.getParameter("joiningDate");

            if (joiningDateStr != null &&
                !joiningDateStr.trim().isEmpty()) {

                faculty.setJoiningDate(
                        java.time.LocalDate.parse(joiningDateStr));
            }

            boolean success =
                    facultyService.updateFacultyProfile(faculty);

            if (success) {
                request.setAttribute("successMessage",
                        "Profile updated successfully!");
            } else {
                request.setAttribute("errorMessage",
                        "Failed to update profile.");
            }

        } catch (Exception e) {
            LOGGER.severe("Error updating profile: " + e.getMessage());
            request.setAttribute("errorMessage",
                    "An error occurred while updating profile.");
        }

        doGet(request, response);
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return value != null && !value.isEmpty()
                    ? Integer.parseInt(value)
                    : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}