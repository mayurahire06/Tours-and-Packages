<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
            <h2 class="text-center mb-5">Featured Experiences</h2>
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
            String defaultImage = "https://images.unsplash.com/photo-1585506942812-e72b29cef752?auto=format&fit=crop&w=800"; // Default image path
            String imageUrl = defaultImage; // Default to the default image

            if (imagePath != null && !imagePath.trim().isEmpty()) {
                // Fix the image path for the browser
                imageUrl = request.getContextPath() + "/" + imagePath.replace("\\", "/").replace("./", "");
            }
%>
                <!-- Package Cards -->
                <div class="col-md-4">
                    <div class="card package-card h-100 shadow">
                        <img src="https://images.unsplash.com/photo-1585506942812-e72b29cef752?auto=format&fit=crop&w=800" class="card-img-top" alt="Golden Triangle">
                        <div class="card-body">
                            <h5 class="card-title"><%= rs.getString("title") %></h5>
                            <p class="card-text"><%= rs.getString("descr") %></p>
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

    <!-- Why Choose Us -->
    <section class="py-5 bg-white">
        <div class="container">
            <h2 class="text-center mb-5">Why ExploreEase?</h2>
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

    <!-- Testimonials -->
    <section id="testimonials" class="py-5 bg-primary text-white">
        <div class="container">
            <h2 class="text-center mb-5">Traveler Stories</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="testimonial-card p-4 rounded">
                        <p class="fst-italic">"Best cultural experience we've ever had!"</p>
                        <div class="d-flex align-items-center">
                            <img src="https://randomuser.me/api/portraits/women/32.jpg" class="rounded-circle me-3" width="50" alt="User">
                            <div>
                                <h6 class="mb-0">Sarah Johnson</h6>
                                <small>From London</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>Contact Us</h5>
                    <p><i class="fas fa-map-marker-alt me-2"></i> New Delhi, India</p>
                    <p><i class="fas fa-envelope me-2"></i> contact@exploreease.in</p>
                </div>
                <div class="col-md-4">
                    <h5>Follow Us</h5>
                    <div class="social-icons">
                        <a href="#" class="text-white me-3"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="text-white me-3"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-white me-3"><i class="fab fa-twitter"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
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