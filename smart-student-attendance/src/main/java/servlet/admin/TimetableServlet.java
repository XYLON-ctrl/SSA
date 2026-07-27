package servlet.admin;

import dao.AdminDAO;
import dao.AdminDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Subject;
import model.TimetableEntry;
import model.User;
import service.AdminService;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/timetable")
public class TimetableServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(TimetableServlet.class.getName());
    private final AdminService adminService = new AdminService();
    private final AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        int id = parseIntOrDefault(request.getParameter("id"), 0);

        if ("edit".equals(action) && id > 0) {
            List<TimetableEntry> all = adminService.getAllTimetableEntries();
            for (TimetableEntry entry : all) {
                if (entry.getTimetableId() == id) {
                    request.setAttribute("editEntry", entry);
                    break;
                }
            }
        }

        // Get filter parameters
        String sectionFilter = request.getParameter("section");
        String facultyFilter = request.getParameter("faculty");
        String dayFilter = request.getParameter("day");
        
        // Load data for dropdowns
        List<TimetableEntry> entries = adminService.getAllTimetableEntries();
        List<Subject> subjects = getAllSubjects();
        List<model.Faculty> allFaculty = adminService.getAllFaculty();
        List<java.util.Map<String, Object>> sections = adminService.getAllSections();
        

        request.setAttribute("entries", entries);
        request.setAttribute("subjects", subjects);
        request.setAttribute("allFaculty", allFaculty);
        request.setAttribute("sections", sections);
        request.setAttribute("sectionFilter", sectionFilter);
        request.setAttribute("facultyFilter", facultyFilter);
        request.setAttribute("dayFilter", dayFilter);

        request.setAttribute("pageTitle", "Manage Timetable");
        setActivePage(request, "timetable");
        request.getRequestDispatcher("/admin/timetable.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/timetable";

        try {
            if ("add".equals(action)) {
                TimetableEntry entry = buildEntryFromRequest(request);
                
                if (adminService.addTimetableEntry(entry)) {
                    setSuccessMessage(request, "Timetable entry added successfully!");
                } else {
                    setErrorMessage(request, "Failed to add entry. Check for time conflicts or missing fields.");
                }
            }
            else if ("update".equals(action)) {
                TimetableEntry entry = buildEntryFromRequest(request);
                int id = parseIntOrDefault(request.getParameter("timetableId"), 0);
                entry.setTimetableId(id);
                
                if (adminService.updateTimetableEntry(entry)) {
                    setSuccessMessage(request, "Timetable entry updated successfully!");
                } else {
                    setErrorMessage(request, "Failed to update entry.");
                }
            }
            else if ("delete".equals(action)) {
                int id = parseIntOrDefault(request.getParameter("timetableId"), 0);
                if (adminService.deleteTimetableEntry(id)) {
                    setSuccessMessage(request, "Timetable entry deleted successfully!");
                } else {
                    setErrorMessage(request, "Failed to delete entry.");
                }
            }
            else {
                setErrorMessage(request, "Invalid action.");
            }
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Validation error", e);
            String msg = e.getMessage();
            if (msg == null || msg.isBlank()) {
                msg = "Validation failed. Check all timetable fields.";
            }
            setErrorMessage(request, msg);
        } catch (Exception e) {
            // ✅ Unknown errors - log full stack trace
            LOGGER.log(Level.SEVERE, "Error processing timetable action", e);
            String errorMsg = e.getMessage();
            if (errorMsg == null || errorMsg.isEmpty()) {
                errorMsg = "An unexpected error occurred. Please check your inputs and try again.";
            }
            setErrorMessage(request, errorMsg);
        }
        response.sendRedirect(redirectUrl);
    }

    private TimetableEntry buildEntryFromRequest(HttpServletRequest request) {
        LOGGER.info("Building timetable entry from request...");
        
        TimetableEntry entry = new TimetableEntry();
        
        // Parse IDs
        int subjectId = parseIntOrDefault(request.getParameter("subjectId"), 0);
        int facultyId = parseIntOrDefault(request.getParameter("facultyId"), 0);
        int sectionId = parseIntOrDefault(request.getParameter("sectionId"), 0);
        
        LOGGER.info("Parsed IDs - subject: " + subjectId + ", faculty: " + facultyId + ", section: " + sectionId);
        
        if (subjectId <= 0) {
            throw new IllegalArgumentException("Please select a subject.");
        }
        if (facultyId <= 0) {
            throw new IllegalArgumentException("Please select a faculty member.");
        }
        if (sectionId <= 0) {
            throw new IllegalArgumentException("Please select a section.");
        }
        
        entry.setSubjectId(subjectId);
        entry.setFacultyId(facultyId);
        entry.setSectionId(sectionId);
        
        // Parse day
        String dayOfWeek = request.getParameter("dayOfWeek");
        if (dayOfWeek == null || dayOfWeek.isEmpty()) {
            throw new IllegalArgumentException("Please select a day of the week.");
        }
        entry.setDayOfWeek(dayOfWeek);
        
        // ✅ Parse times with proper validation
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        
        if (startTimeStr == null || startTimeStr.isEmpty()) {
            throw new IllegalArgumentException("Start time is required.");
        }
        if (endTimeStr == null || endTimeStr.isEmpty()) {
            throw new IllegalArgumentException("End time is required.");
        }
        
        try {
            entry.setStartTime(java.time.LocalTime.parse(startTimeStr));
            entry.setEndTime(java.time.LocalTime.parse(endTimeStr));
            LOGGER.info("Parsed times - start: " + startTimeStr + ", end: " + endTimeStr);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid time format. Please use HH:MM format.");
        }
        
        // Validate time order
        if (!entry.getStartTime().isBefore(entry.getEndTime())) {
            throw new IllegalArgumentException("Start time must be before end time.");
        }
        
        // Room number (optional)
        String room = request.getParameter("roomNumber");
        entry.setRoomNumber(room != null ? room.trim() : "");
        
        LOGGER.info("Timetable entry built successfully: " + entry);
        return entry;
    }

    private List<Subject> getAllSubjects() {
        List<Subject> subjects = new java.util.ArrayList<>();
        String sql = "SELECT * FROM subjects WHERE is_active = 1 ORDER BY subject_name";
        try (java.sql.Connection conn = util.DatabaseUtil.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Subject sub = new Subject();
                sub.setSubjectId(rs.getInt("subject_id"));
                sub.setSubjectCode(rs.getString("subject_code"));
                sub.setSubjectName(rs.getString("subject_name"));
                sub.setCredits(rs.getInt("credits"));
                // ✅ REMOVED: sub.setSemester(rs.getInt("semester"));
                subjects.add(sub);
            }
        } catch (Exception e) {
            LOGGER.severe("Error loading subjects: " + e.getMessage());
        }
        return subjects;
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null || value.isEmpty()) return defaultValue;
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}