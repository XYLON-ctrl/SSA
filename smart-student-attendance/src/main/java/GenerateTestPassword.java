import org.mindrot.jbcrypt.BCrypt;

public class GenerateTestPassword {
    public static void main(String[] args) {
        String password = "Faculty@123";
        String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));   
        System.out.println("=== ADMIN PASSWORD HASH ===");
        System.out.println("Plain Password: " + password);
        System.out.println("BCrypt Hash: " + hash);    
    }
}