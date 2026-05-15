package com.college;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CalculateISA")
public class CalculateISA extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] subjects = request.getParameterValues("subjectName[]");
        String[] codes = request.getParameterValues("courseCode[]");
        String[] types = request.getParameterValues("courseType[]");
        String[] creditsArr = request.getParameterValues("credits[]");
        HttpSession session = request.getSession();
        int rollNo = (Integer) session.getAttribute("rollNo");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = com.college.DBConnection.getConnection();
            
            // Fixed Query: Includes course_type and handles raw lab marks
            String sql = "INSERT INTO student_isa_marks (roll_no, semester, course_code, subject_name, course_category, course_type, credits, test1, test2, test3, assignment, lab_total, final_isa_score) " +
                         "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE final_isa_score=VALUES(final_isa_score), lab_total=VALUES(lab_total)";
            PreparedStatement ps = con.prepareStatement(sql);

            for (int i = 0; i < subjects.length; i++) {
                int finalIsa = 0;
                int t1=0, t2=0, t3=0, asgn=0, labT=0;

                if ("Lab".equals(types[i])) {
                    labT = Integer.parseInt(request.getParameterValues("labTotal[]")[i]);
                    finalIsa = labT; // RAW MARKS: No division, show as it is
                } else {
                    t1 = Integer.parseInt(request.getParameterValues("t1[]")[i]);
                    t2 = Integer.parseInt(request.getParameterValues("t2[]")[i]);
                    t3 = Integer.parseInt(request.getParameterValues("t3[]")[i]);
                    asgn = Integer.parseInt(request.getParameterValues("assignment[]")[i]);
                    int lowest = Math.min(t1, Math.min(t2, t3));
                    finalIsa = (int)Math.round((double)((t1 + t2 + t3) - lowest) / 2) + asgn;
                    if(finalIsa > 30) finalIsa = 30;
                }
                ps.setInt(1, rollNo); ps.setInt(2, 4); // Example for SE Sem IV
                ps.setString(3, codes[i]); ps.setString(4, subjects[i]);
                ps.setString(5, "Major"); ps.setString(6, types[i]);
                ps.setInt(7, Integer.parseInt(creditsArr[i]));
                ps.setInt(8, t1); ps.setInt(9, t2); ps.setInt(10, t3); ps.setInt(11, asgn); ps.setInt(12, labT);
                ps.setInt(13, finalIsa); ps.addBatch();
            }
            ps.executeBatch();
            con.close();
            response.sendRedirect("view_marks.jsp");
        } catch (Exception e) { e.printStackTrace(); }
    }
}