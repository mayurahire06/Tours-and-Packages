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

import org.json.JSONArray;
import org.json.JSONObject;

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
        
        Integer userId = (Integer) bookServletSession.getAttribute("uid");
        if (userId == null) {
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

        String membersParam = request.getParameter("members");
        int members;
        try {
            members = Integer.parseInt(membersParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number of members");
            return;
        }

        String transportType = request.getParameter("transportType");
        //if (transportType == null || transportType.trim().isEmpty()) {
        //    transportType = "Not Specified"; // Default value if transportType is missing
       // }

        // 3. Initialize variables
        String destination = "Not Available";
        String startDate = "Not Available";
        String endDate = "Not Available";
        String itineraryContent = "";
        String fileName = "";

        try (Connection conn = DBConnection.getConnection()) {
            // Start transaction
            conn.setAutoCommit(false);

            // 4. Tour query
            String tourQuery = "SELECT dest, s_date, e_date, itinerary FROM tour WHERE t_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(tourQuery)) {
                pstmt.setInt(1, tourId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        destination = rs.getString("dest");
                        startDate = rs.getString("s_date");
                        endDate = rs.getString("e_date");

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

            // 5. Insert into booking table and get book_id
            String bookingSql = "INSERT INTO booking (user_id, t_id, members, transport) VALUES (?, ?, ?, ?)";
            int bookId;
            try (PreparedStatement bookStmt = conn.prepareStatement(bookingSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                bookStmt.setInt(1, userId);
                bookStmt.setInt(2, tourId);
                bookStmt.setInt(3, members);
                bookStmt.setString(4, transportType);
                int rowsInserted = bookStmt.executeUpdate();

                if (rowsInserted > 0) {
                    System.out.println("Data inserted into booking");
                    try (ResultSet generatedKeys = bookStmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            bookId = generatedKeys.getInt(1);
                        } else {
                            throw new SQLException("Failed to retrieve book_id");
                        }
                    }
                } else {
                    throw new SQLException("Failed to insert booking data");
                }
            }

            // 6. Parse and insert traveler details into travelers table
            String travelerDetails = request.getParameter("travelerDetails");
            if (travelerDetails != null && !travelerDetails.trim().isEmpty()) {
                try {
                    System.out.println("Traveler Details:");
                    JSONArray travelers = new JSONArray(travelerDetails);
                    String travelerSql = "INSERT INTO travelers (book_id, name, age, gender) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement travelerStmt = conn.prepareStatement(travelerSql)) {
                        for (int i = 0; i < travelers.length(); i++) {
                            JSONObject traveler = travelers.getJSONObject(i);
                            String name = traveler.getString("name");
                            String age = traveler.getString("age");
                            String gender = traveler.getString("gender");

                            //System.out.println("  Traveler " + (i + 1) + ": Name=" + name + ", Age=" + age + ", Gender=" + gender);

                            // Insert into travelers table
                            travelerStmt.setInt(1, bookId);
                            travelerStmt.setString(2, name);
                            travelerStmt.setString(3, age); // Assuming age is stored as a string; use setInt if integer
                            travelerStmt.setString(4, gender);
                            travelerStmt.addBatch();
                        }
                        int[] travelerRows = travelerStmt.executeBatch();
                        System.out.println("Inserted " + travelerRows.length + " travelers into travelers table");
                    }
                } catch (Exception e) {
                    System.out.println("Traveler Details: Failed to parse or insert JSON - " + travelerDetails);
                    throw new SQLException("Failed to process traveler details: " + e.getMessage());
                }
            } else {
                System.out.println("Traveler Details: None provided");
            }

            // Commit transaction
            conn.commit();

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error: " + e.getMessage());
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server Error: " + e.getMessage());
            return;
        }

        // 7. Set request attributes
        //request.setAttribute("destination", destination);
        //request.setAttribute("startDate", startDate);
        //request.setAttribute("endDate", endDate);
        //request.setAttribute("tourId", tourId);
        //request.setAttribute("userId", userId);
        request.setAttribute("members", members);
        request.setAttribute("transportType", transportType);
        request.setAttribute("totalPrice", request.getParameter("totalPrice"));
        request.setAttribute("travelerDetails", request.getParameter("travelerDetails"));
        request.setAttribute("itineraryContent", itineraryContent);

        // 8. Forward to JSP
        request.getRequestDispatcher("/user/booking.jsp").forward(request, response);
    }
}