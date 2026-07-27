package model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class AttendanceRecord {
    private int recordId;
    private int studentId;      // ✅ ADDED
    private int subjectId;
    private String subjectName;
    private LocalDate attendanceDate;  // ✅ RENAMED from 'date' for consistency
    private String status;
    private int markedBy;       // ✅ ADDED
    private String remarks;     // ✅ ADDED
    
    // Formatters
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd MMM yyyy");
    private static final DateTimeFormatter DAY_FORMATTER = DateTimeFormatter.ofPattern("EEEE");
    
    // Default Constructor
    public AttendanceRecord() {}
    
    // Getters and Setters
    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }
    
    public int getStudentId() { return studentId; }  // ✅ ADDED
    public void setStudentId(int studentId) { this.studentId = studentId; }  // ✅ ADDED
    
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    
    public LocalDate getAttendanceDate() { return attendanceDate; }  // ✅ RENAMED
    public void setAttendanceDate(LocalDate attendanceDate) { this.attendanceDate = attendanceDate; }  // ✅ RENAMED
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getMarkedBy() { return markedBy; }  // ✅ ADDED
    public void setMarkedBy(int markedBy) { this.markedBy = markedBy; }  // ✅ ADDED
    
    public String getRemarks() { return remarks; }  // ✅ ADDED
    public void setRemarks(String remarks) { this.remarks = remarks; }  // ✅ ADDED
    
    public String getDateFormatted() {
        return attendanceDate != null ? attendanceDate.format(DATE_FORMATTER) : "N/A";
    }

    public String getDayOfWeekFormatted() {
        return attendanceDate != null ? attendanceDate.format(DAY_FORMATTER) : "N/A";
    }
}