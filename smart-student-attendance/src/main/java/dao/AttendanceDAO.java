package dao;
import model.AttendanceRecord;
import model.SubjectAttendanceDTO;
import java.util.List;

public interface AttendanceDAO {
    double getOverallAttendancePercentage(int userId);
    List<SubjectAttendanceDTO> getSubjectWiseAttendance(int userId);
    List<AttendanceRecord> getDailyAttendanceRecords(int userId, int subjectId);
    double getOverallAttendancePercentage();
}