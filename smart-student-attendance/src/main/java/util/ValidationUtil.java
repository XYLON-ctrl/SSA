package util;

import java.util.regex.Pattern;

public class ValidationUtil {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern SQL_INJECTION_PATTERN = Pattern.compile(
        "(?i)(\\b(SELECT|INSERT|UPDATE|DELETE|DROP|UNION|ALTER|CREATE|EXEC|SCRIPT)\\b|--|;|\\'|\\\"|\\bOR\\b=\\b)"
    );

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidUsername(String username) {
        // Accept email format OR regular username (3-50 chars)
        if (username == null || username.trim().isEmpty()) return false;
        
        // Email pattern
        if (username.contains("@")) {
            return username.length() >= 5 && username.length() <= 100;
        }
        
        // Regular username pattern
        return username.length() >= 3 && username.length() <= 50;
    }

    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) return false;
        // Regex: Min 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char, no spaces
        String regex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?])(?=\\S+$).{8,}$";
        return password.matches(regex);
    }

    public static boolean containsMaliciousInput(String input) {
        if (input == null) return false;
        return SQL_INJECTION_PATTERN.matcher(input).find();
    }

    public static String sanitize(String input) {
        if (input == null) return null;
        return input.trim().replaceAll("[<>(){}]", ""); // Basic sanitization
    }
}