<%@ page import="java.sql.*, Util.DBConnection" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>History</title>
    <link rel="stylesheet" href="history.css">
</head>
<body>
    <div class="header">
        <h2>History</h2>
    </div>

    <div class="history-container">
        <h3>Appointments History</h3>
        <ul class="history-list">
            <%
                Integer userId = (Integer) session.getAttribute("user_id");

                if (userId != null) {
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        conn = DBConnection.getConnection();

                        String query = "SELECT a.Appointment_ID, d.Name AS DoctorName, a.Date, a.Time " +
                                       "FROM appointment a " +
                                       "JOIN doctor d ON a.Doctor_ID = d.Doctor_ID " +
                                       "WHERE a.User_ID = ? " +
                                       "ORDER BY a.Date DESC, a.Time DESC";

                        ps = conn.prepareStatement(query);
                        ps.setInt(1, userId);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            int appointmentId = rs.getInt("Appointment_ID");
                            String doctorName = rs.getString("DoctorName");
                            String date = rs.getString("Date");
                            String time = rs.getString("Time");
            %>
                            <li>
                                <span>Appointment with <%= doctorName %> on <%= date %> at <%= time %></span>
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
            %>
        </ul>

        <!-- Back Button -->
        <div class="back-button-container">
            <button class="back-btn"><a href="profile.jsp" class="back-btn-link">Back</a></button>
        </div>
    </div>

    <script>
        function viewDetails(id) {
            window.location.href = "viewAppointment.jsp?id=" + id;
        }
    </script>
</body>
</html>