package model;

public class AdminUser extends User {
    private boolean isActive;
    private String adminCode; // New field for admin code

    // Updated Constructor
    public AdminUser(String username, String email, String nic, String password) {
        super(username, email, nic, password, "admin");
        this.isActive = true;
        this.adminCode = "SECRET123"; // Default admin code
    }

    // Polymorphism: Return admin-specific dashboard page
    @Override
    public String getDashboardPage() {
        return "adminDashboard.jsp";
    }

    // Polymorphism: Admin login rules
    @Override
    public boolean login(String username, String password) {
        return username != null && password != null &&
                username.equals(getUsername()) &&
                password.equals(getPassword()) &&
                isActive;
    }

    // New method to validate admin code
    public boolean validateAdminCode(String code) {
        return code != null && adminCode.equals(code);
    }

    // Admin privilege to modify a regular user's details
    public void modifyUserDetails(User targetUser, String newEmail, String newPassword) {
        if (newEmail != null && !newEmail.isEmpty()) {
            targetUser.setEmail(newEmail);
        }
        if (newPassword != null && !newPassword.isEmpty()) {
            targetUser.setPassword(newPassword);
        }
    }

    // Getter and Setter for isActive
    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }

    // Getter and Setter for adminCode
    public String getAdminCode() {
        return adminCode;
    }

    public void setAdminCode(String adminCode) {
        this.adminCode = adminCode;
    }

    // Updated CSV representation
    @Override
    public String toCSV() {
        return super.toCSV() + "," + isActive + "," + adminCode;
    }

    // Updated fromCSV to handle adminCode
    public static User fromCSV(String csv) {
        String[] parts = csv.split(",");
        if (parts.length == 7 && "admin".equalsIgnoreCase(parts[4])) {
            AdminUser admin = new AdminUser(parts[0], parts[1], parts[2], parts[3]);
            admin.setActive(Boolean.parseBoolean(parts[5]));
            admin.setAdminCode(parts[6]);
            return admin;
        }
        // Fallback for older formats
        if (parts.length == 6 && "admin".equalsIgnoreCase(parts[4])) {
            AdminUser admin = new AdminUser(parts[0], parts[1], parts[2], parts[3]);
            admin.setActive(Boolean.parseBoolean(parts[5]));
            return admin;
        }
        if (parts.length == 5 && "admin".equalsIgnoreCase(parts[4])) {
            AdminUser admin = new AdminUser(parts[0], parts[1], parts[2], parts[3]);
            admin.setActive(true);
            return admin;
        }
        return null;
    }
}