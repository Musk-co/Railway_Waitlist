<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.waitlist.model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Railway Waitlist Probability Calculator</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            box-sizing: border-box;
        }
        header a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
            padding: 8px 15px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 4px;
            font-size: 14px;
            transition: 0.3s;
        }
        header a:hover {
            background-color: rgba(255,255,255,0.2);
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-info span {
            font-size: 14px;
        }
        .container {
            background-color: transparent;
            padding: 30px;
            margin: auto;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            flex: 1;
            width: 100%;
            max-width: 700px;
            box-sizing: border-box;
        }
        h1 {
            color: #333;
            text-align: center;
            margin: 0 0 30px 0;
            width: 100%;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        button:hover {
            background-color: #0056b3;
        }
        .info {
            background-color: #e7f3ff;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #007bff;
            width: 100%;
            box-sizing: border-box;
        }
        
        .content-card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 100%;
            box-sizing: border-box;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <header>
        <h1 style="margin: 0; font-size: 20px;">🚂 Railway Waitlist Calculator</h1>
        <div class="user-info">
            <% if (user != null) { %>
                <span>Welcome, <%= user.getUsername() %>!</span>
                <a href="dashboard.jsp">Dashboard</a>
                <a href="LogoutServlet">Logout</a>
            <% } else { %>
                <a href="LoginServlet">Login</a>
                <a href="RegisterServlet">Register</a>
            <% } %>
        </div>
    </header>

    <div class="container">
        <h1>Welcome to Railway Waitlist Calculator</h1>
        
        <div class="content-card">
            <div style="text-align: center;">
                <h2 style="color: #667eea; margin-top: 0; margin-bottom: 20px;">Calculate Train Ticket Confirmation Probability</h2>
                <p style="font-size: 16px; color: #555; line-height: 1.6;">
                    Predict your chances of getting a confirmed seat on your desired train based on historical booking data and current waitlist position.
                </p>
            </div>
        </div>
        
        <div class="content-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-align: center; margin-bottom: 30px;">
            <h3 style="margin-top: 0; margin-bottom: 20px; font-size: 20px;">Get Started</h3>
            <p style="margin-bottom: 25px; font-size: 16px;">Please login or create an account to access the probability calculator.</p>
            <% if (user == null) { %>
                <a href="LoginServlet" style="display: inline-block; background: white; color: #667eea; padding: 12px 40px; text-decoration: none; border-radius: 5px; font-weight: bold; margin-right: 15px; transition: 0.3s;">Login</a>
                <a href="RegisterServlet" style="display: inline-block; background: rgba(255,255,255,0.2); color: white; padding: 12px 40px; text-decoration: none; border-radius: 5px; font-weight: bold; border: 2px solid white; transition: 0.3s;">Register</a>
            <% } else { %>
                <a href="dashboard.jsp" style="display: inline-block; background: white; color: #667eea; padding: 12px 40px; text-decoration: none; border-radius: 5px; font-weight: bold; transition: 0.3s;">Go to Calculator</a>
            <% } %>
        </div>
        
        <div class="content-card">
            <h3 style="text-align: center; color: #333; margin-top: 0; margin-bottom: 30px;">Features</h3>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div style="background: #f0f0f0; padding: 20px; border-radius: 8px;">
                    <h4 style="color: #667eea; margin-bottom: 10px;">📊 Accurate Analysis</h4>
                    <p>Uses real historical booking data to predict confirmation probability with high accuracy.</p>
                </div>
                <div style="background: #f0f0f0; padding: 20px; border-radius: 8px;">
                    <h4 style="color: #667eea; margin-bottom: 10px;">🔐 Secure & Private</h4>
                    <p>Your search history is securely stored and only accessible by you.</p>
                </div>
                <div style="background: #f0f0f0; padding: 20px; border-radius: 8px;">
                    <h4 style="color: #667eea; margin-bottom: 10px;">📈 Track History</h4>
                    <p>View all your previous searches and track probability patterns over time.</p>
                </div>
                <div style="background: #f0f0f0; padding: 20px; border-radius: 8px;">
                    <h4 style="color: #667eea; margin-bottom: 10px;">⚡ Instant Results</h4>
                    <p>Get immediate probability calculations for any train, date, and waitlist position.</p>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Allow users to select past dates for testing with historical data
        // No date restriction - users can select any date
    </script>
</body>
</html>

