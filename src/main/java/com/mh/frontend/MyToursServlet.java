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
import java.util.ArrayList;
import java.util.List;
import com.mh.DBConnection;

@WebServlet("/MyToursServlet")
public class MyToursServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("uid") == null) {
            response.sendRedirect("./user/loginRegister.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("uid");
        List<MyTour> myTours = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String bookingQuery = "SELECT book_id, t_id, members, transport FROM booking WHERE user_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(bookingQuery)) {
                pstmt.setInt(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        int bookId = rs.getInt("book_id");
                        int tourId = rs.getInt("t_id");
                        int members = rs.getInt("members");
                        String transportType = rs.getString("transport");

                        String detailQuery = "SELECT t.dest, t.s_date, t.e_date, " +
                                           transportType + ".source, " +
                                           transportType + ".arrival_time, " +
                                           transportType + ".departure_time " +
                                           "FROM tour t JOIN " + transportType + " ON t.t_id = " + transportType + ".t_id " +
                                           "WHERE t.t_id = ?";
                        try (PreparedStatement detailStmt = conn.prepareStatement(detailQuery)) {
                            detailStmt.setInt(1, tourId);
                            try (ResultSet detailRs = detailStmt.executeQuery()) {
                                if (detailRs.next()) {
                                    MyTour tour = new MyTour(
                                        bookId,
                                        tourId,
                                        members,
                                        transportType,
                                        detailRs.getString("dest"),
                                        detailRs.getString("s_date"),
                                        detailRs.getString("e_date"),
                                        detailRs.getString("source"),
                                        detailRs.getTime("arrival_time"),
                                        detailRs.getTime("departure_time")
                                    );
                                    myTours.add(tour);
                                }
                            }
                        }
                    }
                }
            }
            session.setAttribute("myTours", myTours);
            response.sendRedirect("./user/myTours.jsp");

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}

// Helper class renamed to MyTour
class MyTour {
    private int bookId, tourId, members;
    private String transportType, destination, startDate, endDate, source;
    private java.sql.Time arrivalTime, departureTime;

    public MyTour(int bookId, int tourId, int members, String transportType, String destination,
                  String startDate, String endDate, String source, java.sql.Time arrivalTime,
                  java.sql.Time departureTime) {
        this.bookId = bookId;
        this.tourId = tourId;
        this.members = members;
        this.transportType = transportType;
        this.destination = destination;
        this.startDate = startDate;
        this.endDate = endDate;
        this.source = source;
        this.arrivalTime = arrivalTime;
        this.departureTime = departureTime;
    }

    // Getters
    public int getBookId() { return bookId; }
    public int getTourId() { return tourId; }
    public int getMembers() { return members; }
    public String getTransportType() { return transportType; }
    public String getDestination() { return destination; }
    public String getStartDate() { return startDate; }
    public String getEndDate() { return endDate; }
    public String getSource() { return source; }
    public java.sql.Time getArrivalTime() { return arrivalTime; }
    public java.sql.Time getDepartureTime() { return departureTime; }
}