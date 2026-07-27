package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import util.DatabaseUtil;

public class SubjectDAOImpl implements SubjectDAO {

	@Override
	public int getActiveSubjectCount() {
	    String sql = "SELECT COUNT(*) FROM subjects WHERE is_Active = '1'";

	    try (Connection conn = DatabaseUtil.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
}