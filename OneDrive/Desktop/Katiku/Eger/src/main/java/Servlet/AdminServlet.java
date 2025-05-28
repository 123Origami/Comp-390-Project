package Servlet;

import Util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            
            if ("doctors".equals(action)) {
                String searchId = request.getParameter("searchId");
                if (searchId != null && !searchId.isEmpty()) {
                    request.setAttribute("doctors", searchDoctorsById(searchId));
                } else {
                    request.setAttribute("doctors", getAllDoctors());
                }
                request.setAttribute("specializations", getAllSpecializations());
            } 
            else if ("specializations".equals(action)) {
                request.setAttribute("specializations", getAllSpecializations());
            }
            else if ("appointments".equals(action)) {
                String dateFilter = request.getParameter("date");
                if (dateFilter != null && !dateFilter.isEmpty()) {
                    request.setAttribute("appointments", getAppointmentsByDate(dateFilter));
                    request.setAttribute("selectedDate", dateFilter);
                } else {
                    request.setAttribute("appointments", getAllAppointments());
                }
            }
            else if ("doctorAppointments".equals(action)) {
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                request.setAttribute("doctorAppointments", getAppointmentsByDoctor(doctorId));
                request.setAttribute("doctor", getDoctorById(doctorId));
            }
            else if ("report".equals(action)) {
                request.setAttribute("reportData", generateReport());
            }
            else if ("editDoctor".equals(action)) {
                int doctorId = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("doctor", getDoctorById(doctorId));
                request.setAttribute("doctorUser", getDoctorUser(doctorId));
                request.setAttribute("specializations", getAllSpecializations());
                request.setAttribute("editing", true);
            }
            else if ("editSpecialization".equals(action)) {
                int specId = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("specialization", getSpecializationById(specId));
                request.setAttribute("specializations", getAllSpecializations());
                request.setAttribute("editing", true);
            }
            
            // Always load dashboard stats
            request.setAttribute("totalDoctors", getCount("doctor"));
            request.setAttribute("totalSpecializations", getCount("specialization"));
            request.setAttribute("pendingAppointments", getCountWhere("appointment", "Status='pending'"));
            request.setAttribute("completedAppointments", getCountWhere("appointment", "Status='completed'"));
            
            request.getRequestDispatcher("Admin.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Invalid ID format");
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        try {
            if ("addDoctor".equals(action)) {
                addDoctor(request);
                session.setAttribute("success", "Doctor added successfully");
            } 
            else if ("addSpecialization".equals(action)) {
                addSpecialization(request);
                session.setAttribute("success", "Specialization added successfully");
            }
            else if ("deleteDoctor".equals(action)) {
                deleteDoctor(request);
            }
            else if ("deleteSpecialization".equals(action)) {
                deleteSpecialization(request);
            }
            else if ("updateAppointment".equals(action)) {
                updateAppointmentStatus(request);
                session.setAttribute("success", "Appointment status updated");
            }
            else if ("updateDoctor".equals(action)) {
                updateDoctor(request);
                session.setAttribute("success", "Doctor updated successfully");
            }
            else if ("updateSpecialization".equals(action)) {
                updateSpecialization(request);
                session.setAttribute("success", "Specialization updated successfully");
            }
            
            String returnTo = request.getParameter("returnTo");
            if (returnTo != null && !returnTo.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin?action=" + returnTo);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?action=" + getReturnAction(action));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Invalid ID format");
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }

    // ========== DOCTOR METHODS ==========
    private List<Map<String, Object>> getAllDoctors() throws SQLException {
        List<Map<String, Object>> doctors = new ArrayList<>();
        String sql = "SELECT d.*, s.Specialization_Name, " +
                    "(SELECT COUNT(*) FROM appointment a WHERE a.Doctor_ID = d.Doctor_ID AND a.Status != 'cancelled') as appointment_count " +
                    "FROM doctor d LEFT JOIN specialization s ON d.Specialization_ID = s.Specialization_ID";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> doctor = new HashMap<>();
                doctor.put("id", rs.getInt("Doctor_ID"));
                doctor.put("name", rs.getString("Name"));
                doctor.put("phone", rs.getString("Phone_number"));
                doctor.put("specialization", rs.getString("Specialization_Name"));
                doctor.put("specializationId", rs.getObject("Specialization_ID"));
                doctor.put("appointment_count", rs.getInt("appointment_count"));
                doctors.add(doctor);
            }
        }
        return doctors;
    }
    
    private List<Map<String, Object>> searchDoctorsById(String id) throws SQLException {
        List<Map<String, Object>> doctors = new ArrayList<>();
        String sql = "SELECT d.*, s.Specialization_Name, " +
                    "(SELECT COUNT(*) FROM appointment a WHERE a.Doctor_ID = d.Doctor_ID AND a.Status != 'cancelled') as appointment_count " +
                    "FROM doctor d LEFT JOIN specialization s ON d.Specialization_ID = s.Specialization_ID " +
                    "WHERE d.Doctor_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> doctor = new HashMap<>();
                    doctor.put("id", rs.getInt("Doctor_ID"));
                    doctor.put("name", rs.getString("Name"));
                    doctor.put("phone", rs.getString("Phone_number"));
                    doctor.put("specialization", rs.getString("Specialization_Name"));
                    doctor.put("specializationId", rs.getObject("Specialization_ID"));
                    doctor.put("appointment_count", rs.getInt("appointment_count"));
                    doctors.add(doctor);
                }
            }
        }
        return doctors;
    }
    
    private Map<String, Object> getDoctorById(int doctorId) throws SQLException {
        String sql = "SELECT d.*, s.Specialization_Name FROM doctor d " +
                     "LEFT JOIN specialization s ON d.Specialization_ID = s.Specialization_ID " +
                     "WHERE d.Doctor_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> doctor = new HashMap<>();
                    doctor.put("id", rs.getInt("Doctor_ID"));
                    doctor.put("name", rs.getString("Name"));
                    doctor.put("phone", rs.getString("Phone_number"));
                    doctor.put("specialization", rs.getString("Specialization_Name"));
                    doctor.put("specializationId", rs.getObject("Specialization_ID"));
                    return doctor;
                }
            }
        }
        return null;
    }
    
    private Map<String, Object> getDoctorUser(int doctorId) throws SQLException {
        String sql = "SELECT * FROM user WHERE Doctor_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("userId", rs.getInt("User_ID"));
                    user.put("username", rs.getString("Username"));
                    user.put("email", rs.getString("Email"));
                    user.put("phone", rs.getString("Phone"));
                    return user;
                }
            }
        }
        return null;
    }
    
    private void addDoctor(HttpServletRequest request) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // First insert into doctor table
            String insertDoctorSQL = "INSERT INTO doctor ( Name, Specialization_ID, Phone_number) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(insertDoctorSQL)) {
               
               
                pstmt.setString(1, request.getParameter("name"));
                pstmt.setInt(2, Integer.parseInt(request.getParameter("specialization")));
                pstmt.setString(3, request.getParameter("phone"));
                pstmt.executeUpdate();
            }
            
            // Then insert into user table
           String insertUserSQL = "INSERT INTO user (Username, Email, Password, Phone, Role) " +
                       "VALUES (?, ?, ?, ?, 'doctor')";
