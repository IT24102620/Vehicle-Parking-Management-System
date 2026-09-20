# Vehicle Parking Management System

A Java-based web application for managing vehicle parking slots, user bookings, admin operations, and customer feedback. The system provides separate user and admin functionality, including parking slot availability tracking, parking reservations, and file-based data storage.

## Project Overview

This project is developed as a servlet-based web application using Java, JSP, Maven, Jakarta Servlet API, HTML, CSS, and JavaScript. The application allows users to manage vehicles, check parking availability, make reservations, view booking history, update their profiles, and provide feedback.

Administrators can manage parking slots, monitor bookings, view registered users, and manage customer feedback.

## Technology Stack

* Java 
* Maven
* Jakarta Servlet API
* JSP / JSTL
* HTML / CSS / JavaScript
* Gson for JSON handling
* File-based data storage

## Main Features

### User Features

* User registration and login
* Vehicle registration
* Search and availability checking for parking slots
* Parking slot booking
* Booking cancellation
* View booking history
* Profile updates
* Feedback submission

### Admin Features

* Admin login
* Admin dashboard
* Manage users and bookings
* Manage parking slots
* Update parking slot availability and conditions
* View submitted feedback
* Approve or delete feedback

## Data Model

The project uses object-oriented models such as:

* `User`
* `RegularUser`
* `AdminUser`
* `Vehicle`
* `Booking`
* `ParkingSlot`
* `RegularSlot`
* `HandicappedSlot`
* `Feedback`

The application stores data using text files located in the `data` directory, including:

* `data/users.txt`
* `data/admin.txt`
* `data/slots.txt`
* `data/bookings.txt`
* `data/booking_history.txt`
* `data/vehicleregister.txt`
* `data/approved.txt`
* `data/FDgeneral.txt`

## Project Structure

```text
Vehicle-Parking-Management-System-main/
├── README.md
└── Parklot Final/
    ├── pom.xml
    ├── data/
    │   ├── admin.txt
    │   ├── approved.txt
    │   ├── booking_history.txt
    │   ├── bookings.txt
    │   ├── FDgeneral.txt
    │   ├── slots.txt
    │   ├── users.txt
    │   └── vehicleregister.txt
    └── src/
        └── main/
            ├── java/
            │   ├── dao/
            │   ├── model/
            │   └── servlet/
            └── webapp/
                ├── WEB-INF/
                ├── index.jsp
                ├── login.html
                ├── dashboard.jsp
                └── ...
```

## How to Run

### Prerequisites

* Java JDK 16 or newer
* Maven
* Apache Tomcat 9 or 10

### Steps

1. Clone or download the repository.
2. Open a terminal in the project directory.
3. Navigate to the web application directory:

```bash
cd "Parklot Final"
```

4. Build the project using Maven:

```bash
mvn clean package
```

5. Locate the generated WAR file in the `target` directory.
6. Deploy the WAR file to Apache Tomcat.
7. Start the Tomcat server.
8. Open the application in a web browser.

Default URL:

```text
http://localhost:8080/parklot
```

## Default Admin Login

The project includes a default administrator account for demonstration purposes.

* **Username:** `admin`
* **Password:** `admin123`

> For production use, default credentials should be changed and passwords should be stored securely.

## Notes

* The application uses text files for data persistence instead of a relational database.
* Some DAO classes currently use absolute local file paths. These paths may need to be updated when the project is moved to another computer.
* The project is intended for academic and learning purposes, demonstrating Java OOP, servlet-based web development, JSP, and file-based data management.

## Future Improvements

The system could be extended with:

* Migration from text-file storage to MySQL or PostgreSQL
* Improved input validation
* Stronger authentication and password security
* Improved UI/UX
* More refined role-based access control
* REST API support
* Automated testing
* Improved database and application security

## Summary

The Vehicle Parking Management System demonstrates core Java web development concepts, object-oriented programming, servlet-based application development, JSP, and file-based data management.

The system provides functionality for both parking customers and administrators and can be further extended into a more robust parking management platform.
