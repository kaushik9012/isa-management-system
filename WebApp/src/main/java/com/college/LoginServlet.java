package com.college;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("studentName").trim().toUpperCase();
        String roll = request.getParameter("rollNo");
        String sClass = request.getParameter("studentClass");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
            
            // Check all three fields
            String sql = "SELECT * FROM users WHERE UPPER(name)=? AND roll_no=? AND student_class=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, roll);
            ps.setString(3, sClass);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("rollNo", rs.getInt("roll_no"));
                session.setAttribute("studentName", rs.getString("name"));
                session.setAttribute("studentClass", rs.getString("student_class"));
                response.sendRedirect("marks_entry.jsp");
            } else {
                // Redirect back with an error if no match is found
                response.sendRedirect("student_login.jsp?error=invalid");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}