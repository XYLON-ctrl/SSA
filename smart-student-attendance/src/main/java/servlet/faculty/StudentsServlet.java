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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/faculty/students")
public class StudentsServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentsServlet.class.getName());
    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = requireFaculty(request, response);
        if (user == null) return;

        int facultyId = facultyService.getFacultyIdByEmail(user.getEmail());
        
        try {
            // Fetch faculty subjects and sections for filters
            List<Subject> subjects = facultyService.getFacultySubjects(facultyId);
            List<Map<String, Object>> sections = facultyService.getFacultySections(facultyId);
            request.setAttribute("subjects", subjects);
            request.setAttribute("sections", sections);
            
            // Get filter parameters
            String subjectIdStr = request.getParameter("subjectId");
            String sectionIdStr = request.getParameter("sectionId");
            String searchQuery = request.getParameter("search");
            
            Integer selectedSubjectId = null;
            Integer selectedSectionId = null;
            
            if (subjectIdStr != null && !subjectIdStr.isEmpty() && !subjectIdStr.equals("all")) {
                selectedSubjectId = Integer.parseInt(subjectIdStr);
            }
            
            if (sectionIdStr != null && !sectionIdStr.isEmpty() && !sectionIdStr.equals("all")) {
                selectedSectionId = Integer.parseInt(sectionIdStr);
            }
            
            request.setAttribute("selectedSubjectId", selectedSubjectId);
            request.setAttribute("selectedSectionId", selectedSectionId);
            request.setAttribute("searchQuery", searchQuery);
            
            // Fetch students based on filters
            List<Student> students;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                students = facultyService.searchStudents(facultyId, searchQuery.trim());
            } else if (selectedSectionId != null) {
                students = facultyService.getFacultyStudentsBySection(facultyId, selectedSectionId);
            } else {
                students = facultyService.getFacultyStudents(facultyId);
            }
            
            // Fetch attendance data and calculate analytics
            Map<Integer, String> attendanceMap = new HashMap<>();
            int excellentCount = 0;
            int atRiskCount = 0;
            double averageAttendance = 0.0;
            
            if (selectedSubjectId != null) {
                for (Student student : students) {
                    String attendance = facultyService.getStudentAttendancePercentage(
                        student.getUserId(), selectedSubjectId);
                    attendanceMap.put(student.getUserId(), attendance);
                }
                
                // Calculate analytics
                excellentCount = facultyService.getExcellentAttendanceCount(facultyId, selectedSubjectId);
                atRiskCount = facultyService.getAtRiskStudentsCount(facultyId, selectedSubjectId);
                averageAttendance = facultyService.getAverageAttendance(facultyId, selectedSubjectId);
            }
            
            request.setAttribute("students", students);
            request.setAttribute("attendanceMap", attendanceMap);
            request.setAttribute("excellentCount", excellentCount);
            request.setAttribute("atRiskCount", atRiskCount);
            request.setAttribute("averageAttendance", String.format("%.1f", averageAttendance));
            request.setAttribute("pageTitle", "My Students");
            request.setAttribute("activePage", "students");
            
        } catch (Exception e) {
            LOGGER.severe("Error loading faculty students: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to load students data.");
        }
        
        request.getRequestDispatcher("/faculty/facultyStudents.jsp").forward(request, response);
    }
}