package servlet.faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TimetableEntry;
import model.User;
import service.FacultyService;

import java.io.IOException;
import java.util.List;

@WebServlet("/faculty/timetable")
public class TimetableServlet extends BaseServlet {

    private final FacultyService facultyService = new FacultyService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        User user = requireFaculty(request, response);
        if (user == null) {
            return;
        }

        int facultyId = facultyService.getFacultyIdByEmail(user.getEmail());

        if (facultyId <= 0) {
            request.setAttribute("errorMessage",
                    "Faculty profile not found.");
            request.getRequestDispatcher("/faculty/facultyTimetable.jsp")
                   .forward(request, response);
            return;
        }

        setActivePage(request, "timetable");

        List<TimetableEntry> timetable =
                facultyService.getFacultyTimetable(facultyId);

        request.setAttribute("timetable", timetable);
        request.setAttribute("pageTitle", "My Timetable");

        request.getRequestDispatcher("/faculty/facultyTimetable.jsp")
               .forward(request, response);
    }
}