package com.mh.frontend;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.mh.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;

@WebServlet("/ProcessTravelersServlet")
public class ProcessTravelers extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get tour ID and number of travelers
        String tourId = request.getParameter("tourId");
        int travelers = Integer.parseInt(request.getParameter("travelers"));

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();  // Ensure you have a DBConnection class
            String insertQuery = "INSERT INTO traveler_details (tour_id, name, age, gender) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertQuery);

            for (int i = 1; i <= travelers; i++) {
                String name = request.getParameter("name_" + i);
                int age = Integer.parseInt(request.getParameter("age_" + i));
                String gender = request.getParameter("gender_" + i);

                pstmt.setString(1, tourId);
                pstmt.setString(2, name);
                pstmt.setInt(3, age);
                pstmt.setString(4, gender);
                pstmt.executeUpdate();
            }

            // Redirect to confirmation page
            response.sendRedirect("confirmation.jsp?tourId=" + tourId);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error saving traveler details.");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}