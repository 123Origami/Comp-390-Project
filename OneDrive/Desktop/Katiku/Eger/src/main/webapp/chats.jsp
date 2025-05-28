<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, Util.DBConnection" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Fetch doctors and their phone numbers from the database
    Connection conn = null;
    PreparedStatement stmtDoctors = null;
    ResultSet rsDoctors = null;

    try {
        conn = DBConnection.getConnection();

        // Query to fetch all doctors with their specialization names and phone numbers
        String sqlDoctors = "SELECT d.Doctor_ID, d.Name, s.Specialization_Name, d.Phone_number " +
                            "FROM Doctor d JOIN Specialization s ON d.Specialization_ID = s.Specialization_ID";
        stmtDoctors = conn.prepareStatement(sqlDoctors);
        rsDoctors = stmtDoctors.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chats</title>
    <link rel="stylesheet" href="chats.css"> <!-- Link to CSS -->
    <script>
        // JavaScript function to filter chat items based on search input
        function performSearch() {
            const searchTerm = document.querySelector('.search-bar input').value.toLowerCase();
            const chatItems = document.querySelectorAll('.chat-item');

            chatItems.forEach(item => {
                const doctorName = item.querySelector('h4').textContent.toLowerCase();
                if (doctorName.includes(searchTerm)) {
                    item.style.display = 'flex'; // Show matching items
                } else {
                    item.style.display = 'none'; // Hide non-matching items
                }
            });
        }

        // Add event listener to search icon
        document.addEventListener('DOMContentLoaded', () => {
            const searchIcon = document.querySelector('.search-icon');
            searchIcon.addEventListener('click', performSearch);

            // Optional: Trigger search when Enter key is pressed in the input field
            const searchInput = document.querySelector('.search-bar input');
            searchInput.addEventListener('keypress', (event) => {
                if (event.key === 'Enter') {
                    performSearch();
                }
            });
        });
    </script>
</head>
<body>

    <!-- Header -->
    <div class="header">
        <h2>Messaging</h2>
    </div>

    <!-- Search Bar -->
    <div class="search-bar">
        <input type="text" placeholder="Search a Doctor">
        <span class="search-icon">🔍</span>
    </div>

    <!-- Messages Section -->
    <h3 class="section-title">Chat via Whatsapp with:</h3>
    <div class="chat-list">
        <%
            while (rsDoctors.next()) {
                String doctorName = rsDoctors.getString("Name");
                String specialization = rsDoctors.getString("Specialization_Name");
                String phoneNumber = rsDoctors.getString("Phone_number");

                // Format phone number for WhatsApp link
                String whatsappLink = "https://wa.me/" + (phoneNumber != null ? phoneNumber.replaceAll("[^0-9]", "") : "");
        %>
        <div class="chat-item">
            <a href="<%= whatsappLink %>" target="_blank">
                <div class="profile-wrapper">
                    <img src="doctor.png" class="chat-avatar">
                    <span class="online-indicator"></span>
                </div>
                <div class="chat-info">
                    <h4><%= doctorName %></h4>
                    <p><%= specialization %>.</p>
                </div>
            </a>
        </div>
        <%
            }
        %>
    </div>

    <!-- Bottom Navigation -->
    <div class="bottom-nav">
        <a href="${pageContext.request.contextPath}/home.jsp">
            <img src="Home.jpeg" alt="Home">
            <span>Home</span>
        </a>
        <a href="${pageContext.request.contextPath}/Appointments.jsp">
            <img src="Appointment.png" alt="Appointments">
            <span>Appointments</span>
        </a>
        <a href="${pageContext.request.contextPath}/chats.jsp" class="active">
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
<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        if (rsDoctors != null) rsDoctors.close();
        if (stmtDoctors != null) stmtDoctors.close();
        if (conn != null) conn.close();
    }
%>