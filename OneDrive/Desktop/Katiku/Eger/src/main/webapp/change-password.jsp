<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="Util.DBConnection" %>
<%@ page import="Util.PasswordUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
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
            margin-bottom: 20px;
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

        input[type="password"] {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 5px;
        }

        .success-message {
            color: green;
            font-size: 14px;
            margin-top: 5px;
        }

        .submit-btn {
            background-color: #0d6efd;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            width: 100%;
        }

        .submit-btn:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <h2>Change Password</h2>

        <%
            String errorMessage = null;
            String successMessage = null;

            // Handle form submission
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String currentPassword = request.getParameter("current_password");
                String newPassword = request.getParameter("new_password");
                String confirmPassword = request.getParameter("confirm_password");

                String username = (String) session.getAttribute("username");

                if (username == null) {
                    errorMessage = "User session expired. Please log in again.";
                } else {
                    Connection conn = null;
                    PreparedStatement stmt = null;

                    try {
                        // Fetch the stored hashed password from the database
                        conn = DBConnection.getConnection();
                        String sql = "SELECT Password FROM User WHERE username = ?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setString(1, username);
                        

                        ResultSet rs = stmt.executeQuery();
                        if (!rs.next()) {
                            errorMessage = "User not found.";
                        } else {
                            String storedHashedPassword = rs.getString("Password");

                            // Verify the current password
                            if (!PasswordUtil.verifyPassword(currentPassword, storedHashedPassword)) {
                                errorMessage = "Current password is incorrect.";
                            } else if (!newPassword.equals(confirmPassword)) {
                                errorMessage = "New password and confirm password do not match.";
                            } else {
                                // Hash the new password
                                String hashedNewPassword = PasswordUtil.hashPassword(newPassword);

                                // Update the password in the database
                                sql = "UPDATE User SET Password = ? WHERE username = ?";
                                stmt = conn.prepareStatement(sql);
                                stmt.setString(1, hashedNewPassword);
                                stmt.setString(2, username);

                                int rowsUpdated = stmt.executeUpdate();
                                if (rowsUpdated > 0) {
                                    successMessage = "Password updated successfully.";
                                } else {
                                    errorMessage = "Failed to update password.";
                                }
                            }
                        }
                    } catch (Exception e) {
                        errorMessage = "An error occurred: " + e.getMessage();
                    } finally {
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                }
            }
        %>

        <!-- Display Messages -->
        <% if (errorMessage != null) { %>
            <p class="error-message"><%= errorMessage %></p>
        <% } %>
        <% if (successMessage != null) { %>
            <p class="success-message"><%= successMessage %></p>
        <% } %>

        <!-- Change Password Form -->
        <form method="POST" action="change-password.jsp">
            <div class="form-group">
                <label for="current_password">Current Password</label>
                <input type="password" id="current_password" name="current_password" required>
            </div>

            <div class="form-group">
                <label for="new_password">New Password</label>
                <input type="password" id="new_password" name="new_password" required>
            </div>

            <div class="form-group">
                <label for="confirm_password">Confirm New Password</label>
                <input type="password" id="confirm_password" name="confirm_password" required>
            </div>

            <button type="submit" class="submit-btn">Update Password</button>
        </form>

        <!-- Back Button -->
        <button class="submit-btn" style="margin-top: 10px;" onclick="window.location.href='settings.jsp'">Back</button>
    </div>

    <script>
        // Delete Account Confirmation
        const deleteAccountBtn = document.getElementById('delete-account-btn');
        deleteAccountBtn.addEventListener('click', () => {
            if (confirm("Are you sure you want to delete your account? This action cannot be undone.")) {
                // Invalidate session and redirect to logout
                window.location.href = 'DeleteUser?action=deleteAccount';
            }
        });
    </script>
</body>
</html>