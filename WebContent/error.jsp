<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Railway Waitlist Calculator</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #dc3545;
            text-align: center;
            margin-bottom: 30px;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 20px;
            border-radius: 4px;
            border-left: 5px solid #dc3545;
            margin-bottom: 30px;
        }
        .error-icon {
            font-size: 48px;
            text-align: center;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            margin: 10px 5px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .help-section {
            background-color: #e7f3ff;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 5px solid #007bff;
        }
        .help-section h3 {
            margin-top: 0;
            color: #007bff;
        }
        .help-list {
            margin: 10px 0;
            padding-left: 20px;
        }
        .help-list li {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-icon">⚠️</div>
        <h1>Error Occurred</h1>
        
        <div class="error-message">
            <strong>Error:</strong> <%= request.getAttribute("error") != null ? request.getAttribute("error") : "An unexpected error occurred." %>
        </div>
        
        <div class="help-section">
            <h3>Common Issues & Solutions</h3>
            <ul class="help-list">
                <li><strong>Invalid Train Number:</strong> Make sure the train number exists in our database</li>
                <li><strong>Invalid Date Format:</strong> Use YYYY-MM-DD format for the journey date</li>
                <li><strong>Invalid Waitlist Number:</strong> Enter a valid positive number</li>
                <li><strong>Database Connection:</strong> Ensure the database is running and accessible</li>
                <li><strong>Missing Fields:</strong> All form fields are required</li>
            </ul>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="index.jsp" class="btn">Try Again</a>
        </div>
        
        <div style="margin-top: 30px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; font-size: 14px; color: #6c757d; text-align: center;">
            If the problem persists, please contact the system administrator.
        </div>
    </div>
</body>
</html>

