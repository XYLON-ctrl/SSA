package dao;

import model.AttendanceRecord;
import model.SubjectAttendanceDTO;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AttendanceDAOImpl implements AttendanceDAO {
    private static final Logger LOGGER = Logger.getLogger(AttendanceDAOImpl.class.getName());

    @Override
    public double getOverallAttendancePercentage(int userId) {
        String sql = "SELECT COALESCE(ROUND(SUM(CASE WHEN status IN ('PRESENT', 'LATE') THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2), 0.0) " +
                     "FROM attendance_records WHERE student_id = ? AND status != 'CANCELLED'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating overall attendance", e);
        }
        return 0.0;
    }

    @Override
    public List<SubjectAttendanceDTO> getSubjectWiseAttendance(int studentId) {
        List<SubjectAttendanceDTO> list = new ArrayList<>();
        String sql = "SELECT sub.subject_id, sub.subject_code, sub.subject_name, " +
                     "COUNT(ar.record_id) as total_classes, " +
                     "SUM(CASE WHEN ar.status IN ('PRESENT', 'LATE') THEN 1 ELSE 0 END) as attended_classes " +
                     "FROM attendance_records ar " +
                     "JOIN subjects sub ON ar.subject_id = sub.subject_id " +
                     "WHERE ar.student_id = ? AND ar.status != 'CANCELLED' " +
                     "GROUP BY sub.subject_id, sub.subject_code, sub.subject_name";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SubjectAttendanceDTO dto = new SubjectAttendanceDTO();
                    dto.setSubjectId(rs.getInt("subject_id"));
                    dto.setSubjectCode(rs.getString("subject_code"));
                    dto.setSubjectName(rs.getString("subject_name"));

                    int total = rs.getInt("total_classes");
                    int attended = rs.getInt("attended_classes");
                    double percentage = (total > 0) ? (attended * 100.0) / total : 0.0;

                    dto.setTotalClasses(total);
                    dto.setAttendedClasses(attended);
                    dto.setPercentage(Math.round(percentage * 10.0) / 10.0);
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching subject-wise attendance", e);
        }
        return list;
    }

    @Override
    public List<AttendanceRecord> getDailyAttendanceRecords(int userId, int subjectId) {
        List<AttendanceRecord> records = new ArrayList<>();
        String sql = "SELECT ar.record_id, ar.subject_id, s.subject_name, ar.attendance_date, ar.status " +
                     "FROM attendance_records ar JOIN subjects s ON ar.subject_id = s.subject_id " +
                     "WHERE ar.student_id = ? AND ar.subject_id = ? ORDER BY ar.attendance_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AttendanceRecord rec = new AttendanceRecord();
                    rec.setRecordId(rs.getInt("record_id"));
                    rec.setSubjectId(rs.getInt("subject_id"));
                    rec.setSubjectName(rs.getString("subject_name"));
                    rec.setAttendanceDate(rs.getDate("attendance_date").toLocalDate());
                    rec.setStatus(rs.getString("status"));
                    records.add(rec);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching daily attendance records", e);
        }
        return records;
    }
    
    @Override
    public double getOverallAttendancePercentage() {

        String sql = "SELECT ROUND((SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2 ) AS percentage FROM attendance_records";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("percentage");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0.0;
    }
}