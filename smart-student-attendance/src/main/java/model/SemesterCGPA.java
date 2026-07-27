package model;

public class SemesterCGPA {
    private int semesterNumber;
    private double cgpa;
    private int semester;
    
    public SemesterCGPA() {}
    
    public SemesterCGPA(int semesterNumber, double cgpa) {
        this.semesterNumber = semesterNumber;
        this.cgpa = cgpa;
    }
    
    public int getSemesterNumber() {
        return semesterNumber;
    }
    
    public void setSemesterNumber(int semesterNumber) {
        this.semesterNumber = semesterNumber;
    }
    
    // ✅ ADD THIS MISSING GETTER
    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public double getCgpa() {
        return cgpa;
    }

    public void setCgpa(double cgpa) {
        this.cgpa = cgpa;
    }
}