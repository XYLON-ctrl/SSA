package dao;

import model.LeaveRequest;
import java.util.List;

public interface LeaveDAO {
    List<LeaveRequest> getLeaveHistory(int userId);
    List<LeaveRequest> getLeaveHistoryByStatus(int userId, String status);
    boolean applyForLeave(LeaveRequest leave);
    int getPendingLeaveCount(int userId);
    int getLeaveCountByStatus(int userId, String status);  // NEW
}