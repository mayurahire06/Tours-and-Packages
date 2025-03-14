<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mh.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ADD TOUR</title>
    <!-- MDBootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.css" rel="stylesheet" />
    <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
</head>
<%
    // User authentication check
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("adminEmail") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
%>

<body>

<%@include file="./includes/header.jsp" %>

<div class="container-fluid px-4">
    <div class="card mb-4">
        <div class="card-header">
            <h4><i class="fas fa-plus-circle me-2"></i>Add New Tour</h4>
        </div>
        <div class="card-body">
            <form action="../AddTour" method="post" enctype="multipart/form-data">
                <div class="row">
                    <!-- Left Column -->
                    <div class="col-md-6">
                        <!-- Tour Title -->
                        <div class="mb-3">
                            <label for="title" class="form-label">Tour Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        <!-- Tour Category-->
                        <div class="mb-3">
						    <label for="catId" class="form-label">Category <span class="text-danger">*</span></label>
						    <select class="form-control" id="catId" name="catId" required>
						        <option value="">---Select Category---</option>
						        <% 
						        try {
						            Connection conn = DBConnection.getConnection();

						            String query = "SELECT cat_id, cat_name FROM category";
						            PreparedStatement pstmt = conn.prepareStatement(query);
						            ResultSet rs = pstmt.executeQuery();

						            while (rs.next()) {        
								        %>
								            <option value="<%= rs.getInt("cat_id") %>"><%= rs.getString("cat_name") %></option>
								        <% 
						            }
						            conn.close();
						        }
						        catch (Exception e) {
						            e.printStackTrace();
						        }
						        %>
						    </select>
						</div>
                        <!-- Tour Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="description" name="description" rows="2" required></textarea>
                        </div>
                        <!-- Tour Destination -->
                        <div class="mb-3">
                            <label for="destination" class="form-label">Destination <span class="text-danger">*</span></label>
                            <input class="form-control" id="destination" name="destination" required>
                        </div>        
                        
                        <!-- Add Itinerary -->
                        <div class="mb-3">
                            <label for="itinerary" class="form-label">Add Itinerary <span class="text-danger">*</span></label>
                            <input type="file" class="form-control" id="itinerary" name="itinerary" required>
                        </div>   

                        <!-- Transportation Options -->
                        <div class="mb-3">
                            <label class="form-label required">Transportation</label><br>
                            <div class="form-check form-check-inline">
                                <input type="checkbox" class="form-check-input" id="bus" name="transportation" value="bus" onclick="toggleSourceField()">
                                <label class="form-check-label" for="bus">Bus</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input type="checkbox" class="form-check-input" id="train" name="transportation" value="train" onclick="toggleSourceField()">
                                <label class="form-check-label" for="train">Train</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input type="checkbox" class="form-check-input" id="flight" name="transportation" value="flight" onclick="toggleSourceField()">
                                <label class="form-check-label" for="flight">Flight</label>
                            </div>
                        </div>
                  
                  <!-- Source -->
                   <div class="mb-3" id="sourceField" style="display: none;">
                       <label for="source" class="form-label">Source</label>
                       <input class="form-control" id="source" name="source">
                   </div>

                 <!-- Bus Details -->
                <div id="busDetails" class="transport-details d-none row mb-3">
                    <h5>Bus Details</h5>
                    <div class="col-md-6">
                        <label for="busCompany" class="form-label">Bus Company</label>
                        <input type="text" class="form-control" id="busCompany" name="busCompany">
                    </div>

			        <div class="col-md-6">
			            <label for="busArrivalTime" class="form-label">Arrival Time</label>
			            <input type="time" class="form-control" id="busArrivalTime" name="busArrivalTime">
			        </div>
			
			        <div class="col-md-6">
			            <label for="busDepartureTime" class="form-label">Departure Time</label>
			            <input type="time" class="form-control" id="busDepartureTime" name="busDepartureTime">
			        </div>
			        <div class="col-md-6">
			            <label for="busTicket" class="form-label">Bus Ticket Price ($)</label>
			            <input type="number" min="0" class="form-control" id="busTicket" name="busTicket">
			        </div>
			
			        <div class="col-md-6">
			            <label for="busSeats" class="form-label">Available Seats</label>
			            <input type="number" class="form-control" id="busSeats" name="busSeats">
			        </div>
			        <!-- <div class="col-md-6">
			            <label for="busImg" class="form-label">Bus Image</label>
			            <input type="file" class="form-control" id="busImg" name="busImg">
			        </div>-->
        		</div>

                <!-- Train Details-->
                <div id="trainDetails" class="transport-details d-none row mb-3">
                    <h5>Train Details</h5>
                    <div class="col-md-6">
                        <label for="trainCompany" class="form-label">Train Company</label>
                        <input type="text" class="form-control" id="trainCompany" name="trainCompany">
                    </div>

			        <div class="col-md-6">
			            <label for="trainArrivalTime" class="form-label">Arrival Time</label>
			            <input type="time" class="form-control" id="trainArrivalTime" name="trainArrivalTime">
			        </div>
			
			        <div class="col-md-6">
			            <label for="trainDepartureTime" class="form-label">Departure Time</label>
			            <input type="time" class="form-control" id="trainDepartureTime" name="trainDepartureTime">
			        </div>
			        <div class="col-md-6">
			            <label for="trainTicket" class="form-label">Train Ticket Price ($)</label>
			            <input type="number" min="0" class="form-control" id="trainTicket" name="trainTicket">
			        </div>
			
			        <div class="col-md-6">
			            <label for="trainSeats" class="form-label">Available Seats</label>
			            <input type="number" class="form-control" id="trainSeats" name="trainSeats">
			        </div>
			        <!--  <div class="col-md-6">
			            <label for="trainImg" class="form-label">Train Image</label>
			            <input type="file" class="form-control" id="trainImg" name="trainImg">
			        </div>-->
                </div>

                <!-- Flight Details-->
                <div id="flightDetails" class="transport-details d-none row mb-3">
                    <h5>Flight Details</h5>
                    <div class="col-md-6">
                        <label for="flightCompany" class="form-label">Airline Name</label>
                        <input type="text" class="form-control" id="flightCompany" name="flightCompany">
                    </div>
                    
			        <div class="col-md-6">
			            <label for="flightArrivalTime" class="form-label">Arrival Time</label>
			            <input type="time" class="form-control" id="flightArrivalTime" name="flightArrivalTime">
			        </div>
			        <div class="col-md-6">
			            <label for="flightDepartureTime" class="form-label">Departure Time</label>
			            <input type="time" class="form-control" id="flightDepartureTime" name="flightDepartureTime">
			        </div>
			        <div class="col-md-6">
                        <label for="flightTicket" class="form-label">Flight Ticket Price ($)</label>
                        <input type="number" class="form-control" id="flightTicket" name="flightTicket">
                    </div>
			        <div class="col-md-6">
			            <label for="flightSeats" class="form-label">Available Seats</label>
			            <input type="number" class="form-control" id="flightSeats" name="flightSeats">
			        </div>
			       <!--  <div class="col-md-6">
			            <label for="flightImg" class="form-label">Flight Image</label>
			            <input type="file" class="form-control" id="flightImg" name="flightImg">
			        </div>-->
                 </div>
              </div>

                    <!-- Right Column -->
                    <div class="col-md-6">
                    
	                    <!-- Hotel Field -->
						  <div class="mb-3">
						      <label for="hotelName" class="form-label">Hotel <span class="text-danger">*</span></label>
						      <input type="text" class="form-control" id="hotelName" name="hotelName" required>
						  </div> 
						  
						  <!-- Hotel Location  -->
						  <div class="mb-3">
						      <label for="hotelLocation" class="form-label">Hotel Location <span class="text-danger">*</span></label>
						      <input type="text" class="form-control" id="hotelLocation" name="hotelLocation" required>
						  </div>
					  
                        <!-- Tour Dates -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="start_date" class="form-label">Start Date <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" id="start_date" name="start_date" required>
                            </div>
                            <div class="col-md-6">
                                <label for="end_date" class="form-label">End Date <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" id="end_date" name="end_date" required>
                            </div>
                        </div>
                        
                        <!-- Duration and capacity -->
						<div class="row mb-3">                    
                        	<!-- Duration (Auto-calculated) -->
	                        <div class="col-md-6">
	                            <label for="duration" class="form-label">Duration (days)</label>
	                            <input type="number" class="form-control" id="duration" name="duration"  min="1">
	                        </div>
	                        <!-- Capacity -->
	                        <div class="col-md-6">
	                            <label for="capacity" class="form-label">Maximum limit <span class="text-danger">*</span></label>
	                            <input type="number" class="form-control" id="capacity" name="capacity"  min="1" required>
	                        </div>
                       </div>
                       
                       <div class="row mb-3">
					    <!-- Tour Price -->
						    <div class="col-md-6">
						        <label for="price" class="form-label">Price <span class="text-danger">*</span></label>
						        <div class="input-group">
						            <span class="input-group-text">$</span>
						            <input type="number" class="form-control" id="price" name="price" min="0" required>
						        </div>
						    </div>
						    
						    <!-- Tour Discount Price -->
						    <div class="col-md-6">
						        <label for="pdprice" class="form-label">Discount Price</label>
						        <div class="input-group">
						            <span class="input-group-text">$</span>
						            <input type="number" class="form-control" id="pdprice" name="pdprice" min="0" required>
						        </div>
						    </div>
						</div>
	  
					   <!-- Image Field -->
					  <div class="mb-3">
					      <label for="images" class="form-label">Tour Images</label>
					      <input type="file" class="form-control" id="images" name="images" accept="image/*" multiple required>
					  </div>
					  
                    </div>
                </div>

                <!-- Form Buttons -->
                <div class="d-flex justify-content-end gap-2">
                    <a href="addTour.jsp" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Add Tour</button>
                </div>
            </form>
            <!-- Display Error Message -->
	        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
	        <% if (errorMessage != null) { %>
	            <div class="alert alert-danger" role="alert"><%= errorMessage %></div>
	        <% } %>
        </div>
    </div>
