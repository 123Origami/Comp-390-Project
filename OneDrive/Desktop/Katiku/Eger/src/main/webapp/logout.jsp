<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout</title>
    <link rel="stylesheet" href="logout.css">
</head>
<body>

    <div class="logout-container">
        <h2>Log Out</h2>
        <p>Are you sure you want to log out?</p>

        <div class="logout-buttons">
            <form action="${pageContext.request.contextPath}/LogoutServlet" method="post">
                <button type="submit" class="logout-btn confirm">Yes, Log Out</button>
            </form>
            <button class="logout-btn cancel" onclick="window.history.back()">Cancel</button>
        </div>
    </div>

</body>
</html>