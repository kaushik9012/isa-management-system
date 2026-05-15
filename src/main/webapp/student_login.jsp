<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.college.DBConnection"%> <%-- Add this import --%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Login | DBCE</title>
    <meta charset="UTF-8">
    <style>
        :root { --primary: #1e3a8a; --bg: #f1f5f9; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        h2 { color: var(--primary); text-align: center; margin-bottom: 30px; }
        label { display: block; margin-top: 15px; color: #475569; font-weight: 600; }
        input, select { width: 100%; padding: 12px; margin-top: 8px; border: 1px solid #e2e8f0; border-radius: 8px; box-sizing: border-box; }
        button { width: 100%; background: var(--primary); color: white; padding: 14px; border: none; border-radius: 8px; margin-top: 25px; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Student Access Portal</h2>
        <form action="LoginServlet" method="POST">
            <label>Full Name (As per records)</label>
            <input type="text" name="studentName" placeholder="e.g. ADARSH MAURYA" required>

            <label>Roll Number</label>
            <input type="number" name="rollNo" placeholder="7-digit Roll No" required>

            <label>Select Year</label>
            <select name="studentClass" required>
                <option value="FE">First Year (FE)</option>
                <option value="SE">Second Year (SE)</option>
            </select>

            <button type="submit">Access My Dashboard</button>
        </form>
    </div>
</body>
</html>
