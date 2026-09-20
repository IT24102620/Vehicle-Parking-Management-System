package servlet;

import dao.SlotDAO;
import model.ParkingSlot;
import model.HandicappedSlot;
import java.util.stream.Collectors;
import model.RegularSlot;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;

@WebServlet("/admin/availability")
public class AdminAvailabilityServlet extends HttpServlet {
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
        String json = new Gson().toJson(slotList);
        response.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String vehicleType = request.getParameter("vehicleType");
        String slotType = request.getParameter("slotType");

        if (vehicleType == null || slotType == null || !isValidVehicleType(vehicleType) || !isValidSlotType(slotType)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing vehicleType or slotType");
            return;
        }

        int slotId = slotDAO.getNextSlotId(vehicleType);
        ParkingSlot newSlot = slotType.equalsIgnoreCase("Handicapped") ?
                new HandicappedSlot(slotId, vehicleType, true) :
                new RegularSlot(slotId, vehicleType, true);
        slotDAO.addSlot(newSlot);

        String acceptHeader = request.getHeader("Accept");
        if (acceptHeader != null && acceptHeader.contains("application/json")) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            ParkingSlot[] updatedSlots = slotDAO.getAllSlots();
            List<ParkingSlot> slotList = new ArrayList<>();
            for (ParkingSlot slot : updatedSlots) {
                if (slot != null) {
                    slotList.add(slot);
                }
            }
            String json = new Gson().toJson(slotList);
            response.getWriter().write(json);
        } else {
            response.sendRedirect("/AvailabilityAdmin.html");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String payload;
        try (BufferedReader reader = new BufferedReader(request.getReader())) {
            payload = reader.lines().collect(Collectors.joining());
        }

        try {
            Map<String, Object> jsonMap = new Gson().fromJson(payload, Map.class);
            if (jsonMap == null || !jsonMap.containsKey("slotId") || !jsonMap.containsKey("vehicleType") || !jsonMap.containsKey("isAvailable")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid slotId, vehicleType, or isAvailable in JSON");
                return;
            }
            int slotId = ((Number) jsonMap.get("slotId")).intValue();
            String vehicleType = (String) jsonMap.get("vehicleType");
            boolean isAvailable = (Boolean) jsonMap.get("isAvailable");

            if (!isValidVehicleType(vehicleType)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid vehicleType");
                return;
            }

            slotDAO.updateSlot(slotId, vehicleType, isAvailable);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            ParkingSlot[] updatedSlots = slotDAO.getAllSlots();
            List<ParkingSlot> slotList = new ArrayList<>();
            for (ParkingSlot slot : updatedSlots) {
                if (slot != null) {
                    slotList.add(slot);
                }
            }
            String json = new Gson().toJson(slotList);
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
            if (jsonMap == null || !jsonMap.containsKey("slotId") || !jsonMap.containsKey("vehicleType")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid slotId or vehicleType in JSON");
                return;
            }
            int slotId = ((Number) jsonMap.get("slotId")).intValue();
            String vehicleType = (String) jsonMap.get("vehicleType");

            if (!isValidVehicleType(vehicleType)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid vehicleType");
                return;
            }

            slotDAO.deleteSlot(slotId, vehicleType);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            ParkingSlot[] updatedSlots = slotDAO.getAllSlots();
            List<ParkingSlot> slotList = new ArrayList<>();
            for (ParkingSlot slot : updatedSlots) {
                if (slot != null) {
                    slotList.add(slot);
                }
            }
            String json = new Gson().toJson(slotList);
            response.getWriter().write(json);
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid JSON format");
        }
    }

    private boolean isValidVehicleType(String vehicleType) {
        return vehicleType != null && Arrays.asList("car", "van", "motorbike", "truck").contains(vehicleType.toLowerCase());
    }

    private boolean isValidSlotType(String slotType) {
        return slotType != null && Arrays.asList("Regular", "Handicapped").contains(slotType);
    }
}