</div>

<!-- Success Modal -->
<div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="successModalLabel">Success</h5>
                <button type="button" class="btn-close" data-mdb-dismiss="modal" aria-label="Close"></button>              
            </div>
            <div class="modal-body">
                Tour added successfully!
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-mdb-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<!-- Date invalid Modal -->
<div class="modal fade" id="invalidModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="successModalLabel">Invalid Date</h5>
                <button type="button" class="btn-close" data-mdb-dismiss="modal" aria-label="Close"></button>              
            </div>
            <div class="modal-body">
                Invalid Date!!!
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-mdb-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<%@include file="./includes/footer.jsp" %>

<!-- MDBootstrap JavaScript -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.js"></script>

<script>
// Auto-calculate duration based on dates
document.getElementById('start_date').addEventListener('change', calculateDuration);
document.getElementById('end_date').addEventListener('change', calculateDuration);

function calculateDuration() {
    const startDate = new Date(document.getElementById('start_date').value);
    const endDate = new Date(document.getElementById('end_date').value);
    
    if (startDate && endDate && startDate < endDate) {
        const diffTime = endDate - startDate;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
        document.getElementById('duration').value = diffDays;
    } else {
        document.getElementById('duration').value = '';
    }
}

// Form Validation before submission
document.querySelector('form').addEventListener('submit', function(e) {
    const startDate = new Date(document.getElementById('start_date').value);
    const endDate = new Date(document.getElementById('end_date').value);
    
    if (startDate >= endDate) {
        e.preventDefault();
        let invalidModal = new mdb.Modal(document.getElementById('invalidModal'));
        invalidModal.show();
        return false;
    }
});

