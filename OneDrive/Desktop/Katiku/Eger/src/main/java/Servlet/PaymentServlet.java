package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Util.DBConnection;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 675892284803225613L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Prevent caching of sensitive data
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Retrieve session
        HttpSession session = request.getSession(false);

        // Check if the user is logged in
        if (session == null || session.getAttribute("user_id") == null || session.getAttribute("appointmentId") == null) {
            response.sendRedirect("login.jsp?error=session"); // Redirect to login if session is invalid
            return;
        }

        // Retrieve session data
        int userId = Integer.parseInt(session.getAttribute("user_id").toString());
        int appointmentId = Integer.parseInt(session.getAttribute("appointmentId").toString());

        // Retrieve form data
        String accountNumber = request.getParameter("accountNumber");

        // Validate input fields
        if (accountNumber == null || accountNumber.isEmpty()) {
            response.sendRedirect("payment.jsp?error=missing_fields"); // Redirect back with error
            return;
        }

        // Predefined amount (e.g., KES 250)
        double amount = 250.0;

        Connection conn = null;
        PreparedStatement stmtInsertPayment = null;

        try {
            // Connect to the database
            conn = DBConnection.getConnection();

            // Insert a new payment record into the payment table
            String sqlInsertPayment = "INSERT INTO payment (User_ID, Appointment_ID, Amount, Payment_Date, Payment_Time) VALUES (?, ?, ?, ?, ?)";
            stmtInsertPayment = conn.prepareStatement(sqlInsertPayment);
            stmtInsertPayment.setInt(1, userId); // User_ID
            stmtInsertPayment.setInt(2, appointmentId); // Appointment_ID
            stmtInsertPayment.setDouble(3, amount); // Predefined amount (KES 250)
            stmtInsertPayment.setDate(4, java.sql.Date.valueOf(LocalDate.now())); // Payment_Date
            stmtInsertPayment.setTime(5, java.sql.Time.valueOf(LocalTime.now())); // Payment_Time

            int rowsAffected = stmtInsertPayment.executeUpdate();

            // Redirect based on success or failure
            if (rowsAffected > 0) {
                // Redirect to confirmation page on success
                response.sendRedirect("confirmation.jsp?success=true");
            } else {
                // Redirect to error page if insertion fails
                response.sendRedirect("payment.jsp?error=database");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("payment.jsp?error=database"); // Redirect to error page
        } finally {
            // Close resources safely
            try {
                if (stmtInsertPayment != null) stmtInsertPayment.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}