package com.college;
import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteISA")
public class DeleteISAServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
            PreparedStatement ps = con.prepareStatement("DELETE FROM student_isa_marks WHERE isa_id = ?");
            ps.setString(1, id);
            ps.executeUpdate();
            con.close();
            response.sendRedirect("view_marks.jsp");
        } catch (Exception e) { e.printStackTrace(); }
    }
}