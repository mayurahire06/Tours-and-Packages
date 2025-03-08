<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Traveler Details</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="p-6 bg-gray-100">

<%
    int travelers = 1;  // Default value
    try {
       
        String travelersParam = request.getParameter("members");
        if (travelersParam != null && !travelersParam.trim().isEmpty()) {
            travelers = Integer.parseInt(travelersParam);
        }
    } catch (NumberFormatException e) {
        travelers = 1;
    }
%>

<div class="container mx-auto max-w-2xl bg-white shadow-md p-6 rounded-lg">
    <h2 class="text-2xl font-semibold mb-4">Enter Traveler Details</h2>

    <form action="processTravelers.jsp" method="post">
        <!-- CORRECTED: Get tour ID from 'id' parameter -->
        <input type="hidden" name="tourId" value="<%= request.getParameter("id") %>">
        <input type="hidden" name="travelers" value="<%= travelers %>">

        <% for (int i = 1; i <= travelers; i++) { %>
            <div class="border p-4 mb-4 rounded-md bg-gray-50">
                <h3 class="text-lg font-bold mb-2">Traveler <%= i %> Details</h3>
                <label class="block mb-2 text-sm">Full Name:</label>
                <input type="text" name="name_<%= i %>" required class="w-full p-2 border rounded-md">
                
                <label class="block mt-2 text-sm">Age:</label>
                <input type="number" name="age_<%= i %>" required min="1" class="w-full p-2 border rounded-md">
                
                <label class="block mt-2 text-sm">Gender:</label>
                <select name="gender_<%= i %>" required class="w-full p-2 border rounded-md">
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
            </div>
        <% } %>

        <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded-md hover:bg-blue-600 transition">
            Submit Details
        </button>
    </form>
</div>

</body>
</html>