try (PreparedStatement pstmt = conn.prepareStatement(insertUserSQL, Statement.RETURN_GENERATED_KEYS)) {
    pstmt.setString(1, request.getParameter("username"));
    pstmt.setString(2, request.getParameter("email"));
    pstmt.setString(3, request.getParameter("password")); // Note: In production, this should be hashed
    pstmt.setString(4, request.getParameter("phone"));
    
    // Execute the insert statement
    pstmt.executeUpdate();
    
    // Retrieve the auto-generated Doctor_ID
    try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
        if (generatedKeys.next()) {
            int doctorId = generatedKeys.getInt(1); // Get the generated Doctor_ID
            // You can now use doctorId for other operations or logging if needed
        }
    }
}

            
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private void deleteDoctor(HttpServletRequest request) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            int doctorId = Integer.parseInt(request.getParameter("id"));
            
            // 1. First cancel all appointments for this doctor
            int cancelledCount = cancelDoctorAppointments(conn, doctorId);
            
            // 2. Delete the user account
            deleteUserForDoctor(conn, doctorId);
            
            // 3. Then delete the doctor
            int rowsDeleted = deleteDoctorRecord(conn, doctorId);
            
            if (rowsDeleted > 0) {
                String successMsg = "Doctor deleted successfully";
                if (cancelledCount > 0) {
                    successMsg += " and " + cancelledCount + " appointment(s) cancelled";
                }
                request.getSession().setAttribute("success", successMsg);
                conn.commit();
            } else {
                request.getSession().setAttribute("error", "Doctor not found");
                conn.rollback();
            }
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private int deleteUserForDoctor(Connection conn, int doctorId) throws SQLException {
        String sql = "DELETE FROM user WHERE Doctor_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            return pstmt.executeUpdate();
        }
    }
    
    private int cancelDoctorAppointments(Connection conn, int doctorId) throws SQLException {
        String sql = "UPDATE appointment SET Status = 'cancelled' WHERE Doctor_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            return pstmt.executeUpdate();
        }
    }
    
    private int deleteDoctorRecord(Connection conn, int doctorId) throws SQLException {
        String sql = "DELETE FROM doctor WHERE Doctor_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            return pstmt.executeUpdate();
        }
    }
    
    private void updateDoctor(HttpServletRequest request) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Update doctor table
            String updateDoctorSQL = "UPDATE doctor SET Name = ?, Specialization_ID = ?, Phone_number = ? " +
                                   "WHERE Doctor_ID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateDoctorSQL)) {
                pstmt.setString(1, request.getParameter("name"));
                
                // Handle potential null specialization
                String specId = request.getParameter("specialization");
                if (specId != null && !specId.isEmpty()) {
                    pstmt.setInt(2, Integer.parseInt(specId));
                } else {
                    pstmt.setNull(2, Types.INTEGER);
                }
                
                pstmt.setString(3, request.getParameter("phone"));
                pstmt.setInt(4, Integer.parseInt(request.getParameter("id")));
                pstmt.executeUpdate();
            }
            
            // Update user table
            String updateUserSQL = "UPDATE user SET Username = ?, Email = ?, Phone = ? " +
                                  "WHERE Doctor_ID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateUserSQL)) {
                pstmt.setString(1, request.getParameter("username"));
                pstmt.setString(2, request.getParameter("email"));
                pstmt.setString(3, request.getParameter("phone"));
                pstmt.setInt(4, Integer.parseInt(request.getParameter("id")));
                pstmt.executeUpdate();
            }
            
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // ========== SPECIALIZATION METHODS ==========
    private List<Map<String, Object>> getAllSpecializations() throws SQLException {
        List<Map<String, Object>> specs = new ArrayList<>();
        String sql = "SELECT s.*, " +
                     "(SELECT COUNT(*) FROM doctor d WHERE d.Specialization_ID = s.Specialization_ID) as doctor_count " +
                     "FROM specialization s";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> spec = new HashMap<>();
                spec.put("id", rs.getInt("Specialization_ID"));
                spec.put("name", rs.getString("Specialization_Name"));
                spec.put("description", rs.getString("Description"));
                spec.put("doctor_count", rs.getInt("doctor_count"));
                specs.add(spec);
            }
        }
        return specs;
    }
    
    private void addSpecialization(HttpServletRequest request) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "INSERT INTO specialization (Specialization_ID, Specialization_Name, Description) " +
                 "VALUES (?, ?, ?)")) {
            
            pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
            pstmt.setString(2, request.getParameter("name"));
            pstmt.setString(3, request.getParameter("description"));
            pstmt.executeUpdate();
        }
    }
    
    private void deleteSpecialization(HttpServletRequest request) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            int specializationId = Integer.parseInt(request.getParameter("id"));
            
            // 1. First check if there are any doctors with this specialization
            int doctorsWithSpec = getCountWhere("doctor", "Specialization_ID = " + specializationId);
            
            if (doctorsWithSpec > 0) {
                // If there are doctors with this specialization, we can't delete it
                request.getSession().setAttribute("error", 
                    "Cannot delete specialization - it is assigned to " + doctorsWithSpec + " doctor(s). " +
                    "Please reassign these doctors first.");
                conn.rollback();
                return;
            }
            
            // 2. If no doctors have this specialization, proceed with deletion
            int rowsDeleted = deleteSpecializationRecord(conn, specializationId);
            
            if (rowsDeleted > 0) {
                request.getSession().setAttribute("success", "Specialization deleted successfully");
                conn.commit();
            } else {
                request.getSession().setAttribute("error", "Specialization not found");
                conn.rollback();
            }
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private int deleteSpecializationRecord(Connection conn, int specializationId) throws SQLException {
        String sql = "DELETE FROM specialization WHERE Specialization_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, specializationId);
            return pstmt.executeUpdate();
        }
    }
    
    private void updateSpecialization(HttpServletRequest request) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "UPDATE specialization SET Specialization_Name = ?, Description = ? " +
                 "WHERE Specialization_ID = ?")) {
            
            pstmt.setString(1, request.getParameter("name"));
            pstmt.setString(2, request.getParameter("description"));
            pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
            pstmt.executeUpdate();
        }
    }
    
    private Map<String, Object> getSpecializationById(int specId) throws SQLException {
        String sql = "SELECT * FROM specialization WHERE Specialization_ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, specId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> specialization = new HashMap<>();
                    specialization.put("id", rs.getInt("Specialization_ID"));
                    specialization.put("name", rs.getString("Specialization_Name"));
                    specialization.put("description", rs.getString("Description"));
                    return specialization;
                }
            }
        }
        return null;
    }

    // ========== APPOINTMENT METHODS ==========
    private List<Map<String, Object>> getAllAppointments() throws SQLException {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = "SELECT a.Appointment_ID, u.Username AS patient, d.Name AS doctor, " +
                     "a.Date, a.Time, a.Status " +
                     "FROM appointment a " +
                     "JOIN user u ON a.User_ID = u.User_ID " +
                     "JOIN doctor d ON a.Doctor_ID = d.Doctor_ID " +
                     "ORDER BY a.Date DESC, a.Time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> appt = new HashMap<>();
                appt.put("id", rs.getInt("Appointment_ID"));
                appt.put("patient", rs.getString("patient"));
                appt.put("doctor", rs.getString("doctor"));
                appt.put("date", rs.getDate("Date"));
                appt.put("time", rs.getTime("Time"));
                appt.put("status", rs.getString("Status"));
                appointments.add(appt);
            }
        }
        return appointments;
    }
    
    private List<Map<String, Object>> getAppointmentsByDate(String date) throws SQLException {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = "SELECT a.Appointment_ID, u.Username AS patient, d.Name AS doctor, " +
                     "a.Date, a.Time, a.Status " +
                     "FROM appointment a " +
                     "JOIN user u ON a.User_ID = u.User_ID " +
                     "JOIN doctor d ON a.Doctor_ID = d.Doctor_ID " +
                     "WHERE a.Date = ? " +
                     "ORDER BY a.Time";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, Date.valueOf(date));
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appt = new HashMap<>();
                    appt.put("id", rs.getInt("Appointment_ID"));
                    appt.put("patient", rs.getString("patient"));
                    appt.put("doctor", rs.getString("doctor"));
                    appt.put("date", rs.getDate("Date"));
                    appt.put("time", rs.getTime("Time"));
                    appt.put("status", rs.getString("Status"));
                    appointments.add(appt);
                }
            }
        }
        return appointments;
    }
    
    private List<Map<String, Object>> getAppointmentsByDoctor(int doctorId) throws SQLException {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = "SELECT a.Appointment_ID, u.Username AS patient, " +
                     "a.Date, a.Time, a.Status " +
                     "FROM appointment a " +
                     "JOIN user u ON a.User_ID = u.User_ID " +
                     "WHERE a.Doctor_ID = ? AND a.Status != 'cancelled' " +
                     "ORDER BY a.Date DESC, a.Time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appt = new HashMap<>();
                    appt.put("id", rs.getInt("Appointment_ID"));
                    appt.put("patient", rs.getString("patient"));
                    appt.put("date", rs.getDate("Date"));
                    appt.put("time", rs.getTime("Time"));
                    appt.put("status", rs.getString("Status"));
                    appointments.add(appt);
                }
            }
        }
        return appointments;
    }
    
    private void updateAppointmentStatus(HttpServletRequest request) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "UPDATE appointment SET Status = ? WHERE Appointment_ID = ?")) {
            
            pstmt.setString(1, request.getParameter("status"));
            pstmt.setInt(2, Integer.parseInt(request.getParameter("appointmentId")));
            pstmt.executeUpdate();
        }
    }

    // ========== REPORT METHODS ==========
    private List<Map<String, Object>> generateReport() throws SQLException {
        List<Map<String, Object>> report = new ArrayList<>();
        String sql = "SELECT d.Doctor_ID, d.Name AS doctor_name, " +
                     "COUNT(a.Appointment_ID) AS appointment_count, " +
                     "s.Specialization_Name " +
                     "FROM doctor d " +
                     "LEFT JOIN appointment a ON d.Doctor_ID = a.Doctor_ID " +
                     "LEFT JOIN specialization s ON d.Specialization_ID = s.Specialization_ID " +
                     "GROUP BY d.Doctor_ID";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("doctor_id", rs.getInt("Doctor_ID"));
                row.put("doctor_name", rs.getString("doctor_name"));
                row.put("appointment_count", rs.getInt("appointment_count"));
                row.put("specialization", rs.getString("Specialization_Name"));
                report.add(row);
            }
        }
        return report;
    }

    // ========== HELPER METHODS ==========
    private String getReturnAction(String action) {
        if (action == null) return "";
        return action.replace("add", "").replace("delete", "").replace("update", "");
    }
    
    private int getCount(String table) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getCountWhere(String table, String condition) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table + " WHERE " + condition)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}