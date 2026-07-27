package servlet.student;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import model.User;

abstract class BaseServlet extends HttpServlet {
    protected User requireLoggedInUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return (User) session.getAttribute("loggedInUser");
    }

    protected void transferFlashMessages(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

        Object success = session.getAttribute("flashSuccessMessage");
        if (success != null) {
            request.setAttribute("successMessage", success);
            session.removeAttribute("flashSuccessMessage");
        }

        Object error = session.getAttribute("flashErrorMessage");
        if (error != null) {
            request.setAttribute("errorMessage", error);
            session.removeAttribute("flashErrorMessage");
        }
    }

    protected void flashSuccess(HttpServletRequest request, String message) {
        request.getSession(true).setAttribute("flashSuccessMessage", message);
    }

    protected void flashError(HttpServletRequest request, String message) {
        request.getSession(true).setAttribute("flashErrorMessage", message);
    }

    protected int parseInt(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }
}
