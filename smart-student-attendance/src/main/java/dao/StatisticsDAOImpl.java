package dao;

import util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StatisticsDAOImpl implements StatisticsDAO {

    @Override
    public int getTotalStudents() {
        return getCount("SELECT COUNT(*) FROM students WHERE is_active = 1", "Total Students");
    }

    @Override
    public int getTotalFaculty() {
        return getCount("SELECT COUNT(*) FROM faculty WHERE is_active = 1", "Total Faculty");
    }

    @Override
    public int getTotalDepartments() {
        return getCount("SELECT COUNT(*) FROM departments", "Total Departments");
    }

    @Override
    public int getTotalAttendanceRecords() {
        return getCount("SELECT COUNT(*) FROM attendance_records", "Attendance Records");
    }

    private int getCount(String sql, String statName) {
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                int count = rs.getInt(1);
                return count;
            }
        } catch (Exception e) {
            e.printStackTrace(); 
        }
        return 0;
    }
}