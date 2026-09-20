package servlet;

import dao.BookingDAO;
import dao.CustomStack;
import dao.SlotDAO;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import com.google.gson.Gson;

@WebServlet("/admin/booking")
public class AdminBookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    private SlotDAO slotDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        slotDAO = new SlotDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Booking[] allBookings = bookingDAO.getAllBookings();
        List<Booking> bookingList = new ArrayList<>();
        for (Booking booking : allBookings) {
            if (booking != null) {
                bookingList.add(booking);
            }
        }

        String json = new Gson().toJson(bookingList);
        response.getWriter().write(json);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String payload;
        try (BufferedReader reader = new BufferedReader(request.getReader())) {
            payload = reader.lines().collect(Collectors.joining());
        }

        try {
            Map<String, Object> jsonMap = new Gson().fromJson(payload, Map.class);
            if (jsonMap == null || !jsonMap.containsKey("bookingId") || !jsonMap.containsKey("username") || !jsonMap.containsKey("duration")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid bookingId, username, or duration");
                return;
            }
            int bookingId = ((Number) jsonMap.get("bookingId")).intValue();
            String username = (String) jsonMap.get("username");
            int duration = ((Number) jsonMap.get("duration")).intValue();

            if (duration <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Duration must be positive");
                return;
            }

            // Update booking duration
            boolean updated = updateBookingDuration(bookingId, username, duration);
            if (!updated) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return;
            }

            // Save updated bookings to file
            bookingDAO.saveBookings();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Booking[] updatedBookings = bookingDAO.getAllBookings();
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

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String payload;
        try (BufferedReader reader = new BufferedReader(request.getReader())) {
            payload = reader.lines().collect(Collectors.joining());
        }

        try {
            Map<String, Object> jsonMap = new Gson().fromJson(payload, Map.class);
            if (jsonMap == null || !jsonMap.containsKey("bookingId") || !jsonMap.containsKey("username")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid bookingId or username");
                return;
            }
            int bookingId = ((Number) jsonMap.get("bookingId")).intValue();
            String username = (String) jsonMap.get("username");

            Booking[] bookings = bookingDAO.getAllBookings();
            Booking targetBooking = null;
            for (Booking booking : bookings) {
                if (booking != null && booking.getBookingId() == bookingId && booking.getUsername().equals(username)) {
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
            System.out.println("AdminBookingServlet: Slot updated after deletion: slotId=" + targetBooking.getSlotId() + ", vehicleType=" + targetBooking.getVehicleType() + ", isAvailable=true");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Booking[] updatedBookings = bookingDAO.getAllBookings();
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

    private boolean updateBookingDuration(int bookingId, String username, int duration) {
        CustomStack<Booking> tempStack = new CustomStack<>(bookingDAO.getAllBookings().length);
        boolean updated = false;
        while (!bookingDAO.bookingStack.isEmpty()) {
            Booking booking = bookingDAO.bookingStack.pop();
            if (booking.getBookingId() == bookingId && booking.getUsername().equals(username)) {
                booking.setDuration(duration);
                updated = true;
            }
            tempStack.push(booking);
        }
        while (!tempStack.isEmpty()) {
            bookingDAO.bookingStack.push(tempStack.pop());
        }
        return updated;
    }
}