<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="CSSfiles/admin.css">
    <style>
        /* Dashboard Layout */
        .dashboard {
            display: flex;
            min-height: 100vh;
            font-family: Arial, sans-serif;
        }
        
        .sidebar {
            width: 250px;
            background: #2c3e50;
            color: white;
            padding: 20px;
        }
        
        .main-content {
            flex: 1;
            padding: 20px;
            background: #f5f5f5;
        }
        
        /* Cards */
        .card-container {
            display: grid;
            grid-template-columns: repeat(4, 1.5fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .card {
            min-width: 220px;
            padding: 15px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .card.blue { border-top: 4px solid #3498db; }
        .card.green { border-top: 4px solid #2ecc71; }
        .card.yellow { border-top: 4px solid #f39c12; }
        .card.cyan { border-top: 4px solid #1abc9c; }
        
        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: white;
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background-color: #2c3e50;
            color: white;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        /* Forms and Buttons */
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 5px;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        /* Modals */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            border-radius: 5px;
            max-height: 80vh;
            overflow-y: auto;
        }
        
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: black;
        }
        
        /* Alert Messages */
        .alert {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        
        .alert-warning {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            color: #856404;
        }
        
        /* Error Message */
        .error-message {
            color: #e74c3c;
            padding: 10px;
            margin: 10px 0;
            background: #fdecea;
            border-radius: 4px;
        }
        
        .success-message {
            color: #155724;
            padding: 10px;
            margin: 10px 0;
            background: #d4edda;
            border-radius: 4px;
        }
        
        /* Search and Filter */
        .search-container {
            margin: 20px 0;
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .search-container input[type="text"],
        .search-container input[type="date"],
        .search-container select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            height: 38px;
        }
        
        /* Print Styles */
        @media print {
            .no-print {
                display: none !important;
            }
            
            body {
                background: white;
                color: black;
                font-size: 12pt;
            }
            
            table {
                width: 100%;
                border-collapse: collapse;
            }
            
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
            }
            
            th {
                background-color: #f2f2f2 !important;
                color: black !important;
            }
            
            .sidebar {
                display: none;
            }
            
            .main-content {
                margin-left: 0;
                padding: 0;
            }
        }
        
        /* Links */
        .view-link {
            color: #3498db;
            text-decoration: none;
            margin-left: 10px;
        }
        
        .view-link:hover {
            text-decoration: underline;
        }
        
        /* Status Badges */
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-pending {
            background-color: #f39c12;
            color: white;
        }
        
        .status-confirmed {
            background-color: #2ecc71;
            color: white;
        }
        
        .status-cancelled {
            background-color: #e74c3c;
            color: white;
        }
        
        .status-completed {
            background-color: #3498db;
            color: white;
        }
        
        /* Print Button */
        .print-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        
        .print-btn:hover {
            background: #5a6268;
        }
        
        /* Two column form layout */
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-col {
            flex: 1;
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <h2>Admin Dashboard</h2>
            <p>Welcome, Admin</p>
            <ul style="list-style: none; padding: 0;">
                <li><a href="admin" style="color: white; text-decoration: none; display: block; padding: 10px;">Dashboard</a></li>
                <li><a href="admin?action=doctors" style="color: white; text-decoration: none; display: block; padding: 10px;">Manage Doctors</a></li>
                <li><a href="admin?action=specializations" style="color: white; text-decoration: none; display: block; padding: 10px;">Manage Specializations</a></li>
                <li><a href="admin?action=appointments" style="color: white; text-decoration: none; display: block; padding: 10px;">Manage Appointments</a></li>
                <li><a href="admin?action=report" style="color: white; text-decoration: none; display: block; padding: 10px;">Generate Report</a></li>
                <li><a href="logout.jsp" style="color: white; text-decoration: none; display: block; padding: 10px;">Logout</a></li>
            </ul>
        </div>

        <!-- Main Content Area -->
        <div class="main-content">
            <!-- Success Message Display -->
            <% if (request.getSession().getAttribute("success") != null) { %>
                <div class="success-message">
                    <%= request.getSession().getAttribute("success") %>
                </div>
                <% request.getSession().removeAttribute("success"); %>
            <% } %>
            
            <!-- Error Message Display -->
            <% if (request.getSession().getAttribute("error") != null) { %>
                <div class="error-message">
                    <%= request.getSession().getAttribute("error") %>
                </div>
                <% request.getSession().removeAttribute("error"); %>
            <% } %>
            
            <!-- Dashboard Overview -->
            <% if (request.getParameter("action") == null || request.getParameter("action").isEmpty()) { %>
                <h1>Dashboard Overview</h1>
                <div class="card-container">
                    <div class="card blue">
                        <h3>Total Doctors</h3>
                        <p>${totalDoctors}</p>
                    </div>
                    <div class="card green">
                        <h3>Specializations</h3>
                        <p>${totalSpecializations}</p>
                    </div>
                    <div class="card yellow">
                        <h3>Pending Appointments</h3>
                        <p>${pendingAppointments}</p>
                    </div>
                    <div class="card cyan">
                        <h3>Completed Appointments</h3>
                        <p>${completedAppointments}</p>
                    </div>
                </div>
            <% } %>
            
            <!-- Doctors Management -->
            <% if ("doctors".equals(request.getParameter("action"))) { %>
                <h1>Manage Doctors</h1>
                
                <div class="search-container no-print">
                    <form method="get" action="admin">
                        <input type="hidden" name="action" value="doctors">
                        <input type="text" name="searchId" placeholder="Search by Doctor ID" 
                               value="<%= request.getParameter("searchId") != null ? request.getParameter("searchId") : "" %>">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <% if (request.getParameter("searchId") != null && !request.getParameter("searchId").isEmpty()) { %>
                            <a href="admin?action=doctors" class="btn btn-secondary">Clear</a>
                        <% } %>
                    </form>
                </div>
                
                <button class="btn btn-primary no-print" onclick="openModal('addDoctorModal')">Add New Doctor</button>
                
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Specialization</th>
                            <th>Phone</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Appointments</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Map<String, Object>> doctors = (List<Map<String, Object>>) request.getAttribute("doctors");
                        if (doctors != null && !doctors.isEmpty()) {
                            for (Map<String, Object> doctor : doctors) { 
                                Map<String, Object> doctorUser = (Map<String, Object>) request.getAttribute("doctorUser_" + doctor.get("id"));
                        %>
                                <tr>
                                    <td><%= doctor.get("id") %></td>
                                    <td><%= doctor.get("name") %></td>
                                    <td><%= doctor.get("specialization") != null ? doctor.get("specialization") : "N/A" %></td>
                                    <td><%= doctor.get("phone") %></td>
                                    <td><%= doctorUser != null ? doctorUser.get("username") : "N/A" %></td>
                                    <td><%= doctorUser != null ? doctorUser.get("email") : "N/A" %></td>
                                    <td><%= doctor.get("appointment_count") %></td>
                                    <td>
                                        <button class="btn btn-primary no-print" 
                                            onclick="openEditDoctorModal(
                                                <%= doctor.get("id") %>, 
                                                '<%= doctor.get("name") %>', 
                                                <%= doctor.get("specializationId") != null ? doctor.get("specializationId") : "null" %>, 
                                                '<%= doctor.get("phone") %>',
                                                '<%= doctorUser != null ? doctorUser.get("username") : "" %>',
                                                '<%= doctorUser != null ? doctorUser.get("email") : "" %>',
                                                '<%= doctorUser != null ? doctorUser.get("phone") : "" %>'
                                            )">
                                            Edit
                                        </button>
                                        <button class="btn btn-danger no-print" 
                                            onclick="showDeleteConfirmation(
                                                'doctor',
                                                <%= doctor.get("id") %>, 
                                                '<%= doctor.get("name") %>', 
                                                <%= doctor.get("appointment_count") != null ? doctor.get("appointment_count") : 0 %>
                                            )">
                                            Delete
                                        </button>
                                        <a href="admin?action=doctorAppointments&doctorId=<%= doctor.get("id") %>" 
                                           class="view-link no-print">
                                            View Appointments
                                        </a>
                                    </td>
                                </tr>
                        <% 
                            }
                        } else { 
                        %>
                            <tr>
                                <td colspan="8">No doctors found</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <!-- Add Doctor Modal -->
                <div id="addDoctorModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal('addDoctorModal')">&times;</span>
                        <h2>Add New Doctor</h2>
                        <form action="admin" method="post">
                            <input type="hidden" name="action" value="addDoctor">
                            <div class="form-row">
                                <div class="form-col">
                                    <h3>Doctor Information</h3>
                                    <div class="form-group">
                                      
                                    </div>
                                    <div class="form-group">
                                        <label>Name:</label>
                                        <input type="text" name="name" class="form-control" pattern="[A-Za-z\s]+" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Specialization:</label>
                                        <select name="specialization" class="form-control" pattern="[A-Za-z\s]+" required>
                                            <option value="">Select Specialization</option>
                                            <% 
                                            List<Map<String, Object>> specializations = (List<Map<String, Object>>) request.getAttribute("specializations");
                                            if (specializations != null) {
                                                for (Map<String, Object> spec : specializations) { 
                                            %>
                                                    <option value="<%= spec.get("id") %>"><%= spec.get("name") %></option>
                                            <% 
                                                }
                                            } 
                                            %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Phone Number:</label>
                                        <input type="text" name="phone" class="form-control" required>
                                    </div>
                                </div>
                                <div class="form-col">
                                    <h3>Login Credentials</h3>
                                    <div class="form-group">
                            
                                    </div>
                                    <div class="form-group">
                                        <label>Username:</label>
                                        <input type="text" name="username" class="form-control" pattern="[A-Za-z\s]+" 	required>
                                    </div>
                                    <div class="form-group">
                                        <label>Email:</label>
                                        <input type="email" name="email" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Password:</label>
                                        <input type="password" name="password" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">Add Doctor</button>
                        </form>
                    </div>
                </div>
                
                <!-- Edit Doctor Modal -->
                <div id="editDoctorModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal('editDoctorModal')">&times;</span>
                        <h2>Edit Doctor</h2>
                        <form action="admin" method="post">
                            <input type="hidden" name="action" value="updateDoctor">
                            <input type="hidden" name="id" id="editDoctorId">
                            <div class="form-row">
                                <div class="form-col">
                                    <h3>Doctor Information</h3>
                                    <div class="form-group">
                                        <label>Name:</label>
                                        <input type="text" name="name" id="editDoctorName" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Specialization:</label>
                                        <select name="specialization" id="editDoctorSpecialization" class="form-control" required>
                                            <option value="">Select Specialization</option>
                                            <% 
                                            if (specializations != null) {
                                                for (Map<String, Object> spec : specializations) { 
                                            %>
                                                    <option value="<%= spec.get("id") %>"><%= spec.get("name") %></option>
                                            <% 
                                                }
                                            } 
                                            %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Phone Number:</label>
                                        <input type="text" name="phone" id="editDoctorPhone" class="form-control" required>
                                    </div>
                                </div>
                                <div class="form-col">
                                    <h3>Login Credentials</h3>
                                    <div class="form-group">
                                        <label>Username:</label>
                                        <input type="text" name="username" id="editDoctorUsername" class="form-control" pattern="[A-Za-z\s]+" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Email:</label>
                                        <input type="email" name="email" id="editDoctorEmail" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                       
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">Update Doctor</button>
                        </form>
                    </div>
                </div>
            <% } %>
            
            <!-- Specializations Management -->
            <% if ("specializations".equals(request.getParameter("action"))) { %>
                <h1>Manage Specializations</h1>
                
                <button class="btn btn-primary no-print" onclick="openModal('addSpecializationModal')">Add New Specialization</button>
                
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Doctors</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Map<String, Object>> specializations = (List<Map<String, Object>>) request.getAttribute("specializations");
                        if (specializations != null && !specializations.isEmpty()) {
                            for (Map<String, Object> spec : specializations) { 
                        %>
                                <tr>
                                    <td><%= spec.get("id") %></td>
                                    <td><%= spec.get("name") %></td>
                                    <td><%= spec.get("description") != null ? spec.get("description") : "" %></td>
                                    <td><%= spec.get("doctor_count") %></td>
                                    <td>
                                        <button class="btn btn-primary no-print" 
                                            onclick="openEditSpecializationModal(
                                                <%= spec.get("id") %>, 
                                                '<%= spec.get("name") %>', 
                                                '<%= spec.get("description") != null ? spec.get("description") : "" %>'
                                            )">
                                            Edit
                                        </button>
                                        <button class="btn btn-danger no-print" 
                                            onclick="showDeleteConfirmation(
                                                'specialization',
                                                <%= spec.get("id") %>, 
                                                '<%= spec.get("name") %>', 
                                                <%= spec.get("doctor_count") != null ? spec.get("doctor_count") : 0 %>
                                            )">
                                            Delete
                                        </button>
                                    </td>
                                </tr>
                        <% 
                            }
                        } else { 
                        %>
                            <tr>
                                <td colspan="5">No specializations found</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <!-- Add Specialization Modal -->
                <div id="addSpecializationModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal('addSpecializationModal')">&times;</span>
                        <h2>Add New Specialization</h2>
                        <form action="admin" method="post">
                            <input type="hidden" name="action" value="addSpecialization">
                            <div class="form-group">
                                <label>ID:</label>
                                <input type="number" name="id" class="form-control" required min="1">
                            </div>
                            <div class="form-group">
                                <label>Name:</label>
                                <input type="text" name="name" class="form-control" pattern="[A-Za-z\s]+" required>
                            </div>
                            <div class="form-group">
                                <label>Description:</label>
                                <textarea name="description" class="form-control" pattern="[A-Za-z\s]+"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Add Specialization</button>
                        </form>
                    </div>
                </div>
                
                <!-- Edit Specialization Modal -->
                <div id="editSpecializationModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal('editSpecializationModal')">&times;</span>
                        <h2>Edit Specialization</h2>
                        <form action="admin" method="post">
                            <input type="hidden" name="action" value="updateSpecialization">
                            <input type="hidden" name="id" id="editSpecId">
                            <div class="form-group">
                                <label>Name:</label>
                                <input type="text" name="name" id="editSpecName" class="form-control" pattern="[A-Za-z\s]+" required>
                            </div>
                            <div class="form-group">
                                <label>Description:</label>
                                <textarea name="description" id="editSpecDescription" class="form-control" pattern="[A-Za-z\s]+"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Update Specialization</button>
                        </form>
                    </div>
                </div>
            <% } %>
            
            <!-- Appointments Management -->
            <% if ("appointments".equals(request.getParameter("action"))) { %>
                <h1>Manage Appointments</h1>
                
                <div class="search-container no-print">
                    <form method="get" action="admin">
                        <input type="hidden" name="action" value="appointments">
                        <input type="date" name="date" value="<%= request.getAttribute("selectedDate") != null ? request.getAttribute("selectedDate") : "" %>">
                        <button type="submit" class="btn btn-primary">Filter</button>
                        <a href="admin?action=appointments" class="btn btn-secondary">Show All</a>
                    </form>
                </div>
                
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Status</th>
                            <th class="no-print">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Map<String, Object>> appointments = (List<Map<String, Object>>) request.getAttribute("appointments");
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Map<String, Object> appt : appointments) { 
                        %>
                                <tr>
                                    <td><%= appt.get("id") %></td>
                                    <td><%= appt.get("patient") %></td>
                                    <td><%= appt.get("doctor") %></td>
                                    <td><%= appt.get("date") %></td>
                                    <td><%= appt.get("time") %></td>
                                    <td>
                                        <span class="status-badge status-<%= appt.get("status") %>">
                                            <%= appt.get("status") %>
                                        </span>
                                    </td>
                                    <td class="no-print">
                                        <form action="admin" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="updateAppointment">
                                            <input type="hidden" name="appointmentId" value="<%= appt.get("id") %>">
                                            <input type="hidden" name="returnTo" value="appointments">
                                            <select name="status" onchange="this.form.submit()">
                                                <option value="pending" <%= "pending".equals(appt.get("status")) ? "selected" : "" %>>Pending</option>
                                                <option value="confirmed" <%= "confirmed".equals(appt.get("status")) ? "selected" : "" %>>Confirmed</option>
                                                <option value="completed" <%= "completed".equals(appt.get("status")) ? "selected" : "" %>>Completed</option>
                                                <option value="cancelled" <%= "cancelled".equals(appt.get("status")) ? "selected" : "" %>>Cancelled</option>
                                            </select>
                                        </form>
                                    </td>
                                </tr>
                        <% 
                            }
                        } else { 
                        %>
                            <tr>
                                <td colspan="7">No appointments found</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <!-- Doctor Appointments View -->
            <% if ("doctorAppointments".equals(request.getParameter("action"))) { %>
                <h1>Appointments for Dr. ${doctor.name}</h1>
                
                <div class="no-print">
                    <a href="admin?action=doctors" class="btn btn-primary">Back to Doctors</a>
                </div>
                
                <table>
                    <thead>
                        <tr>
                            <th>Appointment ID</th>
                            <th>Patient</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Map<String, Object>> appointments = (List<Map<String, Object>>) request.getAttribute("doctorAppointments");
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Map<String, Object> appt : appointments) { 
                        %>
                                <tr>
                                    <td><%= appt.get("id") %></td>
                                    <td><%= appt.get("patient") %></td>
                                    <td><%= appt.get("date") %></td>
                                    <td><%= appt.get("time") %></td>
                                    <td>
                                        <span class="status-badge status-<%= appt.get("status") %>">
                                            <%= appt.get("status") %>
                                        </span>
                                    </td>
                                </tr>
                        <% 
                            }
                        } else { 
                        %>
                            <tr>
                                <td colspan="5">No upcoming appointments found</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <!-- Report Generation -->
            <% if ("report".equals(request.getParameter("action"))) { %>
                <h1>Doctor Appointment Report</h1>
                
                <div class="no-print">
                    <button onclick="window.print()" class="print-btn">Print Report</button>
                </div>
                
                <table>
                    <thead>
                        <tr>
                            <th>Doctor ID</th>
                            <th>Doctor Name</th>
                            <th>Specialization</th>
                            <th>Appointment Count</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Map<String, Object>> reportData = (List<Map<String, Object>>) request.getAttribute("reportData");
                        if (reportData != null && !reportData.isEmpty()) {
                            for (Map<String, Object> row : reportData) { 
                        %>
                                <tr>
                                    <td><%= row.get("doctor_id") %></td>
                                    <td><%= row.get("doctor_name") %></td>
                                    <td><%= row.get("specialization") %></td>
                                    <td><%= row.get("appointment_count") %></td>
                                </tr>
                        <% 
                            }
                        } else { 
                        %>
                            <tr>
                                <td colspan="4">No report data available</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <!-- Delete Confirmation Modal -->
            <div id="confirmDeleteModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal('confirmDeleteModal')">&times;</span>
                    <h2 id="deleteModalTitle">Confirm Deletion</h2>
                    <div class="modal-body">
                        <p id="deleteMessage"></p>
                        <div id="deleteWarning" class="alert alert-warning" style="display:none;"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeModal('confirmDeleteModal')">Cancel</button>
                        <button type="button" id="confirmDeleteBtn" class="btn btn-danger">Confirm Delete</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Global variables for deletion
        let currentDeleteType = null;
        let currentDeleteId = null;
        
        // Modal functions
        function openModal(modalId) {
            document.getElementById(modalId).style.display = 'block';
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.className === 'modal') {
                event.target.style.display = 'none';
            }
        }
        
        // Show delete confirmation dialog
        function showDeleteConfirmation(type, id, name, relatedCount) {
            currentDeleteType = type;
            currentDeleteId = id;
            
            const title = type === 'doctor' ? 'Delete Doctor' : 'Delete Specialization';
            document.getElementById('deleteModalTitle').textContent = title;
            
            const message = `Are you sure you want to delete ${type == 'doctor' ? 'Dr. ' : ''}${name}?`;
            document.getElementById('deleteMessage').textContent = message;
            
            const warningDiv = document.getElementById('deleteWarning');
            if (relatedCount > 0) {
                const warningMsg = type === 'doctor' 
                    ? `Warning: This doctor has ${relatedCount} appointment(s) that will be cancelled.`
                    : `Warning: This specialization is assigned to ${relatedCount} doctor(s) and will be removed from their profiles.`;
                
                warningDiv.style.display = 'block';
                warningDiv.innerHTML = warningMsg;
            } else {
                warningDiv.style.display = 'none';
            }
            
            // Set up confirm button handler
            document.getElementById('confirmDeleteBtn').onclick = performDelete;
            
            // Show modal
            openModal('confirmDeleteModal');
        }
        
        // Perform the actual deletion
        function performDelete() {
            if (!currentDeleteType || !currentDeleteId) return;
            
            // Create a form dynamically
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'admin';
            
            // Add hidden inputs
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete' + currentDeleteType.charAt(0).toUpperCase() + currentDeleteType.slice(1);
            form.appendChild(actionInput);
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = currentDeleteId;
            form.appendChild(idInput);
            
            // Submit the form
            document.body.appendChild(form);
            form.submit();
            
            // Close modal
            closeModal('confirmDeleteModal');
        }
        
        // Open edit doctor modal with data
        function openEditDoctorModal(id, name, specializationId, phone, username, email, userPhone) {
            document.getElementById('editDoctorId').value = id;
            document.getElementById('editDoctorName').value = name;
            document.getElementById('editDoctorSpecialization').value = specializationId;
            document.getElementById('editDoctorPhone').value = phone;
            document.getElementById('editDoctorUsername').value = username;
            document.getElementById('editDoctorEmail').value = email;
            openModal('editDoctorModal');
        }
        
        // Open edit specialization modal with data
        function openEditSpecializationModal(id, name, description) {
            document.getElementById('editSpecId').value = id;
            document.getElementById('editSpecName').value = name;
            document.getElementById('editSpecDescription').value = description;
            openModal('editSpecializationModal');
        }
        
        // Automatically set today's date as default in date filter
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.querySelector('input[type="date"]');
            if (dateInput && !dateInput.value) {
                const today = new Date().toISOString().split('T')[0];
                dateInput.value = today;
            }
        });
    </script>
</body>
</html>