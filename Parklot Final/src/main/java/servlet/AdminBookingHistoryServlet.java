package servlet;

import dao.BookingDAO;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;

@WebServlet("/admin/booking-history")
public class AdminBookingHistoryServlet extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Combine active and historical bookings
        Booking[] activeBookings = bookingDAO.getAllBookings();
        Booking[] historicalBookings = bookingDAO.getAllBookingHistory();
        List<Booking> allBookings = new ArrayList<>();
        for (Booking booking : activeBookings) {
            if (booking != null) {
                allBookings.add(booking);
            }
        }
        for (Booking booking : historicalBookings) {
            if (booking != null) {
                allBookings.add(booking);
            }
        }

        String json = new Gson().toJson(allBookings);
        response.getWriter().write(json);
    }
}