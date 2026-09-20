package dao;

import model.User;

public class LinkedList {
    private static class Node {
        User user;
        Node next;

        Node(User user) {
            this.user = user;
            this.next = null;
        }

        public void displayNode() {
            System.out.println(user != null ? user.getUsername() : "null");
        }
    }

    private Node first;

    public LinkedList() {
        first = null;
    }

    public boolean isEmpty() {
        return first == null;
    }

    // Insert at the beginning of the list
    public void insertFirst(User user) {
        Node newNode = new Node(user);
        newNode.next = first;
        first = newNode;
    }

    // Delete the first node
    public User deleteFirst() {
        if (isEmpty()) {
            return null;
        }
        Node temp = first;
        first = first.next;
        return temp.user;
    }

    // Find a user by username
    public User find(String username) {
        Node current = first;
        while (current != null) {
            if (current.user != null && current.user.getUsername().equalsIgnoreCase(username.trim())) {
                return current.user;
            }
            current = current.next;
        }
        return null;
    }

    // Insert a user at the end of the list
    public void insert(User user) {
        Node newNode = new Node(user);
        if (isEmpty()) {
            first = newNode;
        } else {
            Node current = first;
            while (current.next != null) {
                current = current.next;
            }
            current.next = newNode;
        }
    }

    // Delete a user by username
    public boolean delete(String username) {
        Node current = first;
        Node previous = null;

        while (current != null) {
            if (current.user != null && current.user.getUsername().equalsIgnoreCase(username.trim())) {
                if (previous == null) {
                    first = current.next;
                } else {
                    previous.next = current.next;
                }
                return true;
            }
            previous = current;
            current = current.next;
        }
        return false;
    }

    // Check if username exists
    public boolean usernameExists(String username) {
        return find(username) != null;
    }

    // Check if email exists
    public boolean emailExists(String email) {
        Node current = first;
        while (current != null) {
            if (current.user != null && current.user.getEmail().equalsIgnoreCase(email.trim())) {
                return true;
            }
            current = current.next;
        }
        return false;
    }

    // Check if NIC exists
    public boolean nicExists(String nic) {
        Node current = first;
        while (current != null) {
            if (current.user != null && current.user.getNic().equalsIgnoreCase(nic.trim())) {
                return true;
            }
            current = current.next;
        }
        return false;
    }

    // Update a user
    public boolean updateUser(User updatedUser) {
        Node current = first;
        while (current != null) {
            if (current.user != null && current.user.getUsername().equalsIgnoreCase(updatedUser.getUsername())) {
                current.user = updatedUser;
                return true;
            }
            current = current.next;
        }
        return false;
    }

    // Authenticate a user
    public User authenticate(String username, String password) {
        Node current = first;
        while (current != null) {
            if (current.user != null && current.user.login(username.trim(), password.trim())) {
                return current.user;
            }
            current = current.next;
        }
        return null;
    }

    // Get all users as an array
    public User[] getUsers() {
        int size = 0;
        Node current = first;
        while (current != null) {
            size++;
            current = current.next;
        }

        User[] users = new User[size];
        current = first;
        int index = 0;
        while (current != null) {
            users[index++] = current.user;
            current = current.next;
        }
        return users;
    }

    // Get the size of the list
    public int size() {
        int count = 0;
        Node current = first;
        while (current != null) {
            count++;
            current = current.next;
        }
        return count;
    }

    // Display the list (for debugging)
    public void displayList() {
        Node current = first;
        while (current != null) {
            current.displayNode();
            current = current.next;
        }
        System.out.println("");
    }
}