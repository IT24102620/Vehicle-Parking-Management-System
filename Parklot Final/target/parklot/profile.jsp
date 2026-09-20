<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
  // Check if the user is logged in
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.html?error=Please+log+in");
    return;
  }
  String username = user.getUsername() != null ? user.getUsername() : "";
  String email = user.getEmail() != null ? user.getEmail() : "";
  String nic = user.getNic() != null ? user.getNic() : "";
  String userRole = user.getRole() != null ? user.getRole() : "User";
  String success = request.getParameter("success");
  String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Parklot - Settings</title>
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link href="https://fonts.googleapis.com/css2?family=Kaushan+Script&family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      scroll-behavior: smooth;
    }
    body, html {
      font-family: 'Poppins', sans-serif;
      min-height: 100vh;
      overflow-x: hidden;
      color: #fff;
      display: flex;
      flex-direction: column;
      background: linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E);
      background: url('https://images.unsplash.com/photo-1502161254066-6c74afbf07aa?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D') center/cover fixed no-repeat;
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      background-attachment: fixed;
    }
    body::before {
      content: '';
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.3);
      z-index: -1;
    }

    /* Preloader */
    #preloader {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(45deg, #EFCA29, #00D2FA, #972826);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 9999;
      transition: opacity 0.8s ease;
    }
    #preloader.hide {
      opacity: 0;
      pointer-events: none;
    }
    .loader {
      width: 80px;
      height: 80px;
      border: 10px solid #fff;
      border-top: 10px solid #EFCA29;
      border-radius: 50%;
      animation: spin 1.2s linear infinite, pulseGlow 2s infinite;
    }
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    @keyframes pulseGlow {
      0%, 100% { box-shadow: 0 0 10px rgba(239, 202, 41, 0.5); }
      50% { box-shadow: 0 0 30px rgba(239, 202, 41, 1); }
    }

    /* Navbar (Unchanged) */
    nav {
      position: fixed;
      top: 0;
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E);
      backdrop-filter: blur(10px);
      padding: 15px 40px;
      z-index: 1000;
      transition: all 0.5s ease;
    }
    nav.scrolled {
      background: linear-gradient(45deg, #805AD5, #F687B3, #FBBF24);
      padding: 10px 40px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    }
    .nav-left, .nav-right {
      display: flex;
      align-items: center;
    }
    .nav-left a, .nav-right a {
      color: #fff;
      text-decoration: none;
      margin: 0 25px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      transition: all 0.3s ease;
      position: relative;
    }
    .nav-left a:hover, .nav-right a:hover {
      color: #FFE4E1;
      transform: translateY(-2px);
      text-shadow: 0 0 15px rgba(255, 228, 225, 0.8);
    }
    .nav-left a::after, .nav-right a::after {
      content: '';
      position: absolute;
      width: 0;
      height: 2px;
      bottom: -6px;
      left: 0;
      background: #FFE4E1;
      transition: width 0.4s ease;
    }
    .nav-left a:hover::after, .nav-right a:hover::after {
      width: 100%;
    }
    .logo img {
      width: 60px;
      transition: transform 0.6s ease;
      filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.5));
    }
    .logo img:hover {
      transform: rotate(360deg) scale(1.3);
    }
    #logout-btn {
      background: linear-gradient(45deg, #ED64A6, #F6E05E);
      padding: 12px 25px;
      border-radius: 30px;
      color: #1A1A15;
      font-weight: 700;
      box-shadow: 0 4px 15px rgba(237, 100, 166, 0.5);
      transition: all 0.4s ease;
      margin: 0 15px;
    }
    #logout-btn:hover {
      background: linear-gradient(45deg, #F6E05E, #ED64A6);
      transform: translateY(-4px) scale(1.1);
      box-shadow: 0 8px 25px rgba(237, 100, 166, 0.8);
    }

    /* Profile Section */
    .content-wrapper {
      margin: 120px 40px 100px 40px;
      display: flex;
      flex-direction: column;
      align-items: center;
      flex: 1 0 auto;
    }
    @media (max-width: 768px) {
      .content-wrapper {
        margin: 100px 20px 200px 20px;
      }
    }
    .settings-container {
      width: 100%;
      max-width: 600px;
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      border-radius: 16px;
      overflow: hidden;
      margin-bottom: 60px;
      position: relative;
      animation: fadeInUp 0.6s ease forwards;
    }
    @keyframes fadeInUp {
      0% { opacity: 0; transform: translateY(30px); }
      100% { opacity: 1; transform: translateY(0); }
    }
    .settings-content {
      padding: 40px;
      text-align: center;
    }
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

    /* Particles */
    #particles {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      pointer-events: none;
      z-index: 0;
    }
    .particle {
      position: absolute;
      width: 10px;
      height: 10px;
      background: radial-gradient(circle, rgba(237, 100, 166, 0.8), transparent);
      border-radius: 50%;
      animation: float 8s infinite ease-in-out;
    }
    @keyframes float {
      0%, 100% { transform: translateY(0) scale(1); }
      50% { transform: translateY(-30px) scale(1.2); }
    }

    /* Footer */
    /* Footer */
    .footer {
      padding: 40px 20px;
      background: linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E);
      position: relative;
      overflow: hidden;
      border-radius: 15px;
      backdrop-filter: blur(12px);
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
    .footer-social i {
      font-size: 32px;
      margin: 10px;
      color: #fff;
      transition: transform 0.5s ease, filter 0.5s ease;
    }
    .footer-social i:hover {
      transform: scale(1.4) rotate(20deg);
      filter: drop-shadow(0 0 8px rgba(237, 100, 166, 0.9));
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .settings-container {
        padding: 20px;
      }
      .settings-content h1 {
        font-size: 24px;
      }
      .profile-form input {
        font-size: 14px;
      }
      .nav-left a, .nav-right a {
        margin: 0 15px;
        font-size: 14px;
      }
      .logo img {
        width: 50px;
      }
      #logout-btn {
        padding: 10px 20px;
        font-size: 14px;
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
<div id="preloader">
  <div class="loader"></div>
</div>

<!-- Navbar (Unchanged) -->
<nav>
  <div class="nav-left">
    <a href="dashboard.jsp" class="logo"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Logo" loading="lazy"></a>
    <a href="dashboard.jsp" aria-label="Home page">Home</a>
    <a href="registerVehicle.jsp" aria-label="Register page">Register Vehicle</a>
    <a href="AvailabilityUser.html" aria-label="Check availability">Availability</a>
    <a href="UserBooking.html" aria-label="Book a parking spot">Booking</a>
    <a href="UserBookingHistory.html" aria-label="View booking history">Booking History</a>
    <a href="feedback_form.jsp" aria-label="Provide feedback">Feedback</a>
    <a href="feedback_list.jsp" aria-label="All feedback">My Feedbacks</a>
    <a href="profile.jsp" aria-label="View profile">My Profile</a>
  </div>
  <div class="nav-right">
    <a href="index.jsp" id="logout-btn" aria-label="Log out from Parklot">Log Out</a>
  </div>
</nav>

<!-- Profile Section -->
<div class="content-wrapper">
  <div class="settings-container">
    <div class="settings-content">
      <h1 class="text-2xl md:text-3xl font-bold text-yellow-300 mb-4">User Profile</h1>
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
<!-- Footer (Unchanged) -->
<footer class="footer" role="contentinfo">
  <div class="footer-container">
    <div class="footer-column">
      <h3>Quick Links</h3>
      <ul>
        <li><a href="index.html">Home</a></li>
        <li><a href="login.html" id="footer-booking">Booking</a></li>
        <li><a href="login.html">Availability</a></li>
        <li><a href="login.html">Contact Us</a></li>
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
      <p>✉️ <a href="mailto:support@parklot.com">support@parklot.com</a></p>
      <p>📍 123 Parking St, Colombo, SL</p>
    </div>
    <div class="footer-column footer-social">
      <h3>Stay Connected</h3>
      <div>
        <a href="https://facebook.com" target="_blank" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
        <a href="https://youtube.com" target="_blank" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
        <a href="https://instagram.com" target="_blank" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
        <a href="https://twitter.com" target="_blank" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
      </div>
    </div>
  </div>
</footer>

<script>
  window.showSection = function(id) {
    document.querySelectorAll('.profile-details, .profile-form').forEach(el => el.classList.remove('active'));
    document.getElementById(id).classList.add('active');
  };
  // Preloader
  window.addEventListener('load', () => {
    const preloader = document.getElementById('preloader');
    preloader.classList.add('hide');
    setTimeout(() => preloader.remove(), 800);
  });
  const footer = document.querySelector('.footer');
  const footerObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        document.querySelectorAll('.footer-column').forEach((col, i) => {
          col.classList.add('visible');
          col.style.transitionDelay = `${i * 0.3}s`;
        });
        footerObserver.unobserve(footer);
      }
    });
  }, { threshold: 0.2 });

  footerObserver.observe(footer);

  // Navbar scroll effect
  window.addEventListener('scroll', () => {
    const nav = document.querySelector('nav');
    nav.classList.toggle('scrolled', window.scrollY > 50);
  });

  // Particles
  const particlesContainer = document.getElementById('particles');
  for (let i = 0; i < 30; i++) {
    const particle = document.createElement('div');
    particle.classList.add('particle');
    particle.style.left = `${Math.random() * 100}%`;
    particle.style.top = `${Math.random() * 100}%`;
    particle.style.animationDelay = `${Math.random() * 8}s`;
    particlesContainer.appendChild(particle);
  }

  // Show/Hide Password Toggle
  const togglePassword = document.getElementById('toggle-password');
  const passwordInput = document.getElementById('password');
  const confirmPasswordInput = document.getElementById('confirm-password');

  togglePassword.addEventListener('click', () => {
    const isPasswordVisible = passwordInput.type === 'text';
    passwordInput.type = isPasswordVisible ? 'password' : 'text';
    confirmPasswordInput.type = isPasswordVisible ? 'password' : 'text';
    togglePassword.classList.toggle('fa-eye', isPasswordVisible);
    togglePassword.classList.toggle('fa-eye-slash', !isPasswordVisible);
  });

  // Form validation
  function validateForm() {
    let isValid = true;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirm-password').value;
    const emailError = document.getElementById('email-error');
    const passwordError = document.getElementById('password-error');
    const confirmPasswordError = document.getElementById('confirm-password-error');

    // Reset errors
    emailError.style.display = 'none';
    passwordError.style.display = 'none';
    confirmPasswordError.style.display = 'none';

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      emailError.style.display = 'block';
      isValid = false;
    }

    // Password validation
    if (password && password.length < 6) {
      passwordError.style.display = 'block';
      isValid = false;
    }

    // Confirm password validation
    if (password && password !== confirmPassword) {
      confirmPasswordError.style.display = 'block';
      isValid = false;
    }

    return isValid;
  }

  // Profile container animation on scroll
  const settingsContainer = document.querySelector('.settings-container');
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        entry.target.style.transition = 'all 0.6s ease';
      }
    });
  }, { threshold: 0.2 });

  settingsContainer.style.opacity = '0';
  settingsContainer.style.transform = 'translateY(60px)';
  observer.observe(settingsContainer);

  // Button click effect
  document.querySelectorAll('.profile-toolbar button, #logout-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      for (let i = 0; i < 5; i++) {
        const spark = document.createElement('div');
        spark.classList.add('spark');
        spark.style.position = 'absolute';
        spark.style.left = `${e.offsetX + (Math.random() - 0.5) * 20}px`;
        spark.style.top = `${e.offsetY + (Math.random() - 0.5) * 20}px`;
        spark.style.width = '6px';
        spark.style.height = '6px';
        spark.style.background = 'rgba(237, 100, 166, 0.9)';
        spark.style.borderRadius = '50%';
        spark.style.pointerEvents = 'none';
        btn.appendChild(spark);

        setTimeout(() => {
          spark.style.transform = `translate(${(Math.random() - 0.5) * 50}px, ${(Math.random() - 0.5) * 50}px) scale(2)`;
          spark.style.opacity = '0';
          spark.style.transition = 'all 0.5s ease';
        }, 10);

        setTimeout(() => spark.remove(), 500);
      }
    });
  });

  // Debug image loading
  window.addEventListener('load', () => {
    const bgImage = new Image();
    bgImage.src = 'https://images.unsplash.com/photo-1502161254066-6c74afbf07aa?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    bgImage.onload = () => console.log('Background image loaded successfully');
    bgImage.onerror = () => console.error('Failed to load background image');
  });
</script>
</body>
</html>