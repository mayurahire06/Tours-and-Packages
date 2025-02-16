<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Denali Experience Flightseeing Tour</title>
    <!-- MDBootstrap CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css">
    <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <style>
        .package-container { max-width: 1140px; }
        .carousel-item img { height: 450px; object-fit: cover; }
        .booking-card { border-radius: 1rem; overflow: hidden; }
        .price-highlight { font-size: 1.5rem; letter-spacing: -0.5px; }
        .divider { border-left: 1px solid #dee2e6; height: 1.25rem; }
    </style>
</head>
<body class="bg-light">

<div class="container py-5 package-container">
    <!-- Header Section -->
    <header class="mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="fw-bold display-5">Denali Experience Flightseeing Tour</h1>
            <button class="btn btn-link text-danger p-2">
                <i class="fas fa-heart fa-lg"></i>
            </button>
        </div>
        
        <div class="d-flex align-items-center gap-3 text-secondary mb-3">
            <span class="d-flex align-items-center">
                <i class="fas fa-star text-success me-1"></i>
                <span class="fw-bold">5.0</span> (686 Reviews)
            </span>
            <span class="divider"></span>
            <span class="text-danger">
                <i class="fas fa-thumbs-up"></i> 98% Recommended
            </span>
            <span class="badge bg-warning text-dark rounded-pill">
                <i class="fas fa-award"></i> Excellence Badge
            </span>
        </div>
        
        <p class="h5">
            <i class="fas fa-map-marker-alt text-primary"></i> Talkeetna, Alaska, USA
        </p>
    </header>

    <!-- Image Carousel -->
    <section class="mb-5">
        <div id="packageCarousel" class="carousel slide shadow-4 rounded-4 overflow-hidden" data-mdb-ride="carousel">
            <div class="carousel-indicators">
                <button data-mdb-target="#packageCarousel" data-mdb-slide-to="0" class="active"></button>
                <button data-mdb-target="#packageCarousel" data-mdb-slide-to="1"></button>
                <button data-mdb-target="#packageCarousel" data-mdb-slide-to="2"></button>
            </div>
            
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="../images/1.jpeg" class="d-block w-100" alt="Mountain view from plane">
                </div>
                <div class="carousel-item">
                    <img src="../images/2.jpeg" class="d-block w-100" alt="Aerial view of Denali">
                </div>
                <div class="carousel-item">
                    <img src="../images/3.jpeg" class="d-block w-100" alt="Tour group photo">
                </div>
            </div>
            
            <button class="carousel-control-prev" type="button" data-mdb-target="#packageCarousel" data-mdb-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-mdb-target="#packageCarousel" data-mdb-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>
    </section>

    <!-- Booking Section -->
    <section class="booking-card shadow-5">
        <div class="card">
            <div class="card-body p-4">
                <div class="mb-4">
                    <h3 class="price-highlight text-primary mb-1">₹31,071.49 <span class="text-muted fs-6">/ person</span></h3>
                    <p class="text-success mb-0">
                        <i class="fas fa-tag"></i> Lowest Price Guarantee
                    </p>
                </div>

                <form action="bookPackage.jsp" method="post">
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Select Date</label>
                            <input type="date" name="date" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Travelers</label>
                            <select name="travelers" class="form-select" required>
                                <option value="1">1 Adult</option>
                                <option value="2">2 Adults</option>
                                <option value="3">3 Adults</option>
                                <option value="4">4 Adults</option>
                                <option value="5">5 Adults</option>
                                <option value="6">6 Adults</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg w-100">
                        <i class="fas fa-calendar-check me-2"></i>Book Now
                    </button>
                </form>

                <div class="mt-3 d-flex align-items-center text-secondary">
                    <i class="fas fa-info-circle text-success me-2"></i>
                    <small>Free cancellation 24 hours prior to experience</small>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- MDBootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>
</body>
</html>