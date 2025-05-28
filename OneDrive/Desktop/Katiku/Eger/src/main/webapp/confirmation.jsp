<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Confirmation</title>
    <style>
        /* General Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Body Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        /* Container Styling */
        .container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            padding: 20px;
            text-align: center;
        }

        /* Header Styling */
        h1 {
            font-size: 24px;
            font-weight: bold;
            color: #006400;
            margin-bottom: 20px;
        }

        /* Confirmation Message */
        .confirmation-message {
            font-size: 16px;
            line-height: 1.6;
            margin-top: 20px;
        }

        /* Return to Home Button */
        .return-home-btn {
            display: inline-block;
            background-color: #008000;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }

        .return-home-btn:hover {
            background-color: #006400;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Appointment Booked & Payment Successful!</h1>
        <p class="confirmation-message">Your appointment has been successfully booked, and the payment has been processed.</p>

        <!-- Return to Home Button -->
        <a href="${pageContext.request.contextPath}/home.jsp" class="return-home-btn">Return to Home</a>
    </div>
</body>
</html>