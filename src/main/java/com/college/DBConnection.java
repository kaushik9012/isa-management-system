package com.college; // Ensure this matches your package name

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() throws Exception {
        // Railway automatically provides the MYSQL_URL environment variable
        String dbUrl = System.getenv("MYSQL_URL"); 

        if (dbUrl == null) {
            // --- LOCAL SETTINGS (XAMPP) ---
            // If MYSQL_URL is missing, we are on your laptop.
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection("jdbc:mysql://localhost:3306/college_db", "root", "");
        } else {
            // --- CLOUD SETTINGS (RAILWAY) ---
            // Railway uses 'mysql://', but Java needs 'jdbc:mysql://'
            String jdbcUrl = dbUrl.replace("mysql://", "jdbc:mysql://");
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(jdbcUrl);
        }
    }
}