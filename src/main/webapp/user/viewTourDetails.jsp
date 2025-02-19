<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.mh.DBConnection" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tour Package Details</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>

<%
    // User authentication check
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/user/loginRegister.jsp");
        return;
    }
%>

<body class="m-2 p-6">
    <div class="container max-w-[1440px] bg-white shadow-lg rounded-lg pt-4 border-2 border-gray-300">
        <h1 class="text-4xl font-serif font-bold m-2">Denali Experience Tour from Talkeetna</h1>
        <div class="flex gap-4 mr-4 h-[600px] mb-4">

<%
    // Default values
    String firstImage = request.getContextPath() + "/images/1.jpeg"; 
    List<String> images = new ArrayList<>();
    int price = 0, capacity = 0;
    String s_date = "", dest = "", formattedPrice = "";

    // Get tour ID from request
    int id = 0;
    try {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            id = Integer.parseInt(idParam);
        }
    } catch (NumberFormatException e) {
        e.printStackTrace();
    }

    // Fetch tour data
    
    String query = "SELECT t.s_date, t.price, t.dest, t.capacity, i.image_path " +
            "FROM tour t JOIN images i ON t.t_id = i.t_id WHERE t.t_id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(query)) {
        
        pstmt.setInt(1, id);
        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                // Assign tour details only once
                if (price == 0) {
                    s_date = rs.getString("s_date");
                    price = rs.getInt("price");
                    capacity = rs.getInt("capacity");
                    dest = rs.getString("dest");
                    
                    // Format price correctly
                    formattedPrice = NumberFormat.getNumberInstance(Locale.US).format(price);
                }
                
                // Collect images
                String imagePath = rs.getString("image_path");
                if (imagePath != null && !imagePath.trim().isEmpty()) {
                    imagePath = imagePath.replace("\\", "/");
                    images.add(request.getContextPath() + "/" + imagePath);
                }
            }

            // Set first image
            if (!images.isEmpty()) {
                firstImage = images.get(0);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

            <!-- Image Thumbnails -->
            <div class="w-md flex flex-col items-center pl-4 mt-4">
                <div class="overflow-y-auto flex flex-col space-y-4 pt-2 rounded-lg h-[600px] w-52 border-2 border-gray-300">
                    <% if (!images.isEmpty()) { %>
                        <% for (String img : images) { %>
                            <img src="<%= img %>" 
                                 class="h-28 w-full cursor-pointer border rounded-md object-cover hover:shadow-lg hover:border-blue-500 transition duration-300" 
                                 onclick="changeImage('<%= img %>')" />
                        <% } %>
                    <% } else { %>
                        <p class="text-gray-500 text-sm text-center mt-4">No images available.</p>
                    <% } %>
                </div>
            </div>

            <!-- Second Section: Large Image Display -->
		<div class="w-[800px] h-[600px] flex flex-col items-center border-2 border-gray-300 rounded-lg p-2 hover:shadow-lg transition duration-300">
		    <img id="mainImage" src="<%= firstImage %>" class="w-full h-full max-h-[600px] rounded-lg shadow-md object-cover" />
		</div>
            <!-- Tour Info -->
            <div class="w-[350px] flex flex-col items-center pl-2 mt-4 border-2 border-gray-300 rounded-lg p-4 hover:bg-gray-100 transition duration-300">
                <p class="text-gray-600 mb-4"><%= dest %>, USA</p>
                <div class="mb-6 w-full">
                    <p class="text-xl font-semibold">From ₹<%= formattedPrice %> per person</p>
                    <p class="underline underline-offset-1 text-sm text-gray-500">Lowest Price Guarantee</p>
                </div>
                <div class="mb-6 w-full">
                    <label for="date" class="block text-sm font-medium text-gray-700">Select Date and Travelers</label>
                    <input type="date" id="date" name="date" class="mt-1 block w-full p-2 border border-gray-300 rounded-md hover:border-blue-500 transition duration-300" value="<%= s_date %>" disabled>
                    <input type="number" id="travelers" name="travelers" class="mt-1 block w-full p-2 border border-gray-300 rounded-md hover:border-blue-500 transition duration-300" value="<%= capacity %>" min="1" max="<%= capacity %>">
                </div>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 w-full transition duration-300">Update Search</button>
                <div class="mt-4 text-sm text-gray-600">
                    <p>Free cancellation up to 24 hours before the experience starts (local time)</p>
                </div>
                <div class="mt-6">
                    <a href="#" class="text-blue-500 hover:text-blue-600 transition duration-300">See More</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function changeImage(src) {
            document.getElementById("mainImage").src = src;
        }
    </script>
</body>
</html>

