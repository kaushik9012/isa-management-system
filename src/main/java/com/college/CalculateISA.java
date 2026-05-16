package com.college;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CalculateISA")
public class CalculateISA extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String isaId = request.getParameter("isa_id");
        
        try {
            Connection con = DBConnection.getConnection();
            
            // --- PATH 1: UPDATE EXISTING RECORD (From Edit Page) ---
            if ("update".equals(action) && isaId != null) {
                String type = request.getParameter("courseType");
                int t1 = getInt(request.getParameter("t1"));
                int t2 = getInt(request.getParameter("t2"));
                int t3 = getInt(request.getParameter("t3"));
                int asgn = getInt(request.getParameter("assignment"));
                int labT = getInt(request.getParameter("labTotal"));
                int finalIsa = 0;

                if ("Lab".equalsIgnoreCase(type)) {
                    finalIsa = labT;
                } else {
                    int lowest = Math.min(t1, Math.min(t2, t3));
                    finalIsa = (int)Math.round((double)((t1 + t2 + t3) - lowest) / 2) + asgn;
                    if(finalIsa > 30) finalIsa = 30;
                }

                String sql = "UPDATE student_isa_marks SET test1=?, test2=?, test3=?, assignment=?, lab_total=?, final_isa_score=? WHERE isa_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, t1);
                ps.setInt(2, t2);
                ps.setInt(3, t3);
                ps.setInt(4, asgn);
                ps.setInt(5, labT);
                ps.setInt(6, finalIsa);
                ps.setString(7, isaId);
                ps.executeUpdate();
            } 
            
            // --- PATH 2: BULK INSERT (From Original Registration/Marks Page) ---
            else {
                String[] subjects = request.getParameterValues("subjectName[]");
                if (subjects != null) {
                    String[] codes = request.getParameterValues("courseCode[]");
                    String[] types = request.getParameterValues("courseType[]");
                    String[] creditsArr = request.getParameterValues("credits[]");
                    HttpSession session = request.getSession();
                    int rollNo = (Integer) session.getAttribute("rollNo");

                    String sql = "INSERT INTO student_isa_marks (roll_no, semester, course_code, subject_name, course_category, course_type, credits, test1, test2, test3, assignment, lab_total, final_isa_score) " +
                                 "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE final_isa_score=VALUES(final_isa_score), lab_total=VALUES(lab_total)";
                    PreparedStatement ps = con.prepareStatement(sql);

                    for (int i = 0; i < subjects.length; i++) {
                        int t1=0, t2=0, t3=0, asgn=0, labT=0, finalIsa=0;

                        if ("Lab".equals(types[i])) {
                            labT = getInt(request.getParameterValues("labTotal[]")[i]);
                            finalIsa = labT;
                        } else {
                            t1 = getInt(request.getParameterValues("t1[]")[i]);
                            t2 = getInt(request.getParameterValues("t2[]")[i]);
                            t3 = getInt(request.getParameterValues("t3[]")[i]);
                            asgn = getInt(request.getParameterValues("assignment[]")[i]);
                            int lowest = Math.min(t1, Math.min(t2, t3));
                            finalIsa = (int)Math.round((double)((t1 + t2 + t3) - lowest) / 2) + asgn;
                            if(finalIsa > 30) finalIsa = 30;
                        }
                        ps.setInt(1, rollNo);
                        ps.setInt(2, getInt(request.getParameterValues("semester[]")[i]));
                        ps.setString(3, codes[i]);
                        ps.setString(4, subjects[i]);
                        ps.setString(5, request.getParameterValues("courseCategory[]")[i]);
                        ps.setString(6, types[i]);
                        ps.setInt(7, getInt(creditsArr[i]));
                        ps.setInt(8, t1); ps.setInt(9, t2); ps.setInt(10, t3); ps.setInt(11, asgn); ps.setInt(12, labT);
                        ps.setInt(13, finalIsa);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }
            con.close();
            // This redirect kills the blank screen
            response.sendRedirect("view_marks.jsp");

        } catch (Exception e) {
            // If there's an error, this prints it to the screen so you can debug
            e.printStackTrace();
            response.setContentType("text/html");
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }

    // Helper method to safely parse integers
    private int getInt(String val) {
        if (val == null || val.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(val);
        } catch (Exception e) {
            return 0;
        }
    }
}
