<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Your Package</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@splidejs/splide@4/dist/css/splide.min.css">
    
    <!-- Tailwind CSS CDN (if you're using it) -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/user/style/booking.css" rel="stylesheet">
    
</head>

<%
    // Authentication check
    HttpSession bookJspSession = request.getSession(false);

    if (bookJspSession == null || bookJspSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/user/loginRegister.jsp");
        return;
    }

    // Get attributes with null checks
    String itineraryContent = (String) bookJspSession.getAttribute("itineraryContent");
  
    
    String travelerDetailsJson = (String) bookJspSession.getAttribute("travelerDetails");
    
    //System.out.println("travelerDetailsJson: " +travelerDetailsJson);
    JSONArray travelers = new JSONArray(travelerDetailsJson);
    
    if (travelerDetailsJson != null && !travelerDetailsJson.trim().isEmpty()) {
        try {
            travelers = new JSONArray(travelerDetailsJson);
        } catch (Exception e) {
            e.printStackTrace();
            travelers = new JSONArray(); // Fallback to empty on error
        }
    }
    
    String tourMembers = (String) bookJspSession.getAttribute("members");
    //System.out.println("members: " + tourMembers);
    String transportType = (String) bookJspSession.getAttribute("transportType"); 

   	List<String> list = Arrays.asList("bus", "train", "flight");

    Object transportPrice = bookJspSession.getAttribute("transportationPrice");
    //int transportPrice = (int)transportationPrice; 
    //System.out.println("transportPrice: " + transportPrice.getClass().getName());
%>

<body>
<div class="container">
    <!-- Navigation -->
    
        <div class="review-header">
            <h1>Preview Your Package</h1>
            <p>Please review all details before proceeding to payment</p>
        </div>
        
        <div class="review-content">
            <div class="review-details">
                <!-- Package Information -->
                <div class="package-info">
                    <h2>${sessionScope.title}</h2>
                    <p>${packageDescription} Description</p>
                    
                    <div class="package-info-details">
                        <div class="info-item">
                            <p>1.Traveler Details -></p>
                            <h4></h4>
                        </div>
                        <div class="info-item">
                            <p>2.Packag Add-ons -></p>
                            <h4></h4>
                        </div>
                        <div class="info-item">
                            <p>3.Package Itinerary & inclusions -></p>
                            <h4> </h4>
                        </div>
                        <div class="info-item">
                            <p>4.Cancellation & Date Change -></p>
                            <h4></h4>
                        </div>
                    </div>
                </div>
                
                <!-- Accordion Sections -->
                <!-- 1. Traveler Details -->
                <div class="accordion active">
                    <div class="accordion-header">
                        <h3>Traveler Details</h3>
                        <div class="accordion-icon"></div>
                    </div>
                    <div class="accordion-content">
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
					 </div>
                </div>
                
             
                <!-- 2. Package Add-Ons -->
                <div class="accordion">
                    <div class="accordion-header">
                        <h3>Package Add-Ons</h3>
                        <div class="accordion-icon"></div>
                    </div>
                    <div class="accordion-content">
                        <div class="addon-item">
                            <span>Premium Transport Upgrade</span>
                            <span>₹2,500</span>
                        </div>
                        <div class="addon-item">
                            <span>Additional Activities</span>
                            <span>₹1,500</span>
                        </div>
                        <div class="addon-item">
                            <strong>Total Add-Ons</strong>
                            <strong>₹4,000</strong>
                        </div>
                    </div>
                </div>
                
                <!-- 3. Package Itinerary & Inclusions -->
                <div class="accordion">
                    <div class="accordion-header">
                        <h3>Package Itinerary & Inclusions</h3>
                        <div class="accordion-icon"></div>
                    </div>
                    <div class="accordion-content">
                        <h4>Itinerary</h4>
                        <div id="itineraryContent">
                    <% 
                    if (itineraryContent != null && !itineraryContent.isEmpty()) {
                        String[] days = itineraryContent.split("\n\n");
                        for (String day : days) {
                            if (day.trim().isEmpty()) continue;
                            
                            String[] lines = day.split("\n");
                            if (lines.length > 0) {
                                String dayTitle = lines[0].trim();
                                //System.out.println("Day title: "+dayTitle);
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
					                <div class="activity-item <%= isHighlight ? "font-semibold text-gray-800" : "text-gray-600" %>">
					                   
					                    <% if (isHighlight) { %>
					                        <span class="highlight bg-yellow-100 px-2 py-1 rounded">
					                            <%= activity %>
					                        </span>
					                    <% }  %>
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
                        
                        <!-- You can replace this with your JSP logic to iterate through itinerary days
                        <div class="itinerary-day">
                            <h4>Day 1: Arrival and Welcome</h4>
                            <p>Arrive at the destination, check-in to hotel, welcome dinner.</p>
                        </div>-->
                        
                        <!-- End of itinerary iteration -->
                        
                        <h4>Inclusions</h4>
                        <ul class="inclusions-list">
                            <!-- You can replace this with your JSP logic to iterate through inclusions -->
                            <li>Hotel accommodation with breakfast</li>
                            <li>Airport transfers</li>
                            <li>Sightseeing as per itinerary</li>
                            <li>English speaking tour guide</li>
                            <li>All taxes and service charges</li>
                            <!-- End of inclusions iteration -->
                        </ul>
                    </div>
                </div>
                
                <!-- 4. Cancellation & Date Change -->
                <div class="accordion">
                    <div class="accordion-header">
                        <h3>Cancellation & Date Change</h3>
                        <div class="accordion-icon"></div>
                    </div>
                    <div class="accordion-content">
                        <div class="cancellation-policy">
                            <h4>Cancellation Policy</h4>
                            <p>- Free cancellation up to 7 days before the trip</p>
                            <p>- 50% refund for cancellations 3-7 days before the trip</p>
                            <p>- No refund for cancellations less than 3 days before the trip</p>
                        </div>
                        
                        <div class="cancellation-policy">
                            <h4>Date Change Policy</h4>
                            <p>- Free date change up to 10 days before the trip</p>
                            <p>- ₹1000 fee for date changes 5-10 days before the trip</p>
                            <p>- ₹2500 fee for date changes less than 5 days before the trip</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Payment Sidebar -->
            <div class="payment-sidebar">
                <div class="payment-card">
                    <h3>Price Details</h3>
                    
                    <div class="price-breakdown">
                        <div class="price-item">
                            <span>Base Price</span>
                            <span>₹${sessionScope.basePrice}</span>
                        </div>
                        <div class="price-item">
                            <span>Add-Ons</span>
                            <span>₹${addOnsPrice}0</span>
                        </div>
                        <div class="price-item">
                            <span>Taxes  Fees</span>
                            <span>₹${taxesAndFees}0</span>
                        </div>
                        <div class="price-item">
                            <span>Transport Charges(<%= transportType %>) </span><!-- yet to fix -->
                            <span>₹<%= transportPrice == null ? 0 : "none".equals(transportType) ? 0 : transportPrice %></span>
                        </div>
                        
                        <div class="price-total">
                            <span>Total Amount</span>
                            <span>₹${totalPrice}</span>
                        </div>
                        
                    </div>
                      
                        <div class="payment-option selected">
                            <input type="radio" id="credit-card" name="payment-method" checked>
                            <label for="credit-card">Credit/Debit Card</label>
                        </div>
                        
                        <div class="payment-option">
                            <input type="radio" id="upi" name="payment-method">
                            <label for="upi">UPI</label>
                        </div>
                        
                        <div class="payment-option">
                            <input type="radio" id="net-banking" name="payment-method">
                            <label for="net-banking">Net Banking</label>
                        </div>
                        
                        <div class="payment-option">
                            <input type="radio" id="wallet" name="payment-method">
                            <label for="wallet">Wallet</label>
                        </div>
                        <button id="proceed-btn" class="proceed-btn">Proceed</button>
                    </div>
  
                </div>
            </div>
        </div>
    </div>
    
    
    <!-- Credit/Debit Card Modal -->
    <div id="credit-card-modal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Enter Credit/Debit Card Details</h2>
            <form id="credit-card-form" action="${pageContext.request.contextPath}/TicketsServlet" method="post">
                <label for="card-number">Card Number</label>
                <input type="number" id="card-number" 
                 pattern="^\d{13,19}$"
  				 title="Please enter a 13 to 19-digit number."
                 value="1234567891234" required>
                
                <!-- <label for="expiry">Expiration Date (MM/YYYY)</label>
                <input type="text" id="expiry" placeholder="MM/YYYY" required>-->
                
                <label for="cvv">CVV</label>
                <input type="number" id="cvv" pattern="^\d{3,4}$"
                title="CVV must be 3 or 4 digits." value="123" required>
                
                <label for="cardholder-name">Card holder Name</label>
                <input type="text" id="cardholder-name" 
                title="Card holder name is required."
                value="Mayur Ahire" required>

                <button type="submit">Submit</button>
            </form>
            <!-- <a href="../TicketsServlet">click here</a>-->
        </div>
    </div>

    <!-- UPI Modal -->
    <div id="upi-modal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>Enter UPI Details</h3>
            <form id="upi-form" action="../TicketServlet" target="_blank">
                <label for="upi-id">UPI ID</label>
                <input type="text" id="upi-id" pattern=".+@.+" 
                title="Please enter a valid upi id."
				value="mayur@paytm" required>
				  
                <label for="upi-pin">PIN</label>
                <input type="password" id="upi-pin" 
                 pattern="^\d{4}$|^\d{6}$"
				  title="Please enter 4 or 6-digit password."
				  value="123456" required>
                <button type="submit">Submit</button>
            </form>
        </div>
    </div>

    <!-- Net Banking Modal -->
    <div id="net-banking-modal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>Enter Net Banking Credentials</h3>
            <form id="net-banking-form" action="../TicketServlet" target="_blank">
                <label for="bank-name">Bank Name</label>
                <select id="bank-name" required>
                    <option value="">Select Bank</option>
                    <option value="sbi">SBI</option>
                    <option value="icici">ICICI</option>
                    <option value="hdfc">HDFC</option>
                </select>
                
                <label for="username">Account Number</label>
                <input type="number" id="username" 
                pattern="^\d{10}$" 
			    title="Account number must be exactly 10 digits."
			    value="1234567890" required>
                
                <label for="password">Password</label>
                <input type="password" id="password" pattern="^\d{6}$" value="123456" required>
                
                <button type="submit">Submit</button>
            </form>
        </div>
    </div>

    <!-- Wallet Modal -->
    <div id="wallet-modal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>Enter Wallet Details</h3>
            <form id="wallet-form" action="../TicketServlet" target="_blank">
                <label for="wallet-provider">Wallet Provider</label>
                <select id="wallet-provider" required>
                    <option value="">Select Provider</option>
                    <option value="paytm">Paytm</option>
                    <option value="phonepe">PhonePe</option>
                    <option value="googlepay">Google Pay</option>
                </select>
                <div id="wallet-fields"></div>
                <button type="submit">Submit</button>
            </form>
        </div>
    </div>
    
    <!-- <script src="${pageContext.request.contextPath}/user/script/booking.js"></script>-->
    
    <script>
 // Toggle accordion sections
    document.querySelectorAll('.accordion-header').forEach(header => {
        header.addEventListener('click', () => {
            const accordion = header.parentElement;
            accordion.classList.toggle('active');
        });
    });
    
    // Select payment method
    document.querySelectorAll('.payment-option').forEach(option => {
        option.addEventListener('click', () => {
            // Clear previous selection
            document.querySelectorAll('.payment-option').forEach(opt => {
                opt.classList.remove('selected');
            });
            
            // Select current option
            option.classList.add('selected');
            
            // Check the radio button
            const radio = option.querySelector('input[type="radio"]');
            radio.checked = true;
            
        });
    });

document.addEventListener('DOMContentLoaded', () => {
    const proceedBtn = document.getElementById('proceed-btn');
    const modals = {
        'credit-card': document.getElementById('credit-card-modal'),
        'upi': document.getElementById('upi-modal'),
        'net-banking': document.getElementById('net-banking-modal'),
        'wallet': document.getElementById('wallet-modal')
    };
    
    //console.log(modals)

    // Open modal when Proceed is clicked
    proceedBtn.addEventListener('click', () => {
        const selectedMethod = document.querySelector('input[name="payment-method"]:checked').id;
		console.log(selectedMethod)
        openModal(modals[selectedMethod]);
    });

    // Close modal
    document.querySelectorAll('.close').forEach(closeBtn => {
        closeBtn.addEventListener('click', () => {
            closeModal(closeBtn.closest('.modal'));
        });
    });


    // Wallet Form Handling
    const walletProvider = document.getElementById('wallet-provider');
    const walletFields = document.getElementById('wallet-fields');
    walletProvider.addEventListener('change', () => {
        walletFields.innerHTML = '';
        switch (walletProvider.value) {
            case 'paytm':
                walletFields.innerHTML = `
                    <label for="phone">Phone Number</label>
                    <input type="number" id="phone" pattern="^\d{10}$" 
        			    title="Account number must be exactly 10 digits."
        				value="1234567890" value="9876543210" required>
                    
                    <label for="password">Password</label>
                    <input type="password" id="password" value="123456" required>
                `;
                break;
            case 'phonepe':
                walletFields.innerHTML = `
                    <label for="phone">Phone Number</label>
                    <input type="number" id="phone" pattern="^\d{10}$" 
        			title="Account number must be exactly 10 digits." 
        			value="9876543210" required><br>
        			
                    <label for="pin">PIN</label>
                    <input type="password" id="pin" value="123456" required>
                `;
                break;
            case 'googlepay':
                walletFields.innerHTML = `
                    <label for="email">Email</label>
                    <input type="email" id="email" value="mayur@gmail.com" required><br>
                    
                    <label for="password">Password</label>
                    <input type="password" id="password" value="123456" required>
                `;
                break;
        }
    });

    // Helper Functions
    function openModal(modal) {
        modal.style.display = 'block';
    }

    function closeModal(modal) {
        modal.style.display = 'none';
    }

});
    </script>
</body>
</html>