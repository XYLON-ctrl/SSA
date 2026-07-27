package model;

import java.io.Serializable;

public class Subject implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int credits;
    private int departmentId;
    private String departmentName;
    private int semester;  // ✅ ADDED BACK - populated from sections table
    private boolean active;

    public Subject() {
    }

    public Subject(int subjectId, String subjectCode, String subjectName, int credits, int departmentId, int semester, boolean active) {
        this.subjectId = subjectId;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.credits = credits;
        this.departmentId = departmentId;
        this.semester = semester;
        this.active = active;
    }

    // Getters and Setters
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    
    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }
    
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    
    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }
    
    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }
    
    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    
    // ✅ ADDED BACK - Semester getter and setter
    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }
    
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    
    @Override
    public String toString() {
        return "Subject{" +
                "subjectId=" + subjectId +
                ", subjectCode='" + subjectCode + '\'' +
                ", subjectName='" + subjectName + '\'' +
                ", credits=" + credits +
                ", departmentId=" + departmentId +
                ", semester=" + semester +
                ", active=" + active +
                '}';
    }
}