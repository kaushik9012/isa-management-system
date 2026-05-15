<%@page import="com.college.DBConnection"%>
<%@page import="java.sql.*"%>
<% 
    // Security and Session Check
    String sClass = (String) session.getAttribute("studentClass");
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
        input[readonly] { background: #f1f5f9; cursor: not-allowed; }
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
            if (!select || select.value === "") return;
            
            const data = select.value.split('|');
            const code = data[0];
            const name = data[1];
            const credits = parseInt(data[2]);
            const type = data[3];
            const sem = data[4];

            document.getElementById('courseCode').value = code;
            document.getElementById('subjectName').value = name;
            document.getElementById('credits').value = credits;
            document.getElementById('semester').value = sem;
            document.getElementById('courseType').value = type;
            
            const theoryDiv = document.getElementById('theoryGroup');
            const labDiv = document.getElementById('labGroup');

            const tInputs = theoryDiv.querySelectorAll('input');
            const asgnInput = document.getElementById('asgnField');
            const labInput = document.getElementById('labField');

            if (type === "Lab") {
                theoryDiv.style.display = "none"; 
                labDiv.style.display = "block";
                const labMax = credits * 10;
                labInput.max = labMax;
                labInput.placeholder = "Max " + labMax;
            } else {
                theoryDiv.style.display = "flex"; 
                labDiv.style.display = "none";
                let tMax = (credits === 3) ? 20 : 15;
                let aMax = (credits === 3) ? 10 : 5;

                tInputs.forEach(input => {
                    input.max = tMax;
                    input.placeholder = "Max " + tMax;
                });
                asgnInput.max = aMax;
                asgnInput.placeholder = "Max " + aMax;
            }
        }
    </script>
</head>
<body onload="applyLimits()">
    <div class="sidebar">
        <div style="padding:25px; text-align:center;"><h3>DBCE PORTAL</h3></div>
        <a href="view_marks.jsp" style="display:block; padding:15px 25px; color:white; text-decoration:none;">? Back to Records</a>
    </div>

    <div class="main">
        <div class="card">
            <h2>Edit ISA Record</h2>
            <%
                try {
                    Connection con = DBConnection.getConnection();
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
                                        <optgroup label="First Year">
                                            <option value="CMP-100|Fundamentals of Programming using C|3|Theory|1" <%= "CMP-100".equals(currentCode)?"selected":"" %>>Programming in C (CMP-100)</option>
                                            <option value="CMP-101|C Programming Lab|1|Lab|1" <%= "CMP-101".equals(currentCode)?"selected":"" %>>C Lab (CMP-101)</option>
                                            <option value="SHM-131|Engineering Mathematics - I|3|Theory|1" <%= "SHM-131".equals(currentCode)?"selected":"" %>>Maths-I (SHM-131)</option>
                                            <option value="SEC-144|Electronics and Mechanical Workshop|3|Lab|1" <%= "SEC-144".equals(currentCode)?"selected":"" %>>Workshop (SEC-144)</option>
                                        </optgroup>
                                    <% } else { %>
                                        <optgroup label="Second Year">
                                            <option value="CMP-200|Data Structures and Algorithms|3|Theory|3" <%= "CMP-200".equals(currentCode)?"selected":"" %>>Data Structures (CMP-200)</option>
                                            <option value="CMP-201|Data Structures Lab|1|Lab|3" <%= "CMP-201".equals(currentCode)?"selected":"" %>>DSA Lab (CMP-201)</option>
                                            <option value="CMP-204|Object Oriented Programming|2|Theory|4" <%= "CMP-204".equals(currentCode)?"selected":"" %>>OOP Systems (CMP-204)</option>
                                        </optgroup>
                                    <% } %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Course Details</strong></td>
                            <td>
                                <input type="hidden" name="subjectName[]" id="subjectName">
                                <input type="hidden" name="courseType[]" id="courseType">
                                <input type="hidden" name="semester[]" id="semester">
                                
                                <div style="display:flex; gap:10px;">
                                    <div>
                                        <label style="font-size:12px; color:#64748b;">Code</label>
                                        <input type="text" name="courseCode[]" id="courseCode" readonly style="width:120px; font-weight:bold;">
                                    </div>
                                    <div>
                                        <label style="font-size:12px; color:#64748b;">Credits</label>
                                        <input type="number" name="credits[]" id="credits" readonly style="width:80px; font-weight:bold;">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Marks Entry</strong></td>
                            <td>
                                <div id="theoryGroup" class="theory-group">
                                    <div>
                                        <label style="font-size:11px; display:block;">Test 1</label>
                                        <input type="number" name="t1[]" value="<%= rs.getInt("test1") %>" min="0" oninput="validateLimit(this)">
                                    </div>
                                    <div>
                                        <label style="font-size:11px; display:block;">Test 2</label>
                                        <input type="number" name="t2[]" value="<%= rs.getInt("test2") %>" min="0" oninput="validateLimit(this)">
                                    </div>
                                    <div>
                                        <label style="font-size:11px; display:block;">Test 3</label>
                                        <input type="number" name="t3[]" value="<%= rs.getInt("test3") %>" min="0" oninput="validateLimit(this)">
                                    </div>
                                    <div>
                                        <label style="font-size:11px; display:block;">Assignment</label>
                                        <input type="number" name="assignment[]" id="asgnField" value="<%= rs.getInt("assignment") %>" min="0" oninput="validateLimit(this)">
                                    </div>
                                </div>
                                <div id="labGroup" style="display:none;">
                                    <label style="font-size:11px; display:block;">Lab / Journal Total</label>
                                    <input type="number" name="labTotal[]" id="labField" value="<%= rs.getInt("lab_total") %>" min="0" oninput="validateLimit(this)">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button type="submit" class="btn-save">Update Record</button>
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