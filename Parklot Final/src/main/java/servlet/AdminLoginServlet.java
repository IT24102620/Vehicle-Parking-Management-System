package servlet;

import dao.AdminDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = AdminDAO.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String adminCode = request.getParameter("adminCode");

        if (username == null || password == null || adminCode == null) {
            response.sendRedirect("login.html?error=Invalid username, password, or admin code");
            return;
        }

        User user = adminDAO.authenticate(username.trim(), password.trim(), adminCode.trim());
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            String redirectUrl = user.getDashboardPage();
            response.sendRedirect(redirectUrl + "?success=Login successful");
        } else {
            response.sendRedirect("login.html?error=Invalid username, password, or admin code");
        }
    }
}