<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    String sClass = (String) session.getAttribute("studentClass");
    if (session.getAttribute("rollNo") == null) { response.sendRedirect("student_login.jsp"); return; } 
    String id = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit ISA Record | DBCE</title>
    <style>
        :root { --primary: #1e3a8a; --bg: #f8fafc; --border: #e2e8f0; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin: 0; display: flex; }
        .sidebar { width: 260px; background: var(--primary); color: white; height: 100vh; position: fixed; }
        .main { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .card { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table td { padding: 12px; border-bottom: 1px solid var(--border); }
        input, select { padding: 10px; border: 1px solid var(--border); border-radius: 6px; width: 100%; box-sizing: border-box; }
        .btn-save { background: var(--primary); color: white; border: none; padding: 12px 25px; border-radius: 6px; cursor: pointer; font-weight: bold; float: right; margin-top: 20px; }
        .theory-group { display: flex; gap: 5px; }
        .theory-group input { width: 65px; text-align: center; }
    </style>
    <script>
        function validateLimit(input) {
            if (input.value !== "" && parseInt(input.value) > parseInt(input.max)) {
                alert("The maximum marks allowed for this field is " + input.max);
                input.value = input.max;
            }
        }

        function applyLimits() {
            const select = document.getElementById('subjectSelector');
            if (select.value === "") return;
            
            const data = select.value.split('|');
            const credits = parseInt(data[2]);
            const type = data[3];

            document.getElementById('courseCode').value = data[0];
            document.getElementById('subjectName').value = data[1];
            document.getElementById('credits').value = data[2];
            document.getElementById('semester').value = data[4];
            
            const theoryDiv = document.getElementById('theoryGroup');
            const labDiv = document.getElementById('labGroup');
            const typeInput = document.getElementById('courseType');

            const tInputs = theoryDiv.querySelectorAll('input[name^="t"]');
            const asgnInput = document.getElementById('asgnField');
            const labInput = document.getElementById('labField');

            if (type === "Lab") {
                theoryDiv.style.display = "none"; 
                labDiv.style.display = "block";
                typeInput.value = "Lab";
                const labMax = credits * 10;
                labInput.max = labMax;
                labInput.placeholder = "Max " + labMax;
            } else {
                theoryDiv.style.display = "flex"; 
                labDiv.style.display = "none";
                typeInput.value = "Theory";
                let tMax = (credits === 3) ? 20 : 15;
                let aMax = (credits === 3) ? 10 : 5;

                tInputs.forEach(input => {
                    input.max = tMax;
                    input.placeholder = "T(" + tMax + ")";
                });
                asgnInput.max = aMax;
                asgnInput.placeholder = "A(" + aMax + ")";
            }
        }
    </script>
</head>
<body onload="applyLimits()">
    <div class="sidebar">
        <div style="padding:25px; text-align:center;"><h3>DBCE PORTAL</h3></div>
        <a href="view_marks.jsp" style="display:block; padding:15px 25px; color:white; text-decoration:none;">← Back to Records</a>
    </div>

    <div class="main">
        <div class="card">
            <h2>Edit ISA Record</h2>
            <%
                try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM student_isa_marks WHERE isa_id = ?");
                    ps.setString(1, id);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()) {
                        String currentCode = rs.getString("course_code");
            %>
            <form action="CalculateISA" method="POST">
                <input type="hidden" name="isa_id" value="<%= id %>">
                <table class="table">
                    <tbody>
                        <tr>
                            <td><strong>Subject Selection</strong></td>
                            <td>
                                <select name="subjectSelector" id="subjectSelector" onchange="applyLimits()" required>
                                    <% if ("FE".equals(sClass)) { %>
                                        <optgroup label="First Year - Sem I">
                                            <option value="CMP-100|Fundamentals of Programming using C|3|Theory|1" <%= currentCode.equals("CMP-100")?"selected":"" %>>Programming in C (CMP-100)</option>
                                            <option value="CMP-101|C Programming Lab|1|Lab|1" <%= currentCode.equals("CMP-101")?"selected":"" %>>C Lab (CMP-101)</option>
                                            <option value="SHM-131|Engineering Mathematics - I|3|Theory|1" <%= currentCode.equals("SHM-131")?"selected":"" %>>Maths-I (SHM-131)</option>
                                            <option value="SEC-144|Electronics and Mechanical Workshop|3|Lab|1" <%= currentCode.equals("SEC-144")?"selected":"" %>>Workshop (SEC-144)</option>
                                        </optgroup>
                                    <% } else { %>
                                        <optgroup label="Second Year - Sem III">
                                            <option value="CMP-200|Data Structures and Algorithms|3|Theory|3" <%= currentCode.equals("CMP-200")?"selected":"" %>>Data Structures (CMP-200)</option>
                                            <option value="CMP-201|Data Structures Lab|1|Lab|3" <%= currentCode.equals("CMP-201")?"selected":"" %>>DSA Lab (CMP-201)</option>
                                            <option value="CMP-204|Object Oriented Programming|2|Theory|4" <%= currentCode.equals("CMP-204")?"selected":"" %>>OOP Systems (CMP-204)</option>
                                        </optgroup>
                                    <% } %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Course Details</strong></td>
                            <td>
                                <input type="hidden" name="subjectName[]" id="subjectName" value="<%= rs.getString("subject_name") %>">
                                <input type="hidden" name="courseType[]" id="courseType" value="<%= rs.getString("course_type") %>">
                                <input type="hidden" name="semester[]" id="semester" value="<%= rs.getInt("semester") %>">
                                <input type="text" name="courseCode[]" id="courseCode" value="<%= rs.getString("course_code") %>" readonly style="background:#f1f5f9; width:120px; font-weight:bold;">
                                <input type="number" name="credits[]" id="credits" value="<%= rs.getInt("credits") %>" readonly style="background:#f1f5f9; width:80px; font-weight:bold;">
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Marks Entry</strong></td>
                            <td>
                                <div id="theoryGroup" class="theory-group">
                                    <input type="number" name="t1[]" value="<%= rs.getInt("test1") %>" min="0" oninput="validateLimit(this)">
                                    <input type="number" name="t2[]" value="<%= rs.getInt("test2") %>" min="0" oninput="validateLimit(this)">
                                    <input type="number" name="t3[]" value="<%= rs.getInt("test3") %>" min="0" oninput="validateLimit(this)">
                                    <input type="number" name="assignment[]" id="asgnField" value="<%= rs.getInt("assignment") %>" min="0" oninput="validateLimit(this)">
                                </div>
                                <div id="labGroup" style="display:none;">
                                    <input type="number" name="labTotal[]" id="labField" value="<%= rs.getInt("lab_total") %>" min="0" oninput="validateLimit(this)">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button type="submit" class="btn-save">Update Record</button>
            </form>
            <% } con.close(); } catch(Exception e) { out.println(e.getMessage()); } %>
        </div>
    </div>
</body>
</html>