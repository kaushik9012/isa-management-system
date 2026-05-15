<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.college.DBConnection"%> <%-- Add this import --%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Faculty Login - RC 24-25 Scheme</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
            width: 100%;
            max-width: 450px;
        }
        .header { text-align: center; margin-bottom: 30px; }
        .header h1 { color: #333; font-size: 26px; }
        .divider { height: 3px; background: linear-gradient(to right, transparent, #764ba2, transparent); margin: 20px 0; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #555; font-weight: 600; }
        input { width: 100%; padding: 12px; border: 2px solid #e1e1e1; border-radius: 8px; font-size: 16px; }
        .btn-login {
            width: 100%; padding: 14px; background: #764ba2;
            color: white; border: none; border-radius: 8px; font-size: 18px; font-weight: 600; cursor: pointer;
        }
        .error { color: #dc3545; text-align: center; margin-bottom: 15px; font-size: 14px; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="header">
            <h1>FACULTY PORTAL</h1>
            <p style="color:#666;">Department of Computer Engineering</p>
        </div>
        <div class="divider"></div>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error">Invalid Username or Password</div>
        <% } %>

        <form action="TeacherLoginServlet" method="POST">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter Faculty ID" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="🔒 Enter Password" required>
            </div>
            <button type="submit" class="btn-login">Login to Dashboard</button>
        </form>
        <div style="text-align: center; margin-top: 20px;">
            <a href="index.jsp" style="color: #764ba2; text-decoration: none; font-size: 14px;">⬅️ Back to Role Selection</a>
        </div>
    </div>
</body>
</html>
