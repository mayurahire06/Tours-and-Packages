package com.mh.frontend;

import com.mh.DBConnection;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.text.NumberFormat;
import java.util.Locale;


@WebServlet("/viewTourDetails")
public class ViewTourDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Authentication check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user/loginRegister.jsp");
            return;
        }

        // Get tour ID parameter
        int tourId;
        try {
            tourId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Tour ID");
            return;
        }

        // Initialize data structures
        Map<String, Object> tourDetails = new HashMap<>();
        List<String> images = new ArrayList<>();
        Map<String, Integer> transportPrices = new HashMap<>();
        List<String> transportOptions = new ArrayList<>();
        List<Map<String, Object>> relatedTours = new ArrayList<>();
        String currentCatName = "";
        int currentCatId = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Get main tour details and images
            getTourDetails(conn, tourId, tourDetails, images);
            
            // Process transport options
            processTransportOptions(conn, tourId, 
                (String) tourDetails.get("transport"), 
                transportPrices, 
                transportOptions);
            
            // Get category information
            currentCatId = getCategoryInfo(conn, tourId);
            
            // Get related tours
            getRelatedTours(conn, currentCatId, tourId, relatedTours);
            
            // Get current category name
            currentCatName = getCategoryName(conn, currentCatId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error");
            return;
        }

        // Set request attributes
        request.setAttribute("tour", tourDetails);
        request.setAttribute("images", images);
        request.setAttribute("transportPrices", transportPrices);
        request.setAttribute("transportOptions", transportOptions);
        request.setAttribute("relatedTours", relatedTours);
        request.setAttribute("currentCatName", currentCatName);
        request.setAttribute("formattedBasePrice", 
            NumberFormat.getNumberInstance(Locale.US).format(tourDetails.get("price")));

        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/viewTourDetails.jsp");
        dispatcher.forward(request, response);
    }

    private void getTourDetails(Connection conn, int tourId, 
            Map<String, Object> tourDetails, List<String> images) throws SQLException {
        String query = "SELECT t.s_date, t.price, t.dest, t.capacity, t.transport, i.image_path " +
                     "FROM tour t LEFT JOIN images i ON t.t_id = i.t_id WHERE t.t_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                if (tourDetails.isEmpty()) {
                    tourDetails.put("s_date", rs.getString("s_date"));
                    tourDetails.put("price", rs.getInt("price"));
                    tourDetails.put("dest", rs.getString("dest"));
                    tourDetails.put("capacity", rs.getInt("capacity"));
                    tourDetails.put("transport", rs.getString("transport"));
                }
                
                String imagePath = rs.getString("image_path");
                if (imagePath != null && !imagePath.trim().isEmpty()) {
                    images.add(imagePath.replace("\\", "/"));
                }
            }
        }
    }

    private void processTransportOptions(Connection conn, int tourId, String transport, 
            Map<String, Integer> transportPrices, List<String> transportOptions) throws SQLException {
        if (transport == null || transport.trim().isEmpty()) return;
        
        for (String type : transport.split(",")) {
            String transportType = type.trim().toLowerCase();
            transportOptions.add(transportType);
            
            String query = switch(transportType) {
                case "train" -> "SELECT trainTicket FROM train WHERE t_id = ?";
                case "bus" -> "SELECT busTicket FROM bus WHERE t_id = ?";
                case "flight" -> "SELECT flightTicket FROM flight WHERE t_id = ?";
                default -> "";
            };

            if (!query.isEmpty()) {
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, tourId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        transportPrices.put(transportType, rs.getInt(1));
                    }
                }
            }
        }
    }

    private int getCategoryInfo(Connection conn, int tourId) throws SQLException {
        String query = "SELECT cat_id FROM tour WHERE t_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt("cat_id") : 0;
        }
    }

    private void getRelatedTours(Connection conn, int catId, int currentTourId, 
            List<Map<String, Object>> relatedTours) throws SQLException {
        String query = "SELECT t.t_id, t.title, t.dest, t.price, t.duration, " +
                     "(SELECT i.image_path FROM images i WHERE i.t_id = t.t_id LIMIT 1) AS main_image " +
                     "FROM tour t WHERE t.cat_id = ? AND t.t_id != ? ORDER BY t.s_date DESC LIMIT 4";
        
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, catId);
            stmt.setInt(2, currentTourId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> tour = new HashMap<>();
                tour.put("t_id", rs.getInt("t_id"));
                tour.put("title", rs.getString("title"));
                tour.put("dest", rs.getString("dest"));
                tour.put("price", rs.getInt("price"));
                tour.put("duration", rs.getString("duration"));
                
                String imagePath = rs.getString("main_image");
                tour.put("image", (imagePath != null) ? imagePath.replace("\\", "/") : "images/default-tour.jpg");
                
                relatedTours.add(tour);
            }
        }
    }

    private String getCategoryName(Connection conn, int catId) throws SQLException {
        String query = "SELECT cat_name FROM category WHERE cat_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, catId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getString("cat_name") : "Related";
        }
    }
}