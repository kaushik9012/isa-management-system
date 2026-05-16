<%@page import="com.college.DBConnection"%> <%-- Add this import --%>
<%@page import="java.sql.*"%>
<% 
    String sClass = (String) session.getAttribute("studentClass");
    if (session.getAttribute("rollNo") == null) { response.sendRedirect("student_login.jsp"); return; } 
%>
<!DOCTYPE html>
<html>
<head>
    <title>ISA Entry | DBCE Portal</title>
    <style>
        :root { --primary: #1e3a8a; --bg: #f8fafc; --border: #e2e8f0; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin: 0; display: flex; }
        .sidebar { width: 260px; background: var(--primary); color: white; height: 100vh; position: fixed; }
        .sidebar-header { padding: 25px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .nav-link { display: block; padding: 15px 25px; color: #cbd5e1; text-decoration: none; transition: 0.2s; }
        .nav-link:hover, .nav-link.active { background: rgba(255,255,255,0.1); color: white; }
        .main { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .card { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table th { text-align: left; background: #f1f5f9; padding: 12px; font-size: 11px; text-transform: uppercase; color: #64748b; }
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

        function autoFill(select) {
            if (select.value === "") return;
            const data = select.value.split('|'); // Format: CODE|NAME|CREDITS|TYPE|SEM
            const credits = parseInt(data[2]);
            const type = data[3];

            document.getElementById('courseCode').value = data[0];
            document.getElementById('subjectName').value = data[1];
            document.getElementById('credits').value = data[2];
            document.getElementById('semester').value = data[4];

            document.getElementById('courseCategory').value = data[5];
            
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
                
                // Lab Limits: 1Cr=10, 2Cr=20, 3Cr=30
                const labMax = credits * 10;
                labInput.max = labMax;
                labInput.placeholder = "Max " + labMax;
            } else {
                theoryDiv.style.display = "flex"; 
                labDiv.style.display = "none";
                typeInput.value = "Theory";

                // Theory Limits: 3Cr=20/10, 2Cr=15/5
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
<body>
    <div class="sidebar">
        <div class="sidebar-header"><h3>DBCE PORTAL</h3></div>
        <a href="marks_entry.jsp" class="nav-link active">Enter Marks</a>
        <a href="view_marks.jsp" class="nav-link">My Records</a>
        <a href="LogoutServlet" class="nav-link" style="color:#f87171; margin-top: 20px;">Logout</a>
    </div>

    <div class="main">
        <div class="card">
            <h2><%= sClass %> Full Subject ISA Entry (RC 2024-25)</h2>
            <form action="CalculateISA" method="POST">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width:40%;">Subject Selection</th>
                            <th style="width:15%;">Credits</th>
                            <th style="width:45%;">Marks Input (Validated)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <select onchange="autoFill(this)" required>
    <option value="">-- Choose Course --</option>
    <% if ("FE".equals(sClass)) { %>
        <optgroup label="First Year - Semester I">
            <option value="CMP-100|Fundamentals of Programming using C|3|Theory|1|Major">C Programming (CMP-100)</option>
            <option value="CMP-101|Fundamentals of Programming using C Lab|1|Lab|1|Major">C Lab (CMP-101)</option>
            <option value="EEL-111|Basics of Electrical & Electronics Eng.|3|Theory|1|Major">Basics of Electrical (EEL-111)</option>
            <option value="EEL-112|Basics of Electrical & Electronics Eng. Lab|1|Lab|1|Major">Electrical Lab (EEL-112)</option>
            <option value="SHM-111|Biology for Engineers|3|Theory|1|Major">Biology for Engineers (SHM-111)</option>
            <option value="SHM-112|Biology for Engineers Lab|1|Lab|1|Major">Biology Lab (SHM-112)</option>
            <option value="SHM-131|Engineering Mathematics - I|3|Theory|1|Major">Mathematics - I (SHM-131)</option>
            <option value="AEC-151|Creative Thinking and Innovation|2|Theory|1|Minor">Creative Thinking (AEC-151)</option>
            <option value="AEC-152|Creative Thinking and Innovation Lab|1|Lab|1|Minor">Creative Thinking Lab (AEC-152)</option>
            <option value="VAC-156|Indian Knowledge System|2|Theory|1|Minor">Indian Knowledge System (VAC-156)</option>
            <option value="VAC-157|Indian Knowledge System Lab|1|Lab|1|Minor">IKS Lab (VAC-157)</option>
            <option value="SEC-144|Electronics and Mechanical Workshop|3|Lab|1|Major">Workshop (SEC-144)</option>
        </optgroup>
        <optgroup label="First Year - Semester II">
            <option value="ITH-100|Fundamentals of Computing using Python|3|Theory|2|Major">Python Programming (ITH-100)</option>
            <option value="ITH-101|Fundamentals of Computing using Python Lab|1|Lab|2|Major">Python Lab (ITH-101)</option>
            <option value="MCV-111|Basics of Mechanical & Civil Engineering|3|Theory|2|Major">Basics of Mech & Civil (MCV-111)</option>
            <option value="MCV-112|Basics of Mechanical & Civil Engineering Lab|1|Lab|2|Major">Mech & Civil Lab (MCV-112)</option>
            <option value="SHM-113|Engineering Chemistry|3|Theory|2|Major">Engineering Chemistry (SHM-113)</option>
            <option value="SHM-114|Engineering Chemistry Lab|1|Lab|2|Major">Chemistry Lab (SHM-114)</option>
            <option value="SHM-132|Applied Physics|2|Theory|2|Major">Applied Physics (SHM-132)</option>
            <option value="SHM-133|Applied Physics Lab|1|Lab|2|Major">Physics Lab (SHM-133)</option>
            <option value="AEC-153|Communication and Technical Writing|3|Theory|2|Minor">Technical Writing (AEC-153)</option>
            <option value="VAC-158|Environmental Science & Sustainability|2|Theory|2|Minor">Environmental Science (VAC-158)</option>
            <option value="VAC-159|Environmental Science & Sustainability Lab|1|Lab|2|Minor">Env. Science Lab (VAC-159)</option>
            <option value="SEC-143|Engineering Graphics & Design with UI/UX|3|Lab|2|Major">Eng. Graphics/UIUX (SEC-143)</option>
        </optgroup>
    <% } else { %>
        <optgroup label="Second Year - Semester III">
            <option value="CMP-200|Data Structures and Algorithms using C++|3|Theory|3|Major">Data Structures (CMP-200)</option>
            <option value="CMP-201|Data Structures and Algorithms Lab|1|Lab|3|Major">DSA Lab (CMP-201)</option>
            <option value="CMP-202|Digital System Design and Analysis|3|Theory|3|Major">Digital Systems (CMP-202)</option>
            <option value="CMP-203|Digital System Lab|1|Lab|3|Major">Digital Systems Lab (CMP-203)</option>
            <option value="CMP-221|Computer Organization and Architecture|3|Theory|3|Major">Computer Org (CMP-221)</option>
            <option value="CMP-222|Computer Organization Lab|1|Lab|3|Major">Computer Org Lab (CMP-222)</option>
            <option value="CMP-223|Microprocessors and Interfacing|3|Theory|3|Major">Microprocessors (CMP-223)</option>
            <option value="CMP-224|Microprocessors Lab|1|Lab|3|Major">Microprocessors Lab (CMP-224)</option>
            <option value="SHM-234|Engineering Mathematics II|3|Theory|3|Major">Mathematics II (SHM-234)</option>
            <option value="AEC-251|*|2|Theory|3|Minor">AEC Elective (AEC-251)</option>
            <option value="CMP-241|Web Technology: Design and Development|3|Lab|3|Major">Web Technology (CMP-241)</option>
        </optgroup>
        <optgroup label="Second Year - Semester IV">
            <option value="CMP-204|Object Oriented Programming Systems|2|Theory|4|Minor">OOP Systems (CMP-204)</option>
            <option value="CMP-205|Object Oriented Programming Systems Lab|2|Lab|4|Minor">OOP Lab (CMP-205)</option>
            <option value="CMP-206|Internet of Things|3|Theory|4|Major">Internet of Things (CMP-206)</option>
            <option value="CMP-207|Internet of Things Lab|1|Lab|4|Major">IoT Lab (CMP-207)</option>
            <option value="CMP-208|Automata Theory and Formal Languages|3|Theory|4|Major">Automata Theory (CMP-208)</option>
            <option value="CMP-209|Automata Theory Lab|1|Lab|4|Major">Automata Lab (CMP-209)</option>
            <option value="CMP-210|Software Engineering and Project Management|3|Theory|4|Major">Software Eng (CMP-210)</option>
            <option value="CMP-211|Software Engineering Lab|1|Lab|4|Major">Software Eng Lab (CMP-211)</option>
            <option value="CMP-225|Graph Theory and Combinatorics|3|Theory|4|Major">Graph Theory (CMP-225)</option>
            <option value="CMP-226|Graph Theory and Combinatorics Lab|1|Lab|4|Major">Graph Theory Lab (CMP-226)</option>
            <option value="CMP-227|Computational Number Theory|3|Theory|4|Major">Number Theory (CMP-227)</option>
            <option value="CMP-228|Computational Number Theory Lab|1|Lab|4|Major">Number Theory Lab (CMP-228)</option>
        </optgroup>
    <% } %>
</select>
                            </td>
                            <td>
                                <input type="hidden" name="subjectName[]" id="subjectName">
                                <input type="hidden" name="courseType[]" id="courseType">
                                <input type="hidden" name="semester[]" id="semester">
                                <input type="hidden" name="courseCode[]" id="courseCode">
                                <input type="hidden" name="courseCategory[]" id="courseCategory">
                                <input type="number" name="credits[]" id="credits" readonly style="background:#f1f5f9; font-weight:bold;">
                            </td>
                            <td>
                                <div id="theoryGroup" class="theory-group">
                                    <input type="number" name="t1[]" min="0" oninput="validateLimit(this)" placeholder="T1">
                                    <input type="number" name="t2[]" min="0" oninput="validateLimit(this)" placeholder="T2">
                                    <input type="number" name="t3[]" min="0" oninput="validateLimit(this)" placeholder="T3">
                                    <input type="number" name="assignment[]" id="asgnField" min="0" oninput="validateLimit(this)" placeholder="Asgn">
                                </div>
                                <div id="labGroup" style="display:none;">
                                    <input type="number" name="labTotal[]" id="labField" min="0" oninput="validateLimit(this)" placeholder="Enter Score">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button type="submit" class="btn-save">Calculate & Save</button>
            </form>
        </div>
    </div>
</body>
</html>
