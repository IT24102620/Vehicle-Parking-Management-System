<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.FileFeedbackDAO, model.Feedback, model.User, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parklot - My Feedback</title>
    <link href="https://fonts.googleapis.com/css2?family=Kaushan+Script&family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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

        /* Table and Form Styles */
        .dashboard {
            padding: 120px 20px 60px;
            flex: 1 0 auto;
            position: relative;
        }
        .user-table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(5px);
            border-radius: 15px;
            overflow: hidden;
            margin: 20px auto;
            max-width: 1300px;
        }
        .user-table th, .user-table td {
            padding: 20px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            color: #fff;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
            background: rgba(255, 255, 255, 0.2);
        }
        .user-table th.comment-edit, .user-table td.comment-edit {
            min-width: 200px;
        }
        .user-table th {
            background: linear-gradient(45deg, #6B46C1, #ED64A6);
            font-size: 18px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .user-table td {
            font-size: 16px;
        }
        .user-table tr:hover {
            background: rgba(237, 100, 166, 0.2);
        }
        form {
            display: inline;
        }
        input[type=text], input[type=number] {
            width: 100%;
            max-width: 300px;
            padding: 4px;
            border-radius: 4px;
            border: 1px solid #666;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            box-sizing: border-box;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
        }
        input[type=number] {
            width: 60px;
        }
        input[type=text]:disabled, input[type=number]:disabled {
            background: rgba(255, 255, 255, 0.05);
            color: #ccc;
            cursor: not-allowed;
            text-shadow: none;
        }
        button {
            padding: 6px;
            margin: 2px;
            border: none;
            border-radius: 4px;
            background: #ED64A6;
            color: #fff;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        button:hover {
            background: #C5307A;
        }
        .comment-text {
            font-size: 0.95rem;
            color: #fff;
            font-weight: 400;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 300px;
            word-wrap: break-word;
            display: inline-block;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
            justify-content: center;
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
            .user-table {
                width: 95%;
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

<!-- Feedback Section -->
<section class="dashboard">
    <div id="particles"></div>
    <div class="welcome-section">
        <h1>My Feedback</h1>
    </div>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.html?error=Please log in to access the feedback page");
            return;
        }
        String username = user.getUsername();
        FileFeedbackDAO dao = new FileFeedbackDAO();
        List<Feedback> all = new ArrayList<>();
        for (String cat : new String[]{"general", "parking", "payment", "request"}) {
            all.addAll(
                    dao.findByCategory(cat).stream()
                            .filter(fb -> fb.getUsername().equals(username))
                            .toList()
            );
        }
    %>
    <table class="user-table">
        <tr>
            <th>Category</th>
            <th class="comment-edit">Comment & Edit</th>
            <th>Rating</th>
            <th>Actions</th>
        </tr>
        <%
            for (Feedback fb : all) {
        %>
        <tr>
            <td><%=fb.getCategory()%></td>
            <td class="comment-edit">
                <form action="editFeedback" method="post" id="form-<%=fb.getId()%>">
                    <input type="hidden" name="id" value="<%=fb.getId()%>"/>
                    <input type="hidden" name="category" value="<%=fb.getCategory()%>"/>
                    <span class="comment-text"><%=fb.getComment()%></span>
                    <input type="text" name="comment" value="<%=fb.getComment()%>" required disabled class="edit-input"/>
                    <input type="number" name="rating" value="<%=fb.getRating()%>" min="1" max="5" disabled class="edit-input"/>
                </form>
            </td>
            <td><%=fb.getRating()%></td>
            <td class="action-buttons">
                <button type="button" class="edit-btn" onclick="toggleEdit('<%=fb.getId()%>')">
                    <i class="fas fa-edit"></i>
                </button>
                <button type="submit" form="form-<%=fb.getId()%>" class="save-btn" style="display: none;">
                    <i class="fas fa-save"></i>
                </button>
                <form action="deleteFeedback" method="post">
                    <input type="hidden" name="id" value="<%=fb.getId()%>"/>
                    <input type="hidden" name="category" value="<%=fb.getCategory()%>"/>
                    <button type="submit"><i class="fas fa-trash"></i></button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
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
    document.querySelectorAll('#logout-btn').forEach(btn => {
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

    // Feedback table edit toggle
    function toggleEdit(id) {
        const form = document.getElementById('form-' + id);
        const inputs = form.querySelectorAll('.edit-input');
        const saveBtn = form.closest('tr').querySelector('.save-btn');
        const editBtn = form.closest('tr').querySelector('.edit-btn');
        const commentText = form.querySelector('.comment-text');

        const isDisabled = inputs[0].disabled;
        inputs.forEach(input => input.disabled = !isDisabled);
        saveBtn.style.display = isDisabled ? 'inline-block' : 'none';
        editBtn.style.display = isDisabled ? 'none' : 'inline-block';
        commentText.style.display = isDisabled ? 'none' : 'inline-block';
    }

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