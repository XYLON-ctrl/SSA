package service;

import dao.LeaveDAO;
import dao.LeaveDAOImpl;
import model.LeaveRequest;

import java.util.List;

public class LeaveService {
    private final LeaveDAO leaveDAO = new LeaveDAOImpl();

    public List<LeaveRequest> getLeaveHistory(int userId) {
        return leaveDAO.getLeaveHistory(userId);
    }

    public List<LeaveRequest> getLeaveHistoryByStatus(int userId, String status) {
        if ("ALL".equals(status) || status == null || status.isEmpty()) {
            return leaveDAO.getLeaveHistory(userId);
        }
        return leaveDAO.getLeaveHistoryByStatus(userId, status);
    }

    public boolean applyForLeave(LeaveRequest leave) {
        return leaveDAO.applyForLeave(leave);
    }

    public int getPendingLeaveCount(int userId) {
        return leaveDAO.getPendingLeaveCount(userId);
    }

    public int getLeaveCountByStatus(int userId, String status) {
        return leaveDAO.getLeaveCountByStatus(userId, status);
    }

    public int[] getLeaveSummaryCounts(int userId) {
        int pending = getLeaveCountByStatus(userId, "PENDING");
        int approved = getLeaveCountByStatus(userId, "APPROVED");
        int rejected = getLeaveCountByStatus(userId, "REJECTED");
        return new int[]{pending, approved, rejected};
    }


}