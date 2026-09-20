package servlet;

import dao.BookingDAO;
import model.Booking;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;

@WebServlet("/user/booking-history")
public class UserBookingHistoryServlet extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Combine active and historical bookings
        Booking[] activeBookings = bookingDAO.getUserBookings(username);
        Booking[] historicalBookings = bookingDAO.getUserBookingHistory(username);
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