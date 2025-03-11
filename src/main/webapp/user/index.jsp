<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.mh.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ExploreEase: India Edition - Discover Incredible India</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@splidejs/splide@4/dist/css/splide.min.css">
    
    <!-- Tailwind CSS CDN (if you're using it) -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        .hero-section {
            height: 120vh;
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)),
                        url('https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=1920') center/cover;
        }
        
        .package-card:hover {
            transform: translateY(-5px);
            transition: all 0.3s ease;
        }
        
        .testimonial-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(5px);
        }
        .splide__slide .bg-white {
            transition: transform 0.3s ease;
        }
        .splide__slide .bg-white:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-mountain"></i> ExploreEase: India
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="#packages">Packages</a></li>
                    <li class="nav-item"><a class="nav-link" href="#destinations">Destinations</a></li>
                    <li class="nav-item"><a class="nav-link" href="#testimonials">Testimonials</a></li>
                    <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="profileDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-cog"></i> <%= session.getAttribute("user") != null ? session.getAttribute("user") : "Guest" %>
                            </a>
                            <!-- Dropdown Menu -->
                            <ul class="dropdown-menu dropdown-menu-end">
                                <!-- Profile -->
                                <li>
                                    <a class="dropdown-item" href="./includes/profile.jsp">
                                        <i class="fas fa-user"></i> Profile
                                    </a>
                                </li>

                                <!-- Settings -->
                                <li>
                                    <a class="dropdown-item" href="./includes/settings.jsp">
                                        <i class="fas fa-cog"></i> Settings
                                    </a>
                                </li>

                                <!-- Change Password -->
                                <li>
                                    <a class="dropdown-item" href="./includes/changePassword.jsp">
                                        <i class="fas fa-key"></i> Change Password
                                    </a>
                                </li>

                                <!-- Notifications -->
                                <li>
                                    <a class="dropdown-item" href="./includes/notifications.jsp">
                                        <i class="fas fa-bell"></i> Notifications
                                    </a>
                                </li>

                                <!-- Divider -->
                                <li><hr class="dropdown-divider"></li>

                                <!-- Logout -->
                                <li>
                                    <a class="dropdown-item" href="./logout.jsp">
                                        <i class="fas fa-sign-out-alt"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </ul>
                
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section text-white d-flex align-items-center">
        <div class="container text-center">
            <h1 class="display-4 mb-4">Discover the Soul of India</h1>
            <div class="search-box mx-auto" style="max-width: 600px;">
                <div class="input-group">
                    <input type="text" class="form-control form-control-lg" placeholder="Where do you want to explore?">
                    <button class="btn btn-primary btn-lg">
                        <i class="fas fa-search"></i> Search
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Packages -->
    <section id="packages" class="py-5 bg-light">
        <div class="container">
            <h2 class="pt-16 pb-8 px-4 text-center text-4xl font-bold">Featured Experiences</h2>
            <div class="row g-4">
            
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
            String defaultImage = "../images/1.jpeg";// Default image path
            String imageUrl = defaultImage; // Default to the default image

            if (imagePath != null && !imagePath.trim().isEmpty()) {
                // Fix the image path for the browser
                imageUrl = request.getContextPath() + "/" + imagePath.replace("\\", "/").replace("./", "");
            }
%>
                <!-- Package Cards -->
                <div class="col-md-4">
                    <div class="card package-card h-100 shadow">
						<img src="<%= imageUrl %>" class="card-img-top" alt="<%= rs.getString("title") %>">
							<div class="card-body">
                            <h5 class="card-title"><%= rs.getString("title") %></h5>
                           
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-primary">7 Days</span>
                                <h5 class="text-success mb-0"></h5>
                                 <a href="viewTourDetails.jsp?id=<%= rs.getInt("t_id") %>" class="btn btn-primary">View Package</a>
                            </div>
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
        </div>
    </section>
    <!-- Interactive Destinations Map -->
