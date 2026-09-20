package servlet;

import dao.VehicleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/deleteVehicle")
public class DeleteVehicleServlet extends HttpServlet {
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
            String licensePlate = json.get("licensePlate").getAsString();

            if (licensePlate == null || licensePlate.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"License plate is required.\"}");
                return;
            }

            vehicleDAO.deleteVehicle(licensePlate);
            response.getWriter().write("{\"message\": \"Vehicle deleted successfully.\"}");
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error deleting vehicle: " + e.getMessage() + "\"}");
        }
    }
}