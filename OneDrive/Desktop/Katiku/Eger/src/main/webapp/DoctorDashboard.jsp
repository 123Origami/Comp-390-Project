<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, Util.DBConnection" %>
<%
// Prevent caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

// Check if the user is logged in
String username = (String) session.getAttribute("username");
if (username == null || username.isEmpty()) {
    response.sendRedirect("login.jsp"); // Redirect to login if not logged in
    return;
}

Connection conn = null;
PreparedStatement stmtDoctorID = null;
PreparedStatement stmtAppointments = null;
ResultSet rsDoctorID = null;
ResultSet rsAppointments = null;

String doctorID = null;

try {
    conn = DBConnection.getConnection();

    // Step 1: Retrieve the Doctor_ID associated with the logged-in user
    String sqlDoctorID = "SELECT Doctor_ID FROM user WHERE Username = ?";
    stmtDoctorID = conn.prepareStatement(sqlDoctorID);
    stmtDoctorID.setString(1, username);
    rsDoctorID = stmtDoctorID.executeQuery();

    if (rsDoctorID.next()) {
        doctorID = rsDoctorID.getString("Doctor_ID");
    } else {
        response.sendRedirect("login.jsp"); // Redirect if no Doctor_ID found
        return;
    }

    // Step 2: Fetch today's appointments for the logged-in doctor
    String sqlAppointments = "SELECT a.Appointment_ID, u.Username AS Patient_Name, d.Name AS Doctor_Name, " +
                             "a.Timestamp AS Appointment_Time, a.Status AS Appointment_Status " +
                             "FROM appointment a " +
                             "JOIN user u ON a.User_ID = u.User_ID " +
                             "JOIN doctor d ON a.Doctor_ID = d.Doctor_ID " +
                             "WHERE a.Doctor_ID = ? AND DATE(a.Timestamp) = CURDATE() " +
                             "ORDER BY a.Timestamp ASC";

    stmtAppointments = conn.prepareStatement(sqlAppointments);
    stmtAppointments.setString(1, doctorID); // Use the retrieved doctorID
    rsAppointments = stmtAppointments.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Doctor's Dashboard</title>
<link rel="stylesheet" href="doctordashboard.css"> <!-- Link to CSS -->
</head>
<body>

<!-- Header -->
<div class="header">
<h2>Doctor's Dashboard</h2>
<p>Welcome, Dr. <%= session.getAttribute("doctorName") %></p>
</div>

<!-- Appointments Section -->
<div class="appointments-section">
<h3>Today's Appointments</h3>
<%
boolean hasAppointments = false;
SimpleDateFormat dateTimeFormat = new SimpleDateFormat("hh:mm a");

while (rsAppointments.next()) {
    String patientName = rsAppointments.getString("Patient_Name");
    String doctorName = rsAppointments.getString("Doctor_Name");
    Timestamp appointmentTime = rsAppointments.getTimestamp("Appointment_Time");
    String status = rsAppointments.getString("Appointment_Status");

    hasAppointments = true;
%>
<div class="appointment-item">
<div class="appointment-time"><%= dateTimeFormat.format(appointmentTime) %></div>
<div class="patient-name">Patient: <%= patientName != null ? patientName : "Unknown" %></div>
<div class="doctor-name">Doctor: <%= doctorName != null ? doctorName : "Unknown" %></div>
<div class="status">Status: <%= status != null ? status : "Pending" %></div>
</div>
<%
}

if (!hasAppointments) {
%>
<p>No appointments scheduled for today.</p>
<%
}
%>
</div>

<!-- Footer -->
<div class="footer">
<a href="${pageContext.request.contextPath}/logout.jsp">Logout</a>
</div>

</body>
</html>
<%
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    // Close resources
    if (rsDoctorID != null) rsDoctorID.close();
    if (rsAppointments != null) rsAppointments.close();
    if (stmtDoctorID != null) stmtDoctorID.close();
    if (stmtAppointments != null) stmtAppointments.close();
    if (conn != null) conn.close();
}
%>