<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% if (session.getAttribute("rollNo") == null) { response.sendRedirect("student_login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>My Records | DBCE</title>
    <style>
        :root { --primary: #1e3a8a; --bg: #f8fafc; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin: 0; display: flex; }
        .sidebar { width: 260px; background: var(--primary); color: white; height: 100vh; position: fixed; }
        .main { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .card { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .table { width: 100%; border-collapse: collapse; }
        .table th { text-align: left; background: #f1f5f9; padding: 12px; }
        .table td { padding: 15px 12px; border-bottom: 1px solid #e2e8f0; }
        .btn-act { text-decoration: none; font-weight: bold; padding: 6px 12px; border-radius: 4px; font-size: 13px; border: 1px solid; }
        .edit { color: #1e3a8a; border-color: #1e3a8a; }
        .del { color: #dc2626; border-color: #dc2626; margin-left: 5px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div style="padding:25px; text-align:center;"><h3>DBCE PORTAL</h3></div>
        <a href="marks_entry.jsp" style="display:block; padding:15px 25px; color:white; text-decoration:none;">Enter Marks</a>
        <a href="view_marks.jsp" style="display:block; padding:15px 25px; color:white; background:rgba(255,255,255,0.1); text-decoration:none;">View Records</a>
        <a href="LogoutServlet" style="display:block; padding:15px 25px; color:#fca5a5; text-decoration:none;">Logout</a>
    </div>
    <div class="main">
        <div class="card">
            <h2>Internal Assessment History</h2>
            <table class="table">
                <thead>
                    <tr><th>Sem</th><th>Code</th><th>Subject</th><th>Type</th><th>Score</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            int roll = (Integer) session.getAttribute("rollNo");
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
                            PreparedStatement ps = con.prepareStatement("SELECT * FROM student_isa_marks WHERE roll_no=? ORDER BY semester DESC, course_code ASC");
                            ps.setInt(1, roll);
                            ResultSet rs = ps.executeQuery();
                            while(rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("semester") %></td>
                        <td><strong><%= rs.getString("course_code") %></strong></td>
                        <td><%= rs.getString("subject_name") %></td>
                        <td><%= rs.getString("course_type") %></td>
                        <td><strong style="color:var(--primary); font-size:16px;"><%= rs.getInt("final_isa_score") %></strong></td>
                        <td>
                            <a href="edit_marks.jsp?id=<%= rs.getInt("isa_id") %>" class="btn-act edit">Edit</a>
                            <a href="DeleteISA?id=<%= rs.getInt("isa_id") %>" class="btn-act del" onclick="return confirm('Confirm deletion?')">Delete</a>
                        </td>
                    </tr>
                    <% } con.close(); } catch(Exception e) { out.println(e.getMessage()); } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>