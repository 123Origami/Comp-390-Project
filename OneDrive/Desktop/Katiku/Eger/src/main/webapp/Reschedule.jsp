<%@ page import="java.sql.*, Util.DBConnection" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reschedule Appointment</title>
    <link rel="stylesheet" href="Reschedule.css">
    <script>
        // Function to restrict date selection to today or future dates
        function restrictPastDates() {
            const today = new Date().toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format
            document.getElementById("newDate").setAttribute("min", today);
        }

        // Function to restrict time selection to 9 AM - 5 PM with 30-minute intervals
        function restrictTimeSelection() {
            const timeInput = document.getElementById("newTime");
            const validTimes = [
                "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
                "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
                "15:00", "15:30", "16:00", "16:30", "17:00"
            ];

            // Add event listener to validate time input
            timeInput.addEventListener("input", () => {
                if (!validTimes.includes(timeInput.value)) {
                    alert("Please select a valid time between 9 AM and 5 PM with 30-minute intervals.");
                    timeInput.value = ""; // Clear invalid input
                }
            });

            // Set valid times as a list of options (for browsers that support datalist)
            const timeList = document.createElement("datalist");
            timeList.id = "validTimes";
            validTimes.forEach(time => {
                const option = document.createElement("option");
                option.value = time;
                timeList.appendChild(option);
            });
            timeInput.setAttribute("list", "validTimes");
            document.body.appendChild(timeList);
        }

        // Initialize restrictions when the page loads
        window.onload = function () {
            restrictPastDates();
            restrictTimeSelection();
        };
    </script>
</head>
<body>
    <div class="header">
        <h2>Reschedule Appointment</h2>
    </div>

    <div class="reschedule-container">
        <%
            Integer userId = (Integer) session.getAttribute("user_id");
            String appointmentIdStr = request.getParameter("appointmentId");
            
            if (userId == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                out.println("<p>No appointment selected for rescheduling.</p>");
                out.println("<a href='Appointments.jsp' class='btn'>Back to Appointments</a>");
                return;
            }
            
            int appointmentId = Integer.parseInt(appointmentIdStr);
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            try {
                conn = DBConnection.getConnection();
                
                // Get current appointment details
                String query = "SELECT a.Appointment_ID, d.Name AS DoctorName, s.Specialization_Name AS Specialization, " +
                               "a.Date, a.Time, a.Doctor_ID " +
                               "FROM appointment a " +
                               "JOIN doctor d ON a.Doctor_ID = d.Doctor_ID " +
                               "JOIN specialization s ON d.Specialization_ID = s.Specialization_ID " +
                               "WHERE a.Appointment_ID = ? AND a.User_ID = ?";
                
                ps = conn.prepareStatement(query);
                ps.setInt(1, appointmentId);
                ps.setInt(2, userId);
                rs = ps.executeQuery();
                
                if (rs.next()) {
                    String doctorName = rs.getString("DoctorName");
                    String specialization = rs.getString("Specialization");
                    String currentDate = rs.getString("Date");
                    String currentTime = rs.getString("Time");
                    int doctorId = rs.getInt("Doctor_ID");
        %>
                    <h3>Reschedule with <%= doctorName %> (<%= specialization %>)</h3>
                    <p>Current appointment: <%= currentDate %> at <%= currentTime %></p>
                    
                    <form action="RescheduleHandler.jsp" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                        <input type="hidden" name="doctorId" value="<%= doctorId %>">
                        
                        <div class="form-group">
                            <label for="newDate">New Date:</label>
                            <input type="date" id="newDate" name="newDate" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="newTime">New Time:</label>
                            <input type="time" id="newTime" name="newTime" required>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-reschedule">Confirm Reschedule</button>
                            <a href="Appointments.jsp" class="btn btn-cancel">Cancel</a>
                        </div>
                    </form>
        <%
                } else {
                    out.println("<p>Appointment not found or you don't have permission to reschedule it.</p>");
                    out.println("<a href='Appointments.jsp' class='btn'>Back to Appointments</a>");
                }
            } catch (SQLException e) {
                out.println("<p>Error loading appointment details: " + e.getMessage() + "</p>");
                out.println("<a href='Appointments.jsp' class='btn'>Back to Appointments</a>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception ignore) {}
                if (ps != null) try { ps.close(); } catch (Exception ignore) {}
                if (conn != null) try { conn.close(); } catch (Exception ignore) {}
            }
        %>
    </div>
</body>
</html>