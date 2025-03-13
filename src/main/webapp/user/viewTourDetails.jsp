<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mh.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tour Package Details</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./style/viewTourDetails.css">
        
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
    int basePrice = 0, capacity = 0, disPrice=0;
    String s_date = "", dest = "", transport = "", title = "", description="", hotel="", location="";
    Map<String, Integer> transportPrices = new HashMap<>();
    List<String> transportOptions = new ArrayList<>();
    NumberFormat nf = NumberFormat.getNumberInstance(Locale.US);
    String itineraryContent = "";
    String fileName = "";

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
        String tourQuery = "SELECT t.s_date, t.price, t.descr, t.pdprice, t.dest, t.capacity, t.transport, t.title, i.image_path, t.itinerary " +
                         "FROM tour t LEFT JOIN images i ON t.t_id = i.t_id WHERE t.t_id = ?";
        
        try (PreparedStatement tourStmt = conn.prepareStatement(tourQuery)) {
            tourStmt.setInt(1, id);
            ResultSet tourRs = tourStmt.executeQuery();
            
            while (tourRs.next()) {
                if (basePrice == 0) { // Only set once
                    basePrice = tourRs.getInt("price");
                	disPrice = tourRs.getInt("pdprice");
                    s_date = tourRs.getString("s_date");
                    capacity = tourRs.getInt("capacity");
                    dest = tourRs.getString("dest");
                    transport = tourRs.getString("transport");
                    title = tourRs.getString("title");
                    description = tourRs.getString("descr");
                    if (title == null || title.isEmpty()) {
                        title = "Denali Experience Tour from Talkeetna"; // Default title if not available
                    }
                }

                // Collect images
                String imagePath = tourRs.getString("image_path");
                if (imagePath != null && !imagePath.trim().isEmpty()) {
                    images.add(request.getContextPath() + "/" + imagePath.replace("\\", "/"));
                }
            }
            
            // Fetch hotel details
            String hotelQuery = "SELECT hotel_name, area FROM hotel WHERE t_id = ?";
            try (PreparedStatement hotelStmt = conn.prepareStatement(hotelQuery)) {
                hotelStmt.setInt(1, id);
                try (ResultSet hotelRs = hotelStmt.executeQuery()) {
                    if (hotelRs.next()) {
                        hotel = hotelRs.getString("hotel_name") != null ? hotelRs.getString("hotel_name") : hotel;
                        location = hotelRs.getString("area") != null ? hotelRs.getString("area") : location;
                    }
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
                            //HttpSession transportSession = request.getSession(false);
                            userSession.setAttribute("transportationPrice", transportRs.getInt(1));
                        }
                    }
                }
            }
        }

        // Set first image
        if (!images.isEmpty()) {
            firstImage = images.get(0);
        }
        
        // Get itinerary content
        String itineraryQuery = "SELECT itinerary FROM tour WHERE t_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(itineraryQuery)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String filePath = rs.getString("itinerary");
                
                // Extract only the filename
                if (filePath != null && !filePath.trim().isEmpty()) {
                    // Handle both forward and backslashes
                    String normalizedPath = filePath.replace("\\", "/");
                    fileName = normalizedPath.substring(normalizedPath.lastIndexOf("/") + 1);
                    //System.out.println("filename:" +fileName);
                    if (Files.exists(Paths.get(filePath))) {
                        itineraryContent = new String(Files.readAllBytes(Paths.get(filePath)));
                    } else {
                        itineraryContent = "File not found: " + fileName;
                    }
                } else {
                    itineraryContent = "No itinerary available for this tour.";
                }
            }
        } catch (Exception e) {
            itineraryContent = "Unable to load itinerary at this time.";
            e.printStackTrace();
        }

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error");
        return;
    }

    String formattedBasePrice = nf.format(basePrice);
    String formattedDisPrice = nf.format(disPrice);
    userSession.setAttribute("basePrice", formattedDisPrice);
