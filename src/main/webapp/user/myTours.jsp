<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.mh.frontend.MyToursServlet.MyTour" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Tours</title>
</head>
<body>
    <h1>My Tours</h1>
    <table border="1">
        <tr>
            <th>Booking ID</th>
            <th>Tour ID</th>
            <th>Members</th>
            <th>Transport</th>
            <th>Source</th>
            <th>Destination</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Departure Time</th>
            <th>Arrival Time</th>
        </tr>
        <%
            List<MyTour> myTours = (List<MyTour>) session.getAttribute("myTours");
            if (myTours != null && !myTours.isEmpty()) {
                for (MyTour tour : myTours) {
        %>
        <tr>
            <td><%= tour.getBookId() %></td>
            <td><%= tour.getTourId() %></td>
            <td><%= tour.getMembers() %></td>
            <td><%= tour.getTransportType() %></td>
            <td><%= tour.getSource() %></td>
            <td><%= tour.getDestination() %></td>
            <td><%= tour.getStartDate() %></td>
            <td><%= tour.getEndDate() %></td>
            <td><%= tour.getDepartureTime() != null ? tour.getDepartureTime().toString() : "N/A" %></td>
            <td><%= tour.getArrivalTime() != null ? tour.getArrivalTime().toString() : "N/A" %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="10">No tours booked yet.</td></tr>
        <% } %>
    </table>
    <a href="./user/dashboard.jsp">Back to Dashboard</a>
</body>
</html>