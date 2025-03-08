<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mh.DBConnection" %>
<%@ page import="java.sql.*" %>
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
    <link rel="stylesheet" href="./user/style/viewTourDetails.css">
</head>

<%
    // Authentication check
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/user/loginRegister.jsp");
        return;
    }

    // Initialize variables
    String firstImage = request.getContextPath() + "/images/1.jpeg";
    List<String> images = new ArrayList<>();
    int basePrice = 0, capacity = 0;
    String s_date = "", dest = "", transport = "";
    Map<String, Integer> transportPrices = new HashMap<>();
    List<String> transportOptions = new ArrayList<>();
    NumberFormat nf = NumberFormat.getNumberInstance(Locale.US);

    // Get tour ID from request
    int id = 0;
    try {
        String idParam = request.getParameter("id");
        id = (idParam != null && !idParam.trim().isEmpty()) ? Integer.parseInt(idParam) : 0;
    } catch (NumberFormatException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Tour ID");
        return;
    }

    try (Connection conn = DBConnection.getConnection()) {
        // Fetch main tour details
        String tourQuery = "SELECT t.s_date, t.price, t.dest, t.capacity, t.transport, i.image_path " +
                         "FROM tour t LEFT JOIN images i ON t.t_id = i.t_id WHERE t.t_id = ?";
        
        try (PreparedStatement tourStmt = conn.prepareStatement(tourQuery)) {
            tourStmt.setInt(1, id);
            ResultSet tourRs = tourStmt.executeQuery();
            
            while (tourRs.next()) {
                if (basePrice == 0) { // Only set once
                    basePrice = tourRs.getInt("price");
                    s_date = tourRs.getString("s_date");
                    capacity = tourRs.getInt("capacity");
                    dest = tourRs.getString("dest");
                    transport = tourRs.getString("transport");
                }

                // Collect images
                String imagePath = tourRs.getString("image_path");
                if (imagePath != null && !imagePath.trim().isEmpty()) {
                    images.add(request.getContextPath() + "/" + imagePath.replace("\\", "/"));
                }
            }
        }

        // Process transport options
        if (transport != null && !transport.trim().isEmpty()) {
            for (String transportType : transport.split(",")) {
                transportType = transportType.trim().toLowerCase();
                transportOptions.add(transportType);

                // Get price for each transport type
                String transportQuery = "";
                switch(transportType) {
                    case "train":
                        transportQuery = "SELECT trainTicket FROM train WHERE t_id = ?";
                        break;
                    case "bus":
                        transportQuery = "SELECT busTicket FROM bus WHERE t_id = ?";
                        break;
                    case "flight":
                        transportQuery = "SELECT flightTicket FROM flight WHERE t_id = ?";
                        break;
                }

                if (!transportQuery.isEmpty()) {
                    try (PreparedStatement transportStmt = conn.prepareStatement(transportQuery)) {
                        transportStmt.setInt(1, id);
                        ResultSet transportRs = transportStmt.executeQuery();
                        if (transportRs.next()) {
                            transportPrices.put(transportType, transportRs.getInt(1));
                        }
                    }
                }
            }
        }

        // Set first image
        if (!images.isEmpty()) {
            firstImage = images.get(0);
        }

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error");
        return;
    }

    String formattedBasePrice = nf.format(basePrice);
%>

