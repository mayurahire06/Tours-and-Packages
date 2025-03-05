package com.mh.backend;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import com.mh.DBConnection;

@WebServlet("/viewTourDetails")
public class viewTourDetails extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Default values
        String firstImage = request.getContextPath() + "/images/1.jpeg";
        List<String> images = new ArrayList<>();
        int price = 0, capacity = 0;
        String s_date = "", dest = "", formattedPrice = "", transport = "";
        List<String> transportOptions = new ArrayList<>();

        // Get tour ID from request
        int id = 0;
        try {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                id = Integer.parseInt(idParam);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid tour ID format");
            return;
        }

        // Fetch tour data
        String query = "SELECT t.s_date, t.transport, t.price, t.dest, t.capacity, i.image_path " +
                "FROM tour t LEFT JOIN images i ON t.t_id = i.t_id WHERE t.t_id = ?";

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
                        transport = rs.getString("transport");

                        // Format price correctly
                        formattedPrice = NumberFormat.getNumberInstance(Locale.US).format(price);

                        // Split transport values
                        if (transport != null && !transport.trim().isEmpty()) {
                            String[] options = transport.split(",");
                            for (String option : options) {
                                transportOptions.add(option.trim());
                            }
                        }
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
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
            return;
        } catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

        // Set attributes for JSP
        request.setAttribute("transportOptions", transportOptions);
        request.setAttribute("firstImage", firstImage);
        request.setAttribute("images", images);
        request.setAttribute("price", price);
        request.setAttribute("capacity", capacity);
        request.setAttribute("s_date", s_date);
        request.setAttribute("dest", dest);
        request.setAttribute("formattedPrice", formattedPrice);

        // Forward to JSP page
        request.getRequestDispatcher("/user/includes/half.jsp").forward(request, response);
    }
}