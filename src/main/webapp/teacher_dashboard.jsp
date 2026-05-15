<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    if (session.getAttribute("teacherUser") == null) { 
        response.sendRedirect("teacher_login.jsp"); 
        return; 
    } 
%>
<!DOCTYPE html>
<html>
<head>
    <title>Faculty Dashboard | DBCE</title>
    <style>
        :root { --primary: #1e3a8a; --bg: #f8fafc; --border: #e2e8f0; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin: 0; display: flex; }
        .sidebar { width: 260px; background: var(--primary); color: white; height: 100vh; position: fixed; }
        .main { margin-left: 260px; padding: 40px; width: calc(100% - 260px); box-sizing: border-box; }
        .card { background: white; border-radius: 12px; padding: 25px; margin-bottom: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border: 1px solid var(--border); }
        select, button, input[type="file"], input[type="text"] { width: 100%; padding: 12px; margin-top: 10px; border-radius: 6px; border: 1px solid var(--border); box-sizing: border-box; }
        button { background: var(--primary); color: white; font-weight: bold; cursor: pointer; border: none; transition: 0.2s; }
        button:hover { background: #1e40af; }
        .section-title { color: var(--primary); border-bottom: 2px solid var(--border); padding-bottom: 10px; margin-bottom: 20px; font-size: 1.25rem; }
        label { font-weight: 600; color: #475569; display: block; margin-top: 15px; }
    </style>
    <script>
        // Full Subject Repository based on RC 2024-25 Scheme
        const subjectData = {
            "1": [
                {code: "CMP-100", name: "Fundamentals of Programming using C"},
                {code: "CMP-101", name: "Fundamentals of Programming using C Lab"},
                {code: "EEL-111", name: "Basics of Electrical & Electronics Eng."},
                {code: "EEL-112", name: "Basics of Electrical & Electronics Eng. Lab"},
                {code: "SHM-111", name: "Biology for Engineers"},
                {code: "SHM-112", name: "Biology for Engineers Lab"},
                {code: "SHM-131", name: "Engineering Mathematics - I"},
                {code: "AEC-151", name: "Creative Thinking and Innovation"},
                {code: "AEC-152", name: "Creative Thinking and Innovation Lab"},
                {code: "VAC-156", name: "Indian Knowledge System"},
                {code: "VAC-157", name: "Indian Knowledge System Lab"},
                {code: "SEC-144", name: "Electronics and Mechanical Workshop"}
            ],
            "2": [
                {code: "ITH-100", name: "Fundamentals of Computing using Python"},
                {code: "ITH-101", name: "Fundamentals of Computing using Python Lab"},
                {code: "MCV-111", name: "Basics of Mechanical & Civil Engineering"},
                {code: "MCV-112", name: "Basics of Mechanical & Civil Engineering Lab"},
                {code: "SHM-113", name: "Engineering Chemistry"},
                {code: "SHM-114", name: "Engineering Chemistry Lab"},
                {code: "SHM-132", name: "Applied Physics"},
                {code: "SHM-133", name: "Applied Physics Lab"},
                {code: "AEC-153", name: "Communication and Technical Writing"},
                {code: "VAC-158", name: "Environmental Science & Sustainability"},
                {code: "VAC-159", name: "Environmental Science & Sustainability Lab"},
                {code: "SEC-143", name: "Engineering Graphics & Design with UI/UX"}
            ],
            "3": [
                {code: "CMP-200", name: "Data Structures and Algorithms using C++"},
                {code: "CMP-201", name: "Data Structures and Algorithms Lab"},
                {code: "CMP-202", name: "Digital System Design and Analysis"},
                {code: "CMP-203", name: "Digital System Design Lab"},
                {code: "CMP-221", name: "Computer Organization and Architecture"},
                {code: "CMP-222", name: "Computer Organization Lab"},
                {code: "CMP-223", name: "Microprocessors and Interfacing"},
                {code: "CMP-224", name: "Microprocessors Lab"},
                {code: "SHM-234", name: "Engineering Mathematics II"},
                {code: "CMP-241", name: "Web Technology: Design and Development"}
            ],
            "4": [
                {code: "CMP-204", name: "Object Oriented Programming Systems"},
                {code: "CMP-205", name: "Object Oriented Programming Lab"},
                {code: "CMP-206", name: "Internet of Things"},
                {code: "CMP-207", name: "Internet of Things Lab"},
                {code: "CMP-208", name: "Automata Theory and Formal Languages"},
                {code: "CMP-209", name: "Automata Theory Lab"},
                {code: "CMP-210", name: "Software Engineering & Project Management"},
                {code: "CMP-211", name: "Software Engineering Lab"},
                {code: "CMP-225", name: "Graph Theory and Combinatorics"},
                {code: "CMP-227", name: "Computational Number Theory"}
            ]
        };

        function syncSubjects() {
            const sem = document.getElementById("sem").value;
            const drop = document.getElementById("code");
            drop.innerHTML = '<option value="">-- Select Subject --</option>';
            
            if(subjectData[sem]) {
                subjectData[sem].forEach(s => {
                    let opt = document.createElement("option");
                    opt.value = s.code;
                    opt.text = s.code + " - " + s.name;
                    drop.add(opt);
                });
            }
        }
    </script>
</head>
<body onload="syncSubjects()">
    <div class="sidebar">
        <div style="padding:25px; text-align:center;"><h3>DBCE FACULTY</h3></div>
        <a href="teacher_dashboard.jsp" style="display:block; padding:15px 25px; color:white; background:rgba(255,255,255,0.1); text-decoration:none;">Dashboard</a>
        <a href="LogoutServlet" style="display:block; padding:15px 25px; color:#fca5a5; text-decoration:none;">Logout</a>
    </div>

    <div class="main">
        <div class="card">
            <h3 class="section-title">Batch Student Registration</h3>
            <form action="RegisterStudentServlet" method="POST" enctype="multipart/form-data">
                <label>Target Class</label>
                <select name="studentClass">
                    <option value="FE">First Year (FE)</option>
                    <option value="SE" selected>Second Year (SE)</option>
                </select>
                <label>Upload Student List (PDF)</label>
                <input type="file" name="studentListPdf" accept=".pdf" required>
                <button type="submit" style="margin-top:20px; background: #059669;">Process & Register</button>
            </form>
        </div>

        <div class="card">
            <h3 class="section-title">Generate ISA Report</h3>
            <form action="class_marks_report.jsp" method="GET">
                <label>Select Semester</label>
                <select name="semester" id="sem" onchange="syncSubjects()">
                    <option value="1">Semester 1 (FE)</option>
                    <option value="2">Semester 2 (FE)</option>
                    <option value="3">Semester 3 (SE)</option>
                    <option value="4">Semester 4 (SE)</option>
                </select>
                <label>Course Code</label>
                <select name="courseCode" id="code" required></select>
                <button type="submit" style="margin-top:20px;">View Printable Marksheet</button>
            </form>
        </div>
    </div>
</body>
</html>