package servlet;

import dao.FileFeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteFeedback")
public class DeleteFeedbackServlet extends HttpServlet {
    private FileFeedbackDAO dao;
    @Override
    public void init() throws ServletException {
        dao = new FileFeedbackDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String id       = req.getParameter("id");
        String category = req.getParameter("category");
        dao.deleteFeedbackById(id, category);
        resp.sendRedirect("admin_review.jsp");
    }
}
