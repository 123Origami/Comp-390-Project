<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment</title>
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
            background-color: #ffffff; /* White background */
            color: #333333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        /* Container Styling */
        .container {
            background-color: #f0fff0; /* Light green background */
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            padding: 20px;
            text-align: center;
        }

        /* Header Styling */
        .header {
            font-size: 24px;
            font-weight: bold;
            color: #006400; /* Dark green text */
            margin-bottom: 20px;
        }

        /* Form Styling */
        .payment-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        /* Input Fields */
        .payment-form input[type="text"],
        .payment-form input[type="number"] {
            padding: 10px;
            border: 1px solid #008000; /* Green border */
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }

        .payment-form input[type="text"]:focus,
        .payment-form input[type="number"]:focus {
            border-color: #0000ff; /* Blue border on focus */
            outline: none;
        }

        /* Amount Field */
        .amount-field {
            background-color: #e6f7e6; /* Light green background */
            border: 1px solid #006400; /* Dark green border */
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            cursor: not-allowed;
        }

        /* Pay Now Button */
        .pay-button {
            background-color: #008000; /* Green button */
            color: white;
            border: none;
            padding: 12px;
            font-size: 18px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .pay-button:hover {
            background-color: #006400; /* Darker green on hover */
        }

        /* Error Message */
        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">Make Payment</div>

        <!-- Display Error Message if Exists -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
                if ("missing_fields".equals(error)) {
        %>
                    <div class="error-message">Please fill in all required fields.</div>
        <%
                } else if ("database".equals(error)) {
        %>
                    <div class="error-message">An error occurred while processing your payment. Please try again later.</div>
        <%
                } else if ("payment_failed".equals(error)) {
        %>
                    <div class="error-message">Payment failed. Please check your details and try again.</div>
        <%
                }
            }
        %>

        <form action="${pageContext.request.contextPath}/PaymentServlet" method="post" class="payment-form">
            <!-- Account Number -->
            <label for="accountNumber">Account Number</label>
            <input type="text" id="accountNumber" name="accountNumber" placeholder="e.g., 315655" required>

            <!-- Predefined Amount -->
            <label for="amount">Amount</label>
            <input type="text" id="amount" name="amount" value="250" class="amount-field" readonly>

            <!-- Submit Button -->
            <button type="submit" class="pay-button">Pay Now</button>
        </form>
    </div>
</body>
</html>