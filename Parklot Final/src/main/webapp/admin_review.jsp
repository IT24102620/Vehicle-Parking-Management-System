<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Optional, dao.FileFeedbackDAO, model.Feedback, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Feedback Review</title>
    <style>
        /* Global & Background */
        body, html { margin:0; padding:0; height:100%;
            background-image:
                    linear-gradient(45deg, #6B46C1, #ED64A6, #F6E05E),
                    url('https://images.unsplash.com/photo-1502161254066-6c74afbf07aa?q=80&w=1471');
            background-repeat:no-repeat,no-repeat;
            background-size:cover,cover;
            background-attachment:fixed,fixed;
            background-blend-mode:overlay;
            font-family:'Poppins',sans-serif; color:#fff;
        }
        body::before { content:''; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:-1; }
        :root{--sidebar-width:80px}
        .main-content{margin-left:var(--sidebar-width);padding:1rem}

        /* Heading */
        .feedback-heading {
            text-align: center;
            font-family: 'Montserrat', 'Poppins', sans-serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: #FFFFFF;
            text-shadow: 0 0 8px rgba(0, 0, 0, 0.7), 0 0 12px rgba(246, 224, 94, 0.5);
            background: rgba(89, 37, 198, 0.37);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            display: inline-block;
            animation: fadeInScale 1s ease-in-out;
            margin: 1rem auto;
        }
        @keyframes fadeInScale {
            0% { opacity: 0; transform: scale(0.8); }
            100% { opacity: 1; transform: scale(1); }
        }

        /* Tabs */
        .tabs, .subtabs { display:flex; gap:1rem; list-style:none; padding:0; margin:1rem 0; }
        .tabs li, .subtabs li {
            cursor:pointer; padding:.5rem 1rem; border-radius:4px;
            background:rgba(255,255,255,0.1);
        }
        .tabs li.active, .subtabs li.active {
            background:linear-gradient(45deg,#6B46C1,#ED64A6,#F6E05E);
        }

        /* Charts */
        .chart-row { display:flex; flex-wrap:wrap; gap:1rem; margin:2rem 0; }
        .chart-box { flex:1 1 250px; background:rgba(0,0,0,0.6); padding:1rem; border-radius:8px; text-align:center; }

        /* Tables */
        table { width:100%; border-collapse:collapse; background:rgba(0,0,0,0.6); margin-top:1rem; }
        th, td { padding:.5rem; border:1px solid #444; color:#fff; text-align:left; }
        th { background:linear-gradient(45deg,#6B46C1,#ED64A6,#F6E05E); }

        /* Buttons */
        .btn-approve, .btn-unassign, .btn-delete { margin:0 .25rem; padding:.3rem .6rem; border:none; border-radius:4px; cursor:pointer; color:#fff; font-size:.8rem; }
        .btn-approve   { background:#28a745; }
        .btn-unassign  { background:#ED8936; }
        .btn-delete    { background:#e53e3e; }

        /* Modal */
        #placePicker { display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%);
            background:rgba(0,0,0,0.9); padding:1.5rem; border-radius:8px; z-index:10000;
        }
        #placePicker h3 { color:#fff; text-align:center; }
        #placePicker .slot-btn { background:#ED64A6; color:#fff; padding:.5rem 1rem; border:none; border-radius:4px; cursor:pointer; margin:0 .25rem; }
        #placePicker .cancel-btn { background:#777; color:#fff; padding:.3rem .6rem; border:none; border-radius:4px; cursor:pointer; margin-top:1rem; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<jsp:include page="sidebar.jsp"/>

<div class="main-content">
    <h1 class="feedback-heading" >Feedback Manager</h1>
    <%
        FileFeedbackDAO dao = new FileFeedbackDAO();
        String[] categories = {"all", "general", "parking", "payment", "request"};
        String activeCat    = Optional.ofNullable(request.getParameter("category")).orElse("all");
        String[] statuses   = {"all", "approved", "unapproved"};
        String activeStatus = Optional.ofNullable(request.getParameter("status")).orElse("all");

        List<Feedback> feedbacks;
        if ("approved".equals(activeStatus)) {
            feedbacks = dao.findAllApproved();
        } else {
            feedbacks = new ArrayList<>();
            if ("all".equals(activeCat)) {
                for (String cat : new String[]{"general", "parking", "payment", "request"}) {
                    for (Feedback fb : dao.findByCategory(cat)) {
                        if ("all".equals(activeStatus) || ("unapproved".equals(activeStatus) && !fb.isApproved())) {
                            feedbacks.add(fb);
                        }
                    }
                }
            } else {
                for (Feedback fb : dao.findByCategory(activeCat)) {
                    if ("all".equals(activeStatus) || ("unapproved".equals(activeStatus) && !fb.isApproved())) {
                        feedbacks.add(fb);
                    }
                }
            }
        }
        int[] ratingCounts = new int[5];
        for (Feedback fb : feedbacks) { int r = fb.getRating(); if (r>=1&&r<=5) ratingCounts[r-1]++; }
        int[] catCounts = new int[categories.length - 1];
        int[][] stacked = new int[categories.length - 1][5];
        for (int i = 0; i < categories.length - 1; i++) {
            List<Feedback> list = dao.findByCategory(categories[i + 1]);
            catCounts[i] = list.size();
            for (Feedback fb : list) {
                int r = fb.getRating(); if (r>=1&&r<=5) stacked[i][r-1]++;
            }
        }
    %>

    <!-- Category Tabs -->
    <ul class="tabs">
        <% for (String c : categories) { %>
        <li class="<%= c.equals(activeCat) ? "active" : "" %>"
            onclick="location.href='<%= request.getContextPath() %>/admin_review.jsp?category=<%= c %>&status=<%= activeStatus %>'">
            <%= c.equals("all") ? "All" : c.substring(0,1).toUpperCase() + c.substring(1) %>
        </li>
        <% } %>
    </ul>

    <!-- Charts -->
    <div class="chart-row">
        <div class="chart-box"><h4>Rating Distribution</h4><canvas id="ratingChart"></canvas></div>
        <div class="chart-box"><h4>Category Trends</h4><canvas id="categoryChart"></canvas></div>
        <div class="chart-box"><h4>Ratings by Category</h4><canvas id="stackedChart"></canvas></div>
    </div>

    <!-- Status Tabs -->
    <ul class="subtabs">
        <% for (String s : statuses) { %>
        <li class="<%= s.equals(activeStatus) ? "active" : "" %>"
            onclick="location.href='<%= request.getContextPath() %>/admin_review.jsp?category=<%= activeCat %>&status=<%= s %>'">
            <%= s.substring(0,1).toUpperCase() + s.substring(1) %>
        </li>
        <% } %>
    </ul>

    <!-- Feedback Table -->
    <table>
        <thead>
        <tr><th>User</th><th>Rating</th><th>Category</th><th>Comment</th><th>Status</th><th>Place</th><th>Actions</th></tr>
        </thead>
        <tbody>
        <% for (Feedback fb : feedbacks) { %>
        <tr>
            <td><%= fb.getUsername() %></td>
            <td><%= fb.getRating() %></td>
            <td><%= fb.getCategory() %></td>
            <td><%= fb.getComment() %></td>
            <td><%= fb.isApproved() ? "Approved" : "Pending" %></td>
            <td><%= fb.isApproved() ? fb.getPlace() : "-" %></td>
            <td>
                <button class="btn-approve" type="button" onclick="showPicker('<%= fb.getId() %>','<%= fb.getCategory() %>','<%= fb.getPlace() %>')">Approve</button>
                <form action="<%= request.getContextPath() %>/unassign" method="post" style="display:inline">
                    <input type="hidden" name="id" value="<%= fb.getId() %>"/>
                    <input type="hidden" name="category" value="<%= fb.getCategory() %>"/>
                    <button class="btn-unassign" type="submit">Unapprove</button>
                </form>
                <form action="<%= request.getContextPath() %>/deleteFeedback" method="post" style="display:inline">
                    <input type="hidden" name="id" value="<%= fb.getId() %>"/>
                    <input type="hidden" name="category" value="<%= fb.getCategory() %>"/>
                    <button class="btn-delete" type="submit">Delete</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<jsp:include page="footer.jsp"/>

<!-- Place Picker Modal -->
<div id="placePicker">
    <h3>Assign to Slot</h3>
    <form id="pickerForm" action="<%= request.getContextPath() %>/approveFeedback" method="post">
        <input type="hidden" name="id" id="pickerId"/>
        <input type="hidden" name="category" id="pickerCategory"/>
        <input type="hidden" name="place" id="pickerPlace"/>
        <div>
            <% for (int i = 1; i <= 6; i++) { %>
            <button type="button" class="slot-btn" onclick="submitPicker(<%= i %>)">Slot <%= i %></button>
            <% } %>
        </div>
        <button type="button" class="cancel-btn" onclick="hidePicker()">Cancel</button>
    </form>
</div>

<script>
    function showPicker(id, category, current) {
        document.getElementById('pickerId').value = id;
        document.getElementById('pickerCategory').value = category;
        document.getElementById('pickerPlace').value = current;
        document.getElementById('placePicker').style.display = 'block';
    }
    function hidePicker() {
        document.getElementById('placePicker').style.display = 'none';
    }
    function submitPicker(place) {
        document.getElementById('pickerPlace').value = place;
        document.getElementById('pickerForm').submit();
    }

    // Charts initialization
    window.addEventListener('DOMContentLoaded', () => {
        const rc = [<%= ratingCounts[0] %>, <%= ratingCounts[1] %>, <%= ratingCounts[2] %>, <%= ratingCounts[3] %>, <%= ratingCounts[4] %>];
        const cc = [<%= catCounts[0] %>, <%= catCounts[1] %>, <%= catCounts[2] %>, <%= catCounts[3] %>];
        const cats = ['General', 'Parking', 'Payment', 'Request'];

        new Chart(document.getElementById('ratingChart'), {
            type: 'doughnut',
            data: { labels: ['1','2','3','4','5'], datasets: [{ data: rc }] }
        });

        new Chart(document.getElementById('categoryChart'), {
            type: 'line',
            data: { labels: cats, datasets: [{ label: 'Count', data: cc, fill: false, tension: 0.4 }] },
            options: { scales: { x: { ticks: { color: '#fff' } }, y: { beginAtZero: true, ticks: { color: '#fff' } } } }
        });

        const stackedData = {
            labels: cats,
            datasets: [
                <% for (int r = 1; r <= 5; r++) { %>
                {
                    label: '<%= r %>\u2605',
                    data: [<%= stacked[0][r-1] %>, <%= stacked[1][r-1] %>, <%= stacked[2][r-1] %>, <%= stacked[3][r-1] %>]
                }<%= r < 5 ? "," : "" %>
                <% } %>
            ]
        };
        new Chart(document.getElementById('stackedChart'), {
            type: 'bar',
            data: stackedData,
            options: { scales: { x: { stacked: true }, y: { stacked: true, beginAtZero: true } } }
        });
    });
</script>
</body>
</html>