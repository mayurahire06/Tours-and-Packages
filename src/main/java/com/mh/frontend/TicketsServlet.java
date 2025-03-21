package com.mh.frontend;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
//import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import com.mh.DBConnection;

@WebServlet("/TicketsServlet")
public class TicketsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession ticketSession = request.getSession(false);
        if (ticketSession == null) {
            response.sendRedirect("./user/loginRegister.jsp");
            return;
        }
        
        String src = "";
        Time arrivalTime = null;
        Time departureTime = null;
        Integer tourId = (Integer) ticketSession.getAttribute("tourId"); // Properly cast to Integer
        Integer userId = (Integer) ticketSession.getAttribute("uid");
        String transportType = (String) ticketSession.getAttribute("transportType");
        System.out.println("transportType from ticket servlet: "+ transportType);
        

        if (userId == null || tourId == null) {
	        response.sendRedirect("./user/loginRegister.jsp");
	        return;
        }
    
     List<String> list = Arrays.asList("bus", "train", "flight");

//    System.out.println("List: " + list);

    // Check if the list contains a specific string
    if (list.contains(transportType)) {
            String transportQuery = "SELECT source, arrival_time, departure_time FROM " + transportType + " WHERE t_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(transportQuery)) {
                pstmt.setInt(1, tourId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                    	//ResultSetMetaData metaData = rs.getMetaData(); //int columnCount = metaData.getColumnCount(); //System.out.println("Column Count: "+ columnCount);
                        src = rs.getString("source");
                        arrivalTime = rs.getTime("arrival_time"); //System.out.println("Arrival Time: "+ arrivalTime + arrivalTime.getClass().getName());
                        departureTime = rs.getTime("departure_time");
                 
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Source not found");
                        return;
                    }
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
                return;
            }
        }
        
        String membersStr = (String) ticketSession.getAttribute("members");
        if (membersStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Members not specified");
            return;
        }

        int members;
        try {
            members = Integer.parseInt(membersStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid members parameter");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Get tour details
            String destination, startDate, endDate;
            String tourQuery = "SELECT dest, s_date, e_date FROM tour WHERE t_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(tourQuery)) {
                pstmt.setInt(1, tourId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        destination = rs.getString("dest");
                        startDate = rs.getString("s_date");
                        endDate = rs.getString("e_date");
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tour not found");
                        return;
                    }
                }
            }

            // Insert booking
            int bookId;
            String bookingSql = "INSERT INTO booking (user_id, t_id, members, transport) VALUES (?, ?, ?, ?)";
            try (PreparedStatement bookStmt = conn.prepareStatement(bookingSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                bookStmt.setInt(1, userId);
                bookStmt.setInt(2, tourId);
                bookStmt.setInt(3, members);
                bookStmt.setString(4, transportType);
                bookStmt.executeUpdate();

                try (ResultSet generatedKeys = bookStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        bookId = generatedKeys.getInt(1);
                        //System.out.println("current booking id: "+ bookId);
                    } else {
                        throw new SQLException("Failed to retrieve book_id");
                    }
                }
            }
        
            // Insert travelers
            
            String travelerDetails = (String) ticketSession.getAttribute("travelerDetails");
            if (travelerDetails != null && !travelerDetails.trim().isEmpty()) {
                JSONArray travelers = new JSONArray(travelerDetails);
                System.out.println("travelers"+ travelers);
                String travelerSql = "INSERT INTO travelers (book_id, name, age, gender) VALUES (?, ?, ?, ?)";
                try (PreparedStatement travelerStmt = conn.prepareStatement(travelerSql)) {
                    for (int i = 0; i < travelers.length(); i++) {
                        JSONObject traveler = travelers.getJSONObject(i);
                        travelerStmt.setInt(1, bookId);
                        travelerStmt.setString(2, traveler.getString("name"));
                        travelerStmt.setInt(3, traveler.getInt("age"));
                        travelerStmt.setString(4, traveler.getString("gender"));
                        travelerStmt.addBatch();
                    }
                    travelerStmt.executeBatch();
                }
            }
            
            //START DATE
            Date sdate = Date.valueOf(startDate);
            // Convert to LocalDate
            LocalDate date1 = sdate.toLocalDate();
            // Define a formatter
            DateTimeFormatter formatter1 = DateTimeFormatter.ofPattern("dd MMMM yyyy");
            // Format the date
            String formattedStartDate = date1.format(formatter1);
            

            Date edate = Date.valueOf(endDate);
            LocalDate date2 = edate.toLocalDate();
            DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("dd MMMM yyyy");
            String formattedEndDate = date2.format(formatter2);

            conn.commit();
            ticketSession.setAttribute("bookId", bookId);
            ticketSession.setAttribute("source", src);
            ticketSession.setAttribute("destination", destination);
            ticketSession.setAttribute("startDate", formattedStartDate);
            ticketSession.setAttribute("endDate", formattedEndDate);
            ticketSession.setAttribute("arrivalTime", arrivalTime);
            ticketSession.setAttribute("departureTime", departureTime);
            
            response.sendRedirect("./user/ticket.jsp");
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid traveler data: " + e.getMessage());
        }
    }
}