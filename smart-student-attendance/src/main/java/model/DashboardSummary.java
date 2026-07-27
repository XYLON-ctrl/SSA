package model;

import java.util.List;

public class DashboardSummary {
    private Student student;
    private double attendancePercentage;
    private int totalSubjects;
    private int semesterSubjects;
    private int classesToday;
    private int classesTomorrow;
    private int totalAssessments;
    private int unreadNotifications;
    private int pendingLeaves;
    private int approvedLeaves;
    private int rejectedLeaves;
    private List<SemesterCGPA> semesterCgpas;
    private int totalProgramCredits;
    private int earnedCredits;

    // Getters and Setters
    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

    public double getAttendancePercentage() { return attendancePercentage; }
    public void setAttendancePercentage(double attendancePercentage) { this.attendancePercentage = attendancePercentage; }

    public int getTotalSubjects() { return totalSubjects; }
    public void setTotalSubjects(int totalSubjects) { this.totalSubjects = totalSubjects; }

    public int getSemesterSubjects() { return semesterSubjects; }
    public void setSemesterSubjects(int semesterSubjects) { this.semesterSubjects = semesterSubjects; }

    public int getClassesToday() { return classesToday; }
    public void setClassesToday(int classesToday) { this.classesToday = classesToday; }

    public int getClassesTomorrow() { return classesTomorrow; }
    public void setClassesTomorrow(int classesTomorrow) { this.classesTomorrow = classesTomorrow; }

    public int getTotalAssessments() { return totalAssessments; }
    public void setTotalAssessments(int totalAssessments) { this.totalAssessments = totalAssessments; }

    public int getUnreadNotifications() { return unreadNotifications; }
    public void setUnreadNotifications(int unreadNotifications) { this.unreadNotifications = unreadNotifications; }

    public int getPendingLeaves() { return pendingLeaves; }
    public void setPendingLeaves(int pendingLeaves) { this.pendingLeaves = pendingLeaves; }

    public int getApprovedLeaves() { return approvedLeaves; }
    public void setApprovedLeaves(int approvedLeaves) { this.approvedLeaves = approvedLeaves; }

    public int getRejectedLeaves() { return rejectedLeaves; }
    public void setRejectedLeaves(int rejectedLeaves) { this.rejectedLeaves = rejectedLeaves; }

    public List<SemesterCGPA> getSemesterCgpas() { return semesterCgpas; }
    public void setSemesterCgpas(List<SemesterCGPA> semesterCgpas) { this.semesterCgpas = semesterCgpas; }

    public int getTotalProgramCredits() { return totalProgramCredits; }
    public void setTotalProgramCredits(int totalProgramCredits) { this.totalProgramCredits = totalProgramCredits; }

    public int getEarnedCredits() { return earnedCredits; }
    public void setEarnedCredits(int earnedCredits) { this.earnedCredits = earnedCredits; }
}