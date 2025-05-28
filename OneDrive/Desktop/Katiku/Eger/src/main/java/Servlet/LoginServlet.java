package Servlet;

import java.io.IOException;
import Util.DBConnection;
import Util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = -1943245059483344056L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve username and password from the login form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input fields
        if (username == null || password == null) {
            response.sendRedirect("login.jsp?error=empty fields"); // Redirect back to login page with error
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Connect to the database
            conn = DBConnection.getConnection();

            // Query to fetch user details based on the username
            String sql = "SELECT User_ID, Username, Password, Role FROM user WHERE Username = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (!rs.next()) {
                // No user found with the given username
                response.sendRedirect("login.jsp?error=invalid"); // Redirect back to login page with error
                return;
            }

            // Retrieve stored hashed password and user role
            int userId = rs.getInt("User_ID");
            String hashedPassword = rs.getString("Password");
            String role = rs.getString("Role");

            // Verify the plain-text password against the stored hash
            if (!PasswordUtil.verifyPassword(password, hashedPassword)) {
                response.sendRedirect("login.jsp?error=invalid"); // Invalid password
                return;
            }

            // Invalidate any existing session to prevent conflicts
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate(); // Invalidate the old session
            }

            // Create a new session and set attributes
            HttpSession newSession = request.getSession(true); // Create a new session
            newSession.setAttribute("user_id", userId);
            newSession.setAttribute("username", username);

            // Redirect based on the user's role
            switch (role.toLowerCase()) {
                case "patient":
                    newSession.setAttribute("patientID", userId); // Set patient-specific attribute
                    response.sendRedirect("home.jsp?success=true");
                    break;
                case "doctor":
                    newSession.setAttribute("doctorID", String.valueOf(userId)); 
                    newSession.setAttribute("doctorName", username); 
                    response.sendRedirect("DoctorDashboard.jsp?success=true"); // Redirect to DoctorDashboard.jsp
                    break;
                case "admin":
                    newSession.setAttribute("adminID", userId); // Set admin-specific attribute
                    response.sendRedirect("Admin.jsp?success=true");
                    break;
                default:
                    response.sendRedirect("home.jsp?success=true"); 
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=database");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}