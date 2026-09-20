package dao;

import model.Booking;
import model.ParkingSlot;
import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

public class BookingDAO {
    private static final String FILE_PATH = "C:/Users/ASUS/Desktop/Vehicle-Parking-Management-System/Parklot Final/data/bookings.txt";
    private static final String HISTORY_FILE_PATH = "C:/Users/ASUS/Desktop/Vehicle-Parking-Management-System/Parklot Final/data/booking_history.txt";
    public CustomStack<Booking> bookingStack;
    private SlotDAO slotDAO;

    public BookingDAO() {
        bookingStack = new CustomStack<>(1000);
        slotDAO = new SlotDAO();
        loadBookingsToStack();
    }

    private void loadBookingsToStack() {
        bookingStack.clear();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 10) {
                    int bookingId = Integer.parseInt(parts[0]);
                    String username = parts[1];
                    int slotId = Integer.parseInt(parts[2]);
                    String vehicleType = parts[3];
                    String vehicleNumber = parts[4];
                    String nicNumber = parts[5];
                    String parkingDate = parts[6];
                    String parkingTime = parts[7];
                    int duration = Integer.parseInt(parts[8]);
                    boolean hasHandicappedPermit = Boolean.parseBoolean(parts[9]);
                    Booking booking = new Booking(bookingId, username, slotId, vehicleType, vehicleNumber,
                            nicNumber, parkingDate, parkingTime, duration, hasHandicappedPermit);
                    if (!isBookingExpired(booking)) {
                        bookingStack.push(booking);
                    } else {
                        saveToHistory(booking);
                        slotDAO.updateSlot(slotId, vehicleType, true);
                        System.out.println("BookingDAO: Expired booking moved to history, slot freed: slotId=" + slotId + ", vehicleType=" + vehicleType);
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("BookingDAO: Error loading bookings: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("BookingDAO: Loaded bookings into stack: " + bookingStack.size());
    }

    private void saveToHistory(Booking booking) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(HISTORY_FILE_PATH, true))) {
            writer.write(booking.toString());
            writer.newLine();
        } catch (IOException e) {
            System.out.println("BookingDAO: Error saving to history: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private boolean isBookingExpired(Booking booking) {
        try {
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            LocalDateTime bookingDateTime = LocalDateTime.parse(
                    booking.getParkingDate() + "T" + booking.getParkingTime(),
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")
            );
            LocalDateTime endDateTime = bookingDateTime.plusHours(booking.getDuration());
            return LocalDateTime.now().isAfter(endDateTime);
        } catch (Exception e) {
            System.out.println("BookingDAO: Error parsing booking time: " + e.getMessage());
            return false;
        }
    }

    public Booking[] getUserBookings(String username) {
        Booking[] allBookings = getAllBookings();
        CustomStack<Booking> tempStack = new CustomStack<>(allBookings.length);
        for (Booking booking : allBookings) {
            if (booking != null && booking.getUsername().equals(username)) {
                tempStack.push(booking);
            }
        }
        Booking[] userBookings = new Booking[tempStack.size()];
        int index = 0;
        while (!tempStack.isEmpty()) {
            userBookings[index++] = tempStack.pop();
        }
        System.out.println("BookingDAO: Returning bookings for " + username + ": " + Arrays.toString(userBookings));
        return userBookings;
    }

    public Booking[] getAllBookings() {
        cleanupExpiredBookings();
        Booking[] bookings = new Booking[bookingStack.size()];
        CustomStack<Booking> tempStack = new CustomStack<>(bookings.length);
        int index = 0;
        while (!bookingStack.isEmpty()) {
            Booking booking = bookingStack.pop();
            bookings[index++] = booking;
            tempStack.push(booking);
        }
        while (!tempStack.isEmpty()) {
            bookingStack.push(tempStack.pop());
        }
        return bookings;
    }

    public Booking[] getUserBookingHistory(String username) {
        CustomStack<Booking> historyStack = new CustomStack<>(1000);
        try (BufferedReader reader = new BufferedReader(new FileReader(HISTORY_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 10 && parts[1].equals(username)) {
                    int bookingId = Integer.parseInt(parts[0]);
                    String vehicleType = parts[3];
                    String vehicleNumber = parts[4];
                    String nicNumber = parts[5];
                    String parkingDate = parts[6];
                    String parkingTime = parts[7];
                    int duration = Integer.parseInt(parts[8]);
                    boolean hasHandicappedPermit = Boolean.parseBoolean(parts[9]);
                    Booking booking = new Booking(bookingId, username, Integer.parseInt(parts[2]), vehicleType, vehicleNumber,
                            nicNumber, parkingDate, parkingTime, duration, hasHandicappedPermit);
                    historyStack.push(booking);
                }
            }
        } catch (IOException e) {
            System.out.println("BookingDAO: Error loading booking history: " + e.getMessage());
            e.printStackTrace();
        }
        Booking[] history = new Booking[historyStack.size()];
        int index = 0;
        while (!historyStack.isEmpty()) {
            history[index++] = historyStack.pop();
        }
        return history;
    }

    public Booking[] getAllBookingHistory() {
        CustomStack<Booking> historyStack = new CustomStack<>(1000);
        try (BufferedReader reader = new BufferedReader(new FileReader(HISTORY_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 10) {
                    int bookingId = Integer.parseInt(parts[0]);
                    String username = parts[1];
                    int slotId = Integer.parseInt(parts[2]);
                    String vehicleType = parts[3];
                    String vehicleNumber = parts[4];
                    String nicNumber = parts[5];
                    String parkingDate = parts[6];
                    String parkingTime = parts[7];
                    int duration = Integer.parseInt(parts[8]);
                    boolean hasHandicappedPermit = Boolean.parseBoolean(parts[9]);
                    Booking booking = new Booking(bookingId, username, slotId, vehicleType, vehicleNumber,
                            nicNumber, parkingDate, parkingTime, duration, hasHandicappedPermit);
                    historyStack.push(booking);
                }
            }
        } catch (IOException e) {
            System.out.println("BookingDAO: Error loading booking history: " + e.getMessage());
            e.printStackTrace();
        }
        Booking[] history = new Booking[historyStack.size()];
        int index = 0;
        while (!historyStack.isEmpty()) {
            history[index++] = historyStack.pop();
        }
        return history;
    }

    private void cleanupExpiredBookings() {
        CustomStack<Booking> tempStack = new CustomStack<>(bookingStack.size());
        while (!bookingStack.isEmpty()) {
            Booking booking = bookingStack.pop();
            if (!isBookingExpired(booking)) {
                tempStack.push(booking);
            } else {
                saveToHistory(booking);
                slotDAO.updateSlot(booking.getSlotId(), booking.getVehicleType(), true);
                System.out.println("BookingDAO: Moved expired booking to history, slot freed: slotId=" + booking.getSlotId() + ", vehicleType=" + booking.getVehicleType());
            }
        }
        while (!tempStack.isEmpty()) {
            bookingStack.push(tempStack.pop());
        }
        saveBookings();
    }

    public void addBooking(Booking booking) {
        bookingStack.push(booking);
        saveBookings();
    }

    public void deleteBooking(int bookingId, String username) {
        CustomStack<Booking> tempStack = new CustomStack<>(bookingStack.size());
        boolean removed = false;
        while (!bookingStack.isEmpty()) {
            Booking booking = bookingStack.pop();
            if (booking.getBookingId() == bookingId && booking.getUsername().equals(username)) {
                saveToHistory(booking); // Save to history before deletion
                slotDAO.updateSlot(booking.getSlotId(), booking.getVehicleType(), true);
                removed = true;
            } else {
                tempStack.push(booking);
            }
        }
        while (!tempStack.isEmpty()) {
            bookingStack.push(tempStack.pop());
        }
        if (!removed) {
            throw new IllegalArgumentException("Booking with ID " + bookingId + " for user " + username + " not found");
        }
        saveBookings();
    }

    public boolean updateBookingDuration(int bookingId, String username, int duration) {
        CustomStack<Booking> tempStack = new CustomStack<>(bookingStack.size());
        boolean updated = false;
        while (!bookingStack.isEmpty()) {
            Booking booking = bookingStack.pop();
            if (booking.getBookingId() == bookingId && booking.getUsername().equals(username)) {
                booking.setDuration(duration);
                updated = true;
            }
            tempStack.push(booking);
        }
        while (!tempStack.isEmpty()) {
            bookingStack.push(tempStack.pop());
        }
        if (updated) {
            saveBookings();
        }
        return updated;
    }

    public void saveBookings() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            CustomStack<Booking> tempStack = new CustomStack<>(bookingStack.size());
            while (!bookingStack.isEmpty()) {
                Booking booking = bookingStack.pop();
                writer.write(booking.toString());
                writer.newLine();
                tempStack.push(booking);
            }
            while (!tempStack.isEmpty()) {
                bookingStack.push(tempStack.pop());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public int getNextBookingId() {
        int maxId = 0;
        CustomStack<Booking> tempStack = new CustomStack<>(bookingStack.size());
        while (!bookingStack.isEmpty()) {
            Booking booking = bookingStack.pop();
            if (booking.getBookingId() > maxId) {
                maxId = booking.getBookingId();
            }
            tempStack.push(booking);
        }
        while (!tempStack.isEmpty()) {
            bookingStack.push(tempStack.pop());
        }
        return maxId + 1;
    }
}