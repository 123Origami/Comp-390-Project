package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Util.DBConnection;

@WebServlet("/DoctorAppointmentServlet")
public class DoctorsAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || 
            !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String appointmentId = request.getParameter("appointmentId");
        
        if (appointmentId == null || appointmentId.isEmpty()) {
            response.sendRedirect("DoctorDashboard.jsp?error=invalid_appointment");
            return;
        }

        Connection conn = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            
            switch (action) {
                case "complete":
                    success = completeAppointment(conn, appointmentId);
                    break;
                case "cancel":
                    success = cancelAppointment(conn, appointmentId);
                    break;
                case "reschedule":
                    String newDate = request.getParameter("newDate");
                    String newTime = request.getParameter("newTime");
                    success = rescheduleAppointment(conn, appointmentId, newDate, newTime);
                    break;
                default:
                    response.sendRedirect("DoctorDashboard.jsp?error=invalid_action");
                    return;
            }

            if (success) {
                response.sendRedirect("DoctorDashboard.jsp?success=" + action);
            } else {
                response.sendRedirect("DoctorDashboard.jsp?error=" + action);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("DoctorDashboard.jsp?error=database_error");
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    private boolean completeAppointment(Connection conn, String appointmentId) throws SQLException {
        String sql = "UPDATE appointment SET Status = 'completed' WHERE Appointment_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(appointmentId));
            return stmt.executeUpdate() > 0;
        }
    }

    private boolean cancelAppointment(Connection conn, String appointmentId) throws SQLException {
        String sql = "UPDATE appointment SET Status = 'cancelled' WHERE Appointment_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(appointmentId));
            return stmt.executeUpdate() > 0;
        }
    }

    private boolean rescheduleAppointment(Connection conn, String appointmentId, String newDate, String newTime) 
            throws SQLException {
        try {
            // Parse the date and time
            Date date = Date.valueOf(newDate);
            Time time = Time.valueOf(newTime + ":00"); // Add seconds if not present
            
            String sql = "UPDATE appointment SET Date = ?, Time = ?, Status = 'confirmed' WHERE Appointment_ID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setDate(1, date);
                stmt.setTime(2, time);
                stmt.setInt(3, Integer.parseInt(appointmentId));
                return stmt.executeUpdate() > 0;
            }
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return false;
        }
    }
}