package servlet;

import dao.UserDAO;
import dao.AdminDAO;
import model.RegularUser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/userSignup")
public class UserSignupServlet extends HttpServlet {
    private UserDAO userDAO;
    private AdminDAO adminDAO;

    @Override
    public void init() {
        userDAO = UserDAO.getInstance();
        adminDAO = AdminDAO.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String nic = request.getParameter("nic");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        // Decode email to handle URL-encoded characters (e.g., %40 -> @)
        if (email != null && !email.isEmpty()) {
            try {
                email = URLDecoder.decode(email, StandardCharsets.UTF_8.name());
            } catch (IllegalArgumentException e) {
                response.sendRedirect("Signup.html?error=Invalid email format");
                return;
            }
        }

        // Basic validation
        if (username == null || username.isEmpty()) {
            response.sendRedirect("Signup.html?error=Username is required");
            return;
        }
        if (email == null || email.isEmpty()) {
            response.sendRedirect("Signup.html?error=Email is required");
            return;
        }
        // Validate email format (basic check for @ and domain)
        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            response.sendRedirect("Signup.html?error=Invalid email format");
            return;
        }
        if (nic == null || nic.isEmpty()) {
            response.sendRedirect("Signup.html?error=NIC is required");
            return;
        }
        if (password == null || password.isEmpty()) {
            response.sendRedirect("Signup.html?error=Password is required");
            return;
        }
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            response.sendRedirect("Signup.html?error=Confirm password is required");
            return;
        }
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("Signup.html?error=Passwords do not match");
            return;
        }
        if (password.length() < 6) {
            response.sendRedirect("Signup.html?error=Password must be at least 6 characters");
            return;
        }

        // Check for existing username, email, or NIC
        if (adminDAO.usernameExists(username)) {
            response.sendRedirect("Signup.html?error=Username already exists");
            return;
        }
        if (adminDAO.emailExists(email)) {
            response.sendRedirect("Signup.html?error=Email already registered");
            return;
        }
        if (adminDAO.nicExists(nic)) {
            response.sendRedirect("Signup.html?error=NIC already registered");
            return;
        }
        if (userDAO.usernameExists(username)) {
            response.sendRedirect("Signup.html?error=Username already exists");
            return;
        }
        if (userDAO.emailExists(email)) {
            response.sendRedirect("Signup.html?error=Email already registered");
            return;
        }
        if (userDAO.nicExists(nic)) {
            response.sendRedirect("Signup.html?error=NIC already registered");
            return;
        }

        // Create RegularUser
        RegularUser user = new RegularUser(username, email, nic, password);
        boolean success = userDAO.addUser(user);

        if (success) {
            response.sendRedirect("login.html?success=Account created successfully");
        } else {
            response.sendRedirect("Signup.html?error=Failed to create account");
        }
    }
}