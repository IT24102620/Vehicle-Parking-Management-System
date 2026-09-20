<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Parklot - Sidebar</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        /* ===== Sidebar ===== */
        .sidebar {
            position: fixed; top: 0; left: 0;
            width: 80px; height: 100%;
            background: linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E);
            backdrop-filter: blur(10px);
            display: flex; flex-direction: column; align-items: center;
            padding-top: 20px; z-index: 1000;
            transition: width 0.3s ease; overflow: hidden;
        }
        .sidebar:hover { width: 240px; }
        .sidebar .logo img {
            width: 60px; margin-bottom: 48px;
            transition: transform 0.6s ease;
        }
        .sidebar .logo img:hover { transform: rotate(360deg) scale(1.3); }
        .sidebar-link {
            width: 100%; display: flex; align-items: center; justify-content: center;
            padding: 12px 0; color: #fff; text-decoration: none;
            transition: all 0.3s ease; font-size: 1rem; font-weight: normal;
        }
        .sidebar-link img {
            width: 24px; height: 24px; margin-right: 0;
            transition: margin 0.3s ease; flex-shrink: 0;
        }
        .link-text {
            display: none; opacity: 0; margin-left: 15px;
            white-space: nowrap; transition: opacity 0.3s ease;
            font-size: 1rem; font-weight: normal;
        }
        .sidebar-link:hover { background: rgba(255,255,255,0.1); }
        .sidebar:hover .sidebar-link { justify-content: flex-start; padding-left: 20px; }
        .sidebar:hover .sidebar-link img { margin-right: 15px; }
        .sidebar:hover .link-text { display: inline-block; opacity: 1; }
    </style>
</head>
<body>
<!-- Sidebar -->
<aside class="sidebar">
    <div class="logo"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Logo"></div>
    <a href="adminDashboard.jsp" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/home.png"/><span class="link-text">Home</span></a>

    <a href="<%= request.getContextPath() %>/userList.jsp" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/user.png"/><span class="link-text">User manager</span></a>
    <a href="AvailabilityAdmin.html" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/parking.png"/><span class="link-text">Slot Manager</span></a>

    <a href="AdminBooking.html" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/calendar.png"/><span class="link-text">Bookings</span></a>
    <a href="AdminBookingHistory.html"class="sidebar-link">
        <img src="https://img.icons8.com/ios-filled/50/ffffff/time-machine.png" alt="">
        <span class="link-text">Booking History</span>
        <a href="searchVehicle.html" class="sidebar-link">
            <img src="https://img.icons8.com/ios-filled/50/ffffff/search.png" alt="Search Icon">
            <span class="link-text">Search Vehicles</span>
        </a>
        <a href="VehiclesAdminView.html" class="sidebar-link">
            <img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Car Icon">
            <span class="link-text">Registered Vehicles</span>
        </a>
    </a>

    <a href="admin_review.jsp" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/feedback.png"/><span class="link-text">Feedback manager</span></a>
    <a href="settings.jsp" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/settings.png"/><span class="link-text">Settings</span></a>
    <a href="<%= request.getContextPath() %>/logout" id="logout-btn" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/exit.png"/><span class="link-text">Log Out</span></a>
</aside>

<script>
    // Logout confirmation
    document.getElementById('logout-btn').addEventListener('click', e => {
        if (!confirm('Are you sure you want to log out?')) e.preventDefault();
    });
</script>
</body>
</html>