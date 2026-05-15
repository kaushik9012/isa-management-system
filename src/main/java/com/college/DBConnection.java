package com.college; // Ensure this matches your package name

import java.sql.Connection;
import java.sql.DriverManager;

public static Connection getConnection() {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // This pulls the connection details automatically from Railway
        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String dbName = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        // The full connection URL
        String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName;

        return DriverManager.getConnection(url, user, password);
    } catch (Exception e) {
        e.printStackTrace();
        return null;
    }
}
