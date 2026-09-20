<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    /* Paste your footer CSS here (only footer part from the big style block) */
    .footer {
        padding: 40px 20px;
        background: linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E);
        position: relative; overflow: hidden;
        border-radius: 15px; backdrop-filter: blur(12px);
        margin-top: calc(var(--navbar-height) + 20px);
    }
    .footer::before {
        content: ''; position: absolute; inset: 0;
        background: radial-gradient(circle, rgba(237,100,166,0.2), transparent);
        opacity: 0; transition: opacity 0.6s ease;
    }
    .footer:hover::before { opacity: 1; }
    .footer-container {
        max-width: 1300px; margin: 0 auto;
        display: flex; justify-content: space-around;
        flex-wrap: wrap; gap: 20px;
    }
    .footer-column {
        opacity: 0; transform: translateY(50px);
        transition: all 0.6s ease;
    }
    .footer-column.visible { opacity: 1; transform: translateY(0); }
    .footer-column h3 {
        font-size: 20px; font-family: 'Kaushan Script', cursive;
        color: #F6E05E; margin-bottom: 15px;
        text-shadow: 2px 2px 10px rgba(0,0,0,0.5);
    }
    .footer-column p, .footer-column ul li a {
        font-size: 16px; color: #fff; margin: 8px 0;
        text-decoration: none; transition: all 0.4s ease;
    }
    .footer-column p:hover, .footer-column ul li a:hover {
        color: #FFE4E1; transform: translateX(10px);
        text-shadow: 0 0 8px rgba(255,228,225,0.8);
    }
    .social-icons { display: flex; gap: 15px; }
    .social-icons a {
        color: #fff; font-size: 24px; transition: all 0.4s ease;
    }
    .social-icons a:hover {
        color: #F6E05E; transform: scale(1.2) translateY(-3px);
        text-shadow: 0 0 8px rgba(246,224,94,0.8);
    }
</style>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>Quick Links</h3>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="login.html" id="footer-booking">Booking</a></li>
                <li><a href="login.html">Availability</a></li>
                <li><a href="contact.html">Contact Us</a></li>
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
        <div class="footer-column">
            <h3>Follow Us</h3>
            <div class="social-icons">
                <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                <a href="#" aria-label="WhatsApp"><i class="fab fa-whatsapp"></i></a>
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
