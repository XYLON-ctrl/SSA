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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/faculty/profile/edit")
public class EditProfileServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(EditProfileServlet.class.getName());
    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = requireFaculty(request, response);
        if (user == null) return;

        try {
        	Faculty profile =
        	        facultyService.getFacultyByUserId(user.getUserId());

            if (profile == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int facultyId = profile.getFacultyId();

            request.setAttribute("profile", profile);

            if (profile.getJoiningDate() != null) {
                request.setAttribute(
                    "joiningDateFormatted",
                    profile.getJoiningDate()
                           .format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy"))
                );
            }

            List<Subject> assignedSubjects =
                    facultyService.getAssignedSubjects(facultyId);
            request.setAttribute("assignedSubjects", assignedSubjects);

            Map<String, Object> workload =
                    facultyService.getWorkloadSummary(facultyId);
            request.setAttribute("workload", workload);

            Map<String, Object> completeness =
                    calculateProfileCompleteness(profile);
            request.setAttribute("completeness", completeness);

            request.setAttribute("pageTitle", "Edit Profile");
            request.setAttribute("activePage", "profile");

        } catch (Exception e) {
            LOGGER.severe("Error loading edit profile: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to load profile data.");
        }

        request.getRequestDispatcher("/faculty/facultyEditProfile.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = requireFaculty(request, response);
        if (user == null) return;

        try {
        	Faculty faculty = facultyService.getFacultyByUserId(user.getUserId());

            if (faculty == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            int facultyId = faculty.getFacultyId();

            faculty.setFacultyId(facultyId);
            faculty.setFullName(request.getParameter("fullName"));
            faculty.setEmail(request.getParameter("email"));
            faculty.setPhoneNumber(request.getParameter("phoneNumber"));
            faculty.setAlternatePhone(request.getParameter("alternatePhone"));
            faculty.setOfficeLocation(request.getParameter("officeLocation"));
            faculty.setQualification(request.getParameter("qualification"));
            faculty.setSpecialization(request.getParameter("specialization"));
            faculty.setExperienceYears(
                    parseInt(request.getParameter("experienceYears"), 0));
            faculty.setResearchArea(request.getParameter("researchArea"));
            faculty.setResearchInterests(request.getParameter("researchInterests"));
            faculty.setPublicationsCount(
                    parseInt(request.getParameter("publicationsCount"), 0));
            faculty.setCertifications(request.getParameter("certifications"));
            faculty.setGoogleScholar(request.getParameter("googleScholar"));
            faculty.setLinkedinProfile(request.getParameter("linkedinProfile"));
            faculty.setOrcidId(request.getParameter("orcidId"));
            faculty.setAcademicWebsite(request.getParameter("academicWebsite"));
            faculty.setAddress(request.getParameter("address"));
            faculty.setCity(request.getParameter("city"));
            faculty.setState(request.getParameter("state"));
            faculty.setPostalCode(request.getParameter("postalCode"));

            boolean success = facultyService.updateFacultyProfile(faculty);

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
            return value != null && !value.isEmpty() ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    private Map<String, Object> calculateProfileCompleteness(Faculty profile) {
        Map<String, Object> result = new HashMap<>();
        List<String> missingFields = new java.util.ArrayList<>();
        int totalFields = 15;
        int filledFields = 0;
        
        if (isFilled(profile.getFullName())) filledFields++;
        else missingFields.add("Full Name");
        
        if (isFilled(profile.getEmail())) filledFields++;
        else missingFields.add("Email");
        
        if (isFilled(profile.getPhoneNumber())) filledFields++;
        else missingFields.add("Phone Number");
        
        if (isFilled(profile.getOfficeLocation())) filledFields++;
        else missingFields.add("Office Location");
        
        if (isFilled(profile.getQualification())) filledFields++;
        else missingFields.add("Qualification");
        
        if (isFilled(profile.getSpecialization())) filledFields++;
        else missingFields.add("Specialization");
        
        if (isFilled(profile.getResearchArea())) filledFields++;
        else missingFields.add("Research Area");
        
        if (isFilled(profile.getResearchInterests())) filledFields++;
        else missingFields.add("Research Interests");
        
        if (profile.getPublicationsCount() > 0) filledFields++;
        else missingFields.add("Publications");
        
        if (isFilled(profile.getCertifications())) filledFields++;
        else missingFields.add("Certifications");
        
        if (isFilled(profile.getLinkedinProfile())) filledFields++;
        else missingFields.add("LinkedIn Profile");
        
        if (isFilled(profile.getGoogleScholar())) filledFields++;
        else missingFields.add("Google Scholar");
        
        if (isFilled(profile.getOrcidId())) filledFields++;
        else missingFields.add("ORCID ID");
        
        if (isFilled(profile.getAcademicWebsite())) filledFields++;
        else missingFields.add("Academic Website");
        
        if (isFilled(profile.getAddress())) filledFields++;
        else missingFields.add("Address");
        
        int percentage = totalFields > 0 ? (filledFields * 100) / totalFields : 0;
        
        result.put("percentage", percentage);
        result.put("missingFields", missingFields);
        result.put("filledFields", filledFields);
        result.put("totalFields", totalFields);
        
        return result;
    }
    
    private boolean isFilled(String value) {
        return value != null && !value.trim().isEmpty();
    }
}