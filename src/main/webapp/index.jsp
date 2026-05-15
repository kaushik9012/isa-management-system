<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Academic Portal | DBCE Goa</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; display: flex; height: 100vh; background: #f4f7f6; justify-content: center; align-items: center; }
        .card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.1); text-align: center; width: 600px; }
        .roles { display: flex; gap: 20px; margin-top: 30px; }
        .role-btn { flex: 1; padding: 40px 20px; border-radius: 15px; text-decoration: none; color: white; font-weight: bold; font-size: 1.1rem; transition: 0.3s; }
        .student { background: #4a90e2; }
        .teacher { background: #764ba2; }
        .role-btn:hover { transform: translateY(-5px); }
    </style>
</head>
<body>
    <div class="card">
        <h1>DON BOSCO COLLEGE OF ENGINEERING</h1>
        <h3>ISA Management (RC 2024-25)</h3>
        <div class="roles">
            <a href="student_login.jsp" class="role-btn student">🎓 STUDENT LOGIN</a>
            <a href="teacher_login.jsp" class="role-btn teacher">👨‍🏫 FACULTY LOGIN</a>
        </div>
    </div>
</body>
</html>