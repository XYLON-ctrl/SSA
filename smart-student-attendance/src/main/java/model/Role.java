package model;

public enum Role {
    STUDENT,
    FACULTY,
    ADMIN;
    
    public static Role fromString(String role) {
        if (role == null) return null;
        try {
            return Role.valueOf(role.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}