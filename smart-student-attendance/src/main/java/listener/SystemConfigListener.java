package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.time.Year;

@WebListener
public class SystemConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();

        // --- SYSTEM BRANDING & CONFIGURATION ---
        // In a real enterprise app, you might load these from a properties file or database.
        context.setAttribute("portalName", "Campus Analytics & Student Monitoring Portal");
        context.setAttribute("systemShortName", "Campus Analytics");
        context.setAttribute("systemVersion", "1.0.0 Enterprise");
        
        // --- UNIVERSITY & CONTACT DETAILS ---
        context.setAttribute("universityName", "University of Oxford");
        context.setAttribute("supportEmail", "info@it.ox.ac.uk");
        context.setAttribute("supportPhone", "+1 (555) 123-4567");
        
        // --- DYNAMIC YEAR ---
        context.setAttribute("currentYear", Year.now().getValue());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if necessary
    }
}