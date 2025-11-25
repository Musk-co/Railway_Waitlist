<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.waitlist.model.User" %>
<%@ page import="com.waitlist.model.Train" %>
<%@ page import="java.util.List" %>

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
    <title>Admin Dashboard - Railway Waitlist Calculator</title>
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
            background: linear-gradient(135deg, #d32f2f 0%, #c62828 100%);
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

        .nav-tabs {
            background: white;
            border-bottom: 2px solid #d32f2f;
            display: flex;
            gap: 0;
            margin-bottom: 30px;
            border-radius: 8px 8px 0 0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .nav-tabs a {
            padding: 15px 25px;
            text-decoration: none;
            color: #555;
            font-weight: 600;
            border-right: 1px solid #eee;
            transition: 0.3s;
        }

        .nav-tabs a:last-child {
            border-right: none;
        }

        .nav-tabs a:hover, .nav-tabs a.active {
            background: #d32f2f;
            color: white;
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .section h2 {
            color: #d32f2f;
            margin-bottom: 20px;
            border-bottom: 2px solid #d32f2f;
            padding-bottom: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #d32f2f 0%, #c62828 100%);
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

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .action-buttons form {
            display: inline;
        }

        .action-buttons button {
            padding: 6px 12px;
            font-size: 12px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-promote {
            background: #4CAF50;
            color: white;
        }

        .btn-promote:hover {
            background: #45a049;
        }

        .btn-demote {
            background: #FF9800;
            color: white;
        }

        .btn-demote:hover {
            background: #e68900;
        }

        .btn-deactivate {
            background: #d32f2f;
            color: white;
        }

        .btn-deactivate:hover {
            background: #c62828;
        }

        .role-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: 600;
        }

        .role-admin {
            background: #d32f2f;
            color: white;
        }

        .role-user {
            background: #2196F3;
            color: white;
        }

        .status-active {
            color: #4CAF50;
            font-weight: 600;
        }

        .status-inactive {
            color: #d32f2f;
            font-weight: 600;
        }

        .empty-message {
            text-align: center;
            color: #999;
            padding: 30px;
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

        /* Toast Notification Styles */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-width: 400px;
        }

        .toast {
            background: white;
            padding: 16px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.3s ease-out;
            min-width: 300px;
        }

        .toast.success {
            border-left: 4px solid #4CAF50;
            background: #f1f8f4;
        }

        .toast.success .icon {
            color: #4CAF50;
            font-size: 20px;
        }

        .toast.success .message {
            color: #2d7a3a;
            font-weight: 500;
        }

        .toast.error {
            border-left: 4px solid #d32f2f;
            background: #f8f1f1;
        }

        .toast.error .icon {
            color: #d32f2f;
            font-size: 20px;
        }

        .toast.error .message {
            color: #8b1515;
            font-weight: 500;
        }

        .toast.info {
            border-left: 4px solid #2196F3;
            background: #f1f7f8;
        }

        .toast.info .icon {
            color: #2196F3;
            font-size: 20px;
        }

        .toast.info .message {
            color: #1565a0;
            font-weight: 500;
        }

        .toast-close {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #999;
            padding: 0;
            margin-left: auto;
        }

        .toast-close:hover {
            color: #333;
        }

        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }

        .toast.removing {
            animation: slideOut 0.3s ease-out;
        }

        @media (max-width: 768px) {
            .nav-tabs {
                flex-direction: column;
            }

            .nav-tabs a {
                border-right: none;
                border-bottom: 1px solid #eee;
            }

            .nav-tabs a:last-child {
                border-bottom: none;
            }

            table {
                font-size: 12px;
            }

            table th, table td {
                padding: 8px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-buttons button {
                width: 100%;
            }

            .toast-container {
                right: 10px;
                left: 10px;
                max-width: none;
            }

            .toast {
                min-width: auto;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="header-content">
            <h1>👑 Admin Dashboard</h1>
            <a href="LogoutServlet" class="btn">Logout</a>
        </div>
    </header>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <script>
        function showToast(message, type = 'success', duration = 4000) {
            const container = document.getElementById('toastContainer');
            
            const icon = type === 'success' ? '✓' : type === 'error' ? '✕' : 'ℹ';
            
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            toast.innerHTML = `
                <span class="icon">${icon}</span>
                <span class="message">${message}</span>
                <button class="toast-close" onclick="this.parentElement.classList.add('removing'); setTimeout(() => this.parentElement.remove(), 300);">×</button>
            `;
            
            container.appendChild(toast);
            
            if (duration > 0) {
                setTimeout(() => {
                    if (toast.parentElement) {
                        toast.classList.add('removing');
                        setTimeout(() => toast.remove(), 300);
                    }
                }, duration);
            }
        }

        // Show toast from URL parameter if present
        window.addEventListener('load', function() {
            const params = new URLSearchParams(window.location.search);
            if (params.has('message')) {
                const message = decodeURIComponent(params.get('message'));
                showToast(message, 'success', 4000);
            }
            if (params.has('error')) {
                const error = decodeURIComponent(params.get('error'));
                showToast(error, 'error', 5000);
            }
            
            // Clean up URL
            if (params.has('message') || params.has('error')) {
                const cleanUrl = window.location.pathname + '?' + 
                    Array.from(params.entries())
                        .filter(([key]) => key !== 'message' && key !== 'error')
                        .map(([key, value]) => `${key}=${value}`)
                        .join('&');
                window.history.replaceState({}, document.title, cleanUrl);
            }
        });
    </script>

    <div class="container">
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>

        <div class="nav-tabs">
            <a href="AdminServlet?action=dashboard" class="<%= (request.getParameter("action") == null || "dashboard".equals(request.getParameter("action"))) ? "active" : "" %>">📊 Dashboard</a>
            <a href="AdminServlet?action=users" class="<%= "users".equals(request.getParameter("action")) ? "active" : "" %>">👥 Users</a>
            <a href="AdminServlet?action=trains" class="<%= "trains".equals(request.getParameter("action")) ? "active" : "" %>">🚂 Trains</a>
            <a href="AdminServlet?action=stats" class="<%= "stats".equals(request.getParameter("action")) ? "active" : "" %>">📈 Statistics</a>
        </div>

        <!-- Dashboard View -->
        <% if (request.getParameter("action") == null || "dashboard".equals(request.getParameter("action"))) { %>
            <div class="section">
                <h2>📊 System Overview</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <h4>Total Users</h4>
                        <div class="value"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %></div>
                    </div>
                    <div class="stat-card">
                        <h4>Total Trains</h4>
                        <div class="value"><%= request.getAttribute("totalTrains") != null ? request.getAttribute("totalTrains") : 0 %></div>
                    </div>
                    <div class="stat-card">
                        <h4>Average Probability</h4>
                        <div class="value"><%= request.getAttribute("avgProbability") != null ? request.getAttribute("avgProbability") + "%" : "0%" %></div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- Users Management View -->
        <% if ("users".equals(request.getParameter("action"))) { %>
            <div class="section">
                <h2>👥 User Management</h2>
                
                <% 
                    List<User> users = (List<User>) request.getAttribute("users");
                    if (users != null && !users.isEmpty()) { 
                %>
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Created</th>
                                    <th>Last Login</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User u : users) { %>
                                    <tr>
                                        <td><%= u.getUserId() %></td>
                                        <td><%= u.getUsername() %></td>
                                        <td><%= u.getEmail() %></td>
                                        <td><span class="role-badge <%= u.isAdmin() ? "role-admin" : "role-user" %>"><%= u.isAdmin() ? "Admin" : "User" %></span></td>
                                        <td><span class="<%= u.isActive() ? "status-active" : "status-inactive" %>"><%= u.isActive() ? "Active" : "Inactive" %></span></td>
                                        <td><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                        <td><%= u.getLastLogin() != null ? u.getLastLogin().toString().substring(0, 10) : "Never" %></td>
                                        <td>
                                            <div class="action-buttons">
                                                <% if (!u.isAdmin()) { %>
                                                    <form action="AdminServlet" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="promote_user">
                                                        <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                                        <button type="submit" class="btn-promote">Promote</button>
                                                    </form>
                                                <% } else { %>
                                                    <form action="AdminServlet" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="demote_user">
                                                        <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                                        <button type="submit" class="btn-demote">Demote</button>
                                                    </form>
                                                <% } %>
                                                <% if (u.isActive()) { %>
                                                    <form action="AdminServlet" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="deactivate_user">
                                                        <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                                        <button type="submit" class="btn-deactivate" onclick="return confirm('Are you sure?');">Deactivate</button>
                                                    </form>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="empty-message">
                        <p>No users found or error loading data.</p>
                    </div>
                <% } %>
            </div>
        <% } %>

        <!-- Trains Management View -->
        <% if ("trains".equals(request.getParameter("action"))) { %>
            <div class="section">
                <h2>🚂 Train Management</h2>
                
                <!-- Search Bar -->
                <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                    <form method="GET" action="AdminServlet" id="searchForm" style="display: flex; gap: 10px; align-items: center;">
                        <input type="hidden" name="action" value="trains">
                        <input type="text" name="search" id="searchInput" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" placeholder="🔍 Search by train number, name, source, or destination..." style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;">
                        <button type="submit" style="background: #2196F3; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: 600;">🔍 Search</button>
                        <button type="button" id="clearSearchBtn" onclick="clearSearch()" style="background: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: 600;">✕ Clear</button>
                    </form>
                </div>

                <script>
                    function clearSearch() {
                        document.getElementById('searchInput').value = '';
                        window.location.href = 'AdminServlet?action=trains';
                    }
                </script>
                
                <!-- Add Train Form -->
                <div style="background: #f9f9f9; padding: 20px; border-radius: 8px; margin-bottom: 30px; border: 1px solid #ddd;">
                    <h3 style="color: #d32f2f; margin-bottom: 15px; font-size: 16px;">➕ Add New Train</h3>
                    <form method="POST" action="AdminServlet" id="addTrainForm" style="display: grid; gap: 15px;">
                        <input type="hidden" name="action" value="add_train">
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div>
                                <label style="display: block; font-weight: 600; margin-bottom: 5px; color: #333;">Train Number:</label>
                                <input type="text" name="trainNo" id="trainNo" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;" placeholder="e.g., 12001">
                            </div>
                            <div>
                                <label style="display: block; font-weight: 600; margin-bottom: 5px; color: #333;">Train Name:</label>
                                <input type="text" name="trainName" id="trainName" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;" placeholder="e.g., Rajdhani Express">
                            </div>
                        </div>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div>
                                <label style="display: block; font-weight: 600; margin-bottom: 5px; color: #333;">Source:</label>
                                <input type="text" name="source" id="source" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;" placeholder="e.g., Delhi">
                            </div>
                            <div>
                                <label style="display: block; font-weight: 600; margin-bottom: 5px; color: #333;">Destination:</label>
                                <input type="text" name="destination" id="destination" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;" placeholder="e.g., Mumbai">
                            </div>
                        </div>
                        
                        <button type="submit" id="addTrainBtn" style="background: #4CAF50; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: 600; font-size: 14px; transition: 0.3s;">➕ Add Train</button>
                    </form>
                </div>

                <script>
                    document.getElementById('addTrainForm').addEventListener('submit', function(e) {
                        const trainNo = document.getElementById('trainNo').value.trim();
                        const trainName = document.getElementById('trainName').value.trim();
                        const source = document.getElementById('source').value.trim();
                        const destination = document.getElementById('destination').value.trim();
                        
                        if (!trainNo || !trainName || !source || !destination) {
                            e.preventDefault();
                            showToast('Please fill in all fields', 'error');
                            return;
                        }
                        
                        // Show loading message
                        showToast('Adding train: ' + trainNo + '...', 'info', 0);
                    });
                </script>
                
                <!-- Trains List with Edit Modal -->
                <% 
                    List<Train> trains = (List<Train>) request.getAttribute("trains");
                    if (trains != null && !trains.isEmpty()) { 
                %>
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Train Number</th>
                                    <th>Train Name</th>
                                    <th>Source</th>
                                    <th>Destination</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Train train : trains) { %>
                                    <tr>
                                        <td><strong><%= train.getTrainNo() %></strong></td>
                                        <td><%= train.getTrainName() %></td>
                                        <td><%= train.getSource() %></td>
                                        <td><%= train.getDestination() %></td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <button type="button" class="btn-promote" onclick="openEditModal('<%= train.getTrainNo() %>', '<%= train.getTrainName() %>', '<%= train.getSource() %>', '<%= train.getDestination() %>');" style="background: #2196F3; color: white; padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px;">✏️ Edit</button>
                                                <form action="AdminServlet" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete_train">
                                                    <input type="hidden" name="trainNo" value="<%= train.getTrainNo() %>">
                                                    <button type="submit" class="btn-deactivate" onclick="return confirm('Are you sure you want to delete this train?');" style="padding: 8px 12px; font-size: 13px;">🗑️ Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="empty-message">
                        <p><% String searchQ = (String) request.getAttribute("searchQuery"); %>
                        <% if (searchQ != null && !searchQ.isEmpty()) { %>
                            No trains found matching "<%= searchQ %>". Try a different search or add a new train.
                        <% } else { %>
                            No trains found. Add your first train using the form above.
                        <% } %>
                        </p>
                    </div>
                <% } %>
            </div>
            
            <!-- Edit Train Modal -->
            <div id="editTrainModal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.4);">
                <div style="background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; border-radius: 8px; width: 90%; max-width: 500px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3 style="color: #d32f2f; margin: 0; font-size: 18px;">✏️ Edit Train Information</h3>
                        <button onclick="closeEditModal()" style="background: none; border: none; font-size: 28px; cursor: pointer; color: #999;">&times;</button>
                    </div>
                    
                    <form id="editTrainForm" method="POST" action="AdminServlet">
                        <input type="hidden" name="action" value="update_train">
                        <input type="hidden" id="editTrainNo" name="trainNo">
                        
                        <div style="margin-bottom: 15px;">
                            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: #333;">Train Number (Read-Only):</label>
                            <input type="text" id="modalTrainNo" readonly style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; background: #f5f5f5;">
                        </div>
                        
                        <div style="margin-bottom: 15px;">
                            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: #333;">Train Name:</label>
                            <input type="text" id="editTrainName" name="trainName" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;">
                        </div>
                        
                        <div style="margin-bottom: 15px;">
                            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: #333;">Source:</label>
                            <input type="text" id="editSource" name="source" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;">
                        </div>
                        
                        <div style="margin-bottom: 20px;">
                            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: #333;">Destination:</label>
                            <input type="text" id="editDestination" name="destination" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;">
                        </div>
                        
                        <div style="display: flex; gap: 10px; justify-content: flex-end;">
                            <button type="button" onclick="closeEditModal()" style="background: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: 600;">Cancel</button>
                            <button type="submit" style="background: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: 600;">💾 Update</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <script>
                function openEditModal(trainNo, trainName, source, destination) {
                    document.getElementById('editTrainNo').value = trainNo;
                    document.getElementById('modalTrainNo').value = trainNo;
                    document.getElementById('editTrainName').value = trainName;
                    document.getElementById('editSource').value = source;
                    document.getElementById('editDestination').value = destination;
                    document.getElementById('editTrainModal').style.display = 'block';
                }
                
                function closeEditModal() {
                    document.getElementById('editTrainModal').style.display = 'none';
                }
                
                window.onclick = function(event) {
                    var modal = document.getElementById('editTrainModal');
                    if (event.target == modal) {
                        modal.style.display = 'none';
                    }
                }
            </script>
        <% } %>

        <!-- Statistics View -->
        <% if ("stats".equals(request.getParameter("action"))) { %>
            <div class="section">
                <h2>📊 Statistics & Analytics</h2>
                
                <!-- Quick Stats Cards -->
                <div class="stats-grid" style="margin-bottom: 30px;">
                    <div class="stat-card">
                        <h4>Total Users</h4>
                        <div class="value"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %></div>
                    </div>
                    <div class="stat-card">
                        <h4>Total Trains</h4>
                        <div class="value"><%= request.getAttribute("totalTrains") != null ? request.getAttribute("totalTrains") : 0 %></div>
                    </div>
                    <div class="stat-card">
                        <h4>Average Probability</h4>
                        <div class="value"><%= request.getAttribute("avgProbability") != null ? request.getAttribute("avgProbability") + "%" : "0%" %></div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>
