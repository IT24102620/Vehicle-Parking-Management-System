package model;

import com.google.gson.annotations.SerializedName;

public abstract class ParkingSlot {
    @SerializedName("slotId")
    private int slotId;

    @SerializedName("vehicleType")
    private String vehicleType;

    @SerializedName("isAvailable")
    private boolean isAvailable;

    public ParkingSlot(int slotId, String vehicleType, boolean isAvailable) {
        this.slotId = slotId;
        this.vehicleType = vehicleType;
        this.isAvailable = isAvailable;
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

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

    public abstract String getSlotType();

    public abstract boolean checkAvailability(String context);

    @Override
    public String toString() {
        return slotId + "," + vehicleType + "," + getSlotType() + "," + isAvailable;
    }
}