package model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LeaveRequest {
    private int leaveId;
    private int studentId;
    private String studentName;
    private String studentEmail;
    private String enrollmentNumber;
    private String branch;
    private int currentSemester;
    private String sectionName;
    private LocalDate startDate;
    private LocalDate endDate;
    private String reason;
    private String status;
    private LocalDateTime appliedOn;
    private Integer reviewedBy;
    private String reviewerName;
    private LocalDateTime reviewedAt;
    private String reviewRemarks;

    public LeaveRequest() {}

    // Getters & Setters
    public int getLeaveId() { return leaveId; }
    public void setLeaveId(int leaveId) { this.leaveId = leaveId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getEnrollmentNumber() { return enrollmentNumber; }
    public void setEnrollmentNumber(String enrollmentNumber) { this.enrollmentNumber = enrollmentNumber; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public int getCurrentSemester() { return currentSemester; }
    public void setCurrentSemester(int currentSemester) { this.currentSemester = currentSemester; }

    public String getSectionName() { return sectionName; }
    public void setSectionName(String sectionName) { this.sectionName = sectionName; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getAppliedOn() { return appliedOn; }
    public void setAppliedOn(LocalDateTime appliedOn) { this.appliedOn = appliedOn; }

    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public LocalDateTime getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }

    public String getReviewRemarks() { return reviewRemarks; }
    public void setReviewRemarks(String reviewRemarks) { this.reviewRemarks = reviewRemarks; }

    // ===== Formatted Helpers =====
    public String getStartDateFormatted() {
        return startDate != null ? startDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy")) : "N/A";
    }

    public String getEndDateFormatted() {
        return endDate != null ? endDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy")) : "N/A";
    }

    public String getAppliedOnFormatted() {
        return appliedOn != null ? appliedOn.format(DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm")) : "N/A";
    }

    public String getReviewedAtFormatted() {
        return reviewedAt != null ? reviewedAt.format(DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm")) : "N/A";
    }

    public long getDaysCount() {
        if (startDate == null || endDate == null) return 0;
        return java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;
    }

    public String getAppliedOnTimeFormatted() {
        if (appliedOn == null) return "N/A";
        return appliedOn.format(DateTimeFormatter.ofPattern("hh:mm a"));
    }
}