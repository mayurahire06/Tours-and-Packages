<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mh.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%-- Add this at the top of your JSP --%>
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
        String tourQuery = "SELECT t.s_date, t.price, t.dest, t.capacity, t.transport, i.image_path, t.itinerary " +
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
                
                String itinararyPath = tourRs.getString("itinerary");
                if (itinararyPath != null && !itinararyPath.trim().isEmpty()) {
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
            
                <!-- Update your travelers input section to show selected count -->
				<div class="mb-6 w-full">
				    <label class="block text-sm font-medium text-gray-700">Travelers</label>
				    <div class="mt-2 flex items-center justify-between border border-gray-300 rounded-md p-3">
				        <span class="text-gray-700" id="travelerDisplay">1 traveler</span>
				        <button type="button" onclick="showModal()" 
				                class="text-blue-500 hover:text-blue-700 text-sm font-medium">
				            Change
				        </button>
				    </div>
				    <input type="hidden" id="travelers" name="members" value="1">
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
                
                <input type="hidden" name="id" value="<%= id %>" >
                
				<button type="button" onclick="addDetails()" id="addDetailsButton"
				        class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 w-full transition duration-300">
				    Add Details
				</button>
				
			
                <div class="mt-4 text-sm text-gray-600">
                    <p>Free cancellation up to 24 hours before experience start</p>
                </div>
            </div>
           
        </div>
    </div>
    

<!-- Add this where you want the itinerary to appear -->
<div class="itinerary-section mt-8 p-6 bg-gray-50 rounded-lg border border-gray-200">
    <h2 class="text-2xl font-bold mb-4">Tour Itinerary</h2>
    <div class="itinerary-content bg-white p-4 rounded-md">
        <% 
        String itineraryContent = "";
        String filePath = "";
        String fileName = "";
        try (Connection conn = DBConnection.getConnection()) {
            String itineraryQuery = "SELECT itinerary FROM tour WHERE t_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(itineraryQuery)) {
                pstmt.setInt(1, id);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    filePath = rs.getString("itinerary");
                    
                    // Extract only the filename
                    if (filePath != null && !filePath.trim().isEmpty()) {
                        // Handle both forward and backslashes
                        String normalizedPath = filePath.replace("\\", "/");
                        fileName = normalizedPath.substring(normalizedPath.lastIndexOf("/") + 1);
                    }
                }
            }
            
            if (fileName != null && !fileName.isEmpty()) {
                if (Files.exists(Paths.get(filePath))) {
        %>
                    <a href="../DownloadServlet?filename=<%= java.net.URLEncoder.encode(fileName, "UTF-8") %>" 
                       class="inline-block mb-4 text-blue-600 hover:text-blue-800">
                       <i class="fas fa-download mr-2"></i>Download <%= fileName %>
                    </a>
        <%
                    itineraryContent = new String(Files.readAllBytes(Paths.get(filePath)));
                } else {
                    itineraryContent = "File not found: " + fileName;
                }
            } else {
                itineraryContent = "No itinerary available for this tour.";
            }
        } catch (Exception e) {
            itineraryContent = "Unable to load itinerary at this time.";
            e.printStackTrace();
        }
        %>
        <pre class="whitespace-pre-wrap font-sans"><%= itineraryContent %></pre>
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
        
        
        
        <!-- Add this modal HTML before the closing </body> tag -->
<div id="travelerModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3 text-center">
            <h3 class="text-lg leading-6 font-medium text-gray-900">Select Number of Travelers</h3>
            <div class="mt-2 px-7 py-3">
                <div class="flex items-center justify-center gap-4">
                    <button type="button" onclick="adjustModalTravelers(-1)" 
                            class="px-4 py-2 bg-gray-200 rounded-full hover:bg-gray-300 transition-colors">
                        -
                    </button>
                    <input type="number" id="modalTravelers" min="1" max="<%= capacity %>" 
                           class="w-20 text-center border rounded-md text-lg" value="1" readonly>
                    <button type="button" onclick="adjustModalTravelers(1)" 
                            class="px-4 py-2 bg-gray-200 rounded-full hover:bg-gray-300 transition-colors">
                        +
                    </button>
                </div>
                <p class="text-sm text-gray-500 mt-2">Maximum <%= capacity %> travelers allowed</p>
            </div>
            <div class="items-center px-4 py-3">
                <button onclick="confirmTravelers()" 
                        class="px-6 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition-colors">
                    Confirm
                </button>
                <button onclick="closeModal()" 
                        class="ml-3 px-6 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition-colors">
                    Cancel
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Add this modal for traveler details -->
<div id="travelerDetailsModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
    <div class="relative top-20 mx-auto p-5 border w-full max-w-lg shadow-lg rounded-md bg-white">
        <div class="mt-3 text-center">
            <h3 class="text-2xl leading-6 font-medium text-gray-900 mb-4">Traveler Details</h3>
            <div class="mt-2 px-7 py-3">
                <div id="travelerFields" class="space-y-6"></div>
            </div>
            <div class="items-center px-4 py-3">
                <button onclick="submitTravelerDetails()" 
                        class="px-6 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition-colors">
                    Submit Details
                </button>
                <button onclick="closeTravelerDetailsModal()" 
                        class="ml-3 px-6 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition-colors">
                    Cancel
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Add hidden form for submission -->
<form id="bookingForm" method="post" action="BookingServlet" class="hidden">
    <input type="hidden" name="tourId" value="<%= id %>">
    <input type="hidden" name="members" id="formMembers">
    <input type="hidden" name="transportType" id="formTransportType">
    <input type="hidden" name="totalPrice" id="formTotalPrice">
    <input type="hidden" name="travelerDetails" id="formTravelerDetails">
</form>

        
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
    
    <script>
// Add these functions to your existing script
function showModal() {
    document.getElementById('travelerModal').classList.remove('hidden');
    document.getElementById('modalTravelers').value = document.getElementById('travelers').value;
}

function closeModal() {
    document.getElementById('travelerModal').classList.add('hidden');
}

function adjustModalTravelers(change) {
    const input = document.getElementById('modalTravelers');
    let value = parseInt(input.value) + change;
    value = Math.max(1, Math.min(value, <%= capacity %>));
    input.value = value;
}

function confirmTravelers() {
    const newValue = document.getElementById('modalTravelers').value;
    console.log(newValue);
    document.getElementById('travelers').value = newValue;
    document.getElementById('travelerDisplay').textContent = newValue + " traveler";
    
    updateTotalPrice();
    closeModal();
    
    // Submit the form
    //document.querySelector('form').submit();
}
</script>

<script>
// Update the addDetails function
function addDetails() {
    const transportSelect = document.getElementById('transportSelect');
    //if (transportSelect.value === 'none') {
       // alert('Please select a transportation option before proceeding.');
       //return;
   // }
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
    
    modal.classList.remove('hidden');
}

function closeTravelerDetailsModal() {
    document.getElementById('travelerDetailsModal').classList.add('hidden');
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
    //document.getElementById('bookingForm').submit();
}
</script>
    
    
</body>
</html>