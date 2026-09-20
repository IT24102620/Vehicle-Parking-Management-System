<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    model.User user = (model.User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.html?error=Please+log+in");
        return;
    }
    String success = request.getParameter("success");
    String error   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Parklot - Settings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body, html {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            background: url('https://images.unsplash.com/photo-1502161254066-6c74afbf07aa?q=80&w=1471') center/cover fixed no-repeat;
            color: #fff; position: relative;
        }
        body::before {
            content: '';
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.3);
            z-index: -1;
        }
        .sidebar {
            position: fixed; top: 0; left: 0;
            height: 100%; width: 80px;
            background: linear-gradient(45deg,#6B46C1,#ED64A6,#F6E05E);
            backdrop-filter: blur(12px);
            display: flex; flex-direction: column; align-items: center;
            padding-top: 20px;
            transition: width 0.3s ease;
            z-index: 1000;
        }
        .sidebar:hover { width: 240px; }
        .sidebar .logo img {
            width: 60px; margin-bottom: 30px;
            transition: transform 0.6s ease;
        }
        .sidebar .logo img:hover { transform: rotate(360deg) scale(1.3); }
        .sidebar-link {
            position: relative;
            width: 100%; padding: 12px;
            display: flex; align-items: center; justify-content: center;
            color: #fff; text-decoration: none;
            transition: background 0.3s, justify-content 0.3s;
        }
        .sidebar-link img {
            width: 24px; height: 24px;
            margin-right: 0;
            transition: margin 0.3s;
        }
        .link-text {
            display: none; white-space: nowrap; opacity: 0;
            transition: opacity 0.3s;
        }
        .sidebar:hover .sidebar-link { justify-content: flex-start; padding-left: 20px; }
        .sidebar:hover .sidebar-link img { margin-right: 15px; }
        .sidebar:hover .link-text { display: inline; opacity: 1; }
        .sidebar:not(:hover) .sidebar-link:hover::after {
            content: attr(data-text);
            position: absolute; left: 80px; top: 50%; transform: translateY(-50%);
            background: rgba(0,0,0,0.75);
            padding: 4px 8px; border-radius: 4px;
            white-space: nowrap; opacity: 0;
            animation: fadeIn 0.2s forwards;
            pointer-events: none; font-size: 0.9em;
            color: #fff;
        }
        @keyframes fadeIn { to { opacity: 1; } }
        @media (max-width:768px) { .sidebar { display: none; } }

        .content-wrapper {
            margin-left: 80px; padding: 40px;
            padding-bottom: 100px;
            display: flex;
            flex-direction: column;
            align-items: center;

        }
        .sidebar:hover ~ .content-wrapper { margin-left: 240px; }
        @media (max-width:768px) { .content-wrapper { margin-left: 0; padding: 20px; padding-bottom: 200px; } }

        .settings-container {
            width: 100%; max-width: 600px;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 16px; overflow: hidden;
            margin-bottom: 60px;
        }
        .settings-content { padding: 40px; text-align: center; }
        .profile-toolbar {
            display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 30px;
            justify-content: center;
        }
        .profile-toolbar button,
        .profile-toolbar form button {
            flex: 1; min-width: 120px; padding: 10px 20px;
            background: linear-gradient(45deg,#ED64A6,#F6E05E);
            color: #1A1A15; font-weight: 600;
            border: none; border-radius: 20px;
            transition: transform 0.3s;
        }
        .profile-toolbar button:hover,
        .profile-toolbar form button:hover { transform: scale(1.05); }
        .profile-details, .profile-form { display: none; }
        .profile-details.active, .profile-form.active { display: block; }
        .profile-form input { margin: 0 auto; }

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


<div class="content-wrapper">
    <div class="settings-container">
        <div class="settings-content">
            <h1 class="text-2xl md:text-3xl font-bold text-yellow-300 mb-4">Settings</h1>
            <p class="text-base md:text-lg mb-6">Manage your account details.</p>
            <% if (success != null) { %>
            <div class="mb-4 p-3 bg-green-100 text-green-900 rounded"><%= success %></div>
            <% } else if (error != null) { %>
            <div class="mb-4 p-3 bg-red-100 text-red-900 rounded"><%= error %></div>
            <% } %>

            <div class="profile-toolbar">
                <button type="button" onclick="showSection('profile-details')">My Profile</button>
                <button type="button" onclick="showSection('profile-form')">Update Profile</button>
                <form action="<%= request.getContextPath() %>/adminUsers" method="post" onsubmit="return confirm('Delete your account?');">
                    <input type="hidden" name="action" value="delete" />
                    <input type="hidden" name="username" value="<%= user.getUsername() %>" />
                    <button type="submit">Delete Profile</button>
                </form>
            </div>

            <div id="profile-details" class="profile-details space-y-3 active">
                <p><strong>Username:</strong> <%= user.getUsername() %></p>
                <p><strong>Email:</strong>    <%= user.getEmail()    %></p>
                <p><strong>NIC:</strong>      <%= user.getNic()      %></p>
                <p><strong>Role:</strong>     <%= user.getRole()     %></p>
            </div>

            <form id="profile-form" class="profile-form space-y-4" action="<%= request.getContextPath() %>/UpdateProfileServlet" method="post">
                <div><label>Email</label><input type="email" name="email" value="<%= user.getEmail() %>" required class="w-full border border-white bg-transparent rounded p-2 text-white"/></div>
                <div><label>NIC</label><input type="text" name="nic" value="<%= user.getNic() %>" required class="w-full border border-white bg-transparent rounded p-2 text-white"/></div>
                <div><label>New Password</label><input type="password" name="password" class="w-full border border-white bg-transparent rounded p-2 text-white"/></div>
                <div><label>Confirm Password</label><input type="password" name="confirm-password" class="w-full border border-white bg-transparent rounded p-2 text-white"/></div>
                <button type="submit" class="w-full py-2 bg-gradient-to-r from-red-400 to-yellow-400 text-gray-900 rounded">Save Changes</button>
            </form>
        </div>
    </div>
</div>

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
    window.showSection = function(id) {
        document.querySelectorAll('.profile-details, .profile-form').forEach(el => el.classList.remove('active'));
        document.getElementById(id).classList.add('active');
    };
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
