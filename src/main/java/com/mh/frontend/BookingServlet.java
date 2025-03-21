package com.mh.frontend;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.mh.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session validation
        HttpSession bookServletSession = request.getSession(false);
        if (bookServletSession == null) {
            response.sendRedirect("./user/loginRegister.jsp");
            return;
        }

        // 2. Parameter validation
        String tourIdParam = request.getParameter("tourId");

        int tourId;
        try {
            tourId = Integer.parseInt(tourIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Tour ID");
            return;
        }

        String membersParam = request.getParameter("members");
        int members;
        try {
            members = Integer.parseInt(membersParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number of members");
            return;
        }

        String transportType = request.getParameter("transportType");

        String itineraryContent = "";
        String fileName = "";

        try (Connection conn = DBConnection.getConnection()) {

            String tourQuery = "SELECT itinerary FROM tour WHERE t_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(tourQuery)) {
                pstmt.setInt(1, tourId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {

                        String filePath = rs.getString("itinerary");
                        if (filePath != null && !filePath.trim().isEmpty()) {
                            String normalizedPath = filePath.replace("\\", "/");
                            fileName = normalizedPath.substring(normalizedPath.lastIndexOf("/") + 1);
                            if (Files.exists(Paths.get(filePath))) {
                                itineraryContent = new String(Files.readAllBytes(Paths.get(filePath)));
                            } else {
                                itineraryContent = "File not found: " + fileName;
                            }
                        } else {
                            itineraryContent = "No itinerary available for this tour.";
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tour not found");
                        return;
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error: " + e.getMessage());
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server Error: " + e.getMessage());
            return;
        }

        bookServletSession.setAttribute("tourId", tourId);
        bookServletSession.setAttribute("members", membersParam);
        bookServletSession.setAttribute("transportType", transportType);
        System.out.println("transportType from booking servlet: " +transportType);
        bookServletSession.setAttribute("totalPrice", request.getParameter("totalPrice"));
        bookServletSession.setAttribute("travelerDetails", request.getParameter("travelerDetails"));
        bookServletSession.setAttribute("itineraryContent", itineraryContent);

        // 8. Forward to JSP
        //request.getRequestDispatcher("/user/booking.jsp").include(request, response); //this works
        //request.getRequestDispatcher("/user/booking.jsp").forward(request, response); //THIS DOESN'T WORK
        response.sendRedirect("./user/booking.jsp"); //This is also works
    }
}
