package model;

import java.time.LocalDate;

public class Student {
    private int studentId;
    private int userId;
    private String fullName;
    private String email;
    private String username;
    private String enrollmentNumber;
    private String branch;
    private String department;
    private int departmentId;
    private int sectionId;
    private int currentSemester;
    private double cgpa;
    private String batch;
    private LocalDate admissionDate;
    private String gender;
    private LocalDate dateOfBirth;
    private String bloodGroup;
    private String nationality;
    private String mobileNumber;
    private String alternateMobile;
    private String permanentAddress;
    private String correspondenceAddress;
    private String guardianName;
    private String guardianRelationship;
    private String guardianContact;
    private String guardianAlternateContact;
    private String guardianEmail;
    private String guardianOccupation;
    private int expectedGraduationYear;
    private Integer classAdvisorId;
    private boolean isActive;

    public Student() {}

    // Getters and Setters
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEnrollmentNumber() { return enrollmentNumber; }
    public void setEnrollmentNumber(String enrollmentNumber) { this.enrollmentNumber = enrollmentNumber; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    
	public int getDepartmentId() { return departmentId; }
	public void setDepartmentId(int departmentId) {	this.departmentId = departmentId; }

	public int getSectionId() { return sectionId; }
	public void setSectionId(int sectionId) { this.sectionId = sectionId; }

    public int getCurrentSemester() { return currentSemester; }
    public void setCurrentSemester(int currentSemester) { this.currentSemester = currentSemester; }

    public double getCgpa() { return cgpa; }
    public void setCgpa(double cgpa) { this.cgpa = cgpa; }

    public String getBatch() { return batch; }
    public void setBatch(String batch) { this.batch = batch; }

    public LocalDate getAdmissionDate() { return admissionDate; }
    public void setAdmissionDate(LocalDate admissionDate) { this.admissionDate = admissionDate; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }

    public String getNationality() { return nationality; }
    public void setNationality(String nationality) { this.nationality = nationality; }

    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }

    public String getAlternateMobile() { return alternateMobile; }
    public void setAlternateMobile(String alternateMobile) { this.alternateMobile = alternateMobile; }

    public String getPermanentAddress() { return permanentAddress; }
    public void setPermanentAddress(String permanentAddress) { this.permanentAddress = permanentAddress; }

    public String getCorrespondenceAddress() { return correspondenceAddress; }
    public void setCorrespondenceAddress(String correspondenceAddress) { this.correspondenceAddress = correspondenceAddress; }

    public String getGuardianName() { return guardianName; }
    public void setGuardianName(String guardianName) { this.guardianName = guardianName; }

    public String getGuardianRelationship() { return guardianRelationship; }
    public void setGuardianRelationship(String guardianRelationship) { this.guardianRelationship = guardianRelationship; }

    public String getGuardianContact() { return guardianContact; }
    public void setGuardianContact(String guardianContact) { this.guardianContact = guardianContact; }

    public String getGuardianAlternateContact() { return guardianAlternateContact; }
    public void setGuardianAlternateContact(String guardianAlternateContact) { this.guardianAlternateContact = guardianAlternateContact; }

    public String getGuardianEmail() { return guardianEmail; }
    public void setGuardianEmail(String guardianEmail) { this.guardianEmail = guardianEmail; }

    public String getGuardianOccupation() { return guardianOccupation; }
    public void setGuardianOccupation(String guardianOccupation) { this.guardianOccupation = guardianOccupation; }

    public int getExpectedGraduationYear() { return expectedGraduationYear; }
    public void setExpectedGraduationYear(int expectedGraduationYear) { this.expectedGraduationYear = expectedGraduationYear; }

    public Integer getClassAdvisorId() { return classAdvisorId; }
    public void setClassAdvisorId(Integer classAdvisorId) { this.classAdvisorId = classAdvisorId; }

    public String getDateOfBirthFormatted() {
        if (dateOfBirth == null) return "Not Provided";
        return dateOfBirth.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }
    
    public String getAdmissionDateFormatted() {
        if (admissionDate == null) return "Not Available";
        return admissionDate.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { this.isActive = active; }
}