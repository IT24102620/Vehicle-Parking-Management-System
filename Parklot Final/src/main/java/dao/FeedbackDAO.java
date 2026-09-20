package dao;

import model.Feedback;
import java.util.List;

public interface FeedbackDAO {
    boolean addFeedback(Feedback feedback);
    List<Feedback> findByCategory(String category);
    List<Feedback> findAllApproved();

    boolean assignPlace(String id, String category, int place);
    boolean unassign(String id, String category);
    boolean deleteFeedbackById(String id, String category);
    boolean updateFeedbackById(String id, String newComment, int newRating, String category);
}
