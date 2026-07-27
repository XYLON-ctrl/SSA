package servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Department;
import model.Student;
import model.User;
import service.AdminService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/admin/students")
public class StudentServlet extends BaseServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentServlet.class.getName());
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        String deptFilter = request.getParameter("department");

        if ("edit".equals(action) && id > 0) {
            Student student = adminService.getStudentById(id);
            request.setAttribute("editStudent", student);
        }

        List<Student> students = adminService.getAllStudents();
        List<Department> allDepartments = adminService.getAllDepartments();
        List<Map<String, Object>> allSections = adminService.getAllSections();

        // ✅ Filter to show ONLY ACTIVE departments in dropdowns
        List<Department> activeDepartments = new ArrayList<>();
        for (Department dept : allDepartments) {
            if (dept.isActive()) {
                activeDepartments.add(dept);
            }
        }

        // ✅ Filter to show ONLY ACTIVE sections in dropdowns
        List<Map<String, Object>> activeSections = new ArrayList<>();
        for (Map<String, Object> sec : allSections) {
            Object isActive = sec.get("isActive");
            if (isActive != null && (Boolean) isActive) {
                activeSections.add(sec);
            }
        }

        // ✅ Apply department filter if selected
        if (deptFilter != null && !deptFilter.isEmpty() && !deptFilter.equals("all")) {
            try {
                int deptId = Integer.parseInt(deptFilter);
                List<Student> filteredList = new ArrayList<>();
                for (Student s : students) {
                    if (s.getDepartmentId() == deptId) {
                        filteredList.add(s);
                    }
                }
                students = filteredList;
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid department filter: " + deptFilter);
            }
        }

        // ✅ Get next available enrollment ID
        String nextEnrollmentId = adminService.getNextStudentEnrollmentId();

        request.setAttribute("students", students);
        request.setAttribute("departments", activeDepartments);
        request.setAttribute("sections", activeSections);
        request.setAttribute("deptFilter", deptFilter);
        request.setAttribute("nextEnrollmentId", nextEnrollmentId); // ✅ Pass to JSP

        request.setAttribute("pageTitle", "Manage Students");
        setActivePage(request, "students");
        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = requireAdmin(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/students";

        try {
            if ("add".equals(action)) {
                Student student = buildStudentFromRequest(request);
                String password = request.getParameter("password");
                
                if (password == null || password.length() < 6) {
                    setErrorMessage(request, "Password must be at least 6 characters.");
                } else if (adminService.addStudent(student, password)) {
                    setSuccessMessage(request, "Student added successfully!");
                } else {
                    setErrorMessage(request, "Failed to add student. Email may already exist.");
                }
            }
            else if ("update".equals(action)) {
                Student student = buildStudentFromRequest(request);
                int id = parseIntOrDefault(request.getParameter("studentId"), 0);
                student.setStudentId(id);
                
                // ✅ CHECK EMAIL UNIQUENESS BEFORE UPDATING
                if (!adminService.isStudentEmailUnique(student.getEmail(), id)) {
                    setErrorMessage(request, "Email '" + student.getEmail() + "' is already registered to another student.");
                    response.sendRedirect(redirectUrl);
                    return;
                }
                
                // Get optional new password
                String newPassword = request.getParameter("newPassword");
                
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    if (newPassword.length() < 6) {
                        setErrorMessage(request, "New password must be at least 6 characters.");
                        response.sendRedirect(redirectUrl);
                        return;
                    }
                }
                
                if (adminService.updateStudent(student, newPassword)) {
                    if (newPassword != null && !newPassword.trim().isEmpty()) {
                        setSuccessMessage(request, "Student updated successfully! Password has been reset.");
                    } else {
                        setSuccessMessage(request, "Student updated successfully!");
                    }
                } else {
                    setErrorMessage(request, "Failed to update student.");
                }
            }
            else if ("delete".equals(action)) {
                int id = parseIntOrDefault(request.getParameter("studentId"), 0);
                if (adminService.deleteStudent(id)) {
                    setSuccessMessage(request, "Student deleted successfully!");
                } else {
                    setErrorMessage(request, "Failed to delete student.");
                }
            }
            else {
                setErrorMessage(request, "Invalid action.");
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing student action: " + e.getMessage());
            setErrorMessage(request, "An error occurred: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private Student buildStudentFromRequest(HttpServletRequest request) {
        Student student = new Student();
        student.setFullName(request.getParameter("fullName"));
        student.setEmail(request.getParameter("email"));
        student.setEnrollmentNumber(request.getParameter("enrollmentNumber"));
        student.setBranch(request.getParameter("branch"));
        student.setCurrentSemester(parseIntOrDefault(request.getParameter("currentSemester"), 1));
        student.setSectionId(parseIntOrDefault(request.getParameter("sectionId"), 0));
        student.setDepartmentId(parseIntOrDefault(request.getParameter("departmentId"), 0));
        student.setBatch(request.getParameter("batch"));
        
        String cgpaStr = request.getParameter("cgpa");
        student.setCgpa(cgpaStr != null && !cgpaStr.isEmpty() ? Double.parseDouble(cgpaStr) : 0.0);
        
        String isActiveStr = request.getParameter("isActive");
        student.setActive("1".equals(isActiveStr));
        
        return student;
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