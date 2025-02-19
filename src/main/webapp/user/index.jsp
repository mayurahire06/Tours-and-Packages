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
        // Fetch the first image for each tour
        String query = "SELECT t.t_id, t.title, t.descr, " +
                       "(SELECT i.image_path FROM images i WHERE i.t_id = t.t_id LIMIT 1) AS image_path " +
                       "FROM tour t";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String imagePath = rs.getString("image_path");
            String defaultImage = "../images/1.jpeg"; // Default image path
            String imageUrl = defaultImage; // Default to the default image

            if (imagePath != null && !imagePath.trim().isEmpty()) {
                // Fix the image path for the browser
                imageUrl = request.getContextPath() + "/" + imagePath.replace("\\", "/").replace("./", "");
            }
%>
            <div class="col-md-4 mb-4">
                <div class="card package-card">
                    <img src="<%= imageUrl %>" class="card-img-top" alt="Package Image">
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