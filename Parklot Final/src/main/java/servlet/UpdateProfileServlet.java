package servlet;

import dao.UserDAO;
import model.User;
import model.RegularUser;
import model.AdminUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = UserDAO.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.html?error=Please+log+in");
            return;
        }

        String action = request.getParameter("action");

        // Handle account deletion
        if ("delete".equals(action)) {
            String username = request.getParameter("username");
            if (username != null && username.equalsIgnoreCase(currentUser.getUsername())) {
                boolean deleted = userDAO.deleteUser(username);
                if (deleted) {
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + "/login.html?success=Account+deleted+successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Failed+to+delete+account");
                }
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Invalid+username+for+deletion");
                return;
            }
        }

        // Handle profile update
        String email = request.getParameter("email");
        String nic = request.getParameter("nic");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        // Validation
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Email+is+required");
            return;
        }
        if (nic == null || nic.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=NIC+is+required");
            return;
        }

        String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
        if (!email.matches(emailRegex)) {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Invalid+email+format");
            return;
        }

        if (password != null && !password.isEmpty()) {
            if (password.length() < 6) {
                response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Password+must+be+at+least+6+characters");
                return;
            }
            if (!password.equals(confirmPassword)) {
                response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Passwords+do+not+match");
                return;
            }
        }

        // Check for email and NIC uniqueness
        if (!email.equalsIgnoreCase(currentUser.getEmail()) && userDAO.emailExists(email)) {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Email+already+exists");
            return;
        }
        if (!nic.equalsIgnoreCase(currentUser.getNic()) && userDAO.nicExists(nic)) {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=NIC+already+exists");
            return;
        }

        // Create updated user object based on user type
        User updatedUser;
        if (currentUser instanceof AdminUser) {
            updatedUser = new AdminUser(
                    currentUser.getUsername(),
                    email,
                    nic,
                    password != null && !password.isEmpty() ? password : currentUser.getPassword()
            );
            ((AdminUser) updatedUser).setActive(((AdminUser) currentUser).isActive());
        } else {
            updatedUser = new RegularUser(
                    currentUser.getUsername(),
                    email,
                    nic,
                    password != null && !password.isEmpty() ? password : currentUser.getPassword()
            );
        }

        // Update user in DAO
        boolean updated = userDAO.updateUser(updatedUser);
        if (updated) {
            session.setAttribute("user", updatedUser);
            response.sendRedirect(request.getContextPath() + "/profile.jsp?success=Profile+updated+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Failed+to+update+profile");
        }
    }
}