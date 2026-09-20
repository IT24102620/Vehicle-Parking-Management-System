<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // Session and authentication check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.html?error=Please log in to access the dashboard");
        return;
    }
    String username = user.getUsername();
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String selectedCategory = request.getParameter("category") != null ? request.getParameter("category") : "general";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Feedback - Parklot</title>
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
            background: rgba(0, 0, 0, 0.2);
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

        /* Spacer for navbar */
        .spacer { height: 80px; }

        /* Container */
        .container {
            max-width: 600px;
            margin: 2rem auto 4rem auto;
            background: rgba(0, 0, 0, 0.6);
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 20px #ecc94baa;
            animation: fadeInUp 1s ease forwards;
        }
        h2 {
            text-align: center;
            margin-bottom: 1.5rem;
            font-size: 2rem;
            letter-spacing: 1.5px;
            color: #F6E05E;
            text-shadow: 0 0 8px #F6E05E;
            animation: glow 3s ease-in-out infinite alternate;
        }

        /* Form Elements */
        label {
            display: block;
            margin: 1rem 0 0.5rem;
            font-weight: 600;
            color: #f6e05e;
        }
        select, input, textarea {
            width: 100%;
            padding: 0.6rem;
            margin-bottom: 1rem;
            border: none;
            border-radius: 6px;
            background: #222;
            color: #f6e05e;
            font-family: inherit;
            transition: box-shadow 0.3s ease;
        }
        select:focus, input:focus, textarea:focus {
            box-shadow: 0 0 12px #ecc94dcc;
            outline: none;
        }

        /* Dynamic Sections */
        .section { display: none; }
        .section.active { display: block; }

        /* Rating Cars */
        .rating {
            display: flex;
            gap: 0.5rem;
            margin: 1rem 0;
            justify-content: center;
        }
        .rating input { display: none; }
        .rating label {
            width: 30px;
            height: 30px;
            cursor: pointer;
            transition: all 0.3s ease;
            filter: brightness(0.5);
        }
        .rating label img {
            width: 100%;
            height: 100%;
        }
        .rating input:checked ~ label,
        .rating input:hover ~ label,
        .rating label:hover {
            filter: brightness(1) drop-shadow(0 0 10px rgba(236, 201, 75, 0.8));
            animation: glowRating 0.5s ease-in-out;
        }
        @keyframes glowRating {
            0% { filter: brightness(1) drop-shadow(0 0 5px rgba(236, 201, 75, 0.5)); }
            50% { filter: brightness(1.2) drop-shadow(0 0 15px rgba(236, 201, 75, 1)); }
            100% { filter: brightness(1) drop-shadow(0 0 10px rgba(236, 201, 75, 0.8)); }
        }

        /* Submit Button */
        button {
            width: 100%;
            padding: 0.8rem;
            background: #ED64A6;
            border: none;
            border-radius: 6px;
            color: #111;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        button:hover {
            background: #D53F8C;
        }

        /* Alerts */
        .alert {
            text-align: center;
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 6px;
            font-weight: 600;
        }
        .success {
            background: #48BB78;
            color: #111;
        }
        .error {
            background: #F56565;
            color: #fff;
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

        /* Animations */
        @keyframes glow {
            0% { text-shadow: 0 0 6px #F6E05E; }
            100% { text-shadow: 0 0 20px #ecc94dee; }
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
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
<div class="spacer"></div>

<div class="container">
    <h2>Submit Your Feedback</h2>
    <% if (success != null) { %><div class="alert success">Feedback submitted successfully</div><% } %>
    <% if (error != null) { %><div class="alert error">Submission failed, please try again</div><% } %>

    <form action="submitFeedback" method="post" onsubmit="return validateFeedbackForm();">
        <label for="category">Category</label>
        <select id="category" name="category">
            <option value="general" <%= "general".equals(selectedCategory)?"selected":"" %>>General</option>
            <option value="parking" <%= "parking".equals(selectedCategory)?"selected":"" %>>Parking</option>
            <option value="payment" <%= "payment".equals(selectedCategory)?"selected":"" %>>Payment</option>
            <option value="request" <%= "request".equals(selectedCategory)?"selected":"" %>>Request</option>
        </select>

        <!-- General Section -->
        <div id="section-general" class="section active">
            <label for="generalFeedback">Your General Feedback</label>
            <textarea id="generalFeedback" name="generalFeedback" rows="4" placeholder="Share your thoughts..."></textarea>
        </div>

        <!-- Parking Section -->
        <div id="section-parking" class="section">
            <label for="location">Location</label>
            <input type="text" id="location" name="location" placeholder="Enter location...">
            <label for="slot">Slot Number</label>
            <input type="text" id="slot" name="slot" placeholder="Enter slot number...">
        </div>

        <!-- Payment Section -->
        <div id="section-payment" class="section">
            <label for="paymentFeedback">Please place your concern about payment:</label>
            <textarea id="paymentFeedback" name="paymentFeedback" rows="4" placeholder="Explain your payment issue..."></textarea>
        </div>

        <!-- Request Section -->
        <div id="section-request" class="section">
            <label for="reason">Reason</label>
            <select id="reason" name="reason">
                <option value="makeAdmin">Can you make me admin?</option>
                <option value="business">Let's talk business</option>
                <option value="support">Need technical support</option>
                <option value="feedback">General platform feedback</option>
            </select>
        </div>

        <!-- Rating -->
        <label>Rating</label>
        <div class="rating">
            <input type="radio" id="star5" name="rating" value="5"><label for="star5"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Rating 5"></label>
            <input type="radio" id="star4" name="rating" value="4"><label for="star4"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Rating 4"></label>
            <input type="radio" id="star3" name="rating" value="3"><label for="star3"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Rating 3"></label>
            <input type="radio" id="star2" name="rating" value="2"><label for="star2"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Rating 2"></label>
            <input type="radio" id="star1" name="rating" value="1" checked><label for="star1"><img src="https://img.icons8.com/ios-filled/50/ffffff/car.png" alt="Rating 1"></label>
        </div>

        <!-- Comment -->
        <label for="comment">Comment</label>
        <textarea id="comment" name="comment" rows="4" placeholder="Enter your feedback..." required></textarea>

        <button type="submit">Submit Feedback</button>
    </form>
</div>

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

    // Section toggle
    function updateSections() {
        const cat = document.getElementById('category').value;
        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        document.getElementById('section-' + cat).classList.add('active');
    }
    document.getElementById('category').addEventListener('change', updateSections);
    // Initialize
    updateSections();

    // Form validation
    function validateFeedbackForm() {
        const checked = Array.from(document.getElementsByName('rating')).some(r => r.checked);
        if (!checked) {
            alert('Please select a rating');
            return false;
        }
        return true;
    }

    // Navbar scroll effect
    window.addEventListener('scroll', () => {
        document.querySelector('nav').classList.toggle('scrolled', window.scrollY > 50);
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

    // Button click effect
    document.querySelectorAll('button, #logout-btn').forEach(btn => {
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