package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/login")
public class LoginDispatcherServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String adminCode = request.getParameter("adminCode");
        String targetServlet = (adminCode != null && !adminCode.trim().isEmpty()) ? "/adminLogin" : "/userLogin";
        request.getRequestDispatcher(targetServlet).forward(request, response);
    }
}