package com.mh.frontend;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.json.JSONArray;
import org.json.JSONObject;
import com.mh.DBConnection;

@WebServlet("/TicketsServlet")
public class TicketsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession ticketSession = request.getSession(false);
        if (ticketSession == null) {
            response.sendRedirect("./user/loginRegister.jsp");
            return;
        }

        // Validate session attributes
        Integer userId = (Integer) ticketSession.getAttribute("uid");
//        System.out.println("userId from ticket servlet: "+ userId);
        String transportType = (String) ticketSession.getAttribute("transportType");
        String membersStr = (String) ticketSession.getAttribute("members");
        Object tourId = ticketSession.getAttribute("tourId");
//        System.out.println(tourId.getClass().getName());
//        System.out.println("touid from ticket servlet: "+ tourId.getClass());
        
//        if (userId == null || transportType == null || membersStr == null || tourIdParam) {
//            response.sendRedirect("./user/loginRegister.jsp");
//            return;
//        }

        // Parse numeric values
        int members;
        try {
//            tourId = Integer.parseInt(tourIdParam);
//            System.out.println("tourId from ticket servlet: "+ tourId);
            members = Integer.parseInt(membersStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Get tour details
            String destination, startDate, endDate;
            String tourQuery = "SELECT dest, s_date, e_date FROM tour WHERE t_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(tourQuery)) {
                pstmt.setInt(1, (int)tourId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    destination = rs.getString("dest");
                    startDate = rs.getString("s_date");
                    endDate = rs.getString("e_date");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tour not found");
                    return;
                }
            }

            // Insert booking
            int bookId;
            String bookingSql = "INSERT INTO booking (user_id, t_id, members, transport) VALUES (?, ?, ?, ?)";
            try (PreparedStatement bookStmt = conn.prepareStatement(bookingSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                bookStmt.setInt(1, userId);
                bookStmt.setInt(2, (int) tourId);
                bookStmt.setInt(3, members);
                bookStmt.setString(4, transportType);
                bookStmt.executeUpdate();

                try (ResultSet generatedKeys = bookStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        bookId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Failed to retrieve book_id");
                    }
                }
            }

            // Insert travelers
            String travelerDetails = request.getParameter("travelerDetails");
            if (travelerDetails != null && !travelerDetails.trim().isEmpty()) {
                JSONArray travelers = new JSONArray(travelerDetails);
                String travelerSql = "INSERT INTO travelers (book_id, name, age, gender) VALUES (?, ?, ?, ?)";
                try (PreparedStatement travelerStmt = conn.prepareStatement(travelerSql)) {
                    for (int i = 0; i < travelers.length(); i++) {
                        JSONObject traveler = travelers.getJSONObject(i);
                        travelerStmt.setInt(1, bookId);
                        travelerStmt.setString(2, traveler.getString("name"));
                        travelerStmt.setInt(3, traveler.getInt("age")); // Directly get as int from JSON
                        travelerStmt.setString(4, traveler.getString("gender"));
                        travelerStmt.addBatch();
                    }
                    travelerStmt.executeBatch();
                }
            }

            conn.commit(); // Commit transaction
            ticketSession.setAttribute("bookId", bookId); // Pass booking ID to ticket.jsp
        } catch (SQLException | ClassNotFoundException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
            return;
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid traveler data"+ e.getMessage());
            return;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) {}
            }
        }

        response.sendRedirect("./user/ticket.jsp");
    }
}