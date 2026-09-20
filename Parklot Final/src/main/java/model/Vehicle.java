package model;

public class Vehicle {
    private String vehicleType;
    private String licensePlate; // Removed final
    private String owner;

    // Constructor with validation
    public Vehicle(String vehicleType, String licensePlate, String owner) {
        if (vehicleType == null || vehicleType.trim().isEmpty()) {
            throw new IllegalArgumentException("Vehicle type cannot be null or empty");
        }
        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            throw new IllegalArgumentException("License plate cannot be null or empty");
        }
        if (owner == null || owner.trim().isEmpty()) {
            throw new IllegalArgumentException("Owner cannot be null or empty");
        }
        this.vehicleType = vehicleType.trim();
        this.licensePlate = licensePlate.trim();
        this.owner = owner.trim();
    }

    // Getters
    public String getVehicleType() {
        return vehicleType;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public String getOwner() {
        return owner;
    }

    // Setters with validation
    public void setVehicleType(String vehicleType) {
        if (vehicleType == null || vehicleType.trim().isEmpty()) {
            throw new IllegalArgumentException("Vehicle type cannot be null or empty");
        }
        this.vehicleType = vehicleType.trim();
    }

    public void setLicensePlate(String licensePlate) {
        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            throw new IllegalArgumentException("License plate cannot be null or empty");
        }
        this.licensePlate = licensePlate.trim();
    }

    public void setOwner(String owner) {
        if (owner == null || owner.trim().isEmpty()) {
            throw new IllegalArgumentException("Owner cannot be null or empty");
        }
        this.owner = owner.trim();
    }

    // Override toString to maintain compatibility with file format
    @Override
    public String toString() {
        return vehicleType + "," + licensePlate + "," + owner;
    }

    // Override equals and hashCode for proper comparison
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        Vehicle other = (Vehicle) obj;
        return this.licensePlate.equals(other.licensePlate);
    }

    @Override
    public int hashCode() {
        int result = 17;
        result = 31 * result + licensePlate.hashCode();
        return result;
    }
}