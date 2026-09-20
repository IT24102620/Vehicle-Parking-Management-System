package dao;

import model.Feedback;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FileFeedbackDAO implements FeedbackDAO {
    private static final Path BASE_DIR = Paths.get("C:", "Users", "ASUS", "Desktop", "Vehicle-Parking-Management-System", "Parklot Final");
    private static final String DATA_DIR_NAME      = "data";
    private static final String APPROVED_FILE_NAME = "approved.txt";

    private final Path dataDir;
    private final Path approvedFile;

    public FileFeedbackDAO() {
        this.dataDir      = BASE_DIR.resolve(DATA_DIR_NAME);
        this.approvedFile = dataDir.resolve(APPROVED_FILE_NAME);
        try {
            Files.createDirectories(dataDir);
            if (!Files.exists(approvedFile)) {
                Files.createFile(approvedFile);
            }
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize data directory or approved file", e);
        }
    }

    @Override
    public boolean addFeedback(Feedback fb) {
        Path file = dataDir.resolve("FD" + fb.getCategory() + ".txt");
        try (BufferedWriter w = Files.newBufferedWriter(file, StandardOpenOption.CREATE, StandardOpenOption.APPEND)) {
            w.write(fb.toBlock());
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Feedback> findByCategory(String category) {
        Path file = dataDir.resolve("FD" + category + ".txt");
        List<Feedback> list = new ArrayList<>();
        if (!Files.exists(file)) return list;
        try (BufferedReader r = Files.newBufferedReader(file)) {
            List<String> block = new ArrayList<>();
            String line;
            while ((line = r.readLine()) != null) {
                if ("---".equals(line)) {
                    list.add(Feedback.fromLines(block, category));
                    block.clear();
                } else {
                    block.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Feedback> findAllApproved() {
        // Read from approved.txt
        List<Feedback> approved = new ArrayList<>();
        try (BufferedReader r = Files.newBufferedReader(approvedFile)) {
            List<String> block = new ArrayList<>();
            String line;
            while ((line = r.readLine()) != null) {
                if ("---".equals(line)) {
                    approved.add(Feedback.fromLines(block, /* category embedded */ ""));
                    block.clear();
                } else {
                    block.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return approved;
    }

    @Override
    public boolean assignPlace(String id, String category, int place) {
        Path file = dataDir.resolve("FD" + category + ".txt");
        Feedback target = null;
        try {
            List<String> lines = Files.readAllLines(file);
            try (BufferedWriter w = Files.newBufferedWriter(file, StandardOpenOption.TRUNCATE_EXISTING)) {
                List<String> block = new ArrayList<>();
                for (String line : lines) {
                    if ("---".equals(line)) {
                        Feedback fb = Feedback.fromLines(block, category);
                        if (fb.getId().equals(id)) {
                            fb.setApproved(true);
                            fb.setPlace(place);
                            target = fb;
                        } else if (fb.getPlace() == place) {
                            fb.setApproved(false);
                            fb.setPlace(0);
                        }
                        w.write(fb.toBlock());
                        block.clear();
                    } else {
                        block.add(line);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
        if (target == null) return false;

        // Update approved file
        List<Feedback> approved = findAllApproved();
        approved.removeIf(fb -> fb.getPlace() == place);
        approved.add(target);
        try (BufferedWriter w = Files.newBufferedWriter(approvedFile, StandardOpenOption.TRUNCATE_EXISTING)) {
            for (Feedback fb : approved) {
                w.write(fb.toBlock());
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    @Override
    public boolean unassign(String id, String category) {
        // Clear in category
        Path file = dataDir.resolve("FD" + category + ".txt");
        try {
            List<String> lines = Files.readAllLines(file);
            try (BufferedWriter w = Files.newBufferedWriter(file, StandardOpenOption.TRUNCATE_EXISTING)) {
                List<String> block = new ArrayList<>();
                for (String line : lines) {
                    if ("---".equals(line)) {
                        Feedback fb = Feedback.fromLines(block, category);
                        if (fb.getId().equals(id)) {
                            fb.setApproved(false);
                            fb.setPlace(0);
                        }
                        w.write(fb.toBlock());
                        block.clear();
                    } else {
                        block.add(line);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
        // Remove from approved file
        List<Feedback> approved = findAllApproved();
        approved.removeIf(fb -> fb.getId().equals(id));
        try (BufferedWriter w = Files.newBufferedWriter(approvedFile, StandardOpenOption.TRUNCATE_EXISTING)) {
            for (Feedback fb : approved) w.write(fb.toBlock());
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteFeedbackById(String id, String category) {
        // Remove block
        Path file = dataDir.resolve("FD" + category + ".txt");
        try {
            List<String> lines = Files.readAllLines(file);
            try (BufferedWriter w = Files.newBufferedWriter(file, StandardOpenOption.TRUNCATE_EXISTING)) {
                List<String> block = new ArrayList<>();
                for (String line : lines) {
                    if ("---".equals(line)) {
                        Feedback fb = Feedback.fromLines(block, category);
                        if (!fb.getId().equals(id)) {
                            w.write(fb.toBlock());
                        }
                        block.clear();
                    } else {
                        block.add(line);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
        // Also unassign if needed
        return unassign(id, category);
    }

    @Override
    public boolean updateFeedbackById(String id, String newComment, int newRating, String category) {
        Path file = dataDir.resolve("FD" + category + ".txt");
        try {
            List<String> lines = Files.readAllLines(file);
            try (BufferedWriter w = Files.newBufferedWriter(file, StandardOpenOption.TRUNCATE_EXISTING)) {
                List<String> block = new ArrayList<>();
                for (String line : lines) {
                    if ("---".equals(line)) {
                        Feedback fb = Feedback.fromLines(block, category);
                        if (fb.getId().equals(id)) {
                            if (newComment != null) fb.setComment(newComment);
                            if (newRating > 0) fb.setRating(newRating);
                        }
                        w.write(fb.toBlock());
                        block.clear();
                    } else {
                        block.add(line);
                    }
                }
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