<%@ page import="java.sql.*" %>
<section id="destinations" class="py-5 bg-lightclass="py-16 px-4 bg-gray-100">
    <div class="max-w-7xl mx-auto"><br>
        <h2 class="text-3xl font-bold text-center mb-12">Explore Destinations</h2>
        <div class="relative h-96 bg-white rounded-2xl shadow-xl overflow-hidden p-4">
            <div id="world-map" class="h-full w-full"></div>
            
            <div class="absolute inset-0 flex flex-wrap gap-4 p-4 overflow-auto">
                <%
				
                Statement stmt = null;
                
                int count = 0;
                
                try {
                    conn = DBConnection.getConnection();
                    stmt = conn.createStatement();
                    String sql = "SELECT dest, MIN(t_id) AS t_id FROM tour GROUP BY dest ORDER BY dest ASC;";
                    rs = stmt.executeQuery(sql);
                    
                    while(rs.next()) {
                        String destination = rs.getString("dest");
                        int t_id = rs.getInt("t_id");
                        if(count % 5 == 0) { // Start new column after every 5 items
                %>
                            <div class="w-56 flex-shrink-0"> <!-- Column container -->
                                <ul class="space-y-2">
                <%
                        }
                %>
                                <li class="flex items-center p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors border">
                                    <div class="w-2 h-2 bg-blue-600 rounded-full mr-3"></div>
                                    <a href="viewTourDetails.jsp?id=<%= t_id %>" class="text-gray-700"><%= destination %></a>
                                </li>
                <%
                        count++;
                        if(count % 5 == 0) { // Close column after 5 items
                %>
                                </ul>
                            </div>
                <%
                        }
                    }
                    // Close last column if not already closed
                    if(count % 5 != 0) {
                %>
                            </ul>
                        </div>
                <%
                    }
                } catch(SQLException e) {
                    e.printStackTrace();
                } finally {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(conn != null) conn.close();
                }
                %>
            </div>
        </div>
    </div>
</section>

    
	<!-- Centered Heading with reduced bottom padding -->


<!-- Testimonials Carousel with reduced top padding -->
<section id=testimonials class="pt-8 px-4 pb-16">
<h2 class="pt-16 pb-8 px-4 text-center text-4xl font-bold">Traveler Stories</h2>
    <div class="splide max-w-7xl mx-auto">
        <div class="splide__track">
            <ul class="splide__list">
                <li class="splide__slide p-4">
                    <div class="bg-white p-8 rounded-2xl shadow-lg">
                        <p class="text-xl mb-4">"Best travel experience we've ever had! Everything was perfectly organized."</p>
                        <div class="flex items-center">
                            <img src="https://images.unsplash.com/photo-1585506942812-e72b29cef752?auto=format&fit=crop&w=800" class="w-12 h-12 rounded-full mr-4" alt="Sarah">
                            <div>
                                <h4 class="font-bold">Sarah Johnson</h4>
                                <p class="text-gray-600">Adventure Seeker</p>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</section>
    <!-- Why Choose Us -->
    <section  class="py-5 bg-white">
        <div class="container">
            <h2 class="pt-16 pb-8 px-4 text-center text-4xl font-bold">Why ExploreEase?</h2>
            <div class="row g-4 text-center">
                <div class="col-md-4">
                    <div class="p-3">
                        <i class="fas fa-shield-alt fa-3x text-primary mb-3"></i>
                        <h4>Safe Travels</h4>
                        <p>100% verified partners & COVID-safe protocols</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <%@include file="./includes/footer.jsp" %>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@splidejs/splide@4/dist/js/splide.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
        	new Splide('.splide', {
        	    type: 'loop',
        	    perPage: window.innerWidth > 768 ? 3 : 1, // Show 3 slides on desktop, 1 on mobile
        	    autoplay: true,
        	    interval: 3000,
        	    pauseOnHover: true,
        	}).mount();

        });
    </script>
    <script>
        // Smooth scroll for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });

        // Search functionality
        document.querySelector('.search-box button').addEventListener('click', () => {
            const searchTerm = document.querySelector('.search-box input').value;
            alert(Searching for: ${searchTerm});
        });

        // Card hover effects
        document.querySelectorAll('.package-card').forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-5px)';
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>