<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mh.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tours and Travels</title>
<!-- MDBootstrap CSS -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.css" rel="stylesheet" />
<!-- Font Awesome CDN for icons -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />

<style>
    .package-card img {
        height: 200px;
        object-fit: cover;
    }
    .card.booking-card.v-2 {
        background-color: #c7f2e3;
    }
</style>
</head>
<body>

<!-- Navbar -->
<%@ include file="./includes/navbar.jsp" %>

<!-- Header Section -->
<header class="bg-primary text-white text-center py-5">
    <h1>Welcome to Our Tours and Travels</h1>
    <p>Your dream vacation is just a click away!</p>
</header>

<!-- Tour Packages Section -->
<section class="container my-5">
    <h2 class="text-center mb-4">Our Popular Tour Packages</h2>
    <div class="row">
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        conn = DBConnection.getConnection();
        String query = "SELECT t.t_id, t.title, t.descr, GROUP_CONCAT(i.image_path SEPARATOR ',') AS image_path " +
                       "FROM tour t " +
                       "LEFT JOIN Images i ON t.t_id = i.t_id GROUP BY t.t_id";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String imagePaths = rs.getString("image_path");
            String firstImage = "../images/1.jpeg"; // Default image
            
            if (imagePaths != null && !imagePaths.trim().isEmpty()) {
                String[] images = imagePaths.split(",");
                firstImage = images[0].trim();
                // Fix the image path
                firstImage = firstImage.replace("\\", "/").replace("./", "");
            }
            
            // Debugging: Print out the image paths
           // System.out.println("Image Paths: " + imagePaths);
           // System.out.println("First Image: " + firstImage);
            
            String imageUrl = request.getContextPath() + "/" + firstImage;
            //System.out.println("Final Image URL: " + imageUrl);
%>
            <div class="col-md-4">
                <div class="card package-card">
                    <img src="<%= (imagePaths != null && !imagePaths.isEmpty()) ? imageUrl : firstImage %>" class="card-img-top" alt="Package Image">
                    <div class="card-body">
                        <h5 class="card-title"><%= rs.getString("title") %></h5>
                        <p class="card-text"><%= rs.getString("descr") %></p>
                        <a href="viewTourDetails.jsp?id=<%= rs.getInt("t_id") %>" class="btn btn-primary">View Package</a>
                    </div>
                </div>
            </div>
<% 
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>

    </div>
</section>

<!-- Footer -->
<%@ include file="./includes/footer.jsp" %>

<!-- MDBootstrap JavaScript -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.js"></script>

</body>
</html>
