package model;

public class HandicappedSlot extends ParkingSlot {
    public HandicappedSlot(int slotId, String vehicleType, boolean isAvailable) {
        super(slotId, vehicleType, isAvailable);
    }

    @Override
    public String getSlotType() {
        return "Handicapped";
    }

    @Override
    public boolean checkAvailability(String context) {
        return isAvailable() && (context != null && context.contains("permit"));
    }
}