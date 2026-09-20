package servlet;

import dao.AdminDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AdminUser;
import model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminUsers")
public class AdminUserManagementServlet extends HttpServlet {
    private UserDAO userDAO;
    private AdminDAO adminDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !(user instanceof AdminUser)) {
            response.sendRedirect("login.html?error=Admin access required");
            return;
        }

        String searchQuery = request.getParameter("search");
        List<User> users = getAllUsers();
        System.out.println("AdminUserManagementServlet: Retrieved " + users.size() + " users");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            users = searchUsers(users, searchQuery);
            System.out.println("AdminUserManagementServlet: Filtered to " + users.size() + " users for query: " + searchQuery);
        }

        request.setAttribute("users", users);
        System.out.println("AdminUserManagementServlet: Forwarding to userList.jsp with " + users.size() + " users");
        request.getRequestDispatcher("/userList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !(user instanceof AdminUser)) {
            response.sendRedirect("login.html?error=Admin access required");
            return;
        }

        String action = request.getParameter("action");
        String username = request.getParameter("username");

        if ("update".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm-password");

            // Validation
            if (email == null || email.isEmpty()) {
                response.sendRedirect("userList.jsp?message=Email is required");
                return;
            }
            if (password != null && !password.isEmpty()) {
                if (!password.equals(confirmPassword)) {
                    response.sendRedirect("userList.jsp?message=Passwords do not match");
                    return;
                }
                if (password.length() < 6) {
                    response.sendRedirect("userList.jsp?message=Password must be at least 6 characters");
                    return;
                }
            }
            if (userDAO.emailExists(email) || adminDAO.emailExists(email)) {
                for (User u : getAllUsers()) {
                    if (u.getEmail().equalsIgnoreCase(email) && !u.getUsername().equalsIgnoreCase(username)) {
                        response.sendRedirect("userList.jsp?message=Email already registered");
                        return;
                    }
                }
            }

            // Find and update user
            User targetUser = null;
            boolean isAdmin = false;
            for (User u : getAllUsers()) {
                if (u.getUsername().equalsIgnoreCase(username)) {
                    targetUser = u;
                    isAdmin = u instanceof AdminUser;
                    break;
                }
            }
            if (targetUser == null) {
                response.sendRedirect("userList.jsp?message=User not found");
                return;
            }

            // Update user details
            targetUser.setEmail(email);
            if (password != null && !password.isEmpty()) {
                targetUser.setPassword(password);
            }

            boolean success;
            if (isAdmin) {
                success = adminDAO.updateAdmin((AdminUser) targetUser);
            } else {
                success = userDAO.updateUser(targetUser);
            }

            if (success) {
                response.sendRedirect("userList.jsp?message=User updated successfully");
            } else {
                response.sendRedirect("userList.jsp?message=Failed to update user");
            }
        } else if ("delete".equals(action)) {
            // Prevent admin from deleting themselves
            if (user.getUsername().equalsIgnoreCase(username)) {
                response.sendRedirect("userList.jsp?message=Cannot delete your own account");
                return;
            }

            boolean success = deleteUser(username);
            if (success) {
                response.sendRedirect("userList.jsp?message=User deleted successfully");
            } else {
                response.sendRedirect("userList.jsp?message=Failed to delete user");
            }
        }
    }

    private List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        // Add regular users
        User[] users = userDAO.getUsers();
        for (int i = 0; i < userDAO.getUserCount(); i++) {
            if (users[i] != null) {
                userList.add(users[i]);
            }
        }
        // Add admin users
        AdminUser[] admins = adminDAO.getAdmins();
        for (int i = 0; i < adminDAO.getAdminCount(); i++) {
            if (admins[i] != null) {
                userList.add(admins[i]);
            }
        }
        System.out.println("AdminUserManagementServlet: getAllUsers() retrieved " + userList.size() + " users");
        return userList;
    }

    private List<User> searchUsers(List<User> users, String query) {
        List<User> filtered = new ArrayList<>();
        String lowerQuery = query.toLowerCase();
        for (User user : users) {
            if (user.getUsername().toLowerCase().contains(lowerQuery) ||
                    user.getEmail().toLowerCase().contains(lowerQuery)) {
                filtered.add(user);
            }
        }
        return filtered;
    }

    private boolean deleteUser(String username) {
        // Check regular users
        if (userDAO.usernameExists(username)) {
            boolean success = userDAO.deleteUser(username);
            if (success) {
                System.out.println("AdminUserManagementServlet: Successfully deleted regular user " + username);
                return true;
            } else {
                System.out.println("AdminUserManagementServlet: Failed to delete regular user " + username);
                return false;
            }
        }

        // Check admin users
        if (adminDAO.usernameExists(username)) {
            boolean success = adminDAO.deleteAdmin(username); // Assumes deleteAdmin method exists in AdminDAO
            if (success) {
                System.out.println("AdminUserManagementServlet: Successfully deleted admin user " + username);
                return true;
            } else {
                System.out.println("AdminUserManagementServlet: Failed to delete admin user " + username);
                return false;
            }
        }

        System.out.println("AdminUserManagementServlet: User " + username + " not found for deletion.");
        return false;
    }
}