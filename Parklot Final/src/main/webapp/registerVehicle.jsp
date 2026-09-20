<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
  // Check if the user is logged in
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.html?error=Please log in to access the dashboard");
    return;
  }
  String username = user.getUsername();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Register a vehicle with Parklot.">
  <meta name="keywords" content="vehicle registration, Parklot">
  <title>Register Vehicle - Parklot</title>
  <link href="https://fonts.googleapis.com/css2?family=Kaushan+Script&family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body, html {
      font-family: 'Poppins', sans-serif;
      min-height: 100vh;
      overflow-x: hidden;
      color: #fff;
      display: flex;
      flex-direction: column;
      background: linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E); /* Fallback background */
      background-image: url('https://images.unsplash.com/photo-1502161254066-6c74afbf07aa?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      background-attachment: fixed;
    }

    /* Background Slideshow */
    #background-slideshow {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: -1;
      overflow: hidden;
      isolation: isolate;
    }
    .bg-image {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-size: cover;
      background-position: center;
      opacity: 0;
      transform: scale(1.2) rotate(0.5deg);
      transition: opacity 3s ease;
      will-change: transform, opacity;
      filter: brightness(0.9);
    }
    .bg-image.active {
      opacity: 1;
      transform: scale(1) rotate(0deg);
    }
    .bg-image.parallax {
      transition: transform 0.1s ease;
    }
    .bg-image::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: radial-gradient(circle, transparent, rgba(0, 0, 0, 0.3));
      opacity: 0.7;
    }
    .sparkle {
      position: absolute;
      width: 8px;
      height: 8px;
      background: radial-gradient(circle, rgba(255, 215, 0, 0.9), transparent);
      border-radius: 50%;
      pointer-events: none;
      animation: sparkleFade 1.5s ease forwards;
    }
    @keyframes sparkleFade {
      0% { opacity: 1; transform: scale(1); }
      100% { opacity: 0; transform: scale(2) translateY(-50px); }
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

    /* Navbar */
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
    .nav-right a#logout-btn::after {
      content: none;
    }
    .logo img {
      width: 60px;
      transition: transform 0.6s ease;
      filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.5));
    }
    .logo img:hover {
      transform: rotate(360deg) scale(1.3);
    }
    .nav-right a#logout-btn {
      background: linear-gradient(45deg, #ED64A6, #F6E05E);
      padding: 12px 25px;
      border-radius: 30px;
      color: #1A1A15;
      font-weight: 700;
      box-shadow: 0 4px 15px rgba(237, 100, 166, 0.5);
      transition: all 0.4s ease;
      margin: 0 15px;
      animation: pulse 2.5s infinite;
    }
    .nav-right a#logout-btn:hover {
      background: linear-gradient(45deg, #F6E05E, #ED64A6);
      transform: translateY(-4px) scale(1.1);
      box-shadow: 0 8px 25px rgba(237, 100, 166, 0.8);
    }
    @keyframes pulse {
      0%, 100% { transform: scale(1); box-shadow: 0 4px 15px rgba(237, 100, 166, 0.5); }
      50% { transform: scale(1.05); box-shadow: 0 6px 25px rgba(237, 100, 166, 0.8); }
    }

    /* Form Section */
    .management-section {
      padding: 120px 20px 60px;
      text-align: center;
      position: relative;
      z-index: 2;
    }
    .management-section h2 {
      font-size: 36px;
      color: #F6E05E;
      font-family: 'Kaushan Script', sans-serif;
      margin-bottom: 40px;
      text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5);
    }
    .management-section form {
      max-width: 600px;
      margin: 0 auto;
      background: rgba(255, 255, 255, 0.12);
      padding: 40px;
      border-radius: 25px;
      backdrop-filter: blur(15px);
      border: 2px solid rgba(237, 100, 166, 0.3);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
    }
    .management-section label {
      display: block;
      font-size: 18px;
      color: #fff;
      margin-bottom: 10px;
      text-align: left;
    }
    .management-section input, .management-section select {
      width: 100%;
      padding: 12px;
      margin-bottom: 20px;
      border: none;
      border-radius: 10px;
      background: rgba(255, 255, 255, 0.5);
      color: #1A1A15;
      font-size: 16px;
      transition: all 0.3s ease;
    }
    .management-section select option {
      background: #fff;
      color: #1A1A15;
    }
    .management-section input:focus, .management-section select:focus {
      outline: none;
      background: rgba(255, 255, 255, 0.7);
      box-shadow: 0 0 10px rgba(237, 100, 166, 0.5);
    }
    .management-section input[readonly] {
      background: rgba(255, 255, 255, 0.3);
      cursor: not-allowed;
    }
    .management-section button {
      padding: 12px 30px;
      background: linear-gradient(45deg, #ED64A6, #F6E05E);
      color: #1A1A15;
      border: none;
      border-radius: 25px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    .management-section button:hover {
      background: linear-gradient(45deg, #F6E05E, #ED64A6);
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(237, 100, 166, 0.6);
    }
    .message {
      text-align: center;
      margin-bottom: 20px;
      font-size: 16px;
      color: #F6E05E;
      text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.5);
    }
    .error {
      color: #FF6B6B;
    }

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
      .management-section form {
        width: 90%;
      }
      .nav-left a, .nav-right a {
        margin: 0 15px;
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
      .logo img {
        width: 50px;
      }
    }
  </style>
</head>
<body>
<!-- Background Slideshow -->
<div id="background-slideshow"></div>

<!-- Preloader -->
<div id="preloader">
  <div class="loader"></div>
</div>

<!-- Navbar -->
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

<!-- Register Vehicle Section -->
<section id="register-vehicle" class="management-section">
  <h2>Register Vehicle</h2>
  <% if (request.getAttribute("success") != null) { %>
  <div class="message"><%= request.getAttribute("success") %></div>
  <% } %>
  <% if (request.getAttribute("error") != null) { %>
  <div class="message error"><%= request.getAttribute("error") %></div>
  <% } %>
  <form action="/registerVehicle" method="post">
    <label for="vehicle-type">Vehicle Type:</label>
    <select id="vehicle-type" name="vehicle-type" required>
      <option value="Car">Car</option>
      <option value="Van">Van</option>
      <option value="Truck">Truck</option>
      <option value="Motorcycle">Motorcycle</option>
    </select>
    <label for="license-plate">License Plate:</label>
    <input type="text" id="license-plate" name="license-plate" required>
    <label for="owner">Owner:</label>
    <input type="text" id="owner" name="owner" value="<%= username != null ? username : "" %>" readonly required>
    <button type="submit">Register</button>
  </form>
</section>

<!-- Footer -->
<footer class="footer">
  <div class="footer-container">
    <div class="footer-column">
      <h3>Quick Links</h3>
      <ul>
        <li><a href="index.jsp" aria-label="Home page">Home</a></li>
        <li><a href="booking.jsp" aria-label="Book a parking spot">Booking</a></li>
        <li><a href="availability.jsp" aria-label="Check availability">Availability</a></li>
        <li><a href="contact.jsp" aria-label="Contact us">Contact Us</a></li>
      </ul>
    </div>
    <div class="footer-column">
      <h3>Vehicle Types</h3>
      <p>Car</p>
      <p>Van</p>
      <p>Truck</p>
      <p>Motorcycle</p>
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
  // Background Slideshow
  const images = [
    'https://images.unsplash.com/photo-1610647752706-3bb12232b3ab',
    'https://images.unsplash.com/photo-1485463611174-f302f6a5c1c9',
    'https://images.unsplash.com/photo-1485291571150-772bcfc10da5',
    'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d',
    'https://plus.unsplash.com/premium_photo-1661902046698-40bba703f396',
    'https://images.unsplash.com/photo-1506521781263-d8422e82f27a',
    'https://plus.unsplash.com/premium_photo-1661916866784-cdea580d93f7',
    'https://images.unsplash.com/photo-1612917231506-a0825d1bc76d'
  ];
  const slideshow = document.getElementById('background-slideshow');
  let currentIndex = 0;

  images.forEach((src, index) => {
    const div = document.createElement('div');
    div.classList.add('bg-image');
    const img = new Image();
    img.src = src;
    img.onload = () => {
      div.style.backgroundImage = `url(${src})`;
      if (index === 0) div.classList.add('active');
      slideshow.appendChild(div);
    };
    img.onerror = () => {
      div.style.backgroundImage = `url('/images/fallback.jpg')`;
      if (index === 0) div.classList.add('active');
      slideshow.appendChild(div);
    };
  });

  function changeBackground() {
    const images = document.querySelectorAll('.bg-image');
    if (images.length) {
      images[currentIndex].classList.remove('active');
      currentIndex = (currentIndex + 1) % images.length;
      images[currentIndex].classList.add('active');
    }
  }
  setInterval(changeBackground, 6000);

  // Preloader
  window.addEventListener('load', () => {
    const preloader = document.getElementById('preloader');
    preloader.classList.add('hide');
    setTimeout(() => preloader.remove(), 800);
  });

  // Navbar scroll effect
  window.addEventListener('scroll', () => {
    const nav = document.querySelector('nav');
    nav.classList.toggle('scrolled', window.scrollY > 50);
  });
</script>
</body>
</html>