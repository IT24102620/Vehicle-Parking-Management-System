package dao;

import model.User;

import java.io.*;

public class UserDAO {
    private static UserDAO instance;
    private LinkedList userList; // Use custom LinkedList
    private static final String DATA_DIR = "data";
    private static final String FILE_NAME = "users.txt";
    private String filePath;

    public UserDAO() {
        userList = new LinkedList();
        File baseDir = new File("C:/Users/ASUS/Desktop/Vehicle-Parking-Management-System/Parklot Final/");
        File dataDir = new File(baseDir, DATA_DIR);
        File userFile = new File(dataDir, FILE_NAME);
        filePath = userFile.getAbsolutePath();
        System.out.println("UserDAO: Loading users from " + filePath);
        loadUsersFromFile();
        System.out.println("UserDAO: Loaded " + userList.size() + " users");
    }

    // Singleton instance getter
    public static synchronized UserDAO getInstance() {
        if (instance == null) {
            instance = new UserDAO();
        }
        return instance;
    }

    private boolean ensureFileExists() {
        try {
            File dataDir = new File("C:/Users/ASUS/Desktop/Vehicle-Parking-Management-System/Parklot Final/", DATA_DIR);
            if (!dataDir.exists()) {
                if (!dataDir.mkdirs()) {
                    System.out.println("Error: Could not create data directory: " + dataDir.getAbsolutePath());
                    return false;
                }
            }
            File userFile = new File(dataDir, FILE_NAME);
            if (!userFile.exists()) {
                if (!userFile.createNewFile()) {
                    System.out.println("Error: Could not create file: " + userFile.getAbsolutePath());
                    return false;
                }
            }
            if (!userFile.canWrite()) {
                System.out.println("Error: No write permission for file: " + userFile.getAbsolutePath());
                return false;
            }
            return true;
        } catch (Exception e) {
            System.out.println("Error setting up file: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private void loadUsersFromFile() {
        if (!ensureFileExists()) {
            System.out.println("UserDAO: Failed to ensure file exists");
            return;
        }
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(filePath), "UTF-8"))) {
            String line;
            System.out.println("UserDAO: Starting to read users from file: " + filePath);
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    User user = User.fromCSV(line);
                    if (user != null) {
                        System.out.println("UserDAO: Successfully parsed user: " + user.getUsername());
                        userList.insert(user); // Use LinkedList insert
                    } else {
                        System.out.println("UserDAO: Skipping invalid user entry: " + line);
                    }
                }
            }
            System.out.println("UserDAO: Finished reading. Loaded " + userList.size() + " users");
        } catch (Exception e) {
            System.out.println("UserDAO: Error reading users.txt: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean saveUsersToFile() {
        if (!ensureFileExists()) {
            return false;
        }
        try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath), "UTF-8"))) {
            User[] users = userList.getUsers();
            for (User user : users) {
                if (user != null) {
                    writer.write(user.toCSV());
                    writer.newLine();
                }
            }
            System.out.println("UserDAO: Successfully saved " + userList.size() + " users to file");
            return true;
        } catch (Exception e) {
            System.out.println("UserDAO: Error writing to users.txt: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean usernameExists(String username) {
        return userList.usernameExists(username);
    }

    public boolean emailExists(String email) {
        return userList.emailExists(email);
    }

    public boolean nicExists(String nic) {
        return userList.nicExists(nic);
    }

    public synchronized boolean deleteUser(String username) {
        if (username == null) {
            return false;
        }
        boolean deleted = userList.delete(username);
        if (deleted) {
            System.out.println("UserDAO: Deleted user " + username + ". Total users: " + userList.size());
            boolean saved = saveUsersToFile();
            if (!saved) {
                System.out.println("UserDAO: Failed to save users to file after deletion.");
            }
            return saved;
        }
        System.out.println("UserDAO: User " + username + " not found for deletion.");
        return false;
    }

    public synchronized boolean addUser(User user) {
        if (user == null) {
            System.out.println("UserDAO: Cannot add null user.");
            return false;
        }
        int initialSize = userList.size();
        userList.insert(user);
        System.out.println("UserDAO: Added user " + user.getUsername() + " to linked list. Total users: " + userList.size());
        boolean saved = saveUsersToFile();
        if (!saved) {
            System.out.println("UserDAO: Failed to save users to file. Reverting in-memory change.");
            userList.delete(user.getUsername()); // Revert by deleting the added user
        }
        return saved;
    }

    public boolean updateUser(User updatedUser) {
        if (updatedUser == null) {
            return false;
        }
        boolean updated = userList.updateUser(updatedUser);
        if (updated) {
            return saveUsersToFile();
        }
        return false;
    }

    public synchronized User authenticate(String username, String password) {
        if (username == null || password == null) {
            return null;
        }
        User user = userList.authenticate(username, password);
        if (user != null) {
            System.out.println("UserDAO: Authenticated user: " + username);
        } else {
            System.out.println("UserDAO: Authentication failed for user: " + username);
        }
        return user;
    }

    public User[] getUsers() {
        return userList.getUsers();
    }

    public int getUserCount() {
        return userList.size();
    }

    public void decrementUserCount() {
        // No longer needed since size is managed by LinkedList
        System.out.println("UserDAO: decrementUserCount is deprecated. Use LinkedList.size() instead.");
    }

    // For debugging
    public void displayUsers() {
        userList.displayList();
    }
}