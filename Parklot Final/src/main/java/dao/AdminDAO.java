package dao;

import model.AdminUser;
import model.User;

import java.io.*;

public class AdminDAO {
    private static AdminDAO instance;
    private AdminUser[] admins;
    private int adminCount = 0;
    private static final String DATA_DIR = "data";
    private static final String FILE_NAME = "admin.txt";
    private String filePath;
    private static final int MAX_ADMINS = 10;

    // Private constructor for singleton
    public AdminDAO() {
        admins = new AdminUser[MAX_ADMINS];
        adminCount = 0;
        File baseDir = new File("C:/Users/ASUS/Desktop/Vehicle-Parking-Management-System/Parklot Final/");
        File dataDir = new File(baseDir, DATA_DIR);
        File adminFile = new File(dataDir, FILE_NAME);
        filePath = adminFile.getAbsolutePath();
        System.out.println("AdminDAO: Loading admins from " + filePath);
        loadAdminsFromFile();
        initializeDefaultAdmin();
        System.out.println("AdminDAO: Loaded " + adminCount + " admins");
    }

    // Singleton instance getter
    public static synchronized AdminDAO getInstance() {
        if (instance == null) {
            instance = new AdminDAO();
        }
        return instance;
    }

    private void initializeDefaultAdmin() {
        if (adminCount == 0 && ensureFileExists()) {
            System.out.println("AdminDAO: Initializing default admin user");
            AdminUser admin = new AdminUser("admin", "admin@example.com", "123456789V", "admin123");
            addAdmin(admin);
        }
    }
    public synchronized boolean deleteAdmin(String username) {
        if (username == null) {
            return false;
        }

        int adminIndex = -1;
        for (int i = 0; i < adminCount; i++) {
            if (admins[i] != null && admins[i].getUsername().equalsIgnoreCase(username.trim())) {
                adminIndex = i;
                break;
            }
        }

        if (adminIndex != -1) {
            // Shift admins to fill the gap
            for (int i = adminIndex; i < adminCount - 1; i++) {
                admins[i] = admins[i + 1];
            }
            admins[adminCount - 1] = null;
            adminCount--;
            System.out.println("AdminDAO: Deleted admin " + username + ". Total admins: " + adminCount);
            boolean saved = saveAdminsToFile();
            if (!saved) {
                System.out.println("AdminDAO: Failed to save admins to file after deletion.");
                // Optionally, revert the deletion if saving fails (not implemented here for simplicity)
            }
            return saved;
        }

        System.out.println("AdminDAO: Admin " + username + " not found for deletion.");
        return false;
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

    private void loadAdminsFromFile() {
        if (!ensureFileExists()) {
            System.out.println("AdminDAO: Failed to ensure file exists");
            return;
        }
        adminCount = 0;
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            System.out.println("AdminDAO: Starting to read admins from file: " + filePath);
            while ((line = reader.readLine()) != null && adminCount < MAX_ADMINS) {
                if (!line.trim().isEmpty()) {
                    User user = User.fromCSV(line);
                    if (user instanceof AdminUser) {
                        System.out.println("AdminDAO: Successfully parsed admin: " + user.getUsername());
                        admins[adminCount] = (AdminUser) user;
                        adminCount++;
                    } else {
                        System.out.println("AdminDAO: Skipping non-admin user: " + line);
                    }
                }
            }
            System.out.println("AdminDAO: Finished reading. Loaded " + adminCount + " admins");
        } catch (Exception e) {
            System.out.println("AdminDAO: Error reading admin.txt: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean saveAdminsToFile() {
        if (!ensureFileExists()) {
            return false;
        }
        try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath), "UTF-8"))) {
            for (int i = 0; i < adminCount; i++) {
                if (admins[i] != null) {
                    writer.write(admins[i].toCSV());
                    writer.newLine();
                }
            }
            System.out.println("AdminDAO: Successfully saved " + adminCount + " admins to file");
            return true;
        } catch (Exception e) {
            System.out.println("AdminDAO: Error writing to admin.txt: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean usernameExists(String username) {
        if (username == null) {
            return false;
        }
        for (int i = 0; i < adminCount; i++) {
            if (admins[i] != null && admins[i].getUsername().equalsIgnoreCase(username)) {
                return true;
            }
        }
        return false;
    }

    public boolean emailExists(String email) {
        if (email == null) {
            return false;
        }
        for (int i = 0; i < adminCount; i++) {
            if (admins[i] != null && admins[i].getEmail().equalsIgnoreCase(email)) {
                return true;
            }
        }
        return false;
    }

    public boolean nicExists(String nic) {
        if (nic == null) {
            return false;
        }
        for (int i = 0; i < adminCount; i++) {
            if (admins[i] != null && admins[i].getNic().equalsIgnoreCase(nic)) {
                return true;
            }
        }
        return false;
    }

    public synchronized boolean addAdmin(AdminUser admin) {
        if (admin == null || adminCount >= MAX_ADMINS) {
            System.out.println("AdminDAO: Cannot add admin, maximum limit of " + MAX_ADMINS + " reached or admin is null.");
            return false;
        }
        admins[adminCount] = admin;
        adminCount++;
        System.out.println("AdminDAO: Added admin " + admin.getUsername() + " to in-memory array. Total admins: " + adminCount);
        boolean saved = saveAdminsToFile();
        if (!saved) {
            System.out.println("AdminDAO: Failed to save admins to file. Reverting in-memory change.");
            admins[adminCount - 1] = null;
            adminCount--;
        }
        return saved;
    }

    public boolean updateAdmin(AdminUser updatedAdmin) {
        if (updatedAdmin == null) {
            return false;
        }
        for (int i = 0; i < adminCount; i++) {
            if (admins[i] != null &&
                    admins[i].getUsername().equalsIgnoreCase(updatedAdmin.getUsername())) {
                admins[i] = updatedAdmin;
                return saveAdminsToFile();
            }
        }
        return false;
    }

    public synchronized AdminUser authenticate(String username, String password, String adminCode) {
        if (username == null || password == null || adminCode == null) {
            return null;
        }
        for (int i = 0; i < adminCount; i++) {
            if (admins[i] != null && admins[i].login(username, password) && admins[i].validateAdminCode(adminCode)) {
                System.out.println("AdminDAO: Authenticated admin: " + username);
                return admins[i];
            }
        }
        System.out.println("AdminDAO: Authentication failed for admin: " + username);
        return null;
    }

    public AdminUser[] getAdmins() {
        return admins;
    }

    public int getAdminCount() {
        return adminCount;
    }

    public void decrementAdminCount() {
        adminCount--;
    }
}