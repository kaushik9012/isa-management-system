package com.college;

import java.io.*;
import java.sql.*;
import java.util.regex.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

@WebServlet("/RegisterStudentServlet")
@MultipartConfig
public class RegisterStudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sClass = request.getParameter("studentClass");
        Part filePart = request.getPart("studentListPdf");

        try (InputStream is = filePart.getInputStream()) {
            byte[] bytes = is.readAllBytes();
            PDDocument document = Loader.loadPDF(bytes);
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document);
            document.close();

            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
            String sql = "INSERT INTO users (name, roll_no, student_class) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE name=VALUES(name)";
            PreparedStatement ps = con.prepareStatement(sql);

            // Updated Regex: Matches names and 7-digit roll numbers more robustly
            Pattern p = Pattern.compile("([A-Z\\s]+)\\s+(\\d{7})");
            Matcher m = p.matcher(text);

            int count = 0;
            while (m.find()) {
                ps.setString(1, m.group(1).trim());
                ps.setInt(2, Integer.parseInt(m.group(2)));
                ps.setString(3, sClass);
                ps.addBatch();
                count++;
            }

            ps.executeBatch();
            con.close();
            response.sendRedirect("teacher_dashboard.jsp?registered=" + count);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}