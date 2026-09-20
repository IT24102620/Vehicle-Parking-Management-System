package dao;

import model.ParkingSlot;
import model.RegularSlot;
import model.HandicappedSlot;
import java.io.*;

public class SlotDAO {
    private static final String FILE_PATH = "C:/Users/ASUS/Desktop/Vehicle-Parking-Management-System/Parklot Final/data/slots.txt";
    private static final int MAX_SLOTS = 1000; // Fixed capacity for array

    public ParkingSlot[] getAvailableSlots() {
        ParkingSlot[] allSlots = getAllSlots();
        CustomStack<ParkingSlot> stack = new CustomStack<>(MAX_SLOTS);
        for (ParkingSlot slot : allSlots) {
            if (slot != null && slot.isAvailable()) {
                stack.push(slot);
            }
        }
        ParkingSlot[] availableSlots = new ParkingSlot[stack.size()];
        for (int i = availableSlots.length - 1; i >= 0; i--) {
            availableSlots[i] = stack.pop();
        }
        System.out.println("Fetched available slots: " + availableSlots.length);
        return availableSlots;
    }

    public ParkingSlot[] getAllSlots() {
        ParkingSlot[] slots = new ParkingSlot[MAX_SLOTS];
        int count = 0;
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null && count < MAX_SLOTS) {
                String[] parts = line.split(",");
                if (parts.length == 4) {
                    int slotId = Integer.parseInt(parts[0]);
                    String vehicleType = parts[1];
                    String slotType = parts[2];
                    boolean isAvailable = Boolean.parseBoolean(parts[3]);
                    ParkingSlot slot = slotType.equalsIgnoreCase("Handicapped") ?
                            new HandicappedSlot(slotId, vehicleType, isAvailable) :
                            new RegularSlot(slotId, vehicleType, isAvailable);
                    slots[count++] = slot;
                    System.out.println("Loaded slot: " + slot);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        // Trim array to actual size
        ParkingSlot[] trimmedSlots = new ParkingSlot[count];
        for (int i = 0; i < count; i++) {
            trimmedSlots[i] = slots[i];
        }
        // Sort by vehicle type and availability
        trimmedSlots = groupAndSortSlots(trimmedSlots);
        System.out.println("Fetched all slots: " + count);
        return trimmedSlots;
    }

    private ParkingSlot[] groupAndSortSlots(ParkingSlot[] slots) {
        // Group by vehicle type
        ParkingSlot[] cars = new ParkingSlot[MAX_SLOTS];
        ParkingSlot[] vans = new ParkingSlot[MAX_SLOTS];
        ParkingSlot[] motorbikes = new ParkingSlot[MAX_SLOTS];
        ParkingSlot[] trucks = new ParkingSlot[MAX_SLOTS];
        int carCount = 0, vanCount = 0, motorbikeCount = 0, truckCount = 0;

        for (ParkingSlot slot : slots) {
            if (slot == null) continue;
            String type = slot.getVehicleType().toLowerCase();
            if (type.equals("car") && carCount < MAX_SLOTS) {
                cars[carCount++] = slot;
            } else if (type.equals("van") && vanCount < MAX_SLOTS) {
                vans[vanCount++] = slot;
            } else if (type.equals("motorbike") && motorbikeCount < MAX_SLOTS) {
                motorbikes[motorbikeCount++] = slot;
            } else if (type.equals("truck") && truckCount < MAX_SLOTS) {
                trucks[truckCount++] = slot;
            }
        }

        // Sort each group by availability
        quickSort(cars, 0, carCount - 1);
        quickSort(vans, 0, vanCount - 1);
        quickSort(motorbikes, 0, motorbikeCount - 1);
        quickSort(trucks, 0, truckCount - 1);

        // Combine sorted arrays
        ParkingSlot[] sortedSlots = new ParkingSlot[carCount + vanCount + motorbikeCount + truckCount];
        int index = 0;
        for (int i = 0; i < carCount; i++) {
            sortedSlots[index++] = cars[i];
        }
        for (int i = 0; i < vanCount; i++) {
            sortedSlots[index++] = vans[i];
        }
        for (int i = 0; i < motorbikeCount; i++) {
            sortedSlots[index++] = motorbikes[i];
        }
        for (int i = 0; i < truckCount; i++) {
            sortedSlots[index++] = trucks[i];
        }
        return sortedSlots;
    }

    public void addSlot(ParkingSlot slot) {
        ParkingSlot[] allSlots = getAllSlots();
        int count = 0;
        while (count < allSlots.length && allSlots[count] != null) {
            count++;
        }
        if (count >= MAX_SLOTS) {
            throw new IllegalStateException("Maximum slot capacity reached");
        }
        ParkingSlot[] newSlots = new ParkingSlot[count + 1];
        for (int i = 0; i < count; i++) {
            newSlots[i] = allSlots[i];
        }
        newSlots[count] = slot;
        saveSlots(newSlots);
        System.out.println("Added slot: " + slot);
    }

    public void updateSlot(int slotId, String vehicleType, boolean isAvailable) {
        ParkingSlot[] allSlots = getAllSlots();
        boolean updated = false;
        for (ParkingSlot slot : allSlots) {
            if (slot != null && slot.getSlotId() == slotId && slot.getVehicleType().equalsIgnoreCase(vehicleType)) {
                slot.setAvailable(isAvailable);
                updated = true;
                break;
            }
        }
        if (updated) {
            saveSlots(allSlots);
            System.out.println("Updated slot: slotId=" + slotId + ", vehicleType=" + vehicleType + ", isAvailable=" + isAvailable);
        } else {
            throw new IllegalArgumentException("Slot with ID " + slotId + " and vehicle type " + vehicleType + " not found");
        }
    }

    public void deleteSlot(int slotId, String vehicleType) {
        ParkingSlot[] allSlots = getAllSlots();
        int count = 0;
        for (ParkingSlot slot : allSlots) {
            if (slot != null) count++;
        }
        ParkingSlot[] newSlots = new ParkingSlot[count - 1];
        int index = 0;
        boolean removed = false;
        for (ParkingSlot slot : allSlots) {
            if (slot != null && !(slot.getSlotId() == slotId && slot.getVehicleType().equalsIgnoreCase(vehicleType))) {
                if (index < newSlots.length) {
                    newSlots[index++] = slot;
                }
            } else if (slot != null) {
                removed = true;
            }
        }
        if (!removed) {
            throw new IllegalArgumentException("Slot with ID " + slotId + " and vehicle type " + vehicleType + " not found");
        }
        saveSlots(newSlots);
        System.out.println("Deleted slot: slotId=" + slotId + ", vehicleType=" + vehicleType);
    }

    public void saveSlots(ParkingSlot[] slots) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (ParkingSlot slot : slots) {
                if (slot != null) {
                    System.out.println("Saving slot to file: " + slot);
                    writer.write(slot.toString());
                    writer.newLine();
                }
            }
            System.out.println("Slots saved to " + FILE_PATH);
        } catch (IOException e) {
            System.out.println("Error saving slots: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public int getNextSlotId(String vehicleType) {
        ParkingSlot[] slots = getAllSlots();
        int maxId = 0;
        for (ParkingSlot slot : slots) {
            if (slot != null && slot.getVehicleType().equalsIgnoreCase(vehicleType)) {
                maxId = Math.max(maxId, slot.getSlotId());
            }
        }
        return maxId + 1;
    }

    // QuickSort implementation to sort by availability (true first)
    private void quickSort(ParkingSlot[] slots, int low, int high) {
        if (low < high) {
            int pi = partition(slots, low, high);
            quickSort(slots, low, pi - 1);
            quickSort(slots, pi + 1, high);
        }
    }

    private int partition(ParkingSlot[] slots, int low, int high) {
        boolean pivot = slots[high] != null ? slots[high].isAvailable() : false;
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (slots[j] != null && slots[j].isAvailable() && !pivot) {
                i++;
                swap(slots, i, j);
            } else if (slots[j] != null && slots[j].isAvailable() == pivot) {
                i++;
                swap(slots, i, j);
            }
        }
        swap(slots, i + 1, high);
        return i + 1;
    }

    private void swap(ParkingSlot[] slots, int i, int j) {
        ParkingSlot temp = slots[i];
        slots[i] = slots[j];
        slots[j] = temp;
    }
}