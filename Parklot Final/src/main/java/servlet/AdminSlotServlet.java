package servlet;

import dao.SlotDAO;
import model.ParkingSlot;
import model.HandicappedSlot;
import model.RegularSlot;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.stream.Collectors;

import com.google.gson.Gson;

@WebServlet("/admin/slots")
public class AdminSlotServlet extends HttpServlet {
    private SlotDAO slotDAO;

    @Override
    public void init() throws ServletException {
        slotDAO = new SlotDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String payload = request.getReader().lines().collect(Collectors.joining());
        Gson gson = new Gson();
        Map<String, String> jsonMap = gson.fromJson(payload, Map.class);
        String vehicleType = jsonMap.get("vehicleType");
        String slotType = jsonMap.get("slotType");

        if (vehicleType == null || slotType == null || !isValidVehicleType(vehicleType) || !isValidSlotType(slotType)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing vehicleType or slotType");
            return;
        }

        int slotId = slotDAO.getNextSlotId(vehicleType);
        ParkingSlot newSlot = slotType.equalsIgnoreCase("Handicapped") ?
                new HandicappedSlot(slotId, vehicleType, true) :
                new RegularSlot(slotId, vehicleType, true);
        slotDAO.addSlot(newSlot);

        response.setStatus(HttpServletResponse.SC_OK);
    }

    private boolean isValidVehicleType(String vehicleType) {
        return vehicleType != null && Arrays.asList("car", "van", "motorbike", "truck").contains(vehicleType.toLowerCase());
    }

    private boolean isValidSlotType(String slotType) {
        return slotType != null && Arrays.asList("Regular", "Handicapped").contains(slotType);
    }
}