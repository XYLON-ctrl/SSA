package servlet;

import dao.StatisticsDAO;
import dao.StatisticsDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet({"/", "/index"}) // Maps to the root URL and /index
public class HomeServlet extends HttpServlet {
    
    private final StatisticsDAO statsDAO = new StatisticsDAOImpl();
    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Fetch live counts from the database (Your existing logic)
            int studentCount = statsDAO.getTotalStudents();
            int facultyCount = statsDAO.getTotalFaculty();
            int departmentCount = statsDAO.getTotalDepartments();
            int attendanceRecords = statsDAO.getTotalAttendanceRecords();

            // 2. Set them as Request Attributes
            request.setAttribute("studentCount", String.format("%,d", studentCount)); 
            request.setAttribute("facultyCount", String.format("%,d", facultyCount));
            request.setAttribute("departmentCount", String.format("%,d", departmentCount));
            request.setAttribute("attendanceRecordCount", String.format("%,d", attendanceRecords));

            // 3. ✅ NEW: Set Dynamic Content Lists (Replaces hardcoded HTML blocks)
            request.setAttribute("features", getFeatures());
            request.setAttribute("modules", getModules());
            request.setAttribute("benefits", getBenefits());
            request.setAttribute("techStack", getTechStack());
            request.setAttribute("security", getSecurity());