//Transportation Details Toggle
document.addEventListener("DOMContentLoaded", function() {
    const busCheckbox = document.getElementById("bus");
   const trainCheckbox = document.getElementById("train");
   const flightCheckbox = document.getElementById("flight");

    const busDetails = document.getElementById("busDetails");
    const trainDetails = document.getElementById("trainDetails");
    const flightDetails = document.getElementById("flightDetails");

    function toggleForm(checkbox, details) {
       details.classList.toggle("d-none", !checkbox.checked);
    }

    if (busCheckbox) busCheckbox.addEventListener("change", () => toggleForm(busCheckbox, busDetails));
    if (trainCheckbox) trainCheckbox.addEventListener("change", () => toggleForm(trainCheckbox, trainDetails));
    if (flightCheckbox) flightCheckbox.addEventListener("change", () => toggleForm(flightCheckbox, flightDetails));
});

//Toggle for the source field
function toggleSourceField() {
    var bus = document.getElementById("bus").checked;
    var train = document.getElementById("train").checked;
    var flight = document.getElementById("flight").checked;
    var sourceField = document.getElementById("sourceField");
    if (bus || train || flight) {
        sourceField.style.display = "block";
    } else {
        sourceField.style.display = "none";
    }
}


// Check if "success" parameter is present in the URL and show modal
const urlParams = new URLSearchParams(window.location.search);
if (urlParams.has('success')) {
    var successModal = new mdb.Modal(document.getElementById('successModal'));
    successModal.show();
}
</script>

</body>
</html>