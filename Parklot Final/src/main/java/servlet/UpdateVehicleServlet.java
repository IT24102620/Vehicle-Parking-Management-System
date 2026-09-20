package servlet;

import dao.VehicleDAO;
import model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/updateVehicle")
public class UpdateVehicleServlet extends HttpServlet {
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Parse JSON request body
            Gson gson = new Gson();
            JsonObject json = gson.fromJson(request.getReader(), JsonObject.class);
            String originalLicensePlate = json.get("originalLicensePlate").getAsString();
            String licensePlate = json.get("licensePlate").getAsString();
            String vehicleType = json.get("vehicleType").getAsString();
            String owner = json.get("owner").getAsString();

            if (originalLicensePlate == null || licensePlate == null || vehicleType == null || owner == null ||
                    originalLicensePlate.isEmpty() || licensePlate.isEmpty() || vehicleType.isEmpty() || owner.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"All fields are required.\"}");
                return;
            }

            Vehicle updatedVehicle = new Vehicle(vehicleType, licensePlate, owner);
            vehicleDAO.updateVehicle(updatedVehicle);
            response.getWriter().write("{\"message\": \"Vehicle updated successfully.\"}");
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error updating vehicle: " + e.getMessage() + "\"}");
        }
    }
}