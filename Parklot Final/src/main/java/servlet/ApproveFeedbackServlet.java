package servlet;

import dao.FileFeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/approveFeedback")
public class ApproveFeedbackServlet extends HttpServlet {
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
        int place       = Integer.parseInt(req.getParameter("place"));
        dao.assignPlace(id, category, place);
        resp.sendRedirect("admin_review.jsp");
    }
}
