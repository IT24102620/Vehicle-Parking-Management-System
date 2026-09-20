package servlet;

import dao.BookingDAO;
import dao.SlotDAO;
import dao.VehicleDAO;
import model.Booking;
import model.ParkingSlot;
import model.User;
import model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import com.google.gson.Gson;

@WebServlet("/user/booking")
public class UserBookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    private SlotDAO slotDAO;
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        slotDAO = new SlotDAO();
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (session == null || user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        String username = user.getUsername();
        String nic = user.getNic();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Booking[] userBookings = bookingDAO.getUserBookings(username);
        List<Booking> bookingList = new ArrayList<>();
        for (Booking booking : userBookings) {
            if (booking != null) {
                bookingList.add(booking);
            }
        }

        List<Vehicle> vehicles = vehicleDAO.getVehiclesByOwner(username);

        // Create response object
        Map<String, Object> responseData = new java.util.HashMap<>();
        responseData.put("bookings", bookingList);
        responseData.put("vehicles", vehicles);
        responseData.put("nic", nic);

        String json = new Gson().toJson(responseData);
        response.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (session == null || user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        String username = user.getUsername();
        String userNic = user.getNic();

        String payload;
        try (BufferedReader reader = new BufferedReader(request.getReader())) {
            payload = reader.lines().collect(Collectors.joining());
        }

        try {
            Map<String, Object> jsonMap = new Gson().fromJson(payload, Map.class);
            if (!validateBookingJson(jsonMap)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid booking parameters");
                return;
            }

            int slotId = ((Number) jsonMap.get("slotId")).intValue();
            String vehicleType = (String) jsonMap.get("vehicleType");
            String vehicleNumber = (String) jsonMap.get("vehicleNumber");
            String nicNumber = (String) jsonMap.get("nicNumber");
            String parkingDate = (String) jsonMap.get("parkingDate");
            String parkingTime = (String) jsonMap.get("parkingTime");
            int duration = ((Number) jsonMap.get("duration")).intValue();
            boolean hasHandicappedPermit = jsonMap.containsKey("hasHandicappedPermit") && (Boolean) jsonMap.get("hasHandicappedPermit");

            if (!isValidVehicleType(vehicleType)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid vehicle type");
                return;
            }

            // Validate vehicle belongs to user
            List<Vehicle> userVehicles = vehicleDAO.getVehiclesByOwner(username);
            boolean validVehicle = false;
            for (Vehicle vehicle : userVehicles) {
                if (vehicle.getVehicleType().equalsIgnoreCase(vehicleType) &&
                        vehicle.getLicensePlate().equalsIgnoreCase(vehicleNumber)) {
                    validVehicle = true;
                    break;
                }
            }
            if (!validVehicle) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Selected vehicle not registered to user");
                return;
            }

            // Validate NIC matches user's NIC
            if (!nicNumber.equals(userNic)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "NIC does not match user account");
                return;
            }

            // Check for existing bookings for the slot
            Booking[] existingBookings = bookingDAO.getAllBookings();
            for (Booking b : existingBookings) {
                if (b != null && b.getSlotId() == slotId && b.getVehicleType().equalsIgnoreCase(vehicleType)) {
                    response.sendError(HttpServletResponse.SC_CONFLICT, "Slot is already booked");
                    return;
                }
            }

            // Check slot availability
            ParkingSlot[] slots = slotDAO.getAllSlots();
            ParkingSlot targetSlot = null;
            for (ParkingSlot slot : slots) {
                if (slot != null && slot.getSlotId() == slotId && slot.getVehicleType().equalsIgnoreCase(vehicleType)) {
                    targetSlot = slot;
                    break;
                }
            }

            if (targetSlot == null || !targetSlot.isAvailable() ||
                    !targetSlot.checkAvailability(hasHandicappedPermit ? "permit" : "")) {
                response.sendError(HttpServletResponse.SC_CONFLICT, "Slot is not available or permit required");
                return;
            }

            // Create and save booking
            int bookingId = bookingDAO.getNextBookingId();
            Booking booking = new Booking(bookingId, username, slotId, vehicleType, vehicleNumber, nicNumber,
                    parkingDate, parkingTime, duration, hasHandicappedPermit);
            bookingDAO.addBooking(booking);

            // Update slot availability
            slotDAO.updateSlot(slotId, vehicleType, false);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Booking[] updatedBookings = bookingDAO.getUserBookings(username);
            List<Booking> bookingList = new ArrayList<>();
            for (Booking b : updatedBookings) {
                if (b != null) {
                    bookingList.add(b);
                }
            }
            String json = new Gson().toJson(bookingList);
            response.getWriter().write(json);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid JSON format or data: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (session == null || user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        String username = user.getUsername();

        String payload;
        try (BufferedReader reader = new BufferedReader(request.getReader())) {
            payload = reader.lines().collect(Collectors.joining());
        }

        try {
            Map<String, Object> jsonMap = new Gson().fromJson(payload, Map.class);
            if (jsonMap == null || !jsonMap.containsKey("bookingId")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid bookingId");
                return;
            }
            int bookingId = ((Number) jsonMap.get("bookingId")).intValue();

            Booking[] bookings = bookingDAO.getUserBookings(username);
            Booking targetBooking = null;
            for (Booking booking : bookings) {
                if (booking != null && booking.getBookingId() == bookingId) {
                    targetBooking = booking;
                    break;
                }
            }

            if (targetBooking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return;
            }

            bookingDAO.deleteBooking(bookingId, username);
            slotDAO.updateSlot(targetBooking.getSlotId(), targetBooking.getVehicleType(), true);
            System.out.println("Slot updated after cancellation: slotId=" + targetBooking.getSlotId() + ", vehicleType=" + targetBooking.getVehicleType() + ", isAvailable=true");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Booking[] updatedBookings = bookingDAO.getUserBookings(username);
            List<Booking> bookingList = new ArrayList<>();
            for (Booking b : updatedBookings) {
                if (b != null) {
                    bookingList.add(b);
                }
            }
            String json = new Gson().toJson(bookingList);
            response.getWriter().write(json);
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid JSON format");
        }
    }

    private boolean validateBookingJson(Map<String, Object> jsonMap) {
        return jsonMap != null &&
                jsonMap.containsKey("slotId") &&
                jsonMap.containsKey("vehicleType") &&
                jsonMap.containsKey("vehicleNumber") &&
                jsonMap.containsKey("nicNumber") &&
                jsonMap.containsKey("parkingDate") &&
                jsonMap.containsKey("parkingTime") &&
                jsonMap.containsKey("duration");
    }

    private boolean isValidVehicleType(String vehicleType) {
        return vehicleType != null && Arrays.asList("car", "van", "motorbike", "truck").contains(vehicleType.toLowerCase());
    }
}