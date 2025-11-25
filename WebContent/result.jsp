<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.waitlist.model.Train" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Waitlist Probability Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 700px;
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
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .result-card {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 5px solid #007bff;
        }
        .probability-display {
            text-align: center;
            margin: 30px 0;
        }
        .probability-value {
            font-size: 48px;
            font-weight: bold;
            color: #007bff;
            margin: 10px 0;
        }
        .probability-category {
            font-size: 24px;
            color: #28a745;
            font-weight: bold;
        }
        .info-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 20px 0;
        }
        .info-item {
            background-color: white;
            padding: 15px;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }
        .info-label {
            font-weight: bold;
            color: #495057;
            margin-bottom: 5px;
        }
        .info-value {
            color: #212529;
            font-size: 16px;
        }
        .recommendation {
            background-color: #e7f3ff;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 5px solid #007bff;
        }
        .recommendation h3 {
            margin-top: 0;
            color: #007bff;
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
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .train-info {
            background-color: #fff3cd;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #ffc107;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Waitlist Probability Result</h1>
        
        <div class="train-info">
            <strong>Train Details:</strong><br>
            <% Train train = (Train) request.getAttribute("train"); %>
            <strong><%= train.getTrainName() %></strong> (<%= train.getTrainNo() %>)<br>
            Route: <%= train.getSource() %> → <%= train.getDestination() %>
        </div>
        
        <div class="result-card">
            <div class="probability-display">
                <div class="probability-value"><%= request.getAttribute("probability") %>%</div>
                <div class="probability-category"><%= request.getAttribute("category") %></div>
            </div>
        </div>
        
        <div class="info-section">
            <div class="info-item">
                <div class="info-label">Journey Date</div>
                <div class="info-value"><%= request.getAttribute("journeyDate") %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Class Type</div>
                <div class="info-value"><%= request.getAttribute("classType") %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Waitlist Number</div>
                <div class="info-value">WL<%= request.getAttribute("waitlistNumber") %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Probability Category</div>
                <div class="info-value"><%= request.getAttribute("category") %></div>
            </div>
        </div>
        
        <div class="recommendation">
            <h3>Recommendation</h3>
            <p><%= request.getAttribute("recommendation") %></p>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="index.jsp" class="btn">Calculate Another</a>
            <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
        </div>
        
        <div style="margin-top: 30px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; font-size: 14px; color: #6c757d;">
            <strong>Disclaimer:</strong> This probability calculation is based on historical data and statistical analysis. 
            Actual confirmation depends on various factors including cancellations, no-shows, and operational changes. 
            Results should be used as a guide only.
        </div>
    </div>
</body>
</html>

