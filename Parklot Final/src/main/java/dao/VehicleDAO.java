package dao;

import model.Vehicle;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class VehicleDAO {
    private static final String FILE_PATH = "C:/Users/ASUS/Desktop/Vehicle-Parking-Management-System/Parklot Final/data/vehicleregister.txt";

    // Ensure the file and its directory exist
    private File getFile() throws IOException {
        File file = new File(FILE_PATH);
        File parentDir = file.getParentFile();
        if (!parentDir.exists()) {
            parentDir.mkdirs();
        }
        return file;
    }

    public void saveVehicle(Vehicle vehicle) throws IOException {
        if (vehicle == null) {
            throw new IllegalArgumentException("Vehicle cannot be null");
        }

        // Check for duplicate license plate
        List<Vehicle> existingVehicles = getAllVehicles();
        for (Vehicle v : existingVehicles) {
            if (v.getLicensePlate().equals(vehicle.getLicensePlate())) {
                throw new IOException("Vehicle with license plate " + vehicle.getLicensePlate() + " already exists");
            }
        }

        // Synchronized to prevent concurrent file writes
        synchronized (this) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFile(), true))) {
                writer.write(vehicle.toString());
                writer.newLine();
            }
        }
    }

    public List<Vehicle> getAllVehicles() throws IOException {
        List<Vehicle> vehicles = new ArrayList<>();
        File file = getFile();
        if (!file.exists()) {
            return vehicles;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue; // Skip empty lines
                }
                String[] parts = line.split(",", -1); // Use -1 to handle empty fields
                if (parts.length == 3) {
                    try {
                        vehicles.add(new Vehicle(parts[0], parts[1], parts[2]));
                    } catch (IllegalArgumentException e) {
                        // Log invalid data but continue processing
                        System.err.println("Invalid vehicle data: " + line + ", Error: " + e.getMessage());
                    }
                }
            }
        }
        return vehicles;
    }

    public void updateVehicle(Vehicle vehicle) throws IOException {
        if (vehicle == null) {
            throw new IllegalArgumentException("Vehicle cannot be null");
        }

        List<Vehicle> vehicles = getAllVehicles();
        boolean found = false;
        List<Vehicle> updatedVehicles = new ArrayList<>();

        // Check for duplicate license plate (excluding the vehicle being updated)
        for (Vehicle v : vehicles) {
            if (v.getLicensePlate().equals(vehicle.getLicensePlate()) && !v.equals(vehicle)) {
                throw new IOException("Vehicle with license plate " + vehicle.getLicensePlate() + " already exists");
            }
            if (v.getLicensePlate().equals(vehicle.getLicensePlate())) {
                updatedVehicles.add(vehicle);
                found = true;
            } else {
                updatedVehicles.add(v);
            }
        }

        if (!found) {
            throw new IOException("Vehicle with license plate " + vehicle.getLicensePlate() + " not found");
        }

        // Synchronized to prevent concurrent file writes
        synchronized (this) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFile(), false))) {
                for (Vehicle v : updatedVehicles) {
                    writer.write(v.toString());
                    writer.newLine();
                }
            }
        }
    }

    public void deleteVehicle(String licensePlate) throws IOException {
        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            throw new IllegalArgumentException("License plate cannot be null or empty");
        }

        List<Vehicle> vehicles = getAllVehicles();
        List<Vehicle> remainingVehicles = vehicles.stream()
                .filter(v -> !v.getLicensePlate().equals(licensePlate))
                .collect(Collectors.toList());

        if (remainingVehicles.size() == vehicles.size()) {
            throw new IOException("Vehicle with license plate " + licensePlate + " not found");
        }

        // Synchronized to prevent concurrent file writes
        synchronized (this) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFile(), false))) {
                for (Vehicle v : remainingVehicles) {
                    writer.write(v.toString());
                    writer.newLine();
                }
            }
        }
    }

    public List<Vehicle> getVehiclesByOwner(String owner) throws IOException {
        if (owner == null || owner.trim().isEmpty()) {
            throw new IllegalArgumentException("Owner cannot be null or empty");
        }

        List<Vehicle> vehicles = new ArrayList<>();
        File file = getFile();
        if (!file.exists()) {
            return vehicles;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue; // Skip empty lines
                }
                String[] parts = line.split(",", -1); // Use -1 to handle empty fields
                if (parts.length == 3 && parts[2].equalsIgnoreCase(owner.trim())) {
                    try {
                        vehicles.add(new Vehicle(parts[0], parts[1], parts[2]));
                    } catch (IllegalArgumentException e) {
                        // Log invalid data but continue processing
                        System.err.println("Invalid vehicle data: " + line + ", Error: " + e.getMessage());
                    }
                }
            }
        }
        return vehicles;
    }
}