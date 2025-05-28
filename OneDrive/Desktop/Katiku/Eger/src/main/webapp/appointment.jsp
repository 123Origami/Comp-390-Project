<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment</title>
    <style>
        /* General Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            color: #333;
            line-height: 1.6;
        }

        .appointment-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        header {
            text-align: center;
            margin-bottom: 20px;
        }

        header h1 {
            font-size: 24px;
            color: #4CAF50;
        }

        .back-button {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            margin-bottom: 10px;
        }

        .doctor-info {
            text-align: center;
            margin-bottom: 20px;
        }

        .doctor-info img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 10px;
        }

        .doctor-info h2 {
            font-size: 20px;
            margin-bottom: 5px;
        }

        .doctor-info p.specialization {
            font-size: 14px;
            color: #777;
            margin-bottom: 10px;
        }

        .contact-icons span {
            font-size: 20px;
            margin-right: 10px;
            color: #aaa;
        }

        .details {
            text-align: center;
            margin-bottom: 20px;
        }

        .details p {
            font-size: 14px;
            color: #555;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        form div {
            margin-bottom: 15px;
        }

        label {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
        }

        input[type="date"],
        select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        button.book-button {
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button.book-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="appointment-container">
        <header>
            <button class="back-button" onclick="window.history.back()">&#8592;</button>
            <h1>Appointment</h1>
        </header>

        <%
            // Retrieve doctor details from query parameters
            String doctorName = request.getParameter("doctor");
            String specialization = request.getParameter("specialization");

            // Decode the parameters to handle special characters
            if (doctorName != null) doctorName = java.net.URLDecoder.decode(doctorName, "UTF-8");
            if (specialization != null) specialization = java.net.URLDecoder.decode(specialization, "UTF-8");
        %>

        <div class="doctor-info">
            <img src="doctor.png" alt="<%= doctorName %>" style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover;">
            <h2><%= doctorName != null ? doctorName : "Unknown Doctor" %></h2>
            <p class="specialization"><%= specialization != null ? specialization : "Unknown Specialization" %></p>
            <div class="contact-icons">
                <span>📞</span>
                <span>💬</span>
                <span>📧</span>
            </div>
        </div>

        <div class="details">
            <p>Kindly select a date and time for which you would wish to see the doctor</p>
        </div>

        <form action="<%=request.getContextPath()%>/appointmentservlet" method="POST">
            <div class="date-selection">
                <label>Select a Date</label>
                <input type="date" name="date" id="appointment-date" required>
            </div>

            <div class="time-selection">
                <label>Select a Time</label>
                <select name="time" id="appointment-time" required>
                    <option value="" disabled selected>Select a time</option>
                    <%
                        // Generate time options in half-hour intervals (e.g., 7:00, 7:30, 8:00, etc.)
                        for (int hour = 9; hour <= 17; hour++) { // Assuming working hours from 9 AM to 5 PM
                            for (int minute = 0; minute < 60; minute += 30) {
                                String time = String.format("%02d:%02d", hour, minute);
                    %>
                                <option value="<%= time %>"><%= time %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <input type="hidden" name="doctor" value="<%= doctorName %>">
            <input type="hidden" name="specialization" value="<%= specialization %>">

            <button type="submit" class="book-button" onsubmit="return validateForm()">Book an Appointment</button>
        </form>
    </div>


    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let today = new Date();
            let maxDate = new Date();
            maxDate.setMonth(maxDate.getMonth() + 1); // Allow booking up to one month in advance

            let dateInput = document.getElementById("appointment-date");
            dateInput.min = today.toISOString().split("T")[0]; // Set minimum date to today
            dateInput.max = maxDate.toISOString().split("T")[0]; // Set maximum date to one month ahead
        });

        function validateForm() {
            const selectedDate = document.getElementById("appointment-date").value;
            const selectedTime = document.getElementById("appointment-time").value;

            if (!selectedDate || !selectedTime) {
                alert("Please select both date and time.");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>