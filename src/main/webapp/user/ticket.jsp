<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ExploreEase: India Edition - Tour Ticket</title>
 	<link rel="stylesheet" href="./style/ticket.css">
</head>

<%
 HttpSession ticketSession = request.getSession(false);
    if (ticketSession == null || ticketSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/user/loginRegister.jsp");
        return;
    }
%>
    
<body>
    <div class="container">
        <div class="button-container print-hidden">
            <button onclick="window.print()" class="button outline-button">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                    <rect x="6" y="14" width="12" height="8"></rect>
                </svg>
                Print Ticket
            </button>
            <button onclick="window.print()" class="button primary-button">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                <div class="logo-container">
                    <div class="logo">
                        <!-- Replace with your actual logo -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m21 12-6-6-6 6 6 6 6-6Z"></path>
                            <path d="M3 12h.01"></path>
                            <path d="M12 3v.01"></path>
                            <path d="M12 21v.01"></path>
                            <path d="M21 12h.01"></path>
                        </svg>
                    </div>
                    <div>
                        <h1 style="font-size: 24px; font-weight: bold;">ExploreEase</h1>
                        <p style="font-size: 14px; opacity: 0.9;">India Edition</p>
                    </div>
                </div>
                <div style="text-align: right;">
                    <p style="font-size: 14px; opacity: 0.9;">Booking ID</p>
                    <p style="font-weight: bold;">EE-IND-2024-7845</p>
                </div>
            </div>
            
            <!-- Ticket Body -->
            <div class="ticket-body">
                <div class="ticket-content">
                    <div class="ticket-details">
                        <h2 class="ticket-title">Golden Triangle Tour</h2>
                        
                        <div class="detail-group">
                            <svg xmlns="http://www.w3.org/2000/svg" class="detail-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                            <div>
                                <p class="detail-label">Route</p>
                                <p class="detail-value">New Delhi to Jaipur-Agra-Delhi</p>
                            </div>
                        </div>
                        
                        <div class="detail-group">
                            <svg xmlns="http://www.w3.org/2000/svg" class="detail-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <div>
                                <p class="detail-label">Travel Period</p>
                                <p class="detail-value">15 Apr 2024 - 22 Apr 2024</p>
                            </div>
                        </div>
                        
                        <div class="detail-group">
                            <svg xmlns="http://www.w3.org/2000/svg" class="detail-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="4" y="4" width="16" height="16" rx="2"></rect>
                                <path d="M4 11h16"></path>
                                <path d="M12 4v16"></path>
                            </svg>
                            <div>
                                <p class="detail-label">Transport</p>
                                <p class="detail-value">Train + Bus</p>
                                <div class="detail-subtext">
                                    <div style="display: flex; align-items: center; gap: 4px;">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                        <span>Departure: 08:30 AM from New Delhi Railway Station</span>
                                    </div>
                                    <div style="display: flex; align-items: center; gap: 4px; margin-top: 4px;">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                        <span>Return: 06:45 PM to New Delhi Railway Station</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="detail-group">
                            <svg xmlns="http://www.w3.org/2000/svg" class="detail-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            <div>
                                <p class="detail-label">Travelers (3)</p>
                                <div class="detail-subtext">
                                    <p>Rahul Sharma (35 yrs, Male)</p>
                                    <p>Priya Sharma (32 yrs, Female)</p>
                                    <p>Arjun Sharma (10 yrs, Male)</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="ticket-sidebar">
                        <div>
                            <div class="qr-container">
                                <!-- Replace with actual QR code or use an API -->
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://exploreease.india/ticket/EE-IND-2024-7845" alt="Ticket QR Code" width="150" height="150">
                            </div>
                            <p class="qr-text">Scan to download ticket</p>
                        </div>
                        
                        <div class="confirmation-stamp">
                            <div class="stamp-text">
                                <p class="stamp-title">CONFIRMED</p>
                                <p class="stamp-date">12 Mar 2024</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Itinerary -->
                <div class="divider"></div>
                <h3 class="section-title">Itinerary Overview</h3>
                <div class="itinerary-grid">
                    <div class="itinerary-item">Day 1: Delhi Sightseeing</div>
                    <div class="itinerary-item">Day 2: Delhi to Jaipur</div>
                    <div class="itinerary-item">Day 3-4: Jaipur Exploration</div>
                    <div class="itinerary-item">Day 5: Jaipur to Agra</div>
                    <div class="itinerary-item">Day 6-7: Agra Exploration</div>
                    <div class="itinerary-item">Day 8: Return to Delhi</div>
                </div>
                
                <!-- Price -->
                <div class="divider"></div>
                <div class="price-section">
                    <div>
                        <p class="detail-label">Total Amount Paid</p>
                        <p class="price-amount">₹45,600</p>
                        <p class="price-text">for 3 travelers</p>
                    </div>
                    <div style="text-align: right;">
                        <p class="detail-label">Booked by</p>
                        <p class="booker-name">Rahul Sharma</p>
                        <p class="price-text">on 12 Mar 2024</p>
                    </div>
                </div>
                
                <!-- Footer -->
                <div class="divider"></div>
                <div class="footer-text">
                    <p>Thank you for choosing ExploreEase: India Edition. We wish you a pleasant journey!</p>
                    <p style="margin-top: 4px;">For any assistance, contact us at support@exploreease.india or call +91-9876543210</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>