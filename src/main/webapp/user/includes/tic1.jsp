<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.net.URLEncoder" %>

<%!
    // Sample data class - in a real application, this would come from your database
    public static class Traveler {
        private String name;
        private int age;
        private String gender;
        
        public Traveler(String name, int age, String gender) {
            this.name = name;
            this.age = age;
            this.gender = gender;
        }
        
        public String getName() { return name; }
        public int getAge() { return age; }
        public String getGender() { return gender; }
    }

    public static class Transport {
        private String type;
        private Map<String, String> departure = new HashMap<>();
        private Map<String, String> arrival = new HashMap<>();
        
        public Transport(String type, String depTime, String depLocation, String arrTime, String arrLocation) {
            this.type = type;
            this.departure.put("time", depTime);
            this.departure.put("location", depLocation);
            this.arrival.put("time", arrTime);
            this.arrival.put("location", arrLocation);
        }
        
        public String getType() { return type; }
        public Map<String, String> getDeparture() { return departure; }
        public Map<String, String> getArrival() { return arrival; }
    }
%>

<%
    // Initialize ticket data - in a real application, this would come from your database
    String bookingId = "EE-IND-2024-7845";
    String packageName = "Golden Triangle Tour";
    String customerName = "Rahul Sharma";
    
    List<Traveler> travelers = new ArrayList<>();
    travelers.add(new Traveler("Rahul Sharma", 35, "Male"));
    travelers.add(new Traveler("Priya Sharma", 32, "Female"));
    travelers.add(new Traveler("Arjun Sharma", 10, "Male"));
    
    String source = "New Delhi";
    String destination = "Jaipur-Agra-Delhi";
    String startDate = "15 Apr 2024";
    String endDate = "22 Apr 2024";
    
    Transport transport = new Transport(
        "Train + Bus",
        "08:30 AM",
        "New Delhi Railway Station",
        "06:45 PM",
        "New Delhi Railway Station"
    );
    
    List<String> itinerary = new ArrayList<>();
    itinerary.add("Day 1: Delhi Sightseeing");
    itinerary.add("Day 2: Delhi to Jaipur");
    itinerary.add("Day 3-4: Jaipur Exploration");
    itinerary.add("Day 5: Jaipur to Agra");
    itinerary.add("Day 6-7: Agra Exploration");
    itinerary.add("Day 8: Return to Delhi");
    
    String totalPrice = "₹45,600";
    String bookingDate = "12 Mar 2024";
    
    // Generate QR code URL
    String qrData = "https://exploreease.india/ticket/" + bookingId;
    String qrCode = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=" + URLEncoder.encode(qrData, "UTF-8");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ExploreEase: India Edition - Tour Ticket</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        @media print {
            .print-hidden {
                display: none !important;
            }
            body {
                background-color: white !important;
            }
        }
        
        .ticket-card {
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        
        .ticket-header {
            background-color: #4f46e5;
            color: white;
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo-container {
            height: 4rem;
            width: 4rem;
            border-radius: 9999px;
            background-color: white;
            padding: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .confirmation-stamp {
            width: 8rem;
            height: 8rem;
            border: 4px solid #16a34a;
            border-radius: 9999px;
            display: flex;
            align-items: center;
            justify-content: center;
            transform: rotate(-20deg);
        }
        
        .icon {
            display: inline-flex;
            vertical-align: middle;
        }
        
        .muted-text {
            color: #6b7280;
        }
        
        .button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            font-weight: 500;
            cursor: pointer;
        }
        
        .primary-button {
            background-color: #4f46e5;
            color: white;
        }
        
        .outline-button {
            background-color: white;
            border: 1px solid #d1d5db;
        }
        
        .itinerary-item {
            background-color: #f3f4f6;
            padding: 0.5rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
        }
    </style>
    <script>
        function printTicket() {
            window.print();
        }
        
        function downloadTicket() {
            // In a real application, you would generate a PDF here
            // For this demo, we'll just trigger the print dialog which can save as PDF
            window.print();
        }
    </script>
</head>
<body class="bg-gray-100 min-h-screen p-4 flex flex-col items-center justify-center">
    <div class="w-full max-w-4xl">
        <div class="flex justify-end gap-2 mb-4 print-hidden">
            <button onclick="printTicket()" class="button outline-button">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon">
                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                    <rect x="6" y="14" width="12" height="8"></rect>
                </svg>
                Print Ticket
            </button>
            <button onclick="downloadTicket()" class="button primary-button">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="7 10 12 15 17 10"></polyline>
                    <line x1="12" y1="15" x2="12" y2="3"></line>
                </svg>
                Download Ticket
            </button>
        </div>
        
        <div class="ticket-card">
            <!-- Ticket Header -->
            <div class="ticket-header">
                <div class="flex items-center gap-3">
                    <div class="logo-container">
                        <img src="images/logo.png" alt="ExploreEase Logo" width="60" height="60" class="object-contain">
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold">ExploreEase</h1>
                        <p class="text-sm opacity-90">India Edition</p>
                    </div>
                </div>
                <div class="text-right">
                    <p class="text-sm opacity-90">Booking ID</p>
                    <p class="font-bold"><%= bookingId %></p>
                </div>
            </div>
            
            <!-- Ticket Body -->
            <div class="p-6">
                <div class="flex flex-col md:flex-row justify-between gap-6 mb-6">
                    <div class="flex-1">
                        <h2 class="text-2xl font-bold mb-4"><%= packageName %></h2>
                        
                        <div class="space-y-4">
                            <div class="flex items-start gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon mt-0.5">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                    <circle cx="12" cy="10" r="3"></circle>
                                </svg>
                                <div>
                                    <p class="text-sm muted-text">Route</p>
                                    <p class="font-medium"><%= source %> to <%= destination %></p>
                                </div>
                            </div>
                            
                            <div class="flex items-start gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon mt-0.5">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <div>
                                    <p class="text-sm muted-text">Travel Period</p>
                                    <p class="font-medium"><%= startDate %> - <%= endDate %></p>
                                </div>
                            </div>
                            
                            <div class="flex items-start gap-2">
                                <% if (transport.getType().contains("Bus")) { %>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon mt-0.5">
                                    <path d="M19 17h2l.64-2.54c.24-.959.24-1.962 0-2.92l-1.07-4.27A3 3 0 0 0 17.66 5H4a2 2 0 0 0-2 2v10h2"></path>
                                    <path d="M14 17H9"></path>
                                    <circle cx="6.5" cy="17.5" r="2.5"></circle>
                                    <circle cx="16.5" cy="17.5" r="2.5"></circle>
                                </svg>
                                <% } else if (transport.getType().contains("Train")) { %>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon mt-0.5">
                                    <rect x="4" y="4" width="16" height="16" rx="2"></rect>
                                    <path d="M4 11h16"></path>
                                    <path d="M12 4v16"></path>
                                </svg>
                                <% } else { %>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon mt-0.5">
                                    <path d="M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z"></path>
                                </svg>
                                <% } %>
                                <div>
                                    <p class="text-sm muted-text">Transport</p>
                                    <p class="font-medium"><%= transport.getType() %></p>
                                    <div class="mt-1 text-sm">
                                        <div class="flex items-center gap-1">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span>Departure: <%= transport.getDeparture().get("time") %> from <%= transport.getDeparture().get("location") %></span>
                                        </div>
                                        <div class="flex items-center gap-1 mt-1">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span>Return: <%= transport.getArrival().get("time") %> to <%= transport.getArrival().get("location") %></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="flex items-start gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon mt-0.5">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                                <div>
                                    <p class="text-sm muted-text">Travelers (<%= travelers.size() %>)</p>
                                    <div class="mt-1">
                                        <% for (Traveler traveler : travelers) { %>
                                        <p class="text-sm">
                                            <%= traveler.getName() %> (<%= traveler.getAge() %> yrs, <%= traveler.getGender() %>)
                                        </p>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="flex flex-col items-center">
                        <div class="relative">
                            <img src="<%= qrCode %>" alt="Ticket QR Code" width="150" height="150" class="border p-2 bg-white">
                            <p class="text-xs text-center mt-1 muted-text">Scan to download ticket</p>
                        </div>
                        
                        <div class="mt-6 relative">
                            <div class="confirmation-stamp">
                                <div class="text-center">
                                    <p class="text-green-600 font-bold text-lg">CONFIRMED</p>
                                    <p class="text-green-600 text-xs"><%= bookingDate %></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Itinerary -->
                <div class="mt-8 border-t pt-4">
                    <h3 class="font-bold text-lg mb-2">Itinerary Overview</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                        <% for (String day : itinerary) { %>
                        <div class="itinerary-item">
                            <%= day %>
                        </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Price -->
                <div class="mt-8 border-t pt-4 flex justify-between items-center">
                    <div>
                        <p class="text-sm muted-text">Total Amount Paid</p>
                        <p class="text-2xl font-bold"><%= totalPrice %></p>
                        <p class="text-xs muted-text">for <%= travelers.size() %> travelers</p>
                    </div>
                    <div class="text-right">
                        <p class="text-sm muted-text">Booked by</p>
                        <p class="font-medium"><%= customerName %></p>
                        <p class="text-xs muted-text">on <%= bookingDate %></p>
                    </div>
                </div>
                
                <!-- Footer -->
                <div class="mt-8 border-t pt-4 text-center text-xs muted-text">
                    <p>Thank you for choosing ExploreEase: India Edition. We wish you a pleasant journey!</p>
                    <p class="mt-1">For any assistance, contact us at support@exploreease.india or call +91-9876543210</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>