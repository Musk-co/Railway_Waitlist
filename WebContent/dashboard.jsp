<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.waitlist.model.User" %>
<%@ page import="com.waitlist.dao.SearchHistoryDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    long startTime = System.currentTimeMillis();
    System.out.println("✓ DASHBOARD - Loading dashboard.jsp");
    
    User user = (User) session.getAttribute("user");
    if (user == null) {
        System.out.println("✗ DASHBOARD - No user in session, redirecting to login");
        response.sendRedirect("login.jsp");
        return;
    }
    System.out.println("✓ DASHBOARD - User found: " + user.getUsername());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Railway Waitlist Calculator</title>
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

        .user-section {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            text-align: right;
        }

        .user-info p {
            font-size: 14px;
            opacity: 0.9;
        }

        .user-info strong {
            display: block;
            font-size: 16px;
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

        .btn-logout {
            background-color: #d32f2f;
            border-color: #d32f2f;
        }

        .btn-logout:hover {
            background-color: #c62828;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .welcome-card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .welcome-card h2 {
            color: #667eea;
            margin-bottom: 10px;
        }

        .welcome-card p {
            color: #666;
            font-size: 16px;
            line-height: 1.6;
        }

        .role-badge {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 10px;
            text-transform: uppercase;
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .section h3 {
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .action-buttons a {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
            transition: 0.3s;
        }

        .action-buttons a:hover {
            background: #764ba2;
            transform: translateY(-2px);
        }

        .action-buttons a.secondary {
            background: #6c757d;
        }

        .action-buttons a.secondary:hover {
            background: #5a6268;
        }

        .table-responsive {
            overflow-x: auto;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        table thead {
            background: #f5f5f5;
        }

        table th, table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        table th {
            font-weight: 600;
            color: #333;
        }

        table tbody tr:hover {
            background: #f9f9f9;
        }

        .empty-message {
            text-align: center;
            color: #999;
            padding: 30px;
            font-size: 16px;
        }

        .admin-section {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }

        .admin-section h4 {
            color: #856404;
            margin-bottom: 10px;
        }

        .admin-section a {
            display: inline-block;
            background: #ffc107;
            color: #333;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 600;
            margin-top: 10px;
            transition: 0.3s;
        }

        .admin-section a:hover {
            background: #e0a800;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
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

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .user-section {
                flex-direction: column;
            }

            .user-info {
                text-align: center;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-buttons a {
                text-align: center;
            }

            table {
                font-size: 12px;
            }

            table th, table td {
                padding: 8px;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="header-content">
            <div>
                <h1>🚂 Railway Waitlist Calculator</h1>
            </div>
            <div class="user-section">
                <div class="user-info">
                    <p>Welcome!</p>
                    <strong><%= user.getUsername() %></strong>
                    <p><%= user.getEmail() %></p>
                </div>
                <a href="LogoutServlet" class="btn btn-logout">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="welcome-card">
            <h2>Welcome, <%= user.getUsername() %>! 👋</h2>
            <p>Welcome to the Railway Waitlist Probability Calculator. Use this application to check the probability
                of getting a confirmed seat on your desired train.</p>
            <span class="role-badge"><%= user.isAdmin() ? "👑 Administrator" : "👤 User" %></span>
        </div>

        <div class="section">
            <h3>Calculate Waitlist Probability</h3>
            
            <div class="info" style="margin-bottom: 30px;">
                <strong>Instructions:</strong> Enter your train details and waitlist number to calculate the probability of ticket confirmation.
            </div>
            
            <form action="WaitlistServlet" method="post">
                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="trainNo" style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">Train Number:</label>
                    <input type="text" id="trainNo" name="trainNo" required 
                           placeholder="e.g., 12345" maxlength="10"
                           style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                </div>
                
                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="journeyDate" style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">Journey Date (DD-MM-YYYY):</label>
                    <input type="text" id="journeyDate" name="journeyDate" required 
                           placeholder="DD-MM-YYYY (e.g., 15-01-2024)"
                           pattern="\d{2}-\d{2}-\d{4}"
                           title="Please enter date in DD-MM-YYYY format (e.g., 15-01-2024)"
                           style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                    <small style="color: #666; margin-top: 5px; display: block;">Format: DD-MM-YYYY (e.g., 15-01-2024)</small>
                </div>
                
                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="classType" style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">Class Type:</label>
                    <select id="classType" name="classType" required
                            style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                        <option value="">Select Class</option>
                        <option value="AC1">AC First Class (1A)</option>
                        <option value="AC2">AC 2 Tier (2A)</option>
                        <option value="AC3">AC 3 Tier (3A)</option>
                        <option value="SL">Sleeper (SL)</option>
                        <option value="CC">Chair Car (CC)</option>
                        <option value="2S">Second Sitting (2S)</option>
                    </select>
                </div>
                
                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="waitlistNumber" style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">Waitlist Number:</label>
                    <input type="number" id="waitlistNumber" name="waitlistNumber" required 
                           placeholder="e.g., 5" min="0" max="999"
                           style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                </div>
                
                <button type="submit" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 12px 30px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: 600; width: 100%; transition: 0.3s;">Calculate Probability</button>
            </form>
            
            <div style="margin-top: 20px; text-align: center; color: #666;">
                <small>Note: This calculator uses historical booking data to predict confirmation probability.</small>
                <br>
                <small>✓ You can select past dates (15-01-2024 to 19-06-2024) to test with available data.</small>
            </div>
        </div>

        <div class="section">
            <h3>Quick Actions</h3>
            <div class="action-buttons">
                <a href="dashboard.jsp" class="secondary">📊 Refresh</a>
                <% if (user.isAdmin()) { %>
                    <a href="admin.jsp">⚙️ Admin Dashboard</a>
                    <a href="stats.jsp" class="secondary">📈 Statistics</a>
                <% } %>
            </div>

            <% if (user.isAdmin()) { %>
                <div class="admin-section">
                    <h4>👑 Administrator Access</h4>
                    <p>As an administrator, you have access to additional features for managing the system.</p>
                    <a href="admin.jsp">Go to Admin Panel</a>
                </div>
            <% } %>
        </div>

        <div class="section">
            <h3>Your Recent Searches</h3>
            <% 
                List<Map<String, Object>> searches = null;
                try {
                    long queryStart = System.currentTimeMillis();
                    System.out.println("✓ DASHBOARD - Fetching search history for user: " + user.getUserId());
                    SearchHistoryDAO historyDAO = new SearchHistoryDAO();
                    searches = historyDAO.getUserSearchHistory(user.getUserId(), 5);
                    long queryEnd = System.currentTimeMillis();
                    System.out.println("✓ DASHBOARD - Search history fetched in " + (queryEnd - queryStart) + "ms, records: " + (searches != null ? searches.size() : 0));
                } catch (Exception e) {
                    System.err.println("✗ DASHBOARD - Error loading search history: " + e.getMessage());
                    e.printStackTrace();
                }
            %>
            
            <% if (searches != null && !searches.isEmpty()) { %>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Train Number</th>
                                <th>Journey Date</th>
                                <th>Class</th>
                                <th>Waitlist Number</th>
                                <th>Probability (%)</th>
                                <th>Searched At</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> search : searches) { %>
                                <tr>
                                    <td><%= search.get("train_no") %></td>
                                    <td><%= search.get("journey_date") %></td>
                                    <td><%= search.get("class_type") %></td>
                                    <td><%= search.get("waitlist_number") %></td>
                                    <td><%= String.format("%.2f", search.get("probability")) %></td>
                                    <td><%= search.get("searched_at") %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="empty-message">
                    <p>No search history yet. <a href="index.jsp">Start by checking a train's probability</a></p>
                </div>
            <% } %>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <h4>Account Status</h4>
                <div class="value"><%= user.isActive() ? "✓ Active" : "✗ Inactive" %></div>
            </div>
            <div class="stat-card">
                <h4>Member Since</h4>
                <div class="value" style="font-size: 16px;"><%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0, 10) : "N/A" %></div>
            </div>
            <div class="stat-card">
                <h4>Last Login</h4>
                <div class="value" style="font-size: 16px;"><%= user.getLastLogin() != null ? user.getLastLogin().toString().substring(0, 10) : "First Login" %></div>
            </div>
        </div>
    </div>
</body>
</html>
