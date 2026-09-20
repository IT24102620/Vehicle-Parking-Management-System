package servlet;

import dao.VehicleDAO;
import model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/registerVehicle")
public class VehicleRegisterServlet extends HttpServlet {
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String vehicleType = request.getParameter("vehicle-type");
        String licensePlate = request.getParameter("license-plate");
        String owner = request.getParameter("owner");

        if (vehicleType == null || vehicleType.isEmpty() ||
                licensePlate == null || licensePlate.isEmpty() ||
                owner == null || owner.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/registerVehicle.jsp").forward(request, response);
            return;
        }

        Vehicle vehicle = new Vehicle(vehicleType, licensePlate, owner);
        try {
            vehicleDAO.saveVehicle(vehicle);
            request.setAttribute("success", "Vehicle registered successfully!");
        } catch (IOException e) {
            request.setAttribute("error", "Error registering vehicle: " + e.getMessage());
        }

        request.getRequestDispatcher("/registerVehicle.jsp").forward(request, response);
    }
}