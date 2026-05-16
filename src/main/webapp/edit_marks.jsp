<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.college.DBConnection"%>
<%@page import="java.sql.*"%>
<% 
    // Security and Session Check
    if (session.getAttribute("rollNo") == null) { 
        response.sendRedirect("student_login.jsp"); 
        return; 
    } 
    
    String id = request.getParameter("id");
    if (id == null || id.isEmpty()) {
        response.sendRedirect("view_marks.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Record | DBCE Goa</title>
    <style>
        :root { --primary: #1e3a8a; --bg: #f8fafc; --accent: #7c3aed; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin: 0; display: flex; }
        .sidebar { width: 260px; background: var(--primary); color: white; height: 100vh; position: fixed; }
        .main { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .card { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table td { padding: 15px; border-bottom: 1px solid #f1f5f9; }
        input { padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; width: 100%; box-sizing: border-box; }
        .btn-update { background: var(--accent); color: white; border: none; padding: 14px 35px; border-radius: 8px; cursor: pointer; font-weight: bold; float: right; margin-top: 25px; }
        .marks-grid { display: flex; gap: 10px; }
        .marks-grid div { flex: 1; }
        .label-mini { font-size: 11px; color: #64748b; font-weight: bold; display: block; margin-bottom: 5px; text-transform: uppercase; }
        .subject-badge { background: #eff6ff; color: #1e40af; padding: 5px 12px; border-radius: 20px; font-size: 13px; font-weight: 600; }
        input[readonly] { background: #f8fafc; cursor: not-allowed; font-weight: 600; color: #475569; }
    </style>
    <script>
        function validateLimit(input) {
            if (input.value !== "" && parseInt(input.value) > parseInt(input.max)) {
                alert("Max allowed marks is " + input.max);
                input.value = input.max;
            }
        }
    </script>
</head>
<body>
    <div class="sidebar">
        <div style="padding:30px; text-align:center;"><h3>DBCE PORTAL</h3></div>
        <a href="view_marks.jsp" style="display:block; padding:20px 25px; color:white; text-decoration:none;">⬅️ Back to Records</a>
    </div>

    <div class="main">
        <div class="card">
            <%
                try {
                    Connection con = DBConnection.getConnection();
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM student_isa_marks WHERE isa_id = ?");
                    ps.setString(1, id);
                    ResultSet rs = ps.executeQuery();
                    
                    if(rs.next()) {
                        String type = rs.getString("course_type");
                        int credits = rs.getInt("credits");
                        
                        // Calculate Limits
                        int tMax = (credits == 3) ? 20 : 15;
                        int aMax = (credits == 3) ? 10 : 5;
                        int lMax = credits * 10;
            %>
            <h2>Update ISA: <%= rs.getString("subject_name") %></h2>
            <span class="subject-badge"><%= rs.getString("course_code") %> • Semester <%= rs.getString("semester") %></span>
            
            <form action="CalculateISA" method="POST" style="margin-top:20px;">
                <input type="hidden" name="isa_id" value="<%= id %>">
                <input type="hidden" name="action" value="update">
                
                <input type="hidden" name="courseCode" value="<%= rs.getString("course_code") %>">
                <input type="hidden" name="subjectName" value="<%= rs.getString("subject_name") %>">
                <input type="hidden" name="credits" value="<%= credits %>">
                <input type="hidden" name="courseType" value="<%= type %>">
                <input type="hidden" name="semester" value="<%= rs.getString("semester") %>">
                <input type="hidden" name="courseCategory" value="<%= rs.getString("course_category") %>">

                <table class="table">
                    <tbody>
                        <tr>
                            <td width="30%"><strong>Assessment Marks</strong></td>
                            <td>
                                <% if("Theory".equalsIgnoreCase(type)) { %>
                                    <div class="marks-grid">
                                        <div>
                                            <span class="label-mini">Test 1 (Max <%= tMax %>)</span>
                                            <input type="number" name="t1" value="<%= rs.getInt("test1") %>" max="<%= tMax %>" oninput="validateLimit(this)">
                                        </div>
                                        <div>
                                            <span class="label-mini">Test 2 (Max <%= tMax %>)</span>
                                            <input type="number" name="t2" value="<%= rs.getInt("test2") %>" max="<%= tMax %>" oninput="validateLimit(this)">
                                        </div>
                                        <div>
                                            <span class="label-mini">Test 3 (Max <%= tMax %>)</span>
                                            <input type="number" name="t3" value="<%= rs.getInt("test3") %>" max="<%= tMax %>" oninput="validateLimit(this)">
                                        </div>
                                        <div>
                                            <span class="label-mini">Asgn (Max <%= aMax %>)</span>
                                            <input type="number" name="assignment" value="<%= rs.getInt("assignment") %>" max="<%= aMax %>" oninput="validateLimit(this)">
                                        </div>
                                    </div>
                                <% } else { %>
                                    <div>
                                        <span class="label-mini">Lab / Journal Total (Max <%= lMax %>)</span>
                                        <input type="number" name="labTotal" value="<%= rs.getInt("lab_total") %>" max="<%= lMax %>" oninput="validateLimit(this)">
                                    </div>
                                <% } %>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button type="submit" class="btn-update">💾 Save Changes</button>
            </form>
            <%  
                    } else {
                        out.println("<p style='color:red;'>Record not found.</p>");
                    }
                    con.close(); 
                } catch(Exception e) { 
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>"); 
                } 
            %>
        </div>
    </div>
</body>
</html>
