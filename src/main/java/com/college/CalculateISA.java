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

            // --- PATH 1: UPDATE (From the Edit Page) ---
            if ("update".equals(action) && isaId != null) {
                String type = request.getParameter("courseType");
                String sem = request.getParameter("semester");
                int t1 = getInt(request.getParameter("t1"));
                int t2 = getInt(request.getParameter("t2"));
                int t3 = getInt(request.getParameter("t3"));
                int asgn = getInt(request.getParameter("assignment"));
                int labT = getInt(request.getParameter("labTotal"));
                
                // Calculate Final Score
                int finalIsa = 0;
                if ("Lab".equalsIgnoreCase(type)) {
                    finalIsa = labT;
                } else {
                    int lowest = Math.min(t1, Math.min(t2, t3));
                    finalIsa = (int)Math.round((double)((t1 + t2 + t3) - lowest) / 2) + asgn;
                    if(finalIsa > 30) finalIsa = 30;
                }

                String sql = "UPDATE student_isa_marks SET semester=?, test1=?, test2=?, test3=?, " +
                             "assignment=?, lab_total=?, final_isa_score=? WHERE isa_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, sem);      // 1
                ps.setInt(2, t1);         // 2
                ps.setInt(3, t2);         // 3
                ps.setInt(4, t3);         // 4
                ps.setInt(5, asgn);       // 5
                ps.setInt(6, labT);       // 6
                ps.setInt(7, finalIsa);   // 7
                ps.setString(8, isaId);    // 8 (FIXED: This was Parameter 8)
                ps.executeUpdate();
            } 
            
            // --- PATH 2: BULK INSERT (From Add/Registration Page) ---
            else {
                String[] subjects = request.getParameterValues("subjectName[]");
                if (subjects != null) {
                    String[] codes = request.getParameterValues("courseCode[]");
                    String[] types = request.getParameterValues("courseType[]");
                    String[] creditsArr = request.getParameterValues("credits[]");
                    String[] sems = request.getParameterValues("semester[]");
                    String[] cats = request.getParameterValues("courseCategory[]");
                    
                    HttpSession session = request.getSession();
                    int rollNo = (Integer) session.getAttribute("rollNo");

                    String sql = "INSERT INTO student_isa_marks (roll_no, semester, course_code, subject_name, " +
                                 "course_category, course_type, credits, test1, test2, test3, assignment, lab_total, final_isa_score) " +
                                 "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE final_isa_score=VALUES(final_isa_score)";
                    PreparedStatement ps = con.prepareStatement(sql);

                    for (int i = 0; i < subjects.length; i++) {
                        int t1 = getInt(request.getParameterValues("t1[]")[i]);
                        int t2 = getInt(request.getParameterValues("t2[]")[i]);
                        int t3 = getInt(request.getParameterValues("t3[]")[i]);
                        int asgn = getInt(request.getParameterValues("assignment[]")[i]);
                        int labT = getInt(request.getParameterValues("labTotal[]")[i]);
                        
                        int finalIsa = 0;
                        if ("Lab".equalsIgnoreCase(types[i])) {
                            finalIsa = labT;
                        } else {
                            int lowest = Math.min(t1, Math.min(t2, t3));
                            finalIsa = (int)Math.round((double)((t1 + t2 + t3) - lowest) / 2) + asgn;
                            if(finalIsa > 30) finalIsa = 30;
                        }

                        ps.setInt(1, rollNo);                                    // 1
                        ps.setInt(2, (sems != null) ? getInt(sems[i]) : 3);      // 2
                        ps.setString(3, codes[i]);                               // 3
                        ps.setString(4, subjects[i]);                            // 4
                        ps.setString(5, (cats != null && cats.length > i) ? cats[i] : "Major"); // 5
                        ps.setString(6, types[i]);                               // 6
                        ps.setInt(7, getInt(creditsArr[i]));                     // 7
                        ps.setInt(8, t1);                                        // 8 (FIXED: This was Parameter 8)
                        ps.setInt(9, t2);                                        // 9
                        ps.setInt(10, t3);                                       // 10
                        ps.setInt(11, asgn);                                     // 11
                        ps.setInt(12, labT);                                     // 12
                        ps.setInt(13, finalIsa);                                 // 13
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }
            
            con.close();
            
            // REDIRECT back to the list (Fixes the blank screen)
            response.sendRedirect("view_marks.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }

    // Safely parse integers to avoid crashes
    private int getInt(String val) {
        if (val == null || val.trim().isEmpty()) return 0;
        try { return Integer.parseInt(val); } catch (Exception e) { return 0; }
    }
}
