package model;
//regulerSlot
public class RegularSlot extends ParkingSlot {
    public RegularSlot(int slotId, String vehicleType, boolean isAvailable) {
        super(slotId, vehicleType, isAvailable);
    }

    @Override
    public String getSlotType() {
        return "Regular";
    }

    @Override
    public boolean checkAvailability(String context) {
        return isAvailable();
    }
}