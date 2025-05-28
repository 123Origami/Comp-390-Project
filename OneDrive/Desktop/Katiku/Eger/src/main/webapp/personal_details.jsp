<%@ page import="java.sql.*, Util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Personal Details</title>
    <link rel="stylesheet" href="personal_details.css">
</head>
<body>
    <div class="header">
        <h2>Personal Details</h2>
    </div>

    <div class="details-container">
        <%
            Integer userId = (Integer) session.getAttribute("user_id");
            if (userId != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();
                    String query = "SELECT username, email, phone FROM user WHERE user_id = ?";
                    ps = conn.prepareStatement(query);
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String username = rs.getString("username");
                        String email = rs.getString("email");
                        String phone = rs.getString("phone");

                        // Display form with current details
        %>
                        <form action="personal_details.jsp?action=updateUser" method="POST">
                            <label>Full Name</label>
                            <input type="text" name="username" value="<%= username %>" pattern="[A-Za-z\s]+" readonly>

                            <label>Email</label>
                            <input type="email" name="email" value="<%= email %>" readonly>

                            <label>Phone</label>
                            <input type="text" name="phone" value="<%= phone %>" pattern="[0-9]{10}" readonly>

                            <button type="button" id="edit-btn">Edit</button>
                            <button type="submit" id="save-btn" style="display: none;">Save Changes</button>
                        </form>

                        <!-- Move the Back button here below the form -->
                        <div class="back-button-container">
                            <a href="profile.jsp" class="back-btn">Back</a>
                        </div>
        <%
                    } else {
                        out.println("<p>User not found.</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p>Error loading details: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            } else {
                out.println("<p>No user session found. Please <a href='login.jsp'>login</a>.</p>");
            }

            // Handle update request
            String action = request.getParameter("action");
            if ("updateUser".equals(action)) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                if (userId != null && username != null && email != null && phone != null) {
                    Connection conn = null;
                    PreparedStatement ps = null;

                    try {
                        conn = DBConnection.getConnection();
                        String query = "UPDATE user SET username = ?, email = ?, phone = ? WHERE user_id = ?";
                        ps = conn.prepareStatement(query);
                        ps.setString(1, username);
                        ps.setString(2, email);
                        ps.setString(3, phone);
                        ps.setInt(4, userId);

                        int rowsAffected = ps.executeUpdate();
                        if (rowsAffected > 0) {
                            out.println("<script>alert('Details updated successfully!'); window.location='personal_details.jsp';</script>");
                        } else {
                            out.println("<script>alert('Failed to update details.');</script>");
                        }
                    } catch (SQLException e) {
                        out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
                    } finally {
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    }
                } else {
                    out.println("<script>alert('Invalid input or session expired.');</script>");
                }
            }
        %>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const editBtn = document.getElementById("edit-btn");
            const saveBtn = document.getElementById("save-btn");

            // Enable editing mode
            editBtn.addEventListener("click", function () {
                document.querySelectorAll(".details-container input").forEach(input => {
                    input.removeAttribute("readonly");
                });
                editBtn.style.display = "none";
                saveBtn.style.display = "block";
            });
        });
    </script>
</body>
</html>