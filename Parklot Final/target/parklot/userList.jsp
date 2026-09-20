<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.AdminUser, java.util.List, java.util.ArrayList" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !(user instanceof AdminUser)) {
        response.sendRedirect("login.html?error=Admin access required");
        return;
    }
    if (request.getAttribute("users") == null) {
        response.sendRedirect(request.getContextPath() + "/adminUsers");
        return;
    }
    String username = user.getUsername();
    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) users = new ArrayList<>();
    String searchQuery = request.getParameter("search") != null ? request.getParameter("search") : "";
    String message = request.getParameter("message") != null ? request.getParameter("message") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Parklot Admin – User Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Kaushan+Script&family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* ===== Global & Background ===== */
        body, html {
            margin: 0; padding: 0; scroll-behavior: smooth;
            font-family: 'Poppins', sans-serif;
            min-height: 100vh; display: flex; flex-direction: column;
            background-image:
                    linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E),
                    url('https://images.unsplash.com/photo-1502161254066-6c74afbf07aa?q=80&w=1471&auto=format&fit=crop');
            background-repeat: no-repeat, no-repeat;
            background-position: center center, center center;
            background-size: cover, cover;
            background-attachment: fixed, fixed;
            background-blend-mode: overlay;
            color: #fff;
        }
        body::before {
            content: ''; position: fixed; inset: 0;
            background: rgba(0,0,0,0.2); z-index: -1;
        }

        /* ===== Preloader ===== */
        #preloader {
            position: fixed; inset: 0;
            display: flex; justify-content: center; align-items: center;
            z-index: 9999; transition: opacity 0.8s ease;
            background-image: linear-gradient(45deg, #EFCA29, #00D2FA, #972826);
            background-repeat: no-repeat; background-position: center center;
        }
        #preloader.hide { opacity: 0; pointer-events: none; }
        .loader {
            width: 80px; height: 80px;
            border: 10px solid #fff; border-top: 10px solid #EFCA29;
            border-radius: 50%;
            animation: spin 1.2s linear infinite, pulseGlow 2s infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        @keyframes pulseGlow {
            0%,100% { box-shadow: 0 0 10px rgba(239,202,41,0.5); }
            50%     { box-shadow: 0 0 30px rgba(239,202,41,1); }
        }

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
        .sidebar-link img, .sidebar-link i {
            width: 24px; height: 24px; margin-right: 0;
            transition: margin 0.3s ease; flex-shrink: 0;
        }
        .link-text {
            display: none; opacity: 0; margin-left: 15px;
            white-space: nowrap; transition: opacity 0.3s ease;
            font-size: 1rem; font-weight: normal;
        }
        .sidebar-link:hover { background: rgba(255,255,255,0.1); }
        .sidebar:hover .sidebar-link { justify-content: flex-start; padding-left:20px;}
        .sidebar:hover .sidebar-link img, .sidebar:hover .sidebar-link i { margin-right:15px; }
        .sidebar:hover .link-text { display:inline-block; opacity:1; }

        /* ===== Main Content ===== */
        .main-content {
            margin-left: 80px; transition: margin-left 0.3s ease;
            padding: 40px 20px; flex:1;
        }
        .sidebar:hover ~ .main-content { margin-left:240px; }
        .welcome-message { text-shadow:2px 2px 10px rgba(0,0,0,0.5); }

        /* ===== User List ===== */
        .user-list-container { max-width: 1300px; margin:0 auto; }
        .search-bar { margin-bottom: 40px; display:flex; justify-content:center; }
        .search-bar input {
            padding:15px; width:300px; border:2px solid #F6E05E;
            border-radius:25px 0 0 25px; background:rgba(255,255,255,0.1);
            color:#fff; font-size:16px; outline:none;
        }
        .search-bar button {
            padding:15px 25px; border:none;
            background:linear-gradient(45deg,#ED64A6,#F6E05E);
            color:#1A1A15; font-weight:700;
            border-radius:0 25px 25px 0; cursor:pointer;
            transition:all .4s ease;
        }
        .search-bar button:hover {
            background:linear-gradient(45deg,#F6E05E,#ED64A6);
            transform:scale(1.05);
        }
        .user-table {
            width:100%; border-collapse:collapse;
            background:rgba(255,255,255,0.1); backdrop-filter:blur(5px);
            border-radius:15px; overflow:hidden;
        }
        .user-table th, .user-table td {
            padding:20px; text-align:left;
            border-bottom:1px solid rgba(255,255,255,0.2);
        }
        .user-table th {
            background:linear-gradient(45deg,#6B46C1,#ED64A6);
            font-size:18px; font-weight:700; text-transform:uppercase;
            color:#fff;
        }
        .user-table td { font-size:16px; color:#fff; }
        .user-table tr:hover { background:rgba(237,100,166,0.2); }

        .action-btn {
            padding:10px 20px; border:none; border-radius:20px;
            cursor:pointer; transition:all .4s ease; font-weight:600;
        }
        .update-btn {
            background:linear-gradient(45deg,#F6E05E,#ED64A6);
            color:#1A1A15;
        }
        .delete-btn {
            background:linear-gradient(45deg,#FF4B2B,#FF416C);
            color:#fff;
        }
        .action-btn:hover {
            transform:scale(1.1);
            box-shadow:0 5px 15px rgba(0,0,0,0.3);
        }
        .message {
            text-align:center; margin-bottom:20px;
            font-size:18px; color:#F6E05E;
            text-shadow:1px 1px 5px rgba(0,0,0,0.5);
        }

        /* ===== Modal Overlay ===== */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        /* ===== Modal Box ===== */
        .modal-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 20px;
            width: 400px;
            max-width: 90%;
            position: relative;
            animation: fadeIn 0.5s ease;
        }

        .modal-content h2 {
            font-family: 'Kaushan Script', sans-serif;
            color: #F6E05E;
            margin-bottom: 20px;
            text-align: center;
        }

        .modal-content form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .modal-content input {
            padding: 12px;
            border: 2px solid #F6E05E;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            font-size: 16px;
            outline: none;
        }

        .modal-content button {
            padding: 12px;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.4s ease;
        }

        .modal-content .submit-btn {
            background: linear-gradient(45deg, #ED64A6, #F6E05E);
            color: #1A1A15;
        }

        .modal-content .close-btn {
            background: linear-gradient(45deg, #FF4B2B, #FF416C);
            color: #fff;
        }

        .modal-content button:hover {
            transform: scale(1.05);
        }

        .close-modal {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 24px;
            color: #F6E05E;
            cursor: pointer;
        }


        /* Footer CSS */
        .footer {
            padding: 40px 20px;
            background: linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E);
            position: relative;
            overflow: hidden;
            border-radius: 0px;
            backdrop-filter: blur(12px);
            margin-left: 80px;
            transition: margin-left 0.3s ease;
        }
        .sidebar:hover ~ .footer {
            margin-left: 240px;
        }
        .footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(237, 100, 166, 0.2), transparent);
            opacity: 0;
            transition: opacity 0.6s ease;
        }
        .footer:hover::before {
            opacity: 1;
        }
        .footer-container {
            max-width: 1300px;
            margin: 0 auto;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 20px;
        }
        .footer-column h3 {
            font-size: 20px;
            font-family: 'Kaushan Script', sans-serif;
            color: #F6E05E;
            margin-bottom: 15px;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5);
        }
        .footer-column p, .footer-column ul li a {
            font-size: 16px;
            color: #fff;
            margin: 8px 0;
            text-decoration: none;
            transition: all 0.4s ease;
        }
        .footer-column p:hover, .footer-column ul li a:hover {
            color: #FFE4E1;
            transform: translateX(10px);
            text-shadow: 0 0 8px rgba(255, 228, 225, 0.8);
        }
        .footer-social {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .footer-social img {
            width: 32px;
            margin: 10px;
            transition: transform 0.5s ease, filter 0.5s ease;
        }
        .footer-social img:hover {
            transform: scale(1.4) rotate(20deg);
            filter: drop-shadow(0 0 8px rgba(237, 100, 166, 0.9));
        }
        @media (max-width: 768px) {
            .footer {
                margin-left: 60px;
            }
            .sidebar:hover ~ .footer {
                margin-left: 200px;
            }
            .footer-container {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            .footer-social {
                flex-direction: row;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<!-- Preloader -->
<div id="preloader"><div class="loader"></div></div>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="logo"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Logo"></div>
    <a href="adminDashboard.jsp" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/home.png"/><span class="link-text">Home</span></a>

    <a href="<%= request.getContextPath() %>/userList.jsp" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/user.png"/><span class="link-text">User manager</span></a>
    <a href="AvailabiltyAdmin.html" class="sidebar-link"><img src="https://img.icons8.com/ios-filled/50/ffffff/parking.png"/><span class="link-text">Slot Manager</span></a>

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


<!-- Main Content -->
<div class="main-content">
    <div class="user-list-container">
        <h1 class="welcome-message text-4xl font-bold mb-4 text-center">Manage Users, <%= username %>!</h1>
        <form class="search-bar" action="userList.jsp" method="get">
            <input type="text" name="search" placeholder="Search by username" value="<%= searchQuery %>">
            <button type="submit">Search</button>
        </form>
        <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
        <% } %>
        <table class="user-table">
            <thead>
            <tr>
                <th>Username</th><th>Email</th><th>NIC</th><th>Role</th><th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% for (User u : users) { %>
            <tr>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getNic() %></td>
                <td><%= u.getRole() %></td>
                <td>
                    <button class="action-btn update-btn" onclick="openUpdateModal('<%= u.getUsername() %>','<%= u.getEmail() %>')">Update</button>
                    <form action="adminUsers" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="username" value="<%= u.getUsername() %>">
                        <button type="submit" class="action-btn delete-btn"
                                onclick="return confirm('Delete <%= u.getUsername()%>?');">
                            Delete
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Update Modal -->
<div id="updateModal" class="modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeUpdateModal()">×</span>
        <h2>Update User</h2>
        <form action="adminUsers" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="updateUsername" name="username">
            <label>Email:</label>
            <input type="email" id="updateEmail" name="email" required>
            <label>New Password:</label>
            <input type="password" id="updatePassword" name="password">
            <label>Confirm:</label>
            <input type="password" id="updateConfirmPassword" name="confirm-password">
            <button type="submit" class="submit-btn">Update</button>
            <button type="button" class="close-btn" onclick="closeUpdateModal()">Cancel</button>
        </form>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>Quick Links</h3>
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="UserBooking.html.html" id="footer-booking">Booking</a></li>
                <li><a href="/admin/availability">Availability</a></li>
                <li><a href="login.html">Contact Us</a></li>
                <li><a href="adminFeedback.html">Feedback</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>Locations</h3>
            <p>City Center Parking</p>
            <p>Airport Parking</p>
            <p>Mall Parking</p>
            <p>Residential Parking</p>
        </div>
        <div class="footer-column">
            <h3>Customer Support</h3>
            <p>📞 +94 76 228 2585</p>
            <p>✉️ GR5@gmail.com</p>
            <p>📍 123 Parking St, Colombo, SL</p>
        </div>
        <div class="footer-column footer-social">
            <h3>Stay Connected</h3>
            <div>
                <a href="https://www.facebook.com"><img src="https://img.icons8.com/ios-filled/35/ffffff/facebook-new.png" alt="Facebook" loading="lazy"></a>
                <a href="https://www.youtube.com"><img src="https://img.icons8.com/ios-filled/35/ffffff/youtube-play.png" alt="YouTube" loading="lazy"></a>
                <a href="https://www.instagram.com"><img src="https://img.icons8.com/ios-filled/35/ffffff/instagram-new.png" alt="Instagram" loading="lazy"></a>
                <a href="https://x.com"><img src="https://img.icons8.com/ios-filled/35/ffffff/twitter.png" alt="Twitter" loading="lazy"></a>
            </div>
        </div>
    </div>
</footer>

<script>
    // Logout confirmation
    document.getElementById('logout-btn').addEventListener('click', e => {
        if (!confirm('Are you sure you want to log out?')) e.preventDefault();
    });

    // Preloader
    window.addEventListener('load', () => {
        const pre = document.getElementById('preloader');
        pre.classList.add('hide');
        setTimeout(() => pre.remove(), 800);
    });

    // Modal
    function openUpdateModal(u, e) {
        document.getElementById('updateUsername').value = u;
        document.getElementById('updateEmail').value = e;
        document.getElementById('updatePassword').value = '';
        document.getElementById('updateConfirmPassword').value = '';
        document.getElementById('updateModal').style.display = 'flex';
    }
    function closeUpdateModal() {
        document.getElementById('updateModal').style.display = 'none';
    }
    // Footer animation on scroll
    const footer = document.querySelector('.footer');
    const footerObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                document.querySelectorAll('.footer-column').forEach((col, i) => {
                    col.style.opacity = '1';
                    col.style.transform = 'translateY(0)';
                    col.style.transition = `all 0.6s ease ${i * 0.3}s`;
                });
            }
        });
    }, { threshold: 0.2 });

    document.querySelectorAll('.footer-column').forEach(col => {
        col.style.opacity = '0';
        col.style.transform = 'translateY(50px)';
        footerObserver.observe(footer);
    });
</script>

</body>
</html>
