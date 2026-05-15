package com.college;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TeacherUpdateServlet")
public class TeacherUpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("isa_id"));
        int credits = Integer.parseInt(request.getParameter("credits"));
        String type = request.getParameter("course_type");
        int finalIsa = 0;

        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
            if ("Lab".equals(type)) {
                int labT = Integer.parseInt(request.getParameter("labTotal"));
                finalIsa = (labT * (credits * 10)) / 100;
            } else {
                int t1 = Integer.parseInt(request.getParameter("t1"));
                int t2 = Integer.parseInt(request.getParameter("t2"));
                int t3 = Integer.parseInt(request.getParameter("t3"));
                int asgn = Integer.parseInt(request.getParameter("asgn"));
                int lowest = Math.min(t1, Math.min(t2, t3));
                finalIsa = ((t1 + t2 + t3) - lowest) / 2 + asgn;
            }

            PreparedStatement ps = con.prepareStatement("UPDATE student_isa_marks SET final_isa_score=? WHERE isa_id=?");
            ps.setInt(1, finalIsa);
            ps.setInt(2, id);
            ps.executeUpdate();
            response.sendRedirect("teacher_dashboard.jsp");
        } catch (Exception e) { e.printStackTrace(); }
    }
}