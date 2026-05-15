package com.college;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // These pull the correct cloud addresses automatically
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String dbName = System.getenv("MYSQLDATABASE");
            String user = System.getenv("MYSQLUSER");
            String password = System.getenv("MYSQLPASSWORD");

            // Build the dynamic URL
            String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName;

            return DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
