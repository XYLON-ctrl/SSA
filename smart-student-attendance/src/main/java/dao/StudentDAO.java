package dao;

import model.Student;
import model.Subject;
import model.TimetableEntry;
import model.Mark;
import model.SemesterCGPA;

import java.util.List;
import java.util.Map;

public interface StudentDAO {
    
    // ===== PROFILE & USER DATA =====
    Student getStudentProfile(int userId);
    boolean updateFullProfile(int userId, String gender, String dateOfBirth, String bloodGroup, String nationality, 
                              String email, String mobileNumber, String alternateMobile,
                              String permanentAddress, String correspondenceAddress,
                              String guardianName, String guardianRelationship, String guardianContact, 
                              String guardianAlternateContact, String guardianEmail, String guardianOccupation);
    List<Map<String, Object>> getRecentActivities(int userId);

    // ===== SUBJECTS & ENROLLMENT =====
    List<Subject> getEnrolledSubjects(int userId);
    List<Subject> getEnrolledSubjectsBySemester(int userId, int semester);
    List<Integer> getAvailableSemesters(int userId);
    int getTotalSubjectsCount(int userId);
    int getTotalStudentCount();
    
    // ✅ UPDATED: Returns Map instead of int (removed duplicate)
    int getSubjectsCountBySemester(int userId, int semester);
    Map<Integer, Integer> getSubjectsCountBySemester(int studentId);

    // ===== TIMETABLE =====
    List<TimetableEntry> getWeeklyTimetable(int userId, int semester);
    int getTodayClassesCount(int userId, String dayOfWeek);
    int getTomorrowClassesCount(int userId, String dayOfWeek);

    // ===== MARKS & GRADES =====
    List<Mark> getStudentMarks(int userId);
    List<Mark> getStudentMarksBySemester(int userId, int semester);
    List<Mark> getStudentMarksByExamType(int userId, String examType);
    List<Mark> getStudentMarksBySemesterAndExamType(int userId, int semester, String examType);
    List<Mark> getFilteredMarks(int userId, int semester, String examType, int subjectId);
    int getTotalMarksCount(int userId);

    // ===== PERFORMANCE ANALYTICS =====
    // ✅ UPDATED: Returns Map<Integer, Double> instead of List<Double> (removed duplicate)
    Map<Integer, Double> getSemesterWiseCGPA(int studentId);
    Map<Integer, Double> getSemesterWiseSGPA(int studentId);
    List<SemesterCGPA> getSemesterWiseCGPAWithSemesterNumber(int userId);
    
    // ✅ UPDATED: Returns Map<Integer, Map<String, Object>> instead of List<Map<String, Object>> (removed duplicate)
    Map<Integer, Map<String, Object>> getSemesterExamTotals(int studentId);
    
    int getTotalPossibleCredits(int userId);
    int getTotalCreditsEarned(int userId);
    int getClassRank(int userId, String batch);
    int getTotalStudentsInBatch(String batch);
}