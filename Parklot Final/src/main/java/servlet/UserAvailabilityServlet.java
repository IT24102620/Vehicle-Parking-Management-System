package servlet;

import dao.SlotDAO;
import model.ParkingSlot;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import com.google.gson.Gson;

@WebServlet("/user/availability")
public class UserAvailabilityServlet extends HttpServlet {
    private SlotDAO slotDAO;

    @Override
    public void init() throws ServletException {
        slotDAO = new SlotDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        ParkingSlot[] allSlots = slotDAO.getAllSlots();
        List<ParkingSlot> slotList = new ArrayList<>();
        for (ParkingSlot slot : allSlots) {
            if (slot != null) {
                slotList.add(slot);
            }
        }
        System.out.println("UserAvailabilityServlet: Slots before serialization: " + slotList);
        String json = new Gson().toJson(slotList);
        System.out.println("UserAvailabilityServlet: JSON response: " + json);
        response.getWriter().write(json);
    }
}