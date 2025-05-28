<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Prevent caching of sensitive data
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

// Check if the user is logged in
HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("username") == null) {
   // Redirect to login page if no valid session exists
   response.sendRedirect("login.jsp?error=session");
   return;
}

// Default values for guest access
String loggedInUsername = "Guest"; // Default username for guests
int userId = -1; // Default user ID for guests

// Retrieve username and user_id from the session
if (sessionObj != null) {
    loggedInUsername = (String) sessionObj.getAttribute("username");
    try {
        String userIdStr = sessionObj.getAttribute("user_id").toString();
        userId = Integer.parseInt(userIdStr);
    } catch (NumberFormatException e) {
         //Handle invalid user_id format
        userId = -1;
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>
    <link rel="stylesheet" href="profile1.css"> <!-- Link to CSS -->
    <script defer src="profile.js"></script> 
    <script src="script.js"></script>
    
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">
            <h2>Profile</h2>
            <div class="profile-pic">
                <img src="Profile Pic.jpeg" alt="User Profile">
            </div>
            <!-- Dynamically display username from session -->
            <h3 id="username"><%= loggedInUsername %></h3>
        </div>

        <ul class="profile-menu">
            <li data-action="history"><img src="History Icon.png" class="menu-icon"> History</li>
            <li data-action="personal_details"><img src="Account Icon.png" class="menu-icon"> Personal Details</li>
            <li data-action="settings"><img src="Settings Icon.png" class="menu-icon"> Settings</li>
            <li data-action="help"><img src="Help Icon.png" class="menu-icon"> Help</li>
            <li data-action="logout"><img src="Logout Icon.png" class="menu-icon"> Log Out</li>
        </ul>
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
        <a href="${pageContext.request.contextPath}/chats.jsp">
            <img src="Chats.png" alt="Chats">
            <span>Chats</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile.jsp" class="active">
            <img src="Account Icon.png" alt="Profile">
            <span>Profile</span>
        </a>
    </div>
</body>
</html>