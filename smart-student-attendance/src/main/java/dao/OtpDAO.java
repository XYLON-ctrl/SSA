package dao;

import model.OtpRecord;
import java.time.LocalDateTime;

public interface OtpDAO {
    OtpRecord getActiveOtp(int userId);
    void saveOtp(int userId, String otpCode, LocalDateTime expiry);
    void invalidateExistingOtps(int userId);
    void incrementAttemptCount(int otpId);
    void markOtpAsUsed(int otpId);
    void invalidateOtp(int otpId);
    int getOtpCountInLastHour(int userId);
}