package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            return null;
        }
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public static boolean verifyPassword(String plainPassword, String hashedPassword) {

        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        System.out.println("==== PASSWORD DEBUG ====");
        System.out.println("Hash: " + hashedPassword);
        System.out.println("Length: " + hashedPassword.length());

        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            System.out.println("INVALID HASH FOUND");
            e.printStackTrace();
            return false;
        }
    }
    
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return verifyPassword(plainPassword, hashedPassword);
    }
}