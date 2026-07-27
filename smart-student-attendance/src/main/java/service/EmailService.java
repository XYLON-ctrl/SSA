package service;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException; 
import java.util.Properties;
import java.util.logging.Logger;

public class EmailService {
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());

    public void sendOtpEmail(String toEmail, String fullName, String otp, int expiryMinutes) throws MessagingException {
        // Configuration values loaded from Environment Variables (No hardcoded values)
        String host = getEnv("SMTP_HOST", "smtp.gmail.com");
        String port = getEnv("SMTP_PORT", "587");
        String smtpUser = getEnv("SMTP_USER", "");
        String smtpPassword = getEnv("SMTP_PASSWORD", "");
        String supportEmail = getEnv("SUPPORT_EMAIL", "support@university.edu");
        String systemName = getEnv("SYSTEM_NAME", "Campus Analytics & Student Monitoring Portal");

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPassword);
            }
        });

        Message message = new MimeMessage(session);
        try {
            // Attempt to set the "From" address with the System Name as the display name
            message.setFrom(new InternetAddress(smtpUser, systemName));
        } catch (UnsupportedEncodingException e) {
            // Fallback: If the system name contains unsupported characters, just use the raw email
            LOGGER.warning("Unsupported encoding for email personal name. Falling back to raw email address.");
            message.setFrom(new InternetAddress(smtpUser));
        }
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Password Reset Verification Code");

        // Professional HTML Email Body
        String emailBody = String.format(
            "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;'>" +
            "<h2 style='color: #1e3c72;'>Password Reset Request</h2>" +
            "<p>Hello %s,</p>" +
            "<p>We received a request to reset your password for your %s account.</p>" +
            "<p>Your One-Time Password (OTP) is:</p>" +
            "<h1 style='background: #f0f4f8; padding: 15px; text-align: center; color: #2a5298; letter-spacing: 5px; font-size: 32px;'>%s</h1>" +
            "<p>This code will expire in <strong>%d minutes</strong>.</p>" +
            "<p>If you did not request a password reset, please ignore this email or contact our IT support at <a href='mailto:%s'>%s</a> immediately.</p>" +
            "<hr style='border: 0; border-top: 1px solid #e0e0e0; margin: 20px 0;'>" +
            "<p style='font-size: 12px; color: #718096;'>For security reasons, do not share this code with anyone. University IT staff will never ask for your OTP.</p>" +
            "</div>",
            fullName, systemName, otp, expiryMinutes, supportEmail, supportEmail
        );

        message.setContent(emailBody, "text/html; charset=utf-8");
        Transport.send(message);
        LOGGER.info("OTP email sent successfully to: " + toEmail);
    }

    private String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }
}