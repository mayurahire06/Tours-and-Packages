package com.mh.frontend;

//import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
//import java.util.UUID;

//import org.json.JSONArray;

@WebServlet("/TicketServlet")
public class OneTicketServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession TicketServletSession = request.getSession(false);
//        
//        // Check authentication
        if (TicketServletSession == null || TicketServletSession.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user/loginRegister.jsp");
            return;
        }
//
//        // Retrieve traveler details from session
//        String travelerDetailsJson = (String) TicketServletSession.getAttribute("travelerDetails");
//        JSONArray travelers = new JSONArray();
//        try {
//            if (travelerDetailsJson != null && !travelerDetailsJson.isEmpty()) {
//                travelers = new JSONArray(travelerDetailsJson);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        // Determine payment method and details
//        String paymentMethod = "Unknown";
//        String paymentDetails = "";
//        
//        if (request.getParameter("card-number") != null) {
//            paymentMethod = "Credit/Debit Card";
//            String cardNumber = request.getParameter("card-number");
//            String maskedCard = "****-****-****-" + cardNumber.substring(cardNumber.length() - 4);
//            paymentDetails = "Card: " + maskedCard + ", Name: " + request.getParameter("cardholder-name");
//        } 
//        else if (request.getParameter("upi-id") != null) {
//            paymentMethod = "UPI";
//            paymentDetails = "UPI ID: " + request.getParameter("upi-id");
//        } 
//        else if (request.getParameter("bank-name") != null) {
//            paymentMethod = "Net Banking";
//            String accountNumber = request.getParameter("username");
//            paymentDetails = "Bank: " + request.getParameter("bank-name") + 
//                           ", Account: ***" + accountNumber.substring(accountNumber.length() - 4);
//        } 
//        else if (request.getParameter("wallet-provider") != null) {
//            paymentMethod = "Wallet";
//            String provider = request.getParameter("wallet-provider");
//            String contact = request.getParameter("phone") != null ? request.getParameter("phone") :
//                           request.getParameter("email") != null ? request.getParameter("email") : "";
//            paymentDetails = "Provider: " + provider + ", Contact: " + contact;
//        }
//
//        // Calculate total amount from session attributes
//        double basePrice = getDoubleAttribute(TicketServletSession, "basePrice");
//        double addOns = getDoubleAttribute(TicketServletSession, "addOnsPrice");
//        double taxes = getDoubleAttribute(TicketServletSession, "taxesAndFees");
//        double transport = getDoubleAttribute(TicketServletSession, "transportationPrice");
//        double totalAmount = basePrice + addOns + taxes + transport;
//
//        // Generate booking reference
//        String bookingRef = "BOOK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
//
//        // Set attributes for confirmation page
//        request.setAttribute("bookingRef", bookingRef);
//        request.setAttribute("travelers", travelers.toString());
//        request.setAttribute("paymentMethod", paymentMethod);
//        request.setAttribute("paymentDetails", paymentDetails);
//        request.setAttribute("totalAmount", totalAmount);

        // Forward to confirmation page
    	System.out.println(".........I'm in Ticket Servlet...");
//        request.getRequestDispatcher("${pageContext.request.contextPath}/ticket.jsp").forward(request, response);
    	response.sendRedirect("${pageContext.request.contextPath}/user/ticket.jsp");
    }

//    private double getDoubleAttribute(HttpSession session, String attrName) {
//        Object value = session.getAttribute(attrName);
//        if (value instanceof Double) {
//            return (Double) value;
//        } else if (value instanceof Integer) {
//            return ((Integer) value).doubleValue();
//        } else if (value instanceof String) {
//            try {
//                return Double.parseDouble((String) value);
//            } catch (NumberFormatException e) {
//                return 0.0;
//            }
//        }
//        return 0.0;
//    }
}