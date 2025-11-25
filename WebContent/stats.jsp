<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.waitlist.model.User" %>
<%@ page import="com.waitlist.dao.SearchHistoryDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistics - Railway Waitlist Calculator</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
        }

        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        h1 {
            font-size: 24px;
        }

        .btn {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 10px 20px;
            border: 1px solid white;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .nav-links a {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
            transition: 0.3s;
        }

        .nav-links a:hover {
            background: #764ba2;
        }

        .nav-links a.active {
            background: #d32f2f;
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .section h2 {
            color: #667eea;
            margin-bottom: 20px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 8px;
            text-align: center;
        }

        .stat-card h4 {
            font-size: 14px;
            opacity: 0.9;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .stat-card .value {
            font-size: 32px;
            font-weight: bold;
        }

        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .chart-container {
            position: relative;
            height: 300px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .chart-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
        }

        .back-link:hover {
            background: #5a6268;
        }

        .empty-message {
            text-align: center;
            color: #999;
            padding: 30px;
        }

        @media (max-width: 768px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }

            .chart-container {
                height: 400px;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="header-content">
            <h1>📈 Statistics Dashboard</h1>
            <a href="LogoutServlet" class="btn">Logout</a>
        </div>
    </header>

    <div class="container">
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>

        <div class="nav-links">
            <a href="admin.jsp">Admin Panel</a>
            <a href="stats.jsp" class="active">Statistics</a>
        </div>

        <div class="section">
            <h2>📊 System Statistics & Analytics</h2>

            <div class="stats-grid">
                <div class="stat-card">
                    <h4>Total Users</h4>
                    <div class="value">
                        <%
                            try {
                                com.waitlist.dao.UserDAO userDAO = new com.waitlist.dao.UserDAO();
                                long totalUsers = userDAO.getTotalUsers();
                                out.print(totalUsers);
                            } catch (Exception e) {
                                out.print("--");
                            }
                        %>
                    </div>
                </div>
                <div class="stat-card">
                    <h4>Total Searches</h4>
                    <div class="value">
                        <%
                            try {
                                com.waitlist.dao.SearchHistoryDAO historyDAO = new com.waitlist.dao.SearchHistoryDAO();
                                long totalSearches = historyDAO.getTotalSearches();
                                out.print(totalSearches);
                            } catch (Exception e) {
                                out.print("--");
                            }
                        %>
                    </div>
                </div>
                <div class="stat-card">
                    <h4>Average Probability</h4>
                    <div class="value">
                        <%
                            try {
                                com.waitlist.dao.SearchHistoryDAO historyDAO = new com.waitlist.dao.SearchHistoryDAO();
                                double avgProb = historyDAO.getAverageProbability();
                                out.print(String.format("%.2f%%", avgProb));
                            } catch (Exception e) {
                                out.print("--");
                            }
                        %>
                    </div>
                </div>
            </div>

            <div class="charts-grid">
                <div class="chart-container">
                    <div class="chart-title">Top 5 Trains by Searches</div>
                    <canvas id="trainChart"></canvas>
                </div>
                <div class="chart-container">
                    <div class="chart-title">Probability Distribution</div>
                    <canvas id="probChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Fetch train statistics and render chart
        document.addEventListener('DOMContentLoaded', function() {
            renderChartsWithDummyData();
        });

        function renderChartsWithDummyData() {
            // Train Statistics Chart
            const trainCtx = document.getElementById('trainChart').getContext('2d');
            new Chart(trainCtx, {
                type: 'bar',
                data: {
                    labels: ['Train 12345', 'Train 16789', 'Train 20135', 'Train 24681', 'Train 30246'],
                    datasets: [{
                        label: 'Number of Searches',
                        data: [45, 38, 32, 28, 22],
                        backgroundColor: [
                            'rgba(102, 126, 234, 0.7)',
                            'rgba(118, 75, 162, 0.7)',
                            'rgba(56, 142, 60, 0.7)',
                            'rgba(251, 140, 0, 0.7)',
                            'rgba(211, 47, 47, 0.7)'
                        ],
                        borderColor: [
                            'rgba(102, 126, 234, 1)',
                            'rgba(118, 75, 162, 1)',
                            'rgba(56, 142, 60, 1)',
                            'rgba(251, 140, 0, 1)',
                            'rgba(211, 47, 47, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Probability Distribution Chart
            const probCtx = document.getElementById('probChart').getContext('2d');
            new Chart(probCtx, {
                type: 'doughnut',
                data: {
                    labels: ['0-20%', '20-40%', '40-60%', '60-80%', '80-100%'],
                    datasets: [{
                        label: 'Probability Ranges',
                        data: [15, 25, 30, 20, 10],
                        backgroundColor: [
                            'rgba(211, 47, 47, 0.7)',
                            'rgba(251, 140, 0, 0.7)',
                            'rgba(251, 192, 45, 0.7)',
                            'rgba(56, 142, 60, 0.7)',
                            'rgba(33, 150, 243, 0.7)'
                        ],
                        borderColor: [
                            'rgba(211, 47, 47, 1)',
                            'rgba(251, 140, 0, 1)',
                            'rgba(251, 192, 45, 1)',
                            'rgba(56, 142, 60, 1)',
                            'rgba(33, 150, 243, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }
    </script>
</body>
</html>
