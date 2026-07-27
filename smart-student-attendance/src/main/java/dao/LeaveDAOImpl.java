package dao;

import model.LeaveRequest;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LeaveDAOImpl implements LeaveDAO {
    private static final Logger LOGGER = Logger.getLogger(LeaveDAOImpl.class.getName());

    @Override
    public List<LeaveRequest> getLeaveHistory(int userId) {
        return getLeaveHistoryByStatus(userId, null);
    }

    @Override
    public List<LeaveRequest> getLeaveHistoryByStatus(int userId, String status) {
        List<LeaveRequest> leaves = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM leaves WHERE student_id = ?");
        
        if (status != null && !status.isEmpty() && !"ALL".equals(status)) {
            sql.append(" AND status = ?");
        }
        
        sql.append(" ORDER BY applied_on DESC");
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, userId);
            if (status != null && !status.isEmpty() && !"ALL".equals(status)) {
                ps.setString(2, status);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    leaves.add(mapLeave(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching leave history", e);
        }
        return leaves;
    }

    @Override
    public boolean applyForLeave(LeaveRequest leave) {
        String sql = "INSERT INTO leaves (student_id, start_date, end_date, reason, status) VALUES (?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, leave.getStudentId());
            ps.setDate(2, Date.valueOf(leave.getStartDate()));
            ps.setDate(3, Date.valueOf(leave.getEndDate()));
            ps.setString(4, leave.getReason());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error applying for leave", e);
        }
        return false;
    }

    @Override
    public int getPendingLeaveCount(int userId) {
        return getLeaveCountByStatus(userId, "PENDING");
    }

    @Override
    public int getLeaveCountByStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM leaves WHERE student_id = ? AND status = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting leaves by status", e);
        }
        return 0;
    }

    private LeaveRequest mapLeave(ResultSet rs) throws SQLException {
        LeaveRequest leave = new LeaveRequest();
        leave.setLeaveId(rs.getInt("leave_id"));
        leave.setStudentId(rs.getInt("student_id"));
        leave.setStartDate(rs.getDate("start_date").toLocalDate());
        leave.setEndDate(rs.getDate("end_date").toLocalDate());
        leave.setReason(rs.getString("reason"));
        leave.setStatus(rs.getString("status"));
        leave.setAppliedOn(rs.getTimestamp("applied_on").toLocalDateTime());
        return leave;
    }
}