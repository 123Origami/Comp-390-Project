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
import java.sql.ResultSet;
import java.sql.SQLException;
import Util.DBConnection;

@WebServlet("/appointmentservlet")
public class AppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve session
        HttpSession session = request.getSession(false);

        // Check if the user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp?error=session"); // Redirect to login if no session exists
            return;
        }

        // Retrieve form data
        String doctorName = request.getParameter("doctor");
        String specialization = request.getParameter("specialization");
        String date = request.getParameter("date");
        String time = request.getParameter("time");	

        // Validate input fields
        if (doctorName == null || date == null || time == null || doctorName.isEmpty() || date.isEmpty() || time.isEmpty()) {
            response.sendRedirect("appointment.jsp?error=missing_fields"); // Redirect back with error
            return;
        }

        Connection conn = null;
        PreparedStatement stmtGetDoctorID = null;
        PreparedStatement stmtInsertAppointment = null;
        ResultSet rs = null;

        try {
            // Connect to the database
            conn = DBConnection.getConnection();

            // Step 1: Retrieve Doctor_ID using doctor's name
            String sqlGetDoctorID = "SELECT Doctor_ID FROM Doctor WHERE Name = ?";
            stmtGetDoctorID = conn.prepareStatement(sqlGetDoctorID);
            stmtGetDoctorID.setString(1, doctorName);
            rs = stmtGetDoctorID.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("appointment.jsp?error=invalid_doctor"); // Invalid doctor name
                return;
            }

            int doctorID = rs.getInt("Doctor_ID");

            // Step 2: Retrieve User_ID from session
            int userID = Integer.parseInt(session.getAttribute("user_id").toString());

            // Step 3: Insert appointment into the database
            String sqlInsertAppointment = "INSERT INTO appointment (Doctor_ID, User_ID, Status, Date, Time) VALUES (?, ?, ?, ?, ?)";
            stmtInsertAppointment = conn.prepareStatement(sqlInsertAppointment, PreparedStatement.RETURN_GENERATED_KEYS);
            stmtInsertAppointment.setInt(1, doctorID); // Doctor_ID
            stmtInsertAppointment.setInt(2, userID);   // User_ID
            stmtInsertAppointment.setString(3, "Pending"); // Default status
            stmtInsertAppointment.setString(4, date);  // Date
            stmtInsertAppointment.setString(5, time);  // Time

            int rowsAffected = stmtInsertAppointment.executeUpdate();

            // Step 4: Retrieve the generated Appointment_ID
            int appointmentID = -1;
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmtInsertAppointment.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        appointmentID = generatedKeys.getInt(1); // Get the generated Appointment_ID
                    } else {
                        throw new SQLException("Creating appointment failed, no ID obtained.");
                    }
                }
            }

            // Step 5: Store the Appointment_ID in the session
            session.setAttribute("appointmentId", appointmentID);

            // Step 6: Redirect based on success or failure
            if (rowsAffected > 0) {
                response.sendRedirect("payment.jsp?success=true"); // Redirect to payment page
            } else {
                response.sendRedirect("appointment.jsp?error=database"); // Database error
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("appointment.jsp?error=database"); // Database error
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmtGetDoctorID != null) stmtGetDoctorID.close();
                if (stmtInsertAppointment != null) stmtInsertAppointment.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}