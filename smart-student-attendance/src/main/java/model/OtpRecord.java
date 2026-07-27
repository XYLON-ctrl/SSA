package model;

import java.time.LocalDateTime;

public class OtpRecord {
    private int otpId;
    private int userId;
    private String otpCode;
    private LocalDateTime expiryTime;
    private int attemptCount;
    private boolean isActive;

    // Getters and Setters
    public int getOtpId() { return otpId; }
    public void setOtpId(int otpId) { this.otpId = otpId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getOtpCode() { return otpCode; }
    public void setOtpCode(String otpCode) { this.otpCode = otpCode; }
    public LocalDateTime getExpiryTime() { return expiryTime; }
    public void setExpiryTime(LocalDateTime expiryTime) { this.expiryTime = expiryTime; }
    public int getAttemptCount() { return attemptCount; }
    public void setAttemptCount(int attemptCount) { this.attemptCount = attemptCount; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}