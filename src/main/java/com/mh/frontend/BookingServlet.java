package com.mh.frontend;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
//import java.sql.Time;

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
        
        HttpSession bookServletSession = request.getSession(false);
        
        // 1. Session validation
        Integer userId = (Integer) bookServletSession.getAttribute("uid");
        if(userId == null) {
            response.sendRedirect("/user/loginRegister.jsp");
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

        // 3. Initialize variables
        //String source = "Not Available";
        String destination = "Not Available";
        String startDate = "Not Available";
        String endDate = "Not Available";
        String itineraryContent = "";
        String fileName = "";
        String arrivalTime = null;
        String departureTime = null;
        String transportSource = "Not Available"; // Added for transport source

        try (Connection conn = DBConnection.getConnection()) {
            // 4. Fixed tour query (added source)
            String tourQuery = "SELECT dest, s_date, e_date, itinerary FROM tour WHERE t_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(tourQuery)) {
                pstmt.setInt(1, tourId);
                try{
                	ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        destination = rs.getString("dest");
                        startDate = rs.getString("s_date");
                        endDate = rs.getString("e_date");

                        String filePath = rs.getString("itinerary");
                        
                        // Extract only the filename
                        if (filePath != null && !filePath.trim().isEmpty()) {
                            // Handle both forward and backslashes
                            String normalizedPath = filePath.replace("\\", "/");
                            fileName = normalizedPath.substring(normalizedPath.lastIndexOf("/") + 1);
                            ///System.out.println("filename:" +fileName);
                            if (Files.exists(Paths.get(filePath))) {
                                itineraryContent = new String(Files.readAllBytes(Paths.get(filePath)));
                                //System.out.println("Content: "+ itineraryContent);
                            } else {
                                itineraryContent = "File not found: " + fileName;
                            }
                        } else {
                            itineraryContent = "No itinerary available for this tour.";
                        }
                       
                    }
                    
                } catch (Exception e) {
                    itineraryContent = "Unable to load itinerary at this time.";
                    e.printStackTrace();
                }
                
            }

            // 5. Transport handling improvements
            String transportType = request.getParameter("transportType");
            String transportQuery = null;
            
            if(transportType != null && !transportType.isEmpty()) {
                switch(transportType.toLowerCase()) {
                    case "train":
                        transportQuery = "SELECT source, arrival_time, departure_time FROM train WHERE t_id = ?";
                        break;
                    case "bus":
                        transportQuery = "SELECT source, arrival_time, departure_time FROM bus WHERE t_id = ?";
                        break;
                    case "flight":
                        transportQuery = "SELECT source, arrival_time, departure_time FROM flight WHERE t_id = ?";
                        break;
                    default:
                        // Log unknown transport type
                        break;
                }

                if (transportQuery != null) {
                    try (PreparedStatement transportStmt = conn.prepareStatement(transportQuery)) {
                        transportStmt.setInt(1, tourId);
                        try (ResultSet transportRs = transportStmt.executeQuery()) {
                            if (transportRs.next()) {
                                transportSource = transportRs.getString("source");
                                arrivalTime = transportRs.getString("arrival_time");
                                departureTime = transportRs.getString("departure_time");
                            }
                        }
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            // Log error properly in production
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error");
            return;
        }

        // 6. Set request attributes with null safety
        request.setAttribute("destination", destination);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("transportSource", transportSource);
        request.setAttribute("arrivalTime", arrivalTime);
        request.setAttribute("departureTime", departureTime);

        // 7. Pass through form parameters
        request.setAttribute("tourId", tourId);
        request.setAttribute("userId", userId);
        request.setAttribute("members", request.getParameter("members"));
        request.setAttribute("transportType", request.getParameter("transportType"));
        request.setAttribute("totalPrice", request.getParameter("totalPrice"));
        request.setAttribute("travelerDetails", request.getParameter("travelerDetails"));
        request.setAttribute("itineraryContent", itineraryContent);

        request.getRequestDispatcher("/user/booking.jsp").forward(request, response);
        //response.sendRedirect("./user/booking.jsp");
    }
}