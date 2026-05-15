<%@page import="com.college.DBConnection"%> <%-- Add this import --%>
<%@page import="java.sql.*"%>
<%
    // Security: Only allow teachers to access this page
    if (session.getAttribute("teacherUser") == null) {
        response.sendRedirect("teacher_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Register Student | Faculty Portal</title>
    <style>
        :root { --primary: #764ba2; --sidebar-bg: #2c3e50; --bg: #f4f7f6; }
        body { font-family: 'Segoe UI', sans-serif; margin: 0; display: flex; background: var(--bg); }
        
        /* Sidebar (Same as Dashboard) */
        .sidebar { width: 250px; height: 100vh; background: var(--sidebar-bg); color: white; position: fixed; }
        .sidebar h2 { padding: 20px; font-size: 1.2rem; border-bottom: 1px solid #3e4f5f; margin: 0; }
        .sidebar a { display: block; padding: 15px 20px; color: #bdc3c7; text-decoration: none; transition: 0.3s; }
        .sidebar a:hover { background: #34495e; color: white; }
        .sidebar a.active { background: var(--primary); color: white; }

        /* Content Area */
        .main-content { margin-left: 250px; flex: 1; padding: 40px; display: flex; flex-direction: column; align-items: center; }
        .reg-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); width: 100%; max-width: 500px; }
        .reg-card h2 { margin-top: 0; color: #333; }
        
        label { display: block; margin-top: 15px; font-weight: bold; font-size: 0.9rem; color: #555; }
        input, select { width: 100%; padding: 12px; margin-top: 5px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; }
        .btn-reg { width: 100%; padding: 14px; background: #28a745; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; margin-top: 25px; font-size: 1rem; }
        .btn-reg:hover { background: #218838; }

        /* Alert Messages */
        .alert { padding: 15px; border-radius: 6px; margin-bottom: 20px; width: 100%; max-width: 500px; text-align: center; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>Faculty Portal</h2>
        <a href="teacher_dashboard.jsp">Dashboard</a>
        <a href="register_student.jsp" class="active">Register Students</a>
        <a href="LogoutServlet">Logout</a>
    </div>

    <div class="main-content">
        
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success">Student Roll No. registered successfully!</div>
        <% } %>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-error">Error: Could not register student. Roll number might already exist.</div>
        <% } %>

        <div class="reg-card">
            <h2>Add New Student</h2>
            <p style="color: #777; font-size: 0.9rem;">The student will use their Roll Number to log in.</p>
            
            <form action="AddStudentServlet" method="POST">
                <label>Roll Number</label>
                <input type="number" name="rollNo" placeholder="e.g. 2414032" required>
                
                <label>Full Name</label>
                <input type="text" name="studentName" placeholder="Enter Student Name" required>
                
                <label>Class / Year</label>
                <select name="studentClass">
                    <option value="FE">First Year (FE)</option>
                    <option value="SE" selected>Second Year (SE)</option>
                    <option value="TE">Third Year (TE)</option>
                    <option value="BE">Final Year (BE)</option>
                </select>
                
                <button type="submit" class="btn-reg">Create Student Account</button>
            </form>
        </div>
        
        <a href="teacher_dashboard.jsp" style="margin-top: 20px; color: #666; text-decoration: none;">? Back to Dashboard</a>
    </div>

</body>
</html>