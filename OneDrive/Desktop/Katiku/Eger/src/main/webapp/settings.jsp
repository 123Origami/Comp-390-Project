<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="Util.DBConnection" %>
<%
    // Early session protection
    String username = (String) session.getAttribute("username");

    if (username == null || username.isEmpty()) {
        // No active session — redirect to login
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings</title>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
        }

        .header-container {
            background-color: white;
            border-bottom: 1px solid #ddd;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 15px 20px;
            width: 100%;
            text-align: center;
            margin-bottom: 20px;
        }

        .profile-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 400px;
            text-align: left;
        }

        h2 {
            color: #333;
            margin: 0;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
            color: #333;
        }

        .danger-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            width: 100%;
        }

        .back-btn,
        .change-password-btn {
            background-color: #0d6efd;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            width: 100%;
        }

        .back-btn:hover,
        .change-password-btn:hover,
        .danger-btn:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <!-- Header Card -->
    <div class="header-container">
        <h2>Settings</h2>
    </div>

    <!-- Main Settings Card -->
    <div class="profile-container">
        <div class="form-group">
            <label>Change Password</label>
            <button class="form-control change-password-btn" onclick="window.location.href='change-password.jsp'">Change</button>
        </div>

        <div class="form-group">
            <label>Delete Account</label>
            <button id="delete-account-btn" class="form-control danger-btn">Delete</button>
        </div>

        <button class="back-btn" onclick="window.location.href='profile.jsp'">Back</button>
    </div>

    <script>
        // Delete Account Confirmation
        const deleteAccountBtn = document.getElementById('delete-account-btn');
        deleteAccountBtn.addEventListener('click', () => {
            if (confirm("Are you sure you want to delete your account? This action cannot be undone.")) {
                window.location.href = 'settings.jsp?action=deleteAccount';
            }
        });
    </script>

    <%
        // Handle Delete Action
        String action = request.getParameter("action");
        if ("deleteAccount".equals(action)) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DBConnection.getConnection();
                String sql = "DELETE FROM User WHERE Username = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username); // Correct: setting username (String)

                int rowsDeleted = stmt.executeUpdate();
                if (rowsDeleted > 0) {
                    session.invalidate();
                    response.sendRedirect("logout.jsp");
                } else {
                    out.println("<p style='color: red;'>Error: Failed to delete account.</p>");
                }
            } catch (SQLException e) {
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { }
                if (conn != null) try { conn.close(); } catch (SQLException e) { }
            }
        }
    %>
</body>
</html>
