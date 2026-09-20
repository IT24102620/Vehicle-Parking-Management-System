package servlet;

import dao.FileFeedbackDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/editFeedback")
public class FeedbackEditServlet extends HttpServlet {
    private FileFeedbackDAO dao;
    @Override
    public void init() throws ServletException {
        dao = new FileFeedbackDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.html");
            return;
        }
        String id       = req.getParameter("id");
        String category = req.getParameter("category");
        String comment  = req.getParameter("comment");
        int rating;
        try { rating = Integer.parseInt(req.getParameter("rating")); }
        catch (NumberFormatException e) { rating = 0; }

        dao.updateFeedbackById(id, comment, rating, category);
        resp.sendRedirect("feedback_list.jsp?success=updated");
    }
}
