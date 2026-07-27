package model;

import java.time.LocalDate;

public class Faculty {
    private int facultyId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String alternatePhone;      // ✅ NEW
    private String officeLocation;
    private String employeeId;
    private String department;
    private int departmentId;
    private String designation;
    private String qualification;
    private String specialization;
    private int experienceYears;        // ✅ NEW
    private String researchArea;
    private String researchInterests;   // ✅ NEW
    private int publicationsCount;
    private String certifications;
    private String googleScholar;       // ✅ NEW
    private String linkedinProfile;     // ✅ NEW
    private String orcidId;             // ✅ NEW
    private String academicWebsite;     // ✅ NEW
    private String address;             // ✅ NEW
    private String city;                // ✅ NEW
    private String state;               // ✅ NEW
    private String postalCode;          // ✅ NEW
    private LocalDate joiningDate;
    private boolean classAdvisor;
    private Integer advisorSectionId;
    private boolean isActive;  
    private String passwordHash;
    private int userId; 

    public Faculty() {}

    // Getters and Setters
    public int getFacultyId() { return facultyId; }
    public void setFacultyId(int facultyId) { this.facultyId = facultyId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getAlternatePhone() { return alternatePhone; }
    public void setAlternatePhone(String alternatePhone) { this.alternatePhone = alternatePhone; }

    public String getOfficeLocation() { return officeLocation; }
    public void setOfficeLocation(String officeLocation) { this.officeLocation = officeLocation; }

    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    
	public int getDepartmentId() {return departmentId;}
	public void setDepartmentId(int departmentId) {	this.departmentId = departmentId;}

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public int getExperienceYears() { return experienceYears; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }

    public String getResearchArea() { return researchArea; }
    public void setResearchArea(String researchArea) { this.researchArea = researchArea; }

    public String getResearchInterests() { return researchInterests; }
    public void setResearchInterests(String researchInterests) { this.researchInterests = researchInterests; }

    public int getPublicationsCount() { return publicationsCount; }
    public void setPublicationsCount(int publicationsCount) { this.publicationsCount = publicationsCount; }

    public String getCertifications() { return certifications; }
    public void setCertifications(String certifications) { this.certifications = certifications; }

    public String getGoogleScholar() { return googleScholar; }
    public void setGoogleScholar(String googleScholar) { this.googleScholar = googleScholar; }

    public String getLinkedinProfile() { return linkedinProfile; }
    public void setLinkedinProfile(String linkedinProfile) { this.linkedinProfile = linkedinProfile; }

    public String getOrcidId() { return orcidId; }
    public void setOrcidId(String orcidId) { this.orcidId = orcidId; }

    public String getAcademicWebsite() { return academicWebsite; }
    public void setAcademicWebsite(String academicWebsite) { this.academicWebsite = academicWebsite; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    public LocalDate getJoiningDate() { return joiningDate; }
    public void setJoiningDate(LocalDate joiningDate) { this.joiningDate = joiningDate; }

    public boolean isClassAdvisor() { return classAdvisor; }
    public void setClassAdvisor(boolean classAdvisor) { this.classAdvisor = classAdvisor; }

    public Integer getAdvisorSectionId() { return advisorSectionId; }
    public void setAdvisorSectionId(Integer advisorSectionId) { this.advisorSectionId = advisorSectionId; }
    
    public String getJoiningDateFormatted() {
    	if (joiningDate == null) return "N/A";
        return joiningDate.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; } 
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}