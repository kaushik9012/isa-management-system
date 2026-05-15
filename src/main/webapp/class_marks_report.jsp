<%@page import="com.college.DBConnection"%>
<%@page import="java.sql.*"%>
<%
    // Security Check
    if (session.getAttribute("teacherUser") == null) { 
        response.sendRedirect("teacher_login.jsp"); 
        return; 
    }

    String semStr = request.getParameter("semester");
    String code = request.getParameter("courseCode");
    
    int semInt = Integer.parseInt(semStr);
    String targetClass = (semInt <= 2) ? "FE" : "SE"; 

    // Determine the subject type for header visibility
    String reportType = "Theory"; // Default
    try {
        Connection con = DBConnection.getConnection();
        // Fixed the query to look up course type by the course code
        PreparedStatement psType = con.prepareStatement("SELECT course_type FROM student_isa_marks WHERE course_code = ? LIMIT 1");
        psType.setString(1, code);
        ResultSet rsType = psType.executeQuery();
        if(rsType.next()){
            reportType = rsType.getString("course_type");
        }
        con.close();
    } catch(Exception e) {
        // Log error if needed or keep default "Theory"
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>ISA Report - <%= code %></title>
    <style>
        body { font-family: 'Segoe UI', Arial; padding: 40px; color: #333; background: #fff; }
        .header { text-align: center; border-bottom: 2px solid #1e3a8a; padding-bottom: 20px; margin-bottom: 30px; }
        .report-table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 14px; }
        .report-table th, .report-table td { border: 1px solid #000; padding: 10px; text-align: center; }
        .report-table th { background-color: #f1f5f9; font-weight: bold; }
        .name-col { text-align: left !important; padding-left: 15px; }
        
        .action-bar { display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 20px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; text-decoration: none; display: inline-block; }
        .btn-print { background: #1e3a8a; color: white; }
        .btn-back { background: #64748b; color: white; }
        
        @media print { 
            .action-bar { display: none; } 
            body { padding: 0; }
            .report-table th { background-color: #eee !important; -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>

    <div class="action-bar">
        <a href="teacher_dashboard.jsp" class="btn btn-back">Back to Dashboard</a>
        <button class="btn btn-print" onclick="window.print()">Print Report</button>
    </div>

    <div class="header">
        <h2 style="margin:0;">Don Bosco College of Engineering, Fatorda</h2>
        <h3 style="margin:5px 0;">Internal Assessment Marksheet (RC 2024-25)</h3>
        <p><strong>Class:</strong> <%= targetClass %> | <strong>Subject:</strong> <%= code %> | <strong>Semester:</strong> <%= semStr %> | <strong>Type:</strong> <%= reportType %></p>
    </div>

    <table class="report-table">
        <thead>
            <tr>
                <th style="width: 10%;">Roll No</th>
                <th class="name-col" style="width: 30%;">Student Name</th>
                <% if ("Theory".equals(reportType)) { %>
                    <th>T1 (20/15)</th>
                    <th>T2 (20/15)</th>
                    <th>T3 (20/15)</th>
                    <th>Assignment</th>
                <% } else { %>
                    <th>Lab Performance / Journals</th>
                <% } %>
                <th style="width: 15%;">Final ISA Score</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    // Using cloud-ready connection
                    Connection con = DBConnection.getConnection();
                    
                    String query = "SELECT u.name, u.roll_no, m.test1, m.test2, m.test3, m.assignment, m.lab_total, m.final_isa_score " +
                                   "FROM users u " +
                                   "LEFT JOIN student_isa_marks m ON u.roll_no = m.roll_no AND m.course_code = ? " +
                                   "WHERE u.student_class = ? " +
                                   "ORDER BY u.roll_no ASC"; 

                    PreparedStatement ps = con.prepareStatement(query);
                    ps.setString(1, code);
                    ps.setString(2, targetClass);
                    ResultSet rs = ps.executeQuery();

                    while(rs.next()) {
                        int fIsa = rs.getInt("final_isa_score");
            %>
            <tr>
                <td><%= rs.getInt("roll_no") %></td>
                <td class="name-col"><%= rs.getString("name") %></td>
                
                <% if ("Theory".equals(reportType)) { %>
                    <td><%= (fIsa > 0) ? rs.getInt("test1") : "-" %></td>
                    <td><%= (fIsa > 0) ? rs.getInt("test2") : "-" %></td>
                    <td><%= (fIsa > 0) ? rs.getInt("test3") : "-" %></td>
                    <td><%= (fIsa > 0) ? rs.getInt("assignment") : "-" %></td>
                <% } else { %>
                    <td><%= (fIsa > 0) ? rs.getInt("lab_total") : "-" %></td>
                <% } %>
                
                <td><strong><%= (fIsa > 0) ? fIsa : "Not Entered" %></strong></td>
            </tr>
            <% 
                    }
                    con.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='10' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </tbody>
    </table>

    <div style="margin-top:80px; display:flex; justify-content: space-around;">
        <div style="text-align:center;">
            <p>__________________________</p>
            <p><strong>Subject Teacher</strong></p>
        </div>
        <div style="text-align:center;">
            <p>__________________________</p>
            <p><strong>HOD Computer</strong></p>
        </div>
    </div>

</body>
</html>
