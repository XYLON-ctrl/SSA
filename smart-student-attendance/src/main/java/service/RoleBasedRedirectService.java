package service;

import model.Role;

public class RoleBasedRedirectService {
    
    public static String getDashboardPath(Role role) {
        if (role == null) {
            return "/login";
        }
        
        switch (role) {
            case ADMIN:
                return "/admin/dashboard";
            case FACULTY:
                return "/faculty/dashboard";
            case STUDENT:
                return "/student/dashboard";
            default:
                return "/login";
        }
    }
    
    public static String getProfilePath(Role role) {
        if (role == null) {
            return "/login";
        }
        
        switch (role) {
            case ADMIN:
                return "/admin/profile";
            case FACULTY:
                return "/faculty/profile";
            case STUDENT:
                return "/student/profile";
            default:
                return "/login";
        }
    }
    
    public static String getHomePath(Role role) {
        return getDashboardPath(role);
    }
}