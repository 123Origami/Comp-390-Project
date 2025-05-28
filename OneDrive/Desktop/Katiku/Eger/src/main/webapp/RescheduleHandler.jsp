<%@ page import="java.sql.*, Util.DBConnection" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    String appointmentIdStr = request.getParameter("appointmentId");
    String doctorIdStr = request.getParameter("doctorId");
    String newDate = request.getParameter("newDate");
    String newTime = request.getParameter("newTime");
    
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    if (appointmentIdStr == null || doctorIdStr == null || newDate == null || newTime == null) {
        response.sendRedirect("Appointments.jsp?error=missing_fields");
        return;
    }
    
    int appointmentId = Integer.parseInt(appointmentIdStr);
    int doctorId = Integer.parseInt(doctorIdStr);
    
    Connection conn = null;
    PreparedStatement ps = null;
    
    try {
        conn = DBConnection.getConnection();
        
        // First verify the appointment belongs to the user
        String verifyQuery = "SELECT Appointment_ID FROM appointment WHERE Appointment_ID = ? AND User_ID = ?";
        ps = conn.prepareStatement(verifyQuery);
        ps.setInt(1, appointmentId);
        ps.setInt(2, userId);
        ResultSet rs = ps.executeQuery();
        
        if (!rs.next()) {
            response.sendRedirect("Appointments.jsp?error=invalid_appointment");
            return;
        }
        
        // Check if the new time slot is available
        String availabilityQuery = "SELECT Appointment_ID FROM appointment " +
                                 "WHERE Doctor_ID = ? AND Date = ? AND Time = ? " +
                                 "AND Appointment_ID != ?";
        ps = conn.prepareStatement(availabilityQuery);
        ps.setInt(1, doctorId);
        ps.setString(2, newDate);
        ps.setString(3, newTime);
        ps.setInt(4, appointmentId);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            response.sendRedirect("Reschedule.jsp?appointmentId=" + appointmentId + "&error=slot_taken");
            return;
        }
        
        // Update the appointment
        String updateQuery = "UPDATE appointment SET Date = ?, Time = ? WHERE Appointment_ID = ?";
        ps = conn.prepareStatement(updateQuery);
        ps.setString(1, newDate);
        ps.setString(2, newTime);
        ps.setInt(3, appointmentId);
        
        int rowsUpdated = ps.executeUpdate();
        
        if (rowsUpdated > 0) {
            response.sendRedirect("Appointments.jsp?success=rescheduled");
        } else {
            response.sendRedirect("Appointments.jsp?error=update_failed");
        }
    } catch (SQLException e) {
        response.sendRedirect("Appointments.jsp?error=database");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
    }
%>