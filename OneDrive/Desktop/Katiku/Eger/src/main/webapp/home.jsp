<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, Util.DBConnection" %>
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
             // Handle invalid user_id format
            userId = -1;
        }
    }

    // Fetch doctors and specializations from the database
    Connection conn = null;
    PreparedStatement stmtDoctors = null;
    PreparedStatement stmtSpecializations = null;
    ResultSet rsDoctors = null;
    ResultSet rsSpecializations = null;

    try {
        conn = DBConnection.getConnection();

        // Query to fetch all doctors with their specialization names
        String sqlDoctors = "SELECT d.Doctor_ID, d.Name, s.Specialization_Name " +
                            "FROM Doctor d JOIN Specialization s ON d.Specialization_ID = s.Specialization_ID";
        stmtDoctors = conn.prepareStatement(sqlDoctors);
        rsDoctors = stmtDoctors.executeQuery();

        // Query to fetch all specializations
        String sqlSpecializations = "SELECT Specialization_Name FROM Specialization";
        stmtSpecializations = conn.prepareStatement(sqlSpecializations);
        rsSpecializations = stmtSpecializations.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Home</title>
    <!-- Link to CSS -->
    <link rel="stylesheet" href="home.css">
    <!-- JavaScript for Filtering and Search -->
    <script>
        // Function to filter doctors by specialization
        function filterDoctors(specialization) {
            const doctorCards = document.querySelectorAll('.doctor-card');
            doctorCards.forEach(card => {
                const doctorSpecialization = card.querySelector('.doctor-info p').textContent.trim();
                if (specialization === 'All' || doctorSpecialization === specialization) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Function to perform search
        function performSearch() {
            const query = document.getElementById('search-input').value.trim().toLowerCase();
            const doctorCards = document.querySelectorAll('.doctor-card');
            const resultsList = document.getElementById('results-list');
            resultsList.innerHTML = ''; // Clear previous results
            let foundResults = false;

            doctorCards.forEach(card => {
                const doctorName = card.querySelector('.doctor-info h4').textContent.trim().toLowerCase();
                const doctorSpecialization = card.querySelector('.doctor-info p').textContent.trim().toLowerCase();

                if (doctorName.includes(query) || doctorSpecialization.includes(query)) {
                    card.style.display = 'block'; // Show matching doctor cards
                    foundResults = true;

                    // Add result to the search results list
                    const listItem = document.createElement('li');
                    listItem.textContent = `${doctorName} (${doctorSpecialization})`;
                    resultsList.appendChild(listItem);
                } else {
                    card.style.display = 'none'; // Hide non-matching doctor cards
                }
            });

            // Show or hide the search results section
            const searchResults = document.getElementById('search-results');
            if (foundResults) {
                searchResults.style.display = 'block';
            } else {
                searchResults.style.display = 'none';
            }
        }

        // Add event listeners for categories and search
        document.addEventListener('DOMContentLoaded', () => {
            // Add click event listeners to category buttons
            const categoryButtons = document.querySelectorAll('.category');
            categoryButtons.forEach(button => {
                button.addEventListener('click', () => {
                    const specialization = button.textContent.trim();
                    filterDoctors(specialization);
                });
            });

            // Add a default "All" button
            const allButton = document.createElement('button');
            allButton.textContent = 'All';
            allButton.classList.add('category');
            allButton.addEventListener('click', () => filterDoctors('All'));
            document.querySelector('.category-list').prepend(allButton);

            // Make the search icon clickable
            document.querySelector('.search-icon').addEventListener('click', performSearch);

            // Allow pressing Enter in the search bar to trigger search
            document.getElementById('search-input').addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <!-- Profile & Greeting -->
        <div class="header">
            <!-- Profile Picture -->
            <img src="Profile Pic.jpeg" class="profile-avatar" alt="Profile Picture">
            <div class="greeting">
                <p>Hi, Welcome Back,</p>
                <h2 id="username"><%= loggedInUsername %></h2>
            </div>
            <span class="notification-icon" title="Notifications">🔔</span>
        </div>

        <!-- Search Bar -->
        <div class="search-bar">
            <input type="text" id="search-input" placeholder="Search a Doctor">
            <button class="search-icon" onclick="performSearch()">🔍</button>
        </div>

        <div class="banner">
            <p>Tipape's Group of Hospitals Medical Appointments Management System—your gateway to efficient and seamless healthcare services. Book appointments with doctors, and stay informed about your health, all in one place. Designed to enhance convenience and streamline medical care.</p>
        </div>

        <!-- Search Results -->
        <div id="search-results" class="search-results" style="display: none;">
            <h4>Search Results</h4>
            <ul id="results-list"></ul>
        </div>

        <!-- Categories -->
        <div class="categories">
            <h3>Categories</h3>
            <div class="category-list">
                <%
                    while (rsSpecializations.next()) {
                        String specializationName = rsSpecializations.getString("Specialization_Name");
                %>
                    <button class="category"><%= specializationName %></button>
                <%
                    }
                %>
            </div>
        </div>

        <!-- All Doctors -->
        <div class="doctors-list">
            <h3>All Doctors</h3>
            <%
                while (rsDoctors.next()) {
                    String doctorName = rsDoctors.getString("Name");
                    String specializationName = rsDoctors.getString("Specialization_Name");
            %>
                <div class="doctor-card">
                    <img src="doctor.png" class="doctor-avatar" alt="Doctor Profile">
                    <div class="doctor-info">
                        <h4><%= doctorName %></h4>
                        <p><%= specializationName %></p>
                    </div>
                    <a href="appointment.jsp?doctor=<%= java.net.URLEncoder.encode(doctorName, "UTF-8") %>&specialization=<%= java.net.URLEncoder.encode(specializationName, "UTF-8") %>" class="book-btn">Book</a>
                </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- Bottom Navigation -->
    <div class="bottom-nav">
        <a href="${pageContext.request.contextPath}/home.jsp" class="active">
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
        if (rsSpecializations != null) rsSpecializations.close();
        if (stmtDoctors != null) stmtDoctors.close();
        if (stmtSpecializations != null) stmtSpecializations.close();
        if (conn != null) conn.close();
    }
%>