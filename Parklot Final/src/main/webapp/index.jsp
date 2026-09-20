<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.FileFeedbackDAO, model.Feedback, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Parklot offers a vibrant, hassle-free parking experience with swift booking, top-notch security, and live updates.">
    <meta name="keywords" content="parking, Parklot, booking, vehicle security, real-time parking">
    <title>Parklot - Vibrant Parking Experience</title>
    <link href="https://fonts.googleapis.com/css2?family=Kaushan+Script&family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body, html {
            font-family: 'Poppins', sans-serif;
            height: 100%;
            overflow-x: hidden;
            color: #fff;
            scroll-behavior: smooth;
        }

        /* Background Slideshow */
        body {
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
            animation: backgroundFade 24s infinite;
        }
        @keyframes backgroundFade {
            0%, 10% { background-image: url('https://images.unsplash.com/photo-1610647752706-3bb12232b3ab?q=80&w=1450&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); }
            12.5%, 22.5% { background-image: url('https://images.unsplash.com/photo-1485463611174-f302f6a5c1c9?q=80&w=1476&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); }
            25%, 35% { background-image: url('https://images.unsplash.com/photo-1485291571150-772bcfc10da5?q=80&w=1528&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); }
            37.5%, 47.5% { background-image: url('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); }
            50%, 60% { background-image: url('https://plus.unsplash.com/premium_photo-1661902046698-40bba703f396?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); }
            62.5%, 72.5% { background-image: url('https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); }
            75%, 85% { background-image: url('https://plus.unsplash.com/premium_photo-1661916866784-cdea580d93f7?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); }
            87.5%, 100% { background-image: url('https://images.unsplash.com/photo-1612917231506-a0825d1bc76d?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); }
        }
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, transparent, rgba(0, 0, 0, 0.3));
            opacity: 0.7;
            z-index: -1;
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
        .logo img {
            width: 60px;
            transition: transform 0.6s ease;
            filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.5));
        }
        .logo img:hover {
            transform: rotate(360deg) scale(1.3);
        }

        /* Special Buttons */
        .nav-right a#signup-btn, .nav-right a#signin-btn {
            background: linear-gradient(45deg, #6B46C1, #ED64A6);
            padding: 12px 25px;
            border-radius: 30px;
            color: #1A1A15;
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(237, 100, 166, 0.5);
            transition: all 0.4s ease;
            margin: 0 15px;
        }
        .nav-right a#signup-btn:hover, .nav-right a#signin-btn:hover {
            background: linear-gradient(45deg, #ED64A6, #6B46C1);
            transform: translateY(-4px) scale(1.1);
            box-shadow: 0 8px 25px rgba(237, 100, 166, 0.8);
        }
        .nav-right a#signup-btn {
            background: linear-gradient(45deg, #ED64A6, #F6E05E);
            animation: pulse 2.5s infinite;
        }
        .nav-right a#signup-btn:hover {
            background: linear-gradient(45deg, #F6E05E, #ED64A6);
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); box-shadow: 0 4px 15px rgba(237, 100, 166, 0.5); }
            50% { transform: scale(1.05); box-shadow: 0 6px 25px rgba(237, 100, 166, 0.8); }
        }

        /* Home Section */
        .home {
            position: relative;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            background: rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        .home-content {
            padding: 50px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 25px;
            backdrop-filter: blur(0px);
            animation: bounceIn 1.8s ease forwards;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.4);
            position: relative;
            z-index: 2;
        }
        @keyframes bounceIn {
            0% { opacity: 0; transform: scale(0.7); }
            60% { opacity: 1; transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        .home-content h1 {
            font-size: 80px;
            font-weight: 800;
            font-family: 'Kaushan Script', sans-serif;
            color: #F6E05E;
            text-shadow: 4px 4px 20px rgba(0, 0, 0, 0.6);
            margin-bottom: 25px;
            overflow: hidden;
            white-space: nowrap;
        }
        .home-content p {
            font-size: 28px;
            color: #fff;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5);
            opacity: 0;
            animation: fadeInUp 1.2s ease 1.8s forwards;
        }
        @keyframes fadeInUp {
            0% { opacity: 0; transform: translateY(30px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .cta-btn {
            padding: 20px 60px;
            background: linear-gradient(45deg, #ED64A6, #F6E05E);
            color: #1A1A15;
            border: none;
            border-radius: 50px;
            font-size: 22px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 6px 20px rgba(237, 100, 166, 0.6);
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }
        .cta-btn:hover {
            background: linear-gradient(45deg, #F6E05E, #ED64A6);
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 10px 30px rgba(237, 100, 166, 0.8);
        }
        .cta-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.5), transparent);
            transition: 0.6s;
        }
        .cta-btn:hover::before {
            left: 100%;
        }

        /* Features Section */
        .features {
            padding: 80px 0;
            background: rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 2;
        }
        .features-container {
            max-width: 1300px;
            margin: 0 auto;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 50px;
        }
        .feature-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 25px;
            width: 350px;
            text-align: center;
            border: 2px solid rgba(237, 100, 166, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(237, 100, 166, 0.4);
            border-color: #ED64A6;
        }
        .feature-card img {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            margin-bottom: 30px;
            border: 4px solid #ED64A6;
            transition: transform 0.3s ease;
        }
        .feature-card:hover img {
            transform: scale(1.1);
        }
        .feature-card h3 {
            font-size: 28px;
            color: #F6E05E;
            font-family: 'Kaushan Script', sans-serif;
            margin-bottom: 20px;
        }
        .feature-card p {
            font-size: 18px;
            color: #fff;
            text-shadow: 1px 1px 8px rgba(0, 0, 0, 0.5);
        }

        /* Feedback Section */
        .feedback {
            padding: 80px 0;
            background: rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 2;
        }
        .feedback h2 {
            font-size: 48px;
            font-family: 'Kaushan Script', sans-serif;
            color: #F6E05E;
            text-align: center;
            margin-bottom: 50px;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5);
        }
        .feedback-container {
            max-width: 1300px;
            margin: 0 auto;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 50px;
        }
        .feedback-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 25px;
            width: 350px;
            text-align: center;
            border: 2px solid rgba(237, 100, 166, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .feedback-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(237, 100, 166, 0.4);
            border-color: #ED64A6;
        }
        .feedback-card h3 {
            font-size: 24px;
            color: #F6E05E;
            font-family: 'Kaushan Script', sans-serif;
            margin-bottom: 15px;
        }
        .feedback-card p {
            font-size: 16px;
            color: #fff;
            text-shadow: 1px 1px 8px rgba(0, 0, 0, 0.5);
            margin-bottom: 10px;
        }
        .feedback-card .rating {
            font-size: 18px;
            color: #FFE4E1;
            font-weight: 600;
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
            .home-content h1 {
                font-size: 50px;
            }
            .home-content p {
                font-size: 20px;
            }
            .cta-btn {
                padding: 16px 50px;
                font-size: 18px;
            }
            .features-container, .feedback-container {
                flex-direction: column;
                align-items: center;
            }
            .feature-card, .feedback-card {
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
<!-- Preloader -->
<div id="preloader">
    <div class="loader"></div>
</div>

<!-- Navbar -->
<nav>
    <div class="nav-left">
        <a href="index.jsp" class="logo" aria-label="Parklot home page"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Parklot Logo" loading="lazy"></a>
        <a href="index.jsp" aria-label="Home page">Home</a>
        <a href="login.html" aria-label="Register page">Register Vehicle</a>
        <a href="login.html" aria-label="Check availability">Availability</a>
        <a href="login.html" aria-label="Book a parking spot">Booking</a>
        <a href="login.html" aria-label="Provide feedback">Feedback</a>
        <a href="login.html" aria-label="All feedback">My Feedbacks</a>
    </div>
    <div class="nav-right">
        <a href="Signup.html" id="signup-btn" aria-label="Sign up for Parklot">Sign Up</a>
        <a href="login.html" id="signin-btn" aria-label="Sign in to Parklot">Sign In</a>
    </div>
</nav>

<!-- Home Section -->
<section class="home">
    <div class="home-content">
        <h1 id="typing-text"></h1>
        <p>Discover a vibrant, hassle-free parking experience with Parklot!</p>
        <button class="cta-btn book-now-btn" aria-label="Log in to book a parking spot">Park Now</button>
    </div>
</section>

<!-- Features Section -->
<section class="features">
    <div class="features-container">
        <div class="feature-card">
            <img src="https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Swift Booking Feature">
            <h3>Swift Booking</h3>
            <p>Secure your parking spot instantly with our dynamic system.</p>
        </div>
        <div class="feature-card">
            <img src="https://www.searchenginejournal.com/wp-content/uploads/2020/03/the-top-10-most-popular-online-payment-solutions-5e9978d564973-1280x720.png" alt="Safe and Sound Feature">
            <h3>Safe & Sound</h3>
            <p>Your vehicle is protected with top-notch security.</p>
        </div>
        <div class="feature-card">
            <img src="https://img.freepik.com/free-photo/luxurious-car-parked-highway-with-illuminated-headlight-sunset_181624-60607.jpg" alt="Live Updates Feature">
            <h3>Live Updates</h3>
            <p>Get real-time parking insights with a colorful twist.</p>
        </div>
    </div>
</section>

<!-- Feedback Section -->
<section class="feedback">
    <h2>User Feedback</h2>
    <div class="feedback-container">
        <%
            FileFeedbackDAO dao = new FileFeedbackDAO();
            List<Feedback> approvedFeedbacks = dao.findAllApproved();
            for (Feedback fb : approvedFeedbacks) {
        %>
        <div class="feedback-card">
            <h3><%= fb.getCategory().substring(0, 1).toUpperCase() + fb.getCategory().substring(1) %> Feedback</h3>
            <p><%= fb.getComment() %></p>
            <p class="rating">Rating: <%= fb.getRating() %>/5</p>
        </div>
        <% } %>
        <% if (approvedFeedbacks.isEmpty()) { %>
        <div class="feedback-card">
            <h3>No Feedback Available</h3>
            <p>We currently have no approved feedback to display.</p>
        </div>
        <% } %>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>Quick Links</h3>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="UserBooking.html" id="footer-booking">Booking</a></li>
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
            <p>✉ GR5@gmail.com</p>
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

    // Typing effect for hero headline
    const typingText = document.getElementById('typing-text');
    const text = "Parklot - Unleash Easy Parking";
    let index = 0;
    function type() {
        if (index < text.length) {
            typingText.textContent += text.charAt(index);
            index++;
            setTimeout(type, 120);
        }
    }
    setTimeout(type, 500);

    // Simulated login state
    let isLoggedIn = false;

    // Button interaction
    const bookNowBtn = document.querySelector('.book-now-btn');
    bookNowBtn.addEventListener('click', () => {
        if (isLoggedIn) {
            window.location.href = 'booking.html';
        } else {
            window.location.href = 'login.html';
        }
    });

    // Feature and feedback card click handling
    document.querySelectorAll('.feature-card').forEach(card => {
        card.addEventListener('click', (e) => {
            e.stopPropagation();
            console.log(`Clicked ${card.querySelector('h3').textContent}`);
        });
    });

    // Feature and feedback card animation on scroll
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry, i) => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0) scale(1)';
                entry.target.style.transition = `all 0.7s ease ${i * 0.2}s`;
            }
        });
    }, { threshold: 0.3 });

    document.querySelectorAll('.feature-card, .feedback-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(80px) scale(0.9)';
        observer.observe(card);
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

    // Spark effect on buttons
    document.querySelectorAll('#signup-btn, #signin-btn, .cta-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            for (let i = 0; i < 5; i++) {
                const spark = document.createElement('div');
                spark.classList.add('sparkle');
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
</script>
</body>
</html>