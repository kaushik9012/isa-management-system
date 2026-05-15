package com.college;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddStudentServlet")
public class AddStudentServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get data from the form
        String rollNoStr = request.getParameter("rollNo");
        String name = request.getParameter("studentName");
        String sClass = request.getParameter("studentClass");

        try {
            // 2. Database Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
            
            // 3. Insert Query
            // Note: 'id' is auto-increment in your schema, so we skip it
            String sql = "INSERT INTO users (name, roll_no, student_class) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, Integer.parseInt(rollNoStr));
            ps.setString(3, sClass);
            
            int rowsAffected = ps.executeUpdate();
            con.close();
            
            if (rowsAffected > 0) {
                response.sendRedirect("register_student.jsp?success=1");
            } else {
                response.sendRedirect("register_student.jsp?error=1");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Redirect with error if roll number is a duplicate or SQL fails
            response.sendRedirect("register_student.jsp?error=1");
        }
    }
}