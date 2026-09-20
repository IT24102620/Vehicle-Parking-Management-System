package servlet;

import dao.FileFeedbackDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/submitFeedback")
public class FeedbackSubmitServlet extends HttpServlet {
    private FileFeedbackDAO dao;
    @Override
    public void init() throws ServletException {
        dao = new FileFeedbackDAO();
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.html");
            return;
        }
        User user = (User) session.getAttribute("user");
        String username = user.getUsername();
        String category = req.getParameter("category");
        String comment = req.getParameter("comment");
        if ("parking".equals(category)) {
            String location = req.getParameter("location");
            String slot = req.getParameter("slot");
            comment = String.format("Location: %s; Slot: %s; %s", location, slot, comment);
        } else if ("request".equals(category)) {
            String reason = req.getParameter("reason");
            comment = String.format("Request: %s; %s", reason, comment);
        } else if ("payment".equals(category)) {
            comment = "Payment concern: " + comment;
        }
        int rating;
        try { rating = Integer.parseInt(req.getParameter("rating")); } catch (NumberFormatException e) { rating = 0; }
        boolean success = dao.addFeedback(new model.Feedback(username, comment, category, rating, false, 0));
        String target = success ? "/feedback_form.jsp?success=FeedbackSubmitted" : "/feedback_form.jsp?error=SubmissionFailed";
        resp.sendRedirect(req.getContextPath() + target);
    }
}
