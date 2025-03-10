<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%
    String tourId = (String) request.getAttribute("tourId");
    String members = (String) request.getAttribute("members");
    String transportType = (String) request.getAttribute("transportType");
    String totalPrice = (String) request.getAttribute("totalPrice");
    String travelerDetailsJson = (String) request.getAttribute("travelerDetails");

    JSONArray travelers = new JSONArray(travelerDetailsJson);
%>

<html>
<head>
    <title>Booking Confirmation</title>
</head>
<body>
    <h2>Booking Confirmed!</h2>
    <p><strong>Tour ID:</strong> <%= tourId %></p>
    <p><strong>Members:</strong> <%= members %></p>
    <p><strong>Transport Type:</strong> <%= transportType %></p>
    <p><strong>Total Price:</strong> ₹<%= totalPrice %></p>

    <h3>Traveler Details</h3>
    <ul>
        <% for (int i = 0; i < travelers.length(); i++) {
            JSONObject traveler = travelers.getJSONObject(i);
        %>
        <li>
            <strong>Name:</strong> <%= traveler.getString("name") %>,
            <strong>Age:</strong> <%= traveler.getString("age") %>,
            <strong>Gender:</strong> <%= traveler.getString("gender") %>
        </li>
        <% } %>
    </ul>
</body>
</html>
