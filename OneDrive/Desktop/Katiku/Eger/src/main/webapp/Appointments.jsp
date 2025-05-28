<%@ page import="java.sql.*, Util.DBConnection" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment History</title>
    <link rel="stylesheet" href="Appointments.css">
</head>
<body>
    <div class="header">
        <h2>Appointment History</h2>
    </div>

    <div class="history-container">
        <%-- Display success/error messages --%>
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            
            if (success != null) {
                if ("rescheduled".equals(success)) {
        %>
                    <div class="alert alert-success">
                        Appointment successfully rescheduled!
                    </div>
        <%
                } else if ("deleted".equals(success)) {
        %>
                    <div class="alert alert-success">
                        Appointment successfully deleted!
                    </div>
        <%
                }
            }
            
            if (error != null) {
                String errorMessage = "An error occurred";
                if ("slot_taken".equals(error)) {
                    errorMessage = "The selected time slot is already taken";
                } else if ("invalid_appointment".equals(error)) {
                    errorMessage = "Invalid appointment";
                } else if ("database".equals(error)) {
                    errorMessage = "Database error";
                }
        %>
                <div class="alert alert-error">
                    <%= errorMessage %>
                </div>
        <%
            }
        %>

        <h3>Recent Appointments</h3>
        <ul class="history-list">
            <%
                Integer userId = (Integer) session.getAttribute("user_id");

                if (userId != null) {
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        conn = DBConnection.getConnection();

                        String query = "SELECT a.Appointment_ID, d.Name AS DoctorName, s.Specialization_Name AS Specialization, a.Date, a.Time " +
                                       "FROM appointment a " +
                                       "JOIN doctor d ON a.Doctor_ID = d.Doctor_ID " +
                                       "JOIN specialization s ON d.Specialization_ID = s.Specialization_ID " +
                                       "WHERE a.User_ID = ? " +
                                       "ORDER BY a.Date DESC, a.Time DESC";

                        ps = conn.prepareStatement(query);
                        ps.setInt(1, userId);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            int appointmentId = rs.getInt("Appointment_ID");
                            String doctorName = rs.getString("DoctorName");
                            String specialization = rs.getString("Specialization");
                            String date = rs.getString("Date");
                            String time = rs.getString("Time");
            %>
                            <li>
                                <span>Appointment with <%= doctorName %> (<%= specialization %>) on <%= date %> at <%= time %></span>
                                <div class="buttons-container">
                                    <!-- Reschedule Button -->
                                    <a href="Reschedule.jsp?appointmentId=<%= appointmentId %>" 
                                       class="btn btn-reschedule">Reschedule</a>

                                    <!-- Delete Button -->
                                    <form action="Appointments.jsp" method="post">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                                        <button type="submit" class="btn btn-delete">Delete</button>
                                    </form>
                                </div>
                            </li>
            <%
                        }
                    } catch (SQLException e) {
                        out.println("<li>Error loading appointments: " + e.getMessage() + "</li>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception ignore) {}
                        if (ps != null) try { ps.close(); } catch (Exception ignore) {}
                        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
                    }
                } else {
                    out.println("<li>No user session found. Please <a href='login.jsp'>login</a>.</li>");
                }

                // Handle Delete Action
                String action = request.getParameter("action");
                if ("delete".equals(action)) {
                    String appointmentIdStr = request.getParameter("appointmentId");
                    if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                        int appointmentId = Integer.parseInt(appointmentIdStr);

                        Connection deleteConn = null;
                        PreparedStatement deletePs = null;

                        try {
                            deleteConn = DBConnection.getConnection();
                            String deleteQuery = "DELETE FROM appointment WHERE Appointment_ID = ?";
                            deletePs = deleteConn.prepareStatement(deleteQuery);
                            deletePs.setInt(1, appointmentId);

                            int rowsAffected = deletePs.executeUpdate();

                            if (rowsAffected > 0) {
                                response.sendRedirect("Appointments.jsp?success=deleted");
                            } else {
                                response.sendRedirect("Appointments.jsp?error=not_found");
                            }
                        } catch (SQLException e) {
                            response.sendRedirect("Appointments.jsp?error=database");
                        } finally {
                            if (deletePs != null) try { deletePs.close(); } catch (Exception ignore) {}
                            if (deleteConn != null) try { deleteConn.close(); } catch (Exception ignore) {}
                        }
                    } else {
                        response.sendRedirect("Appointments.jsp?error=invalid_id");
                    }
                }
            %>
        </ul>

        <!-- Back Button -->
        <div class="back-button-container">
            <button class="back-btn"><a href="profile.jsp" class="back-btn-link">Back</a></button>
        </div>
    </div>

    <!-- Bottom Navigation -->
    <div class="bottom-nav">
        <a href="${pageContext.request.contextPath}/home.jsp">
            <img src="Home.jpeg" alt="Home">
            <span>Home</span>
        </a>
        <a href="${pageContext.request.contextPath}/Appointments.jsp" class="active">
            <img src="Appointment.png" alt="Appointments">
            <span>Appointments</span>
        </a>
        <a href="${pageContext.request.contextPath}/chats.jsp">
            <img src="Chats.png" alt="Chats">
            <span>Chats</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile.jsp">
            <img src="Account Icon.png" alt="Profile">
            <span>Profile</span>
        </a>
    </div>
</body>
</html>
