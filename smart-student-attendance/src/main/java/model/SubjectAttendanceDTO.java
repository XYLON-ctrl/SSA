package model;

public class SubjectAttendanceDTO {
    private int subjectId;
    private String subjectName;
    private int totalClasses;
    private int attendedClasses;
    private double percentage;
    private String status;           // ADD THIS
    private int classesNeeded;       // ADD THIS
    private String subjectCode;     
    
    // Existing getters and setters...
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    
    public int getTotalClasses() { return totalClasses; }
    public void setTotalClasses(int totalClasses) { this.totalClasses = totalClasses; }
    
    public int getAttendedClasses() { return attendedClasses; }
    public void setAttendedClasses(int attendedClasses) { this.attendedClasses = attendedClasses; }
    
    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }
    
    // ADD THESE NEW GETTERS AND SETTERS
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getClassesNeeded() { return classesNeeded; }
    public void setClassesNeeded(int classesNeeded) { this.classesNeeded = classesNeeded; }
    
    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }
}