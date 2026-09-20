package model;

import java.util.UUID;
import java.util.List;
import java.util.ArrayList;

public class Feedback {
    private String id;
    private String username;
    private String comment;
    private String category;
    private int rating;
    private boolean approved;
    private int place;

    // Loader-style constructor
    public Feedback(String id, String username, String comment, String category, int rating, boolean approved, int place) {
        this.id = id;
        this.username = username;
        this.comment = comment;
        this.category = category;
        this.rating = rating;
        this.approved = approved;
        this.place = place;
    }

    // New-feedback constructor
    public Feedback(String username, String comment, String category, int rating, boolean approved, int place) {
        this.id = UUID.randomUUID().toString();
        this.username = username;
        this.comment = comment;
        this.category = category;
        this.rating = rating;
        this.approved = approved;
        this.place = place;
    }

    // Getters
    public String getId() { return id; }
    public String getUsername() { return username; }
    public String getComment() { return comment; }
    public String getCategory() { return category; }
    public int getRating() { return rating; }
    public boolean isApproved() { return approved; }
    public int getPlace() { return place; }

    // Setters
    public void setComment(String comment) { this.comment = comment; }
    public void setRating(int rating) { this.rating = rating; }
    public void setApproved(boolean a) { this.approved = a; }
    public void setPlace(int p) { this.place = p; }

    // Serialize for file storage
    public String toBlock() {
        return String.format(
                "ID: %s%n" +
                        "Username: %s%n" +
                        "Rating: %d%n" +
                        "Comment: %s%n" +
                        "Approved: %b%n" +
                        "Place: %d%n" +
                        "Category: %s%n" +
                        "---%n",
                id,
                username,
                rating,
                comment.replace("\n", " "),
                approved,
                place,
                category
        );
    }

    // Deserialize from storage
    public static Feedback fromLines(List<String> lines, String defaultCategory) {
        String id = "";
        String username = "";
        String comment = "";
        String category = defaultCategory;
        int rating = 0;
        boolean approved = false;
        int place = 0;

        for (String line : lines) {
            if (line.startsWith("ID: ")) {
                id = line.substring(4).trim();
            } else if (line.startsWith("Username: ")) {
                username = line.substring(10).trim();
            } else if (line.startsWith("Rating: ")) {
                try { rating = Integer.parseInt(line.substring(8).trim()); }
                catch (NumberFormatException e) { rating = 0; }
            } else if (line.startsWith("Comment: ")) {
                comment = line.substring(9).trim();
            } else if (line.startsWith("Approved: ")) {
                approved = Boolean.parseBoolean(line.substring(10).trim());
            } else if (line.startsWith("Place: ")) {
                try { place = Integer.parseInt(line.substring(7).trim()); }
                catch (NumberFormatException e) { place = 0; }
            } else if (line.startsWith("Category: ")) {
                category = line.substring(10).trim();
            }
        }
        return new Feedback(id, username, comment, category, rating, approved, place);
    }
}