# Vehicle Parking Management System

A Java-based web application for managing vehicle parking slots, user bookings, admin operations, and customer feedback. The system provides both user and admin dashboards with slot availability tracking, parking reservations, and persistent storage using text files.

## Project Overview

This project is built as a servlet-based web application using Java, JSP, Maven, and MySQL-like file persistence patterns. It lets users:

- create an account and log in
- register vehicles
- check available parking slots
- book a parking slot for a specific vehicle
- view their own booking history
- update profile details
- submit and review feedback

Admins can:

- log in to the admin dashboard
- manage parking slots
- monitor bookings and booking history
- view registered users
- handle feedback approval or deletion
- manage availability and slot conditions

## Technology Stack

- Java 16
- Maven
- Jakarta Servlet API
- JSP / JSTL
- HTML / CSS / JavaScript
- Gson for JSON handling
- File-based data storage in the data folder

## Main Features

### User Features
- User registration and login
- Vehicle registration by owner
- Search and availability check for parking slots
- Booking creation and cancellation
- View booking history
- Profile updates
- Feedback submission

### Admin Features
- Admin sign-up and login
- Dashboard overview
- Manage users and bookings
- Slot management and availability updates
- Review submitted feedback
- Approve or delete feedback

### Data Model
The project uses object-oriented models such as:

- User
- RegularUser
- AdminUser
- Vehicle
- Booking
- ParkingSlot
- RegularSlot
- HandicappedSlot
- Feedback

These models are stored and retrieved from text files like:

- data/users.txt
- data/admin.txt
- data/slots.txt
- data/bookings.txt
- data/booking_history.txt
- data/vehicleregister.txt

## Project Structure

```text
Vehicle-Parking-Management-System-main/
├── README.md
├── Parklot Final/
│   ├── pom.xml
│   ├── data/
│   │   ├── admin.txt
│   │   ├── approved.txt
│   │   ├── booking_history.txt
│   │   ├── bookings.txt
│   │   ├── FDgeneral.txt
│   │   ├── slots.txt
│   │   ├── users.txt
│   │   └── vehicleregister.txt
│   └── src/
│       ├── main/
│       │   ├── java/
│       │   │   ├── dao/
│       │   │   ├── model/
│       │   │   └── servlet/
│       │   └── webapp/
│       │       ├── WEB-INF/
│       │       ├── index.jsp
│       │       ├── login.html
│       │       ├── dashboard.jsp
│       │       └── ...
│       └── target/
```

## How to Run

### Prerequisites
- Java JDK 16 or newer
- Maven installed
- Apache Tomcat 9 or 10

### Steps
1. Open a terminal in the project folder.
2. Navigate to the web app folder:

```bash
cd "Parklot Final"
```

3. Build the project:

```bash
mvn clean package
```

4. Deploy the generated WAR file to Tomcat.
5. Start Tomcat and open the application in your browser.

Default URL:

```text
http://localhost:8080/parklot
```

## Default Admin Login

The project initializes a default admin account automatically.

- Username: admin
- Password: admin123

## Notes

- The application uses text files for persistence instead of a database.
- Some DAO classes currently use absolute local file paths, so if the project is moved to another machine, those paths may need to be updated.
- The project is intended for learning and academic demonstration of Java OOP, servlet-based web development, and file-based data management.


## Contributing

This project can be extended with:

- database migration to MySQL/PostgreSQL
- improved validation and security
- better UI/UX enhancements
- role-based access refinement
- REST API support

## Summary

This system is a complete parking management web application that demonstrates core Java-based web development concepts, object-oriented design, and operational logic for vehicle parking services. It is suitable for learning, college projects, and further extension into a more robust production-ready parking platform.