<body class="m-2 p-6">
    <div class="container max-w-[1440px] bg-white shadow-lg rounded-lg pt-4 border-2 border-gray-300">
        <h1 class="text-4xl font-serif font-bold m-2">Denali Experience Tour from Talkeetna</h1>
        <div class="flex gap-4 mr-4 h-[600px] mb-4">

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

            <!-- Main Image Display -->
            <div class="w-[800px] h-[600px] flex flex-col items-center border-2 border-gray-300 rounded-lg p-2 hover:shadow-lg transition duration-300">
                <img id="mainImage" src="<%= firstImage %>" class="w-full h-full max-h-[600px] rounded-lg shadow-md object-cover" />
            </div>

            <!-- Tour Information Section -->
            <div class="w-[350px] flex flex-col items-center pl-2 mt-4 border-2 border-gray-300 rounded-lg p-4 hover:bg-gray-100 transition duration-300">
                <p class="text-gray-600 mb-4"><%= dest %>, USA</p>
                
                <div class="mb-6 w-full">
                    <p class="text-xl font-semibold">Base Price: ₹<span id="basePrice"><%= formattedBasePrice %></span></p>
                    <p class="underline underline-offset-1 text-sm text-gray-500">Lowest Price Guarantee</p>
                </div>

                <div class="mb-6 w-full">
                    <label for="date" class="block text-sm font-medium text-gray-700">Tour Date</label>
                    <input type="date" id="date" name="date" class="mt-1 block w-full p-2 border border-gray-300 rounded-md hover:border-blue-500 transition duration-300" 
                           value="<%= s_date %>" disabled>
                </div>

                <div class="mb-6 w-full">
                    <label class="block text-sm font-medium text-gray-700">Travelers</label>
                    <div class="mt-2 flex items-center justify-between border border-gray-300 rounded-md">
                        <button type="button" onclick="adjustTravelers(-1)" class="px-3 py-2 bg-gray-300 text-gray-700 rounded-l-md hover:bg-red-500 transition-colors">
                            -
                        </button>
                        <input type="number" id="travelers" name="members" 
                               class="w-full text-center p-2 focus:outline-none" 
                               value="1" min="1" max="<%= capacity %>" readonly>
                        <button type="button" onclick="adjustTravelers(1)" class="px-3 py-2 bg-gray-300 text-gray-700 rounded-r-md hover:bg-yellow-600 transition-colors">
                            +
                        </button>
                    </div>
                </div>


                <!-- In the Transportation Options section -->
				<div class="mb-6 w-full">
				    <p class="text-lg font-semibold mb-2">Transportation Options</p>
				    <select id="transportSelect" onchange="updateTotalPrice()" class="border rounded px-3 py-2 text-sm text-gray-600 w-full">
				        <!-- Default placeholder with proper attributes -->
				        <option value="none" data-price="0" selected>Select Transportation</option>
				        
				        <% for (String transport1 : transportOptions) { 
				            Integer price = transportPrices.get(transport1);
				            String displayName = transport1.substring(0, 1).toUpperCase() + transport1.substring(1);
				            String displayPrice = (price != null && price > 0) ? nf.format(price) : null;
				        %>
				            <option value="<%= transport1 %>" data-price="<%= price != null ? price : 0 %>">
				                <% if(displayPrice != null) { %>
				                    <%= displayName %> (+₹<%= displayPrice %>)
				                <% } else { %>
				                    <%= displayName %>
				                <% } %>
				            </option>
				        <% } %>
				    </select>
				</div>
			

				<!-- Single-line price breakdown -->
				<div class="text-sm text-gray-600 mt-2" id="priceNote">
				    <div class="flex gap-2">
				        <span>Base Price: ₹<%= formattedBasePrice %></span>
				        <span class="hidden" id="transportPriceNote">+ Transportation: ₹<span id="transportPrice">0</span></span>
				    </div>
				</div>

                <div class="mb-6 w-full mt-2">
                    <p class="text-xl font-semibold">Total Price: ₹<span id="totalPrice"><%= formattedBasePrice %></span></p>
                </div>

                <button class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 w-full transition duration-300">
                    Add Details
                </button>

                <div class="mt-4 text-sm text-gray-600">
                    <p>Free cancellation up to 24 hours before experience start</p>
                </div>
            </div>
        </div>
    </div>
	
	    
    <%-- First get category ID of current tour --%>
<%
int currentTourId = Integer.parseInt(request.getParameter("id"));
int currentCatId = 0;
String currentCatName = "";
ResultSet rs=null;
// Get category information from joined tables
String categoryQuery = "SELECT c.cat_id, c.cat_name " +
                       "FROM tour t " +
                       "JOIN category c ON t.cat_id = c.cat_id " +
                       "WHERE t.t_id = ?";

try (Connection conn = DBConnection.getConnection();
     PreparedStatement pstmt = conn.prepareStatement(categoryQuery)) {
    
    pstmt.setInt(1, currentTourId);
    try {
    	rs = pstmt.executeQuery();
        if (rs.next()) {
            currentCatId = rs.getInt("cat_id");
            currentCatName = rs.getString("cat_name");
        }
    }finally{
    	rs.close();
    	pstmt.close();
    }
} catch (SQLException e) {
    e.printStackTrace(); 
}finally{
	rs.close();
}
%>

