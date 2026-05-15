<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("teacherUser") == null) { response.sendRedirect("teacher_login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Modify Student Marks | Faculty</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .edit-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 450px; }
        label { display: block; margin-top: 10px; font-weight: bold; font-size: 14px; }
        input { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; }
        .btn-update { width: 100%; padding: 12px; background: #764ba2; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="edit-card">
        <%
            int id = Integer.parseInt(request.getParameter("id"));
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
                PreparedStatement ps = con.prepareStatement("SELECT * FROM student_isa_marks WHERE isa_id = ?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) {
                    String type = rs.getString("course_type");
        %>
        <h2 style="margin-top:0;">Edit Student Marks</h2>
        <p><strong>Code:</strong> <%= rs.getString("course_code") %> | <strong>Roll:</strong> <%= rs.getInt("roll_no") %></p>
        
        <form action="TeacherUpdateServlet" method="POST">
            <input type="hidden" name="isa_id" value="<%= id %>">
            <input type="hidden" name="course_type" value="<%= type %>">
            <input type="hidden" name="credits" value="<%= rs.getInt("credits") %>">
            <input type="hidden" name="course_code" value="<%= rs.getString("course_code") %>">
            <input type="hidden" name="semester" value="<%= rs.getInt("semester") %>">

            <% if(type.equalsIgnoreCase("Theory")) { %>
                <label>Test 1 (Max 20)</label><input type="number" name="t1" value="<%= rs.getInt("test1") %>" max="20" min="0">
                <label>Test 2 (Max 20)</label><input type="number" name="t2" value="<%= rs.getInt("test2") %>" max="20" min="0">
                <label>Test 3 (Max 20)</label><input type="number" name="t3" value="<%= rs.getInt("test3") %>" max="20" min="0">
                <label>Assignment (Max 10)</label><input type="number" name="asgn" value="<%= rs.getInt("assignment") %>" max="10" min="0">
            <% } else { %>
                <label>Lab Raw Total (Out of 100)</label>
                <input type="number" name="labTotal" value="<%= rs.getInt("lab_total") %>" max="100" min="0">
            <% } %>
            
            <button type="submit" class="btn-update">Save Corrections</button>
            <a href="teacher_dashboard.jsp" style="display:block; text-align:center; margin-top:15px; color:#666; font-size: 13px;">Cancel</a>
        </form>
        <% } con.close(); } catch(Exception e) { out.println(e.getMessage()); } %>
    </div>
</body>
</html>