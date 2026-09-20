package model;

public abstract class User {
    private String username; // Encapsulation Private things
    private String email;
    private String nic;
    private String password;
    private String role;

    public User(String username, String email, String nic, String password, String role) {
        this.username = username;
        this.email = email;
        this.nic = nic;
        this.password = password;
        this.role = role;
    }
    //below is polymorphism in abstract
    public abstract String getDashboardPage();
    public abstract boolean login(String username, String password);

    // Getters and setters (encapsulation)
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNic() {
        return nic;
    }

    public void setNic(String nic) {
        this.nic = nic;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // CSV methods for file storage
    public String toCSV() {
        return username + "," + email + "," + nic + "," + password + "," + role;
    }

    public static User fromCSV(String csv) {
        String[] parts = csv.split(",");
        // *** New branch: AdminUser with isActive flag ***
        if (parts.length == 6 && "admin".equalsIgnoreCase(parts[4])) {
            AdminUser admin = new AdminUser(
                    parts[0],  // username
                    parts[1],  // email
                    parts[2],  // nic
                    parts[3]   // password
            );
            // Restore the saved isActive flag
            admin.setActive(Boolean.parseBoolean(parts[5]));
            return admin;
        }
        // *** Original logic for 5-field lines ***
        if (parts.length == 5) {
            String username = parts[0];
            String email    = parts[1];
            String nic      = parts[2];
            String password = parts[3];
            String role     = parts[4];
            if ("admin".equalsIgnoreCase(role)) {
                // Fallback: old admin entries (no isActive flag) default to active
                AdminUser admin = new AdminUser(username, email, nic, password);
                admin.setActive(true);
                return admin;
            } else {
                return new RegularUser(username, email, nic, password);
            }
        }
        return null;
    }

}