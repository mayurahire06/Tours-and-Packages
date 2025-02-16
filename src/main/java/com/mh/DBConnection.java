package com.mh;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Database credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/toursandtravellers";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    // Static method to get database connection
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish and return connection
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}
