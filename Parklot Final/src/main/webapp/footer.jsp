<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
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
    // Footer animation on view
    const footer = document.querySelector('.footer');
    const obs = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                document.querySelectorAll('.footer-column').forEach((col, i) => {
                    col.classList.add('visible'); col.style.transitionDelay = `${i * 0.3}s`;
                });
                obs.unobserve(footer);
            }
        });
    }, { threshold: 0.2 });
    obs.observe(footer);
</script>
