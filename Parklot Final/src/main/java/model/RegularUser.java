package model;

public class RegularUser extends User {
    public RegularUser(String username, String email, String nic, String password) {
        super(username, email, nic, password, "user"); // Inheritance
    }

    @Override
    public String getDashboardPage() {
        return "dashboard.jsp"; // Polymorphism
    }

    @Override
    public boolean login(String username, String password) {
        // Polymorphism: case-insensitive username
        return username != null && password != null &&
                username.equalsIgnoreCase(getUsername()) && password.equals(getPassword());
    }
}