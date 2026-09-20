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
    <title>Parklot - User Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Kaushan+Script&family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
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
            background: linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E); /* Fallback background */
            background-image: url('https://images.unsplash.com/photo-1502161254066-6c74afbf07aa?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
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
            background: rgba(0, 0, 0, 0.2); /* Overlay for better text readability */
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

        /* Dashboard Section */
        .dashboard {
            padding: 120px 20px 60px;
            flex: 1 0 auto;
            position: relative;
        }
        .dashboard-container {
            max-width: 1300px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 40px;
        }
        .dashboard-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(0px);
            padding: 35px;
            border-radius: 25px;
            border: 2px solid rgba(255, 255, 255, 0.2);
            text-align: center;
            transition: all 0.5s ease;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease forwards;
            animation-delay: calc(0.2s * var(--i));
        }
        @keyframes fadeInUp {
            0% { opacity: 0; transform: translateY(30px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .dashboard-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at center, rgba(237, 100, 166, 0.3), transparent);
            opacity: 0;
            transition: opacity 0.5s ease;
        }
        .dashboard-card:hover::before {
            opacity: 1;
        }
        .dashboard-card:hover {
            transform: translateY(-15px) scale(1.05);
            box-shadow: 0 20px 40px rgba(237, 100, 166, 0.5);
        }
        .dashboard-card img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin-bottom: 25px;
            border: 4px solid #F6E05E;
            transition: transform 0.5s ease, box-shadow 0.5s ease;
            object-fit: cover;
        }
        .dashboard-card:hover img {
            transform: scale(1.15) rotate(5deg);
            box-shadow: 0 0 20px rgba(246, 224, 94, 0.8);
        }
        .dashboard-card h3 {
            font-size: 28px;
            font-family: 'Kaushan Script', sans-serif;
            color: #F6E05E;
            margin-bottom: 20px;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5);
        }
        .dashboard-card p {
            font-size: 18px;
            color: #fff;
            margin-bottom: 25px;
            text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
        }
        .dashboard-card .cta-btn {
            padding: 15px 35px;
            background: linear-gradient(45deg, #ED64A6, #F6E05E);
            color: #1A1A15;
            border: none;
            border-radius: 50px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(237, 100, 166, 0.5);
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }
        .dashboard-card .cta-btn:hover {
            background: linear-gradient(45deg, #F6E05E, #ED64A6);
            transform: scale(1.1);
            box-shadow: 0 8px 20px rgba(237, 100, 166, 0.8);
        }
        .dashboard-card .cta-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.5), transparent);
            transition: 0.6s;
        }
        .dashboard-card .cta-btn:hover::before {
            left: 100%;
        }

        /* Welcome Section */
        .welcome-section {
            text-align: center;
            margin-bottom: 60px;
            animation: bounceIn 1s ease forwards;
        }
        @keyframes bounceIn {
            0% { opacity: 0; transform: scale(0.8); }
            60% { opacity: 1; transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        .welcome-section h1 {
            font-size: 52px;
            font-family: 'Kaushan Script', sans-serif;
            color: #F6E05E;
            text-shadow: 4px 4px 20px rgba(0, 0, 0, 0.5);
            margin-bottom: 25px;
        }
        .welcome-section p {
            font-size: 22px;
            color: #fff;
            text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.5);
        }

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
        .footer-social img {
            width: 32px;
            margin: 10px;
            transition: transform 0.5s ease, filter 0.5s ease;
        }
        .footer-social img:hover {
            transform: scale(1.4) rotate(20deg);
            filter: drop-shadow(0 0 8px rgba(237, 100, 166, 0.9));
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .welcome-section h1 {
                font-size: 36px;
            }
            .welcome-section p {
                font-size: 18px;
            }
            .dashboard-container {
                grid-template-columns: 1fr;
            }
            .dashboard-card {
                width: 95%;
                margin: 0 auto;
                padding: 25px;
            }
            .dashboard-card img {
                width: 100px;
                height: 100px;
            }
            .dashboard-card h3 {
                font-size: 24px;
            }
            .dashboard-card p {
                font-size: 16px;
            }
            .dashboard-card .cta-btn {
                padding: 12px 30px;
                font-size: 16px;
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

<!-- Dashboard Section -->
<section class="dashboard">
    <div id="particles"></div>
    <div class="welcome-section">
        <h1>Welcome, <%= username %>!</h1>
        <p>Your vibrant parking journey starts here.</p>
    </div>

    <div class="dashboard-container">
        <div class="dashboard-card" style="--i: 1">
            <img src="https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Book a Spot">
            <h3>Book a Spot</h3>
            <p>Reserve your parking space with ease and style.</p>
            <button class="cta-btn" onclick="window.location.href='UserBooking.html'">Book Now</button>
        </div>
        <div class="dashboard-card" style="--i: 2">
            <img src="https://img.freepik.com/free-photo/luxurious-car-parked-highway-with-illuminated-headlight-sunset_181624-60607.jpg" alt="My Bookings">
            <h3>My Bookings</h3>
            <p>View and manage your active and past bookings.</p>
            <button class="cta-btn" onclick="window.location.href='UserBookingHistory.html'">View Bookings</button>
        </div>
        <div class="dashboard-card" style="--i: 3">
            <img src="https://www.searchenginejournal.com/wp-content/uploads/2020/03/the-top-10-most-popular-online-payment-solutions-5e9978d564973-1280x720.png" alt="Profile">
            <h3>Your Profile</h3>
            <p>Update your details and preferences.</p>
            <button class="cta-btn" onclick="window.location.href='profile.jsp'">Manage Profile</button>
        </div>
        <div class="dashboard-card" style="--i: 4">
            <img src="https://cdn.pixabay.com/photo/2021/07/02/09/39/cars-6381364_960_720.jpg" alt="Live Availability">
            <h3>Live Availability</h3>
            <p>Check real-time parking spot availability.</p>
            <button class="cta-btn" onclick="window.location.href='AvailabilityUser.html'">Check Now</button>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>Quick Links</h3>
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="booking.html">Booking</a></li>
                <li><a href="Availability.html">Availability</a></li>
                <li><a href="#">Contact Us</a></li>
                <li><a href="#">FAQs</a></li>
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

    // Button click effect
    document.querySelectorAll('.cta-btn, #logout-btn').forEach(btn => {
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