%>

<body class="py-8">
    <div class="container-custom">
        <!-- Main Tour Card -->
        <div class="card mb-10">
            <!-- Tour Title -->
            <div class="p-6 border-b border-gray-200">
                <h1 class="text-3xl md:text-4xl font-bold text-gray-800"><%= title %></h1>
                <p class="text-gray-600 mt-2 flex items-center">
                    <span class="inline-block mr-2">📍</span> <%= dest %>
                </p>
            </div>

            <!-- Main Content Area with Fixed Heights -->
            <div class="flex flex-col md:flex-row p-6 gap-6">
                <!-- Image Thumbnails - Fixed Width -->
                <div class="thumbnails-container border border-gray-200 rounded-lg p-2 bg-gray-50">
                    <div class="grid gap-3">
                        <% if (!images.isEmpty()) { %>
                            <% for (String img : images) { %>
                                <div class="cursor-pointer transition-all duration-300" onclick="changeImage('<%= img %>')" id="thumb-<%= images.indexOf(img) %>">
                                    <img src="<%= img %>" 
                                         alt="Tour image <%= images.indexOf(img) + 1 %>" 
                                         class="h-28 w-full object-cover">
                                </div>
                            <% } %>
                        <% } else { %>
                            <p class="text-gray-500 text-sm text-center mt-4">No images available.</p>
                        <% } %>
                    </div>
                </div>

                <!-- Main Image - Fixed Width and Height -->
                <div class="main-image-container border border-gray-200 rounded-lg overflow-hidden bg-gray-50">
                    <img id="mainImage" src="<%= firstImage %>" alt="Selected tour view" class="w-full h-full object-cover">
                </div>

                <!-- Tour Information - Fixed Width -->
                <div class="info-container border border-gray-200 rounded-lg p-6 bg-gray-50">
                    <div class="space-y-6">
                        <!-- Price Section -->
                        <div>
                            <p class="text-2xl font-bold text-gray-800"><del><span class="m-2">₹<%= formattedBasePrice %></span></del>₹<span id="basePrice"><%= formattedDisPrice %></span></p>
            
                            <p class="text-sm text-[#e05d37] underline">Lowest Price Guarantee </p>
                        </div>

                        <!-- Date Section -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Tour Date</label>
                            <input type="date" id="date" name="date" 
                                   class="w-full p-2 bg-white border border-gray-300 rounded-md text-gray-500" 
                                   value="<%= s_date %>" disabled>
                        </div>

                        <!-- Travelers Section -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Travelers</label>
                            <div class="flex items-center justify-between border border-gray-300 rounded-md p-3 bg-white">
                                <span class="text-gray-700" id="travelerDisplay">1 traveler</span>
                                <button type="button" onclick="showTravelerModal()" 
                                        class="text-[#e05d37] hover:text-[#d04d27] text-sm font-medium">
                                    Change
                                </button>
                            </div>
                            <input type="hidden" id="travelers" name="members" value="1">
                        </div>

                        <!-- Transportation Options -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Transportation</label>
                            <select id="transportSelect" onchange="updateTotalPrice()" 
                                    class="w-full p-2 border border-gray-300 rounded-md bg-white">
                                <option value="none" data-price="0" selected>Select Transportation</option>
                                <% for (String transportType : transportOptions) { 
                                    Integer price = transportPrices.get(transportType);
                                    String displayName = transportType.substring(0, 1).toUpperCase() + transportType.substring(1);
                                    String displayPrice = (price != null && price > 0) ? nf.format(price) : null;
                                %>
                                    <option value="<%= transportType %>" data-price="<%= price != null ? price : 0 %>">
                                        <% if(displayPrice != null) { %>
                                            <%= displayName %> (+₹<%= displayPrice %>)
                                        <% } else { %>
                                            <%= displayName %>
                                        <% } %>
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Price Breakdown -->
                        <div class="text-sm text-gray-600 border-t border-gray-200 pt-4">
                            <div class="flex justify-between mb-1">
                                <span>Base Price:</span>
                                <span>₹<%= formattedDisPrice %></span>
                            </div>
                            
                            <div id="transportPriceNote" class="flex justify-between mb-1 hidden">
                                <span>Transportation:</span>
                                <span>₹<span id="transportPrice">0</span></span>
                            </div>
                            
                            <div id="travelerMultiplier" class="flex justify-between mb-1 hidden">
                                <span>Travelers:</span>
                                <span>× <span id="travelerCount">1</span></span>
                            </div>
                            
                            <div class="flex justify-between font-bold text-lg mt-2 pt-2 border-t border-gray-200">
                                <span>Total:</span>
                                <span>₹<span id="totalPrice"><%= formattedDisPrice %></span></span>
                            </div>
                        </div>

                        <!-- Book Button -->
                        <button type="button" onclick="showTravelerDetailsModal()" id="addDetailsButton"
                                class="w-full py-3 primary-btn rounded-md font-medium">
                            Add Details
                        </button>

                        <!-- Cancellation Policy -->
                        <p class="text-sm text-gray-600">
                            Free cancellation up to 24 hours before experience start
                        </p>
                    </div>
                </div>
            </div>
            <div class="p-6">
                <p class="text-gray-700">Description: <%= description %></p>
                <p class="text-gray-700">Hotel: <%= hotel %></p>
                <p class="text-gray-700">Location: <%= location %></p>
            </div>
        </div>

        <!-- Itinerary Section - Enhanced -->
        <div class="card mb-10">
            <div class="p-6 border-b border-gray-200 bg-gray-50 flex justify-between items-center">
                <h2 class="text-2xl font-bold text-gray-800">Tour Itinerary</h2>
                
                <div class="flex items-center space-x-4">
                    <% if (fileName != null && !fileName.isEmpty()) { %>
                        <!-- Download Button -->
                        <a href="../DownloadServlet?filename=<%= java.net.URLEncoder.encode(fileName, "UTF-8") %>" 
                           class="inline-flex items-center px-4 py-2 bg-[#e05d37]/10 text-[#e05d37] rounded-md hover:bg-[#e05d37]/20 transition-colors">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                            </svg>
                            Download Itinerary
                        </a>
                    <% } %>
                    
                    <!-- Show/Hide Itinerary Button -->
                    <button id="toggleItinerary" class="inline-flex items-center px-4 py-2 bg-blue-50 text-blue-600 rounded-md hover:bg-blue-100 transition-colors">
                        <span>Show Itinerary</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2 itinerary-toggle" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    </button>
                </div>
            </div>
            
            <div class="p-6">
                <!-- Itinerary Content - Initially Hidden -->
                <div id="itineraryContent" class="itinerary-container hidden">
                    <% 
                    if (itineraryContent != null && !itineraryContent.isEmpty()) {
                        String[] days = itineraryContent.split("\n\n");
                        for (String day : days) {
                            if (day.trim().isEmpty()) continue;
                            
                            String[] lines = day.split("\n");
                            if (lines.length > 0) {
                                String dayTitle = lines[0].trim();
                    %>
					<div class="itinerary-day mb-10">
					    <h3 class="text-xl font-bold text-blue-600 mb-3 border-b border-blue-100 pb-2">
					        <%= dayTitle %>
					    </h3>
					    <div class="space-y-3 pl-4">
					        <% 
					        for (int i = 1; i < lines.length; i++) {
					            String activity = lines[i].trim();
					            if (!activity.isEmpty()) {
					                // Check for special pattern to highlight
					                boolean isHighlight = activity.startsWith("**");
					                if (isHighlight) {
					                    activity = activity.substring(2).trim();
					                }
					        %>
					                <div class="activity-item flex items-start <%= isHighlight ? "font-semibold text-gray-800" : "text-gray-600" %>">
					                    <% if (!isHighlight) { %>
					                        <div class="w-2 h-2 bg-blue-400 rounded-full mt-2 mr-3"></div>
					                    <% } %>
					                    <% if (isHighlight) { %>
					                        <span class="highlight bg-yellow-100 px-2 py-1 rounded">
					                            <%= activity %>
					                        </span>
					                    <% } else { %>
					                        <%= activity.replaceFirst("^-\\s*", "") %>
					                    <% } %>
					                </div>
					        <% 
					            }
					        }
					        %>
					    </div>
					</div>
					<%
					        }
					    }
					} else { 
					%>
					    <p class="text-gray-500">No itinerary information available for this tour.</p>
					<% } %>
                </div>
            </div>
        </div>

        <%-- Get related tours --%>
        <%
        int currentTourId = Integer.parseInt(request.getParameter("id"));
        int currentCatId = 0;
        String currentCatName = "";
        ResultSet rs = null;
        
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
            } finally {
                if (rs != null) rs.close();
                pstmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        }

        // Get related tours with first image
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
            
            rs = null;
            try {
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
            } finally {
                if (rs != null) rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        %>

        <!-- Related Tours Section -->
        <div class="card">
            <div class="p-6 border-b border-gray-200 bg-gray-50">
                <h2 class="text-2xl font-bold text-gray-800">More <%= currentCatName %> Packages</h2>
            </div>
            
            <div class="p-6">
                <% if (!relatedTours.isEmpty()) { %>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <% for (Map<String, Object> tour : relatedTours) { %>
                            <div class="bg-white border border-gray-200 rounded-lg overflow-hidden shadow-sm hover:shadow-md transition-shadow">
                                <img src="<%= tour.get("image") %>" 
                                     alt="<%= tour.get("title") %>" 
                                     class="w-full h-48 object-cover">
                                <div class="p-4">
                                    <h3 class="font-semibold text-gray-800 mb-1"><%= tour.get("title") %></h3>
                                    <div class="flex items-center text-sm text-gray-600 mb-2">
                                        <span class="mr-3">📍 <%= tour.get("dest") %></span>
                                        <span>⏳ <%= tour.get("duration") %></span>
                                    </div>
                                    <div class="flex justify-between items-center mt-3">
                                        <div>
                                            <span class="text-xs text-gray-500">from</span>
                                            <p class="text-[#e05d37] font-bold">₹<%= NumberFormat.getNumberInstance(Locale.US).format(tour.get("price")) %></p>
                                        </div>
                                        <a href="viewTourDetails.jsp?id=<%= tour.get("t_id") %>" 
                                           class="px-3 py-1 primary-btn text-white text-sm rounded hover:bg-[#d04d27] transition-colors">
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
        </div>
    </div>

    <!-- Traveler Selection Modal -->
    <div id="travelerModal" class="modal">
        <div class="modal-content ">
            <h3 class="text-xl font-bold mb-4 text-center">Select Number of Travelers</h3>
            
            <div class="flex items-center justify-center gap-6 my-6">
                <button onclick="adjustModalTravelers(-1)"
                        class="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center text-xl font-bold hover:bg-gray-300">
                    -
                </button>
                <input type="number" id="modalTravelers" min="1" max="<%= capacity %>" 
                       class="w-16 text-center border rounded-md text-2xl font-bold p-1" value="1" readonly>
                <button onclick="adjustModalTravelers(1)"
                        class="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center text-xl font-bold hover:bg-gray-300">
                    +
                </button>
            </div>
            
            <p class="text-sm text-gray-500 text-center mb-6">
                Maximum <%= capacity %> travelers allowed
            </p>
            
            <div class="flex justify-end gap-3">
                <button onclick="closeTravelerModal()"
                        class="px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50">
                    Cancel
                </button>
                <button onclick="confirmTravelers()"
                        class="px-4 py-2 primary-btn text-white rounded-md">
                    Confirm
                </button>
            </div>
        </div>
    </div>

    <!-- Traveler Details Modal -->
    <div id="travelerDetailsModal" class="modal">
        <div class="modal-content  max-h-[90vh] overflow-y-auto">
            <h3 class="text-xl font-bold mb-4 text-center">Traveler Details</h3>
            
            <div id="travelerFields" class="space-y-4 mb-6">
                <!-- Will be populated dynamically -->
            </div>
            
            <div class="flex justify-end gap-3">
                <button onclick="closeTravelerDetailsModal()"
                        class="px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50">
                    Cancel
                </button>
                <button onclick="submitTravelerDetails()"
                        class="px-4 py-2 primary-btn text-white rounded-md">
                    Submit Details
                </button>
            </div>
        </div>
    </div>

    <!-- Hidden form for submission -->
    <form id="bookingForm" method="post" action="../BookingServlet" class="hidden" target="_blanck">
        <input type="hidden" name="tourId" value="<%= id %>">
        <input type="hidden" name="members" id="formMembers">
        <input type="hidden" name="transportType" id="formTransportType">
        <input type="hidden" name="totalPrice" id="formTotalPrice">
        <input type="hidden" name="travelerDetails" id="formTravelerDetails">
    </form>

    <script>
        // Function to update the total price
        function updateTotalPrice() {
            const transportSelect = document.getElementById('transportSelect');
            const selectedOption = transportSelect.options[transportSelect.selectedIndex];
            const transportPrice = parseInt(selectedOption.dataset.price) || 0;
            const disPrice = <%= disPrice %>;
            const travelers = parseInt(document.getElementById('travelers').value);
            
            // Calculate total price
            const totalPrice = (disPrice + transportPrice) * travelers;
            
            // Update display
            document.getElementById('totalPrice').textContent = 
                new Intl.NumberFormat('en-IN').format(totalPrice);
            
            // Show/hide transport price
            const transportPriceNote = document.getElementById('transportPriceNote');
            if (selectedOption.value === 'none') {
                transportPriceNote.classList.add('hidden');
            } else {
                transportPriceNote.classList.remove('hidden');
                document.getElementById('transportPrice').textContent = 
                    new Intl.NumberFormat('en-IN').format(transportPrice);
            }
            
            // Show/hide traveler multiplier
            const travelerMultiplier = document.getElementById('travelerMultiplier');
            if (travelers > 1) {
                travelerMultiplier.classList.remove('hidden');
                document.getElementById('travelerCount').textContent = travelers;
            } else {
                travelerMultiplier.classList.add('hidden');
            }
        }

        // Function to change the main image
        function changeImage(newSrc) {
            document.getElementById('mainImage').src = newSrc;
            
            // Update active thumbnail styling
            const thumbnails = document.querySelectorAll('[id^="thumb-"]');
            thumbnails.forEach(thumb => {
                thumb.classList.remove('thumbnail-active');
            });
            
            // Find the thumbnail that matches this image and highlight it
            <% if (!images.isEmpty()) { %>
                <% for (int i = 0; i < images.size(); i++) { %>
                    if ('<%= images.get(i) %>' === newSrc) {
                        document.getElementById('thumb-<%= i %>').classList.add('thumbnail-active');
                    }
                <% } %>
            <% } %>
        }

        // Traveler modal functions
        function showTravelerModal() {
            const modal = document.getElementById('travelerModal');
            modal.classList.add('visible');
            document.getElementById('modalTravelers').value = document.getElementById('travelers').value;
        }

        function closeTravelerModal() {
            document.getElementById('travelerModal').classList.remove('visible');
        }

        function adjustModalTravelers(change) {
            const input = document.getElementById('modalTravelers');
            let value = parseInt(input.value) + change;
            value = Math.max(1, Math.min(value, <%= capacity %>));
            input.value = value;
        }

        function confirmTravelers() {
            const newValue = document.getElementById('modalTravelers').value;
            document.getElementById('travelers').value = newValue;
            document.getElementById('travelerDisplay').textContent = 
                newValue + (newValue === "1" ? " traveler" : " travelers");
            
            updateTotalPrice();
            closeTravelerModal();
        }

        // Traveler details functions
        function addDetails() {
            showTravelerDetailsModal();
        }

        function showTravelerDetailsModal() {
            const modal = document.getElementById('travelerDetailsModal');
            const travelerFields = document.getElementById('travelerFields');
            travelerFields.innerHTML = '';
            
            const travelerCount = parseInt(document.getElementById('travelers').value);
            
            for(let i = 1; i <= travelerCount; i++) {
                travelerFields.innerHTML += `<div class="traveler-group bg-gray-50 p-4 rounded-lg">
                        <h4 class="text-lg font-semibold mb-3">Traveler ${i} </h4>
                        <div class="space-y-3">
                            <input type="text" required 
                                   class="w-full p-2 border rounded-md traveler-name" 
                                   placeholder="Full Name">
                            <input type="number" required min="1" max="100"
                                   class="w-full p-2 border rounded-md traveler-age" 
                                   placeholder="Age">
                            <select class="w-full p-2 border rounded-md traveler-gender">
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                                <option value="other">Other</option>
                                <option value="prefer-not-to-say">Prefer not to say</option>
                            </select>
                        </div>
                    </div>`;
            }
            
            modal.classList.add('visible');
        }

        function closeTravelerDetailsModal() {
            document.getElementById('travelerDetailsModal').classList.remove('visible');
        }

        function submitTravelerDetails() {
            const travelers = [];
            const names = document.querySelectorAll('.traveler-name');
            const ages = document.querySelectorAll('.traveler-age');
            const genders = document.querySelectorAll('.traveler-gender');

            // Validate all fields
            for(let i = 0; i < names.length; i++) {
                if(!names[i].value || !ages[i].value || !genders[i].value) {
                    alert('Please fill all fields for Traveler ' + (i+1));
                    return;
                }
                if(ages[i].value < 1 || ages[i].value > 120) {
                    alert('Please enter a valid age (1-120) for Traveler ' + (i+1));
                    return;
                }
                
                travelers.push({
                    name: names[i].value,
                    age: ages[i].value,
                    gender: genders[i].value
                });
            }

            // Set form values
            document.getElementById('formMembers').value = document.getElementById('travelers').value;
            document.getElementById('formTransportType').value = document.getElementById('transportSelect').value;
            document.getElementById('formTotalPrice').value = document.getElementById('totalPrice').textContent.replace(/,/g, '');
            document.getElementById('formTravelerDetails').value = JSON.stringify(travelers);

            // Submit the form
            document.getElementById('bookingForm').submit();
        }
        
        // Toggle itinerary visibility
        function toggleItinerary() {
            const itineraryContent = document.getElementById('itineraryContent');
            const toggleButton = document.getElementById('toggleItinerary');
            const toggleIcon = toggleButton.querySelector('.itinerary-toggle');
            
            if (itineraryContent.classList.contains('hidden')) {
                // Show itinerary
                itineraryContent.classList.remove('hidden');
                toggleButton.querySelector('span').textContent = 'Hide Itinerary';
                toggleIcon.classList.add('open');
            } else {
                // Hide itinerary
                itineraryContent.classList.add('hidden');
                toggleButton.querySelector('span').textContent = 'Show Itinerary';
                toggleIcon.classList.remove('open');
            }
        }
        
        // Initialize the page
        document.addEventListener('DOMContentLoaded', function() {
            // Set the first thumbnail as active
            if (document.getElementById('thumb-0')) {
                document.getElementById('thumb-0').classList.add('thumbnail-active');
            }
            
            // Initialize price calculation
            updateTotalPrice();
            
            // Add event listener for itinerary toggle
            document.getElementById('toggleItinerary').addEventListener('click', toggleItinerary);
        });
    </script>
</body>
</html>

