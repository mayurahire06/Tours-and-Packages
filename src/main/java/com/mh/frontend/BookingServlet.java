package com.mh.frontend;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        // Retrieve parameters from form
        String tourId = request.getParameter("tourId");
        String members = request.getParameter("members");
        String transportType = request.getParameter("transportType");
        String totalPrice = request.getParameter("totalPrice");
        String travelerDetailsJson = request.getParameter("travelerDetails");

        // Debug logs (optional)
        System.out.println("Tour ID: " + tourId);
        System.out.println("Members: " + members);
        System.out.println("Transport Type: " + transportType);
        System.out.println("Total Price: " + totalPrice);
        System.out.println("Traveler Details (JSON): " + travelerDetailsJson);

        // TODO: Save this information to your database here.
        // You can use JDBC or a DAO layer to insert into bookings table.
        // You might also want to parse the JSON string using a library like org.json or Gson.

        // For now, forward to a confirmation JSP
        request.setAttribute("tourId", tourId);
        request.setAttribute("members", members);
        request.setAttribute("transportType", transportType);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("travelerDetails", travelerDetailsJson); // can be parsed on JSP side too

        request.getRequestDispatcher("/user/booking.jsp").forward(request, response);
    }
}
