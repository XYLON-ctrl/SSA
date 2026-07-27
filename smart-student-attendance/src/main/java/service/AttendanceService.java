package service;

import dao.AttendanceDAO;
import dao.AttendanceDAOImpl;
import model.AttendanceRecord;
import model.SubjectAttendanceDTO;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AttendanceService {
    private static final Logger LOGGER = Logger.getLogger(AttendanceService.class.getName());
    
    // Standard university attendance threshold
    private static final double MINIMUM_ATTENDANCE_THRESHOLD = 75.0;

    private final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();

    /**
     * Get Overall Attendance Percentage for a student
     * @param userId The student's user ID
     * @return Overall attendance percentage (0-100)
     */
    public double getOverallAttendance(int userId) {
        if (userId <= 0) {
            LOGGER.warning("Invalid user ID provided for overall attendance.");
            return 0.0;
        }
        
        try {
            double percentage = attendanceDAO.getOverallAttendancePercentage(userId);
            LOGGER.fine("Overall attendance for user " + userId + ": " + percentage + "%");
            return percentage;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error calculating overall attendance for user ID: " + userId, e);
            return 0.0;
        }
    }

    /**
     * Get Subject-Wise Attendance
     * Returns a list of DTOs containing total classes, attended classes, and percentage.
     * @param userId The student's user ID
     * @return List of SubjectAttendanceDTO objects
     */
    public List<SubjectAttendanceDTO> getSubjectWiseAttendance(int userId) {
        if (userId <= 0) {
            LOGGER.warning("Invalid user ID provided for subject-wise attendance.");
            return List.of();
        }
        
        try {
            List<SubjectAttendanceDTO> attendanceList = attendanceDAO.getSubjectWiseAttendance(userId);
            LOGGER.fine("Retrieved " + attendanceList.size() + " subject attendance records for user " + userId);
            return attendanceList;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving subject-wise attendance for user ID: " + userId, e);
            return List.of();
        }
    }

    /**
     * Get Daily Attendance Records for a Specific Subject
     * Used for the attendanceDetails.jsp page.
     * @param userId The student's user ID
     * @param subjectId The subject ID
     * @return List of AttendanceRecord objects
     */
    public List<AttendanceRecord> getSubjectAttendanceDetails(int userId, int subjectId) {
        if (userId <= 0 || subjectId <= 0) {
            LOGGER.warning("Invalid user ID or subject ID provided for attendance details.");
            return List.of();
        }
        
        try {
            List<AttendanceRecord> records = attendanceDAO.getDailyAttendanceRecords(userId, subjectId);
            LOGGER.fine("Retrieved " + records.size() + " attendance records for user " + userId + ", subject " + subjectId);
            return records;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving attendance details for user ID: " + userId + ", subject ID: " + subjectId, e);
            return List.of();
        }
    }

    // ==========================================
    // ENTERPRISE BUSINESS LOGIC (Value Add)
    // ==========================================

    /**
     * Calculates the attendance status based on the percentage.
     * Used to color-code the UI (Green for Good, Red for Critical).
     * @param percentage The attendance percentage
     * @return Status string: "Excellent", "Good", "Warning", or "Critical"
     */
    public String getAttendanceStatus(double percentage) {
        if (percentage >= 85.0) return "Excellent";
        if (percentage >= MINIMUM_ATTENDANCE_THRESHOLD) return "Good";
        if (percentage >= 60.0) return "Warning";
        return "Critical";
    }

    /**
     * Calculates how many consecutive classes a student must attend 
     * to reach the minimum threshold (e.g., 75%).
     * 
     * Math: (attended + x) / (total + x) >= target / 100
     * Solving for x: x >= (target * total - 100 * attended) / (100 - target)
     * 
     * @param attended Number of classes attended
     * @param total Total number of classes held
     * @return Number of consecutive classes needed to reach 75%
     */
    public int getClassesNeededToReachTarget(int attended, int total) {
        if (total <= 0 || attended < 0 || attended > total) {
            LOGGER.warning("Invalid attendance data: attended=" + attended + ", total=" + total);
            return 0;
        }
        
        double currentPercentage = (attended * 100.0) / total;
        
        // If already above threshold, no classes needed
        if (currentPercentage >= MINIMUM_ATTENDANCE_THRESHOLD) {
            return 0; 
        }

        // Calculate required classes
        double numerator = (MINIMUM_ATTENDANCE_THRESHOLD * total) - (100 * attended);
        double denominator = 100 - MINIMUM_ATTENDANCE_THRESHOLD;
        
        int classesNeeded = (int) Math.ceil(numerator / denominator);
        int result = Math.max(0, classesNeeded); // Ensure it never returns negative
        
        LOGGER.fine("Classes needed to reach 75%: " + result + " (current: " + currentPercentage + "%)");
        return result;
    }

    /**
     * Calculates how many classes a student can afford to miss 
     * while staying above the minimum threshold.
     * 
     * Math: attended / (total + x) >= target / 100
     * Solving for x: x <= (100 * attended - target * total) / target
     * 
     * @param attended Number of classes attended
     * @param total Total number of classes held
     * @return Number of classes that can be missed while maintaining 75%
     */
    public int getClassesCanAffordToMiss(int attended, int total) {
        if (total <= 0 || attended < 0 || attended > total) {
            LOGGER.warning("Invalid attendance data: attended=" + attended + ", total=" + total);
            return 0;
        }
        
        double currentPercentage = (attended * 100.0) / total;
        
        // If already below threshold, cannot miss any
        if (currentPercentage < MINIMUM_ATTENDANCE_THRESHOLD) {
            return 0;
        }

        // Calculate allowed misses
        double numerator = (100 * attended) - (MINIMUM_ATTENDANCE_THRESHOLD * total);
        double denominator = MINIMUM_ATTENDANCE_THRESHOLD;
        
        int classesCanMiss = (int) Math.floor(numerator / denominator);
        int result = Math.max(0, classesCanMiss);
        
        LOGGER.fine("Classes that can be missed: " + result + " (current: " + currentPercentage + "%)");
        return result;
    }
}