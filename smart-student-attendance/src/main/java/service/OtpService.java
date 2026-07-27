package service;

import dao.OtpDAO;
import dao.OtpDAOImpl;
import exception.InvalidOtpException;
import exception.OtpExpiredException;
import exception.SecurityViolationException;
import exception.TooManyAttemptsException;
import model.OtpRecord;
import model.User;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.logging.Logger;

public class OtpService {
    private static final Logger LOGGER = Logger.getLogger(OtpService.class.getName());
    private static final int OTP_EXPIRY_MINUTES = 10;
    private static final int MAX_REQUESTS_PER_HOUR = 5;
    private static final int MAX_VERIFICATION_ATTEMPTS = 5;
    
    private final SecureRandom secureRandom = new SecureRandom();
    private final OtpDAO otpDAO = new OtpDAOImpl();
    private final EmailService emailService = new EmailService();
    private final AuditLogService auditLogService = new AuditLogService();

    /**
     * Generates an OTP, saves it, and emails it to the user.
     */
    public void generateAndSendOtp(User user, String ipAddress, String userAgent) throws Exception {
        // 1. Rate Limiting Check
        checkRateLimit(user.getUserId());

        // 2. Generate Secure 6-Digit OTP
        String otp = generateSecureOtp();
        LocalDateTime expiry = LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES);

        // 3. Store OTP in Database (Invalidates any previous active OTPs)
        otpDAO.invalidateExistingOtps(user.getUserId());
        otpDAO.saveOtp(user.getUserId(), otp, expiry);

        // 4. Email Delivery
        emailService.sendOtpEmail(user.getEmail(), user.getFullName(), otp, OTP_EXPIRY_MINUTES);

        // 5. Audit Logging
        auditLogService.logLoginAttempt(user.getUserId(), user.getUsername(), ipAddress, userAgent, "FORGOT_PASSWORD_REQUESTED");
        
        LOGGER.info("OTP generated and sent for user: " + user.getUsername());
    }

    /**
     * Verifies the submitted OTP against the database record.
     */
    public void verifyOtp(int userId, String submittedOtp) 
            throws InvalidOtpException, OtpExpiredException, TooManyAttemptsException {
        
        OtpRecord otpRecord = otpDAO.getActiveOtp(userId);
        
        if (otpRecord == null) {
            throw new InvalidOtpException("No active verification code found.");
        }

        // 1. Check Expiry (Server-side validation, ignores client-side timer)
        if (otpRecord.getExpiryTime().isBefore(LocalDateTime.now())) {
            otpDAO.invalidateOtp(otpRecord.getOtpId());
            throw new OtpExpiredException("Verification code has expired. Please request a new code.");
        }

        // 2. Check Attempt Limit
        if (otpRecord.getAttemptCount() >= MAX_VERIFICATION_ATTEMPTS) {
            otpDAO.invalidateOtp(otpRecord.getOtpId());
            throw new TooManyAttemptsException("Maximum verification attempts exceeded. Please request a new verification code.");
        }

        // 3. Compare OTP securely
        if (!otpRecord.getOtpCode().equals(submittedOtp)) {
            otpDAO.incrementAttemptCount(otpRecord.getOtpId());
            int remaining = MAX_VERIFICATION_ATTEMPTS - (otpRecord.getAttemptCount() + 1);
            
            if (remaining <= 0) {
                otpDAO.invalidateOtp(otpRecord.getOtpId());
                throw new TooManyAttemptsException("Maximum verification attempts exceeded. Please request a new verification code.");
            }
            
            throw new InvalidOtpException("Invalid verification code. You have " + remaining + " attempts remaining.");
        }

        // 4. Success: Mark as used (Prevents replay attacks)
        otpDAO.markOtpAsUsed(otpRecord.getOtpId());
        LOGGER.info("OTP verified successfully for user ID: " + userId);
    }

    private void checkRateLimit(int userId) throws SecurityViolationException {
        int count = otpDAO.getOtpCountInLastHour(userId);
        if (count >= MAX_REQUESTS_PER_HOUR) {
            LOGGER.warning("Rate limit exceeded for user ID: " + userId);
            throw new SecurityViolationException("Too many requests. Please try again later.");
        }
    }

    private String generateSecureOtp() {
        // Generates a number between 100000 and 999999
        int otp = 100000 + secureRandom.nextInt(900000);
        return String.valueOf(otp);
    }
}