            // 4. ✅ NEW: Global Site Settings (Fetched dynamically instead of hardcoded in JSP)
            request.setAttribute("universityName", "University of Oxford");
            request.setAttribute("supportEmail", "support@ox.ac.uk");
            request.setAttribute("supportPhone", "+44 123 456 789");
            request.setAttribute("currentYear", java.time.Year.now().getValue());
            request.setAttribute("systemVersion", "1.0.0 Enterprise");
            request.setAttribute("systemShortName", "Campus Analytics");
            request.setAttribute("portalName", "Campus Analytics & Student Monitoring Portal");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to fetch dashboard statistics", e);
            // Fallback to 0 if database fails
            request.setAttribute("studentCount", "0");
            request.setAttribute("facultyCount", "0");
            request.setAttribute("departmentCount", "0");
            request.setAttribute("attendanceRecordCount", "0");
        }

        // 5. Forward to the landing page
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    // ==========================================
    // DYNAMIC CONTENT GENERATORS (Controller Layer)
    // ==========================================

    private List<Map<String, String>> getFeatures() {
        List<Map<String, String>> list = new ArrayList<>();
        list.add(Map.of("icon", "fa-clipboard-check", "title", "Attendance Management", "desc", "Automated tracking of student attendance with real-time updates, proxy detection, and biometric integration capabilities."));
        list.add(Map.of("icon", "fa-user-graduate", "title", "Student Information", "desc", "Centralized repository for student profiles, academic history, enrollment details, and personal records."));
        list.add(Map.of("icon", "fa-chalkboard-user", "title", "Faculty Management", "desc", "Streamline faculty profiles, course allocations, workload distribution, and performance evaluations."));
        list.add(Map.of("icon", "fa-chart-line", "title", "Performance Tracking", "desc", "Monitor GPA, internal marks, and semester results with comprehensive progress reports and trend analysis."));
        list.add(Map.of("icon", "fa-chart-pie", "title", "Analytics Dashboard", "desc", "Visualize institutional data with interactive charts, graphs, and real-time metrics for data-driven insights."));
        list.add(Map.of("icon", "fa-file-export", "title", "Report Generation", "desc", "Generate automated PDF and Excel reports for attendance, grades, and administrative audits with a single click."));
        list.add(Map.of("icon", "fa-user-shield", "title", "Role-Based Access", "desc", "Granular permission management ensuring users only access data and modules relevant to their specific role."));
        list.add(Map.of("icon", "fa-lock", "title", "Secure Authentication", "desc", "Enterprise-grade login security with BCrypt hashing, CSRF protection, and robust session management."));
        return list;
    }

    private List<Map<String, String>> getModules() {
        List<Map<String, String>> list = new ArrayList<>();
        list.add(Map.of("icon", "fa-sign-in-alt", "title", "Authentication Module", "desc", "Secure login, session handling, and multi-factor verification."));
        list.add(Map.of("icon", "fa-users", "title", "Student Management", "desc", "Admissions, profiles, and academic lifecycle tracking."));
        list.add(Map.of("icon", "fa-id-badge", "title", "Faculty Management", "desc", "Staff directories, assignments, and workload analytics."));
        list.add(Map.of("icon", "fa-book", "title", "Subject Management", "desc", "Course catalogs, credit structures, and syllabus tracking."));
        list.add(Map.of("icon", "fa-calendar-check", "title", "Attendance Management", "desc", "Daily tracking, percentage calculations, and shortage alerts."));
        list.add(Map.of("icon", "fa-graduation-cap", "title", "Academic Monitoring", "desc", "Internal marks, semester results, and CGPA calculations."));
        list.add(Map.of("icon", "fa-chart-bar", "title", "Reports & Analytics", "desc", "Visual dashboards and exportable institutional reports."));
        list.add(Map.of("icon", "fa-cogs", "title", "Administration", "desc", "System configuration, user roles, and global settings."));
        return list;
    }

    private List<Map<String, String>> getBenefits() {
        List<Map<String, String>> list = new ArrayList<>();
        list.add(Map.of("icon", "fa-robot", "title", "Reduced Manual Work", "desc", "Automate repetitive administrative tasks and eliminate paper-based record keeping."));
        list.add(Map.of("icon", "fa-bolt", "title", "Real-Time Monitoring", "desc", "Track attendance and academic metrics as they happen with live dashboard updates."));
        list.add(Map.of("icon", "fa-lightbulb", "title", "Improved Academic Insights", "desc", "Identify at-risk students early and analyze performance trends across departments."));
        list.add(Map.of("icon", "fa-chess-king", "title", "Better Decision Making", "desc", "Empower leadership with data-driven insights for strategic academic planning."));
        list.add(Map.of("icon", "fa-shield-alt", "title", "Secure Data Management", "desc", "Enterprise-grade encryption and secure protocols to protect sensitive student data."));
        list.add(Map.of("icon", "fa-database", "title", "Centralized Information", "desc", "A single source of truth for all academic, administrative, and operational data."));
        return list;
    }

    private List<Map<String, String>> getTechStack() {
        List<Map<String, String>> list = new ArrayList<>();
        list.add(Map.of("icon", "fab fa-java", "name", "Java"));
        list.add(Map.of("icon", "fas fa-code", "name", "JSP"));
        list.add(Map.of("icon", "fas fa-server", "name", "Servlets"));
        list.add(Map.of("icon", "fas fa-plug", "name", "JDBC"));
        list.add(Map.of("icon", "fas fa-database", "name", "MySQL"));
        list.add(Map.of("icon", "fab fa-bootstrap", "name", "Bootstrap 5"));
        list.add(Map.of("icon", "fab fa-html5", "name", "HTML5"));
        list.add(Map.of("icon", "fab fa-css3-alt", "name", "CSS3"));
        list.add(Map.of("icon", "fab fa-js", "name", "JavaScript"));
        return list;
    }

    private List<Map<String, String>> getSecurity() {
        List<Map<String, String>> list = new ArrayList<>();
        list.add(Map.of("icon", "fa-user-tag", "title", "Role-Based Authentication", "desc", "Strict access control ensuring users only interact with authorized modules."));
        list.add(Map.of("icon", "fa-clock", "title", "Session Management", "desc", "Secure session handling with fixation prevention and automatic timeout protocols."));
        list.add(Map.of("icon", "fa-key", "title", "Password Encryption", "desc", "Industry-standard BCrypt hashing ensures passwords are never stored in plain text."));
        list.add(Map.of("icon", "fa-shield-virus", "title", "CSRF Protection", "desc", "Token-based validation prevents Cross-Site Request Forgery attacks on all forms."));
        list.add(Map.of("icon", "fa-filter", "title", "Input Validation", "desc", "Comprehensive sanitization and regex validation to block SQL injection and XSS."));
        list.add(Map.of("icon", "fa-lock", "title", "Access Control Filters", "desc", "Servlet filters intercept and verify authorization before any protected resource is served."));
        return list;
    }
}