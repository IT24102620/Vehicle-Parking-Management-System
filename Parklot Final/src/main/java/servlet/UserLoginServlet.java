package servlet;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/userLogin")
public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = UserDAO.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Read form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic null/empty check
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login.html?error=Please+enter+both+username+and+password");
            return;
        }

        // Authenticate user
        User user = userDAO.authenticate(username.trim(), password.trim());
        if (user != null) {
            // On success, store in session and redirect to user dashboard
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            response.sendRedirect("dashboard.jsp?success=Login+successful");
        } else {
            // On failure, redirect back with error
            response.sendRedirect("login.html?error=Invalid+credentials");
        }
    }

    @Override
    public void destroy() {
        super.destroy();
    }
}