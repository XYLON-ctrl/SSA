package util;

import jakarta.servlet.http.HttpSession;
import java.util.UUID;

public class CsrfUtil {
    public static final String CSRF_TOKEN_SESSION_KEY = "CSRF_TOKEN";

    public static String generateToken(HttpSession session) {
        String token = UUID.randomUUID().toString();
        session.setAttribute(CSRF_TOKEN_SESSION_KEY, token);
        return token;
    }

    public static boolean isValidToken(HttpSession session, String submittedToken) {
        if (session == null || submittedToken == null) return false;
        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_SESSION_KEY);
        return submittedToken.equals(sessionToken);
    }

    public static void removeToken(HttpSession session) {
        if (session != null) session.removeAttribute(CSRF_TOKEN_SESSION_KEY);
    }
}