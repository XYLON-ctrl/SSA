package servlet.faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import service.FacultyService;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/faculty/marks")
public class MarksServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(MarksServlet.class.getName());
    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireFaculty(request, response);
        if (user == null) return;

        // ✅ FIXED: Use getFacultyByUserId instead of getFacultyIdByEmail
        Faculty faculty = facultyService.getFacultyByUserId(user.getUserId());
        if (faculty == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        int facultyId = faculty.getFacultyId();

        // ✅ Fetch ONLY subjects and sections assigned to this faculty
        request.setAttribute("subjects", facultyService.getFacultySubjects(facultyId));
        request.setAttribute("sections", facultyService.getFacultySections(facultyId));

        String subjectIdStr = request.getParameter("subjectId");
        String sectionIdStr = request.getParameter("sectionId");
        String examType = request.getParameter("examType");

        if (subjectIdStr != null && sectionIdStr != null && examType != null) {
            try {
                int subjectId = Integer.parseInt(subjectIdStr);
                int sectionId = Integer.parseInt(sectionIdStr);

                request.setAttribute("selectedSubjectId", subjectId);
                request.setAttribute("selectedSectionId", sectionId);
                request.setAttribute("selectedExamType", examType);
                request.setAttribute("students", facultyService.getStudentsForMarking(subjectId, sectionId));
                request.setAttribute("existingMarks", facultyService.getExistingMarks(subjectId, sectionId, examType));
                request.setAttribute("showMarksForm", true);
            } catch (Exception e) {
                LOGGER.warning("Invalid parameters for marks loading");
            }
        }

        request.setAttribute("pageTitle", "Enter Marks");
        request.setAttribute("activePage", "marks");
        request.getRequestDispatcher("/faculty/marks.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireFaculty(request, response);
        if (user == null) return;

        // ✅ FIXED: Use getFacultyByUserId
        Faculty faculty = facultyService.getFacultyByUserId(user.getUserId());
        if (faculty == null) { response.sendRedirect(request.getContextPath() + "/faculty/marks"); return; }
        int facultyId = faculty.getFacultyId();

        HttpSession session = request.getSession();
        String subjectId = request.getParameter("subjectId");
        String sectionId = request.getParameter("sectionId");
        String examType = request.getParameter("examType");

        String redirectUrl = request.getContextPath() + "/faculty/marks?subjectId=" + subjectId + 
                             "&sectionId=" + sectionId + "&examType=" + examType;

        try {
            int subId = Integer.parseInt(subjectId);
            int secId = Integer.parseInt(sectionId);
            double maxMarks = Double.parseDouble(request.getParameter("maxMarks"));

            String[] studentIds = request.getParameterValues("studentId");
            String[] marksObtained = request.getParameterValues("marks");

            if (studentIds == null || marksObtained == null || studentIds.length != marksObtained.length) {
                session.setAttribute("errorMessage", "Data mismatch. Please reload and try again.");
                response.sendRedirect(redirectUrl);
                return;
            }

            for (int i = 0; i < marksObtained.length; i++) {
                String markStr = marksObtained[i];
                if (markStr == null || markStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Please enter marks for all students.");
                    response.sendRedirect(redirectUrl);
                    return;
                }
                double marks = Double.parseDouble(markStr.trim());
                if (marks < 0 || marks > maxMarks) {
                    session.setAttribute("errorMessage", "Marks must be between 0 and " + maxMarks + ".");
                    response.sendRedirect(redirectUrl);
                    return;
                }
            }

            int count = 0;
            for (int i = 0; i < studentIds.length; i++) {
                if (facultyService.saveMarks(Integer.parseInt(studentIds[i]), subId, examType, 
                        Double.parseDouble(marksObtained[i].trim()), maxMarks, facultyId)) {
                    count++;
                }
            }
            session.setAttribute("successMessage", "Marks saved for " + count + " students.");

        } catch (Exception e) {
            LOGGER.severe("Error saving marks: " + e.getMessage());
            session.setAttribute("errorMessage", "Failed to save marks.");
        }
        response.sendRedirect(redirectUrl);
    }
}