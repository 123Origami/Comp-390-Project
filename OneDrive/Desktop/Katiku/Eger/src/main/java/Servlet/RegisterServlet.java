package Servlet;

import Util.DBConnection;
import Util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 2369922809544114419L;

	/**
     * Handles the registration process for new users.
     *
     * @param request  The HttpServletRequest object that contains the user's input.
     * @param response The HttpServletResponse object to send back the response.
     * @throws IOException      If an input or output exception occurs.
     * @throws ServletException If a servlet exception occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Retrieve parameters from the registration form
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password"); // Plain-text password
        String phone_number = request.getParameter("phone_number");
        String role = request.getParameter("role");

        // Validate input (optional but recommended)
        if (username == null || username.isEmpty() ||
            email == null || email.isEmpty() ||
            password == null || password.isEmpty() ||
            phone_number == null || phone_number.isEmpty() ||
            role == null || role.isEmpty()) {
            response.sendRedirect("register.jsp?error=All fields are required.");
            return;
        }

        // Hash the plain-text password before storing it in the database
        String hashedPassword = PasswordUtil.hashPassword(password);

        try (Connection conn = DBConnection.getConnection()) {
            // SQL query to insert the user into the database
            String sql = "INSERT INTO user (Username, Email, Password, Phone, Role) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, hashedPassword); // Store the hashed password
                stmt.setString(4, phone_number);
                stmt.setString(5, role);

                // Execute the query to insert the user data
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    // Registration successful: Redirect to login page with success message
                    response.sendRedirect("login.jsp?message=Registration successful! Please log in.");
                } else {
                    // Failed to register: Redirect to register page with error message
                    response.sendRedirect("register.jsp?error=Failed to register. Please try again.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Database error: Redirect to register page with error message
            response.sendRedirect("register.jsp?error=Database error. Please try again later.");
        }
    }
}