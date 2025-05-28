<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In</title>
    <link rel="stylesheet" href="login.css">
    <script src="script.js" defer></script>
</head>
<body>

<div class="login-container">
    <h1 class="welcome">Welcome</h1>

    <!-- Display success or error messages -->
    <%
        String message = request.getParameter("message");
        if (message != null && !message.trim().isEmpty()) {
    %>
        <div class="success-message"><%= message %></div>
    <%
        }

        String error = (String) session.getAttribute("error");
        if (error != null && !error.trim().isEmpty()) {
    %>
        <div class="error-message"><%= error %></div>
    <%
            session.removeAttribute("error");
        }
    %>

    <!-- Login Form -->
    <form id="loginForm" action="login" method="POST">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Enter Your Username" pattern="[A-Za-z\s]+" required>

        <label for="password">Password</label>
        <div class="password-container">
            <input type="password" id="password" name="password" placeholder="Enter Your Password" required>
            <span class="toggle-password" onclick="togglePassword()">👁️</span>
        </div>

        <button type="submit" class="login-btn">Sign In</button>
    </form>

    <p class="or-text">OR</p>

    <!-- Social Login (Optional) -->
    <div class="social-login">
        <button class="social-btn">
            <img src="facebook.png" alt="Facebook">
        </button>
        <button class="social-btn">
            <img src="google.png" alt="Google">
        </button>
    </div>

    <p class="signup-text">Don’t have an account? <a href="register.jsp">Sign Up</a></p>
</div>

</body>
</html>
