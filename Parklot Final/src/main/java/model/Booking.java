package model;

public class Booking {
    private int bookingId;
    private String username;
    private int slotId;
    private String vehicleType;
    private String vehicleNumber;
    private String nicNumber;
    private String parkingDate;
    private String parkingTime;
    private int duration;
    private boolean hasHandicappedPermit;

    public Booking(int bookingId, String username, int slotId, String vehicleType, String vehicleNumber,
                   String nicNumber, String parkingDate, String parkingTime, int duration, boolean hasHandicappedPermit) {
        this.bookingId = bookingId;
        this.username = username;
        this.slotId = slotId;
        this.vehicleType = vehicleType;
        this.vehicleNumber = vehicleNumber;
        this.nicNumber = nicNumber;
        this.parkingDate = parkingDate;
        this.parkingTime = parkingTime;
        this.duration = duration;
        this.hasHandicappedPermit = hasHandicappedPermit;
    }

    // Getters and Setters
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getVehicleNumber() {
        return vehicleNumber;
    }

    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }

    public String getNicNumber() {
        return nicNumber;
    }

    public void setNicNumber(String nicNumber) {
        this.nicNumber = nicNumber;
    }

    public String getParkingDate() {
        return parkingDate;
    }

    public void setParkingDate(String parkingDate) {
        this.parkingDate = parkingDate;
    }

    public String getParkingTime() {
        return parkingTime;
    }

    public void setParkingTime(String parkingTime) {
        this.parkingTime = parkingTime;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public boolean isHasHandicappedPermit() {
        return hasHandicappedPermit;
    }

    public void setHasHandicappedPermit(boolean hasHandicappedPermit) {
        this.hasHandicappedPermit = hasHandicappedPermit;
    }

    @Override
    public String toString() {
        return bookingId + "," + username + "," + slotId + "," + vehicleType + "," + vehicleNumber + "," +
                nicNumber + "," + parkingDate + "," + parkingTime + "," + duration + "," + hasHandicappedPermit;
    }
}