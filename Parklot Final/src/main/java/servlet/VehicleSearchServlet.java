package servlet;

import dao.VehicleDAO;
import model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import com.google.gson.Gson;

@WebServlet("/searchVehicle")
public class VehicleSearchServlet extends HttpServlet {
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            List<Vehicle> vehicles;
            if (searchQuery == null || searchQuery.trim().isEmpty()) {
                vehicles = vehicleDAO.getAllVehicles();
            } else {
                // Search by owner or license plate
                vehicles = vehicleDAO.getVehiclesByOwner(searchQuery);
                // Also search by license plate (not directly supported by DAO, so filter manually)
                List<Vehicle> allVehicles = vehicleDAO.getAllVehicles();
                for (Vehicle vehicle : allVehicles) {
                    if (vehicle.getLicensePlate().equalsIgnoreCase(searchQuery) && !vehicles.contains(vehicle)) {
                        vehicles.add(vehicle);
                    }
                }
            }

            // Convert to JSON
            Gson gson = new Gson();
            String json = gson.toJson(vehicles);
            out.write(json);
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error retrieving vehicles: " + e.getMessage() + "\"}");
        }
    }
}