<%-- Get related tours with first image --%>
<%
String relatedToursQuery = "SELECT t.t_id, t.title, t.dest, t.price, t.duration, " +
                           "(SELECT i.image_path FROM images i WHERE i.t_id = t.t_id LIMIT 1) AS main_image " +
                           "FROM tour t " +
                           "WHERE t.cat_id = ? AND t.t_id != ? " +
                           "ORDER BY t.s_date DESC " +
                           "LIMIT 4";

List<Map<String, Object>> relatedTours = new ArrayList<>();

try (Connection conn = DBConnection.getConnection();
     PreparedStatement pstmt = conn.prepareStatement(relatedToursQuery)) {
    
    pstmt.setInt(1, currentCatId);
    pstmt.setInt(2, currentTourId);
    
    rs=null;
    try{
    	rs = pstmt.executeQuery();
        while (rs.next()) {
            Map<String, Object> tour = new HashMap<>();
            tour.put("t_id", rs.getInt("t_id"));
            tour.put("title", rs.getString("title"));
            tour.put("dest", rs.getString("dest"));
            tour.put("price", rs.getInt("price"));
            tour.put("duration", rs.getString("duration"));
            
            String imagePath = rs.getString("main_image");
            if (imagePath != null) {
                imagePath = request.getContextPath() + "/" + imagePath.replace("\\", "/");
            } else {
                imagePath = request.getContextPath() + "/images/default-tour.jpg";
            }
            tour.put("image", imagePath);
            
            relatedTours.add(tour);
        }
    }finally{
    	rs.close();
    }
} catch (SQLException e) {
    e.printStackTrace();
}
%>

<!-- Display Section -->
<div class="related-tours mt-12">
    <h3 class="text-2xl font-bold mb-6">More <%= currentCatName %> Packages</h3>
    
    <% if (!relatedTours.isEmpty()) { %>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <% for (Map<String, Object> tour : relatedTours) { %>
                <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition-shadow duration-300">
                    <img src="<%= tour.get("image") %>" 
                         alt="<%= tour.get("title") %>" 
                         class="w-full h-48 object-cover">
                    
                    <div class="p-4">
                        <h4 class="text-lg font-semibold mb-2"><%= tour.get("title") %></h4>
                        <div class="flex items-center text-sm text-gray-600 mb-2">
                            <span class="mr-2">📍 <%= tour.get("dest") %></span>
                            <span>⏳ <%= tour.get("duration") %></span>
                        </div>
                        <div class="flex justify-between items-center">
                        	<div>
                        	<span>from</span>
                            <span class="text-lg font-bold text-blue-600">
                                ₹<%= NumberFormat.getNumberInstance(Locale.US).format(tour.get("price")) %>
                            </span>
                            </div>
                            <a href="viewTourDetails.jsp?id=<%= tour.get("t_id") %>" 
                               class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition">
                                View
                            </a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="text-center py-8 bg-gray-50 rounded-lg">
            <p class="text-gray-500">No other packages found in <%= currentCatName %> category</p>
        </div>
    <% } %>
</div>
        
        
    <script>
    <!-- In the JavaScript section -->
        function updateTotalPrice() {
            const transportSelect = document.getElementById('transportSelect');
            const selectedOption = transportSelect.options[transportSelect.selectedIndex];
            const transportPrice = parseInt(selectedOption.dataset.price) || 0;
            const basePrice = <%= basePrice %>;
            const travelers = parseInt(document.getElementById('travelers').value);
            
            // Calculate total price
            const totalPrice = (basePrice + transportPrice) * travelers;
            
            // Update display
            document.getElementById('totalPrice').textContent = 
                new Intl.NumberFormat('en-IN').format(totalPrice);
            
            // Show/hide transport price
            const priceNote = document.getElementById('transportPriceNote');
            if (selectedOption.value === 'none') {
                priceNote.classList.add('hidden');
            } else {
                priceNote.classList.remove('hidden');
                document.getElementById('transportPrice').textContent = 
                    new Intl.NumberFormat('en-IN').format(transportPrice);
            }
        }

        function adjustTravelers(change) {
            const input = document.getElementById('travelers');
            let value = parseInt(input.value) + change;
            value = Math.max(parseInt(input.min), Math.min(value, parseInt(input.max)));
            input.value = value;
            updateTotalPrice();
        }

        function changeImage(newSrc) {
            document.getElementById('mainImage').src = newSrc;
        }

        // Initialize price calculation
        updateTotalPrice();
    </script>
    
    
</body>
</html>