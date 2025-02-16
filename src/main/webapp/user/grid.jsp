<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

    <title>Tour Packages(grid)</title>

    <!-- MDBootstrap CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css">
    <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    
    <style>
        .package-card {
            transition: transform 0.3s ease-in-out;
        }
        .package-card:hover {
            transform: scale(1.05);
        }
        .wishlist-btn {
            border: none;
            background: transparent;
            font-size: 20px;
            position: absolute;
            top: 10px;
            right: 10px;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <div class="row row-cols-1 row-cols-md-4 g-4">

        <!-- Package 1 -->
        <div class="col">
            <div class="card package-card shadow-2-strong">
                <div class="position-relative">
                    <img src="../images/1.jpeg" class="card-img-top" alt="Mendenhall Glacier Tour" style="width: 100%; height: 200px; object-fit: cover;">
                    <button class="wishlist-btn"><i class="far fa-heart"></i></button>
                </div>
                <div class="card-body">
                    <p class="text-success"><i class="fas fa-star"></i> 4.4 (271)</p>
                    <h6 class="card-title">Mendenhall Glacier Trolley Tour</h6>
                    <p><i class="far fa-clock"></i> 3 hours</p>
                    <p class="fw-bold text-primary">From ₹7,050</p>
                </div>
            </div>
        </div>

        <!-- Package 2 -->
        <div class="col">
            <div class="card package-card shadow-2-strong">
                <div class="position-relative">
                    <img src="../images/2.jpeg" class="card-img-top" alt="Whale Tour" style="width: 100%; height: 200px; object-fit: cover;">
                    <button class="wishlist-btn"><i class="far fa-heart"></i></button>
                </div>
                <div class="card-body">
                    <p class="text-success"><i class="fas fa-star"></i> 4.9 (918)</p>
                    <h6 class="card-title">3.5 Hour Crowd-Skipping Whale Tour in Juneau Alaska</h6>
                    <p><i class="far fa-clock"></i> 3 hours 30 minutes</p>
                    <p class="fw-bold text-primary">From ₹19,186</p>
                </div>
            </div>
        </div>

        <!-- Package 3 -->
        <div class="col">
            <div class="card package-card shadow-2-strong">
                <div class="position-relative">
                    <img src="../images/3.jpeg" class="card-img-top" alt="Wildlife Cruise" style="width: 100%; height: 200px; object-fit: cover;">
                    <button class="wishlist-btn"><i class="far fa-heart"></i></button>
                </div>
                <div class="card-body">
                    <p class="text-success"><i class="fas fa-star"></i> 4.7 (902)</p>
                    <h6 class="card-title">Kenai Fjords and Resurrection Bay Half-Day Wildlife Cruise</h6>
                    <p><i class="far fa-clock"></i> 4 hours</p>
                    <p class="fw-bold text-primary">From ₹14,425</p>
                </div>
            </div>
        </div>

        <!-- Package 4 -->
        <div class="col">
            <div class="card package-card shadow-2-strong">
                <div class="position-relative">
                    <img src="../images/4.jpeg" class="card-img-top" alt="Wild Adventure Yukon" style="width: 100%; height: 200px; object-fit: cover;">
                    <button class="wishlist-btn"><i class="far fa-heart"></i></button>
                </div>
                <div class="card-body">
                    <p class="text-success"><i class="fas fa-star"></i> 4.8 (179)</p>
                    <h6 class="card-title">Wild Adventure Yukon Tour into Canada including City and Summit</h6>
                    <p><i class="far fa-clock"></i> 6 hours 30 minutes</p>
                    <p class="fw-bold text-primary">From ₹15,081</p>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- MDBootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>
</body>
</html>
