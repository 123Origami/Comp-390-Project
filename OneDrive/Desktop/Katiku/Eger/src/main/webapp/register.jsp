<%-- 
    Document   : register
    Created on : Apr 4, 2025, 11:15:24 PM
    Author     : samtp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="register.css">
    <script src="script.js" defer></script>
</head>
<body>
    <div class="signup-container">
        <h1 class="welcome">Create New Account</h1>
        
        <form action="register" method="post">
            <!-- Username Field -->
            <label for="username">Username</label>
            <input 
                type="text" 
                id="username" 
                name="username" 
                placeholder="Enter Your Username" 
                required 
                minlength="3" 
                maxlength="50"
                aria-label="Username"
                pattern="[A-Za-z\s]+"
            >
            <small class="hint">Username must be 3–50 characters long.</small>

            <!-- Password Field -->
            <label for="password">Password</label>
            <div class="password-container">
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    placeholder="Enter Your Password" 
                    required 
                    minlength="6" 
                    aria-label="Password"
                >
                <span class="toggle-password" onclick="togglePassword()" role="button" aria-label="Toggle Password Visibility">👁️</span>
            </div>
            <small class="hint">Password must be at least 6 characters long.</small>

            <!-- Email Field -->
            <label for="email">Email</label>
            <input 
                type="email" 
                id="email" 
                name="email" 
                placeholder="Enter Your Email" 
                required 
                aria-label="Email"
            >
            <small class="hint">Please enter a valid email address.</small>

            <!-- Mobile Number Field -->
            <label for="phone">Mobile Number</label>
            <input 
                type="tel" 
                id="phone" 
                name="phone_number" 
                placeholder="Enter Your Phone Number" 
                required 
                pattern="[0-9]{10}" 
                aria-label="Phone Number"
            >
            <small class="hint">Phone number must be 10 digits (e.g., 0712345678).</small>

            <!-- Role Dropdown -->
            <label for="role">Role</label>
            <select 
                id="role" 
                name="role" 
                required 
                aria-label="User Role"
            >
                <option value="" disabled selected>Select Your Role</option>
                <option value="Patient">Patient</option>
            </select>
            <small class="hint">Select your role in the system.</small>

            <!-- Sign Up Button -->
            <button type="submit" class="signup-btn" aria-label="Sign Up">Sign Up</button>
        </form>

        <p class="or-text">OR</p>

        <!-- Social Signup -->
        <div class="social-signup">
            <button class="social-btn" aria-label="Sign up with Facebook">
                <img src="facebook.png" alt="Facebook Logo">
            </button>
            <button class="social-btn" aria-label="Sign up with Google">
                <img src="google.png" alt="Google Logo">
            </button>
        </div>

        <p class="signin-text">
            Already have an account? <a href="login.jsp" aria-label="Go to Login Page">Sign In</a>
        </p>
    </div>
</body>
</html>
