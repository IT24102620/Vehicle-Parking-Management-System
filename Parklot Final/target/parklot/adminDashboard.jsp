<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Parklot - Admin Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>

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

    /* ===== Main Content ===== */
    .main-content {
      margin-left: 80px;
      transition: margin-left 0.3s ease;
      padding: 40px 20px; flex: 1;
    }
    .sidebar:hover ~ .main-content { margin-left: 240px; }
    .welcome-message { text-shadow: 2px 2px 10px rgba(0,0,0,0.5); }
    .grid-card h3 { font-size: 1.25rem; font-weight: 600; color: #ECC94B; margin-bottom: 0.5rem; }
    .grid-card p { color: #4A5568; margin-bottom: 1rem; }

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
  <div class="max-w-6xl mx-auto">
    <h1 class="welcome-message text-5xl font-extrabold text-yellow-400 text-center py-8 mb-8">Welcome to Parklot Admin, ${sessionScope.user.username}!</h1>
    <p class="text-lg text-center text-white mb-12 text-shadow-md">Manage your locations, bookings, and users all in one place.</p>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <div class="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition grid-card">
        <h3>Manage Slot</h3>
        <p>Add, update, or remove parking slot details.</p>
        <a href="AvailabilityAdmin.html" class="inline-block px-4 py-2 bg-gradient-to-r from-red-400 to-yellow-400 text-gray-800 rounded-full hover:scale-105 transition">View Slot's</a>
      </div>
      <div class="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition grid-card">
        <h3>View Bookings</h3>
        <p>Check and manage recent bookings from users.</p>
        <a href="AdminBooking.html" class="inline-block px-4 py-2 bg-gradient-to-r from-red-400 to-yellow-400 text-gray-800 rounded-full hover:scale-105 transition">View Bookings</a>
      </div>
      <div class="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition grid-card">
        <h3>Manage Users</h3>
        <p>Browse and manage all registered users in the system.</p>
        <a href="userList.jsp" class="inline-block px-4 py-2 bg-gradient-to-r from-red-400 to-yellow-400 text-gray-800 rounded-full hover:scale-105 transition">View Users</a>
      </div>
      <div class="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition grid-card">
        <h3>View FeedBack</h3>
        <p>Generate summaries and view key metrics about application performance..</p>
        <a href="admin_review.jsp" class="inline-block px-4 py-2 bg-gradient-to-r from-red-400 to-yellow-400 text-gray-800 rounded-full hover:scale-105 transition">View Feed back</a>
      </div>
    </div>

    <div class="mini-display bg-black bg-opacity-30 border border-gray-200 rounded-2xl shadow-2xl p-6 mt-12 backdrop-blur-md">
      <h2 class="text-2xl font-extrabold text-yellow-400 mb-6 text-center drop-shadow-lg">Admin UI Preview</h2>
      <div class="p-[2px] rounded-xl bg-white bg-opacity-10 overflow-hidden">
        <iframe src="dashboard.jsp" class="w-full h-[450px] rounded-lg border-none" loading="lazy"></iframe>
      </div>
    </div>
  </div>
</div>

<!-- Footer -->
<footer class="footer">
  <div class="footer-container">
    <div class="footer-column">
      <h3>Quick Links</h3>
      <ul>
        <li><a href="index.jsp">Home</a></li>
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
