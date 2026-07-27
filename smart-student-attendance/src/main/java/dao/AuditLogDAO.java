package dao;

public interface AuditLogDAO{
	void logAuditAction(int userId, String actionType, String description, String ipAddress);
} 