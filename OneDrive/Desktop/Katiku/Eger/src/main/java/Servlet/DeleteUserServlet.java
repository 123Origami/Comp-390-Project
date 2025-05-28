package Servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import Util.DBConnection;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Get the session (do not create a new session if it doesn't exist)
        HttpSession session = request.getSession(false);

        if (session != null) {
            String username = (String) session.getAttribute("username"); // Retrieve the username from the session

            if ("deleteAccount".equals(action) && username != null) {
                // Delete the user's account from the database using the username
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "DELETE FROM User WHERE Username = ?"; // Use "Username" column
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setString(1, username); // Set the username as the parameter

                        int rowsDeleted = stmt.executeUpdate();
                        if (rowsDeleted > 0) {
                            // Invalidate the session
                            session.invalidate();

                            // Redirect to the login page
                            response.sendRedirect("login.jsp"); // Replace with your login page URL
                            return;
                        } else {
                            response.getWriter().write("Error: Account not found.");
                            return;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.getWriter().write("Error deleting account: " + e.getMessage());
                    return;
                }
            }

            // Invalidate the session if no specific action is provided
            session.invalidate();
        } else {
            // Handle case where session is null or expired
            response.getWriter().write("Error: User not logged in or session expired.");
            return;
        }

        // Redirect to the login page by default
        response.sendRedirect("login.jsp"); // Replace with your login page URL
    }
}