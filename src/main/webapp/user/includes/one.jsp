<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
        body {
	background-color: #f5f7fa;
}

.card.booking-card.v-2 {
  background-color: #c7f2e3;
}

.card.booking-card.v-2 .fa {
  color: #f7aa00;
}

.card.booking-card.v-2 .card-body .card-text {
  color: #db2d43;
  
}

.card.card.booking-card.v-2 .chip {
  background-color: #87e5da;
}

.card.booking-card.v-2 .card-body hr {
  border-top: 1px solid #f7aa00;
}
        
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Tours and Travels</a>
             <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
                
            </button>
            <button type="button" class="btn btn-primary btn-floating" data-mdb-ripple-init>
  				<i class="fas fa-download"></i>
			</button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Packages</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="one.jsp">Contact</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="loginRegister.jsp">Login</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Header Section -->
    <header class="bg-primary text-white text-center py-5">
        <h1>Welcome to Our Tours and Travels</h1>
        <p>Your dream vacation is just a click away!</p>
    </header>

    <!-- Tour Packages Section -->
    <section class="container my-5">
        <h2 class="text-center mb-4">Our Popular Tour Packages</h2>
        <div class="row">
            <!-- Package 1 -->
            <div class="col-md-4">
                <div class="card package-card">
                    <img src="../images/1.jpeg" class="card-img-top" alt="Package 1">
                    <div class="card-body">
                        <h5 class="card-title">Beach Getaway</h5>
                        <p class="card-text">Relax on the beach with a serene and peaceful environment. Explore exotic beaches, and enjoy luxurious resorts.</p>
                        <a href="viewTourDetails.jsp" class="btn btn-primary">View Package</a>
                    </div>
                </div>
            </div>

            <!-- Package 2 -->
            <div class="col-md-4">
                <div class="card package-card">
                    <img src="../images/2.jpeg" class="card-img-top" alt="Package 2">
                    <div class="card-body">
                        <h5 class="card-title">Mountain Adventure</h5>
                        <p class="card-text">Explore the mountains, go trekking, and experience the thrill of adventure in the great outdoors.</p>
                        <a href="viewTourDetails.jsp" class="btn btn-primary">View Package</a>
                    </div>
                </div>
            </div>

            <!-- Package 3 -->
            <div class="col-md-4">
                <div class="card package-card">
                    <img src="../images/3.jpeg" class="card-img-top" alt="Package 3">
                    <div class="card-body">
                        <h5 class="card-title">Cultural Heritage</h5>
                        <p class="card-text">Immerse yourself in the rich cultural heritage of the region. Visit historical landmarks and experience local traditions.</p>
                        <a href="viewTourDetails.jsp" class="btn btn-primary">View Package</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <!-- Package 3 -->
            <div class="col-md-4">
                <div class="container">
					  <section class="mx-auto my-5" style="max-width: 23rem;">
					      
					    <div class="card booking-card v-2 mt-2 mb-4 rounded-bottom">
					      <div class="bg-image hover-overlay ripple ripple-surface ripple-surface-light" data-mdb-ripple-color="light">
					        <img src="https://mdbootstrap.com/img/Photos/Others/water-lily.jpg" class="img-fluid">
					        <a href="#!">
					          <!-- <div class="mask" style="background-color: rgba(251, 251, 251, 0.15);"></div>-->
					        </a>
					      </div>
					      <div class="card-body">
					        <h4 class="card-title font-weight-bold"><a>Fine Art Pictures Gallery</a></h4>
					        <ul class="list-unstyled list-inline mb-2">
					          <li class="list-inline-item me-0"><i class="fa fa-star fa-xs"> </i></li>
					          <li class="list-inline-item me-0"><i class="fa fa-star fa-xs"></i></li>
					          <li class="list-inline-item me-0"><i class="fa fa-star fa-xs"></i></li>
					          <li class="list-inline-item me-0"><i class="fa fa-star fa-xs"></i></li>
					          <li class="list-inline-item"><i class="fa fa-star-half-alt fa-xs"></i></li>
					        </ul>
					        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's
					          content.</p>
					        <hr class="my-4">
					        <p class="h5 font-weight-bold mb-4">Opening hours</p>
					        <ul class="list-unstyled d-flex justify-content-start align-items-center mb-0">
					          <li>Tuesday - Friday</li>
					          <li>
					            <div class="chip ms-3">10:00AM</div>
					          </li>
					          <li>
					            <div class="chip ms-0 me-0">6:00PM</div>
					          </li>
					        </ul>
					        <ul class="list-unstyled d-flex justify-content-start align-items-center mb-0">
					          <li>Saturday - Sunday</li>
					          <li>
					            <div class="chip ms-3">9:00AM</div>
					          </li>
					          <li>
					            <div class="chip ms-0 me-0">7:00PM</div>
					          </li>
					        </ul>
					        <ul class="list-unstyled d-flex justify-content-start align-items-center mb-0">
					          <li>Monday</li>
					          <li>
					            <div class="chip ms-3">CLOSED</div>
					          </li>
					        </ul>
					      </div>
					    </div>
					    
					  </section>
</div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <!-- Footer -->
<footer class="text-center text-lg-start bg-body-tertiary text-muted">
  <!-- Section: Social media -->
  <section class="d-flex justify-content-center justify-content-lg-between p-4 border-bottom">
    <!-- Left -->
    <div class="me-5 d-none d-lg-block">
      <span>Get connected with us on social networks:</span>
    </div>
    <!-- Left -->

    <!-- Right -->
    <div>
      <a href="" class="me-4 text-reset">
        <i class="fab fa-facebook-f"></i>
      </a>
      <a href="" class="me-4 text-reset">
        <i class="fab fa-twitter"></i>
      </a>
      <a href="" class="me-4 text-reset">
        <i class="fab fa-google"></i>
      </a>
      <a href="" class="me-4 text-reset">
        <i class="fab fa-instagram"></i>
      </a>
      <a href="" class="me-4 text-reset">
        <i class="fab fa-linkedin"></i>
      </a>
      <a href="" class="me-4 text-reset">
        <i class="fab fa-github"></i>
      </a>
    </div>
    <!-- Right -->
  </section>
  <!-- Section: Social media -->

  <!-- Section: Links  -->
  <section class="">
    <div class="container text-center text-md-start mt-5">
      <!-- Grid row -->
      <div class="row mt-3">
        <!-- Grid column -->
        <div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
          <!-- Content -->
          <h6 class="text-uppercase fw-bold mb-4">
            <i class="fas fa-gem me-3"></i>Company name
          </h6>
          <p>
            Here you can use rows and columns to organize your footer content. Lorem ipsum
            dolor sit amet, consectetur adipisicing elit.
          </p>
        </div>
        <!-- Grid column -->

        <!-- Grid column -->
        <div class="col-md-2 col-lg-2 col-xl-2 mx-auto mb-4">
          <!-- Links -->
          <h6 class="text-uppercase fw-bold mb-4">
            Products
          </h6>
          <p>
            <a href="#!" class="text-reset">Angular</a>
          </p>
          <p>
            <a href="#!" class="text-reset">React</a>
          </p>
          <p>
            <a href="#!" class="text-reset">Vue</a>
          </p>
          <p>
            <a href="#!" class="text-reset">Laravel</a>
          </p>
        </div>
        <!-- Grid column -->

        <!-- Grid column -->
        <div class="col-md-3 col-lg-2 col-xl-2 mx-auto mb-4">
          <!-- Links -->
          <h6 class="text-uppercase fw-bold mb-4">
            Useful links
          </h6>
          <p>
            <a href="#!" class="text-reset">Pricing</a>
          </p>
          <p>
            <a href="#!" class="text-reset">Settings</a>
          </p>
          <p>
            <a href="#!" class="text-reset">Orders</a>
          </p>
          <p>
            <a href="#!" class="text-reset">Help</a>
          </p>
        </div>
        <!-- Grid column -->

        <!-- Grid column -->
        <div class="col-md-4 col-lg-3 col-xl-3 mx-auto mb-md-0 mb-4">
          <!-- Links -->
          <h6 class="text-uppercase fw-bold mb-4">Contact</h6>
          <p><i class="fas fa-home me-3"></i> New York, NY 10012, US</p>
          <p>
            <i class="fas fa-envelope me-3"></i>
            info@example.com
          </p>
          <p><i class="fas fa-phone me-3"></i> + 01 234 567 88</p>
          <p><i class="fas fa-print me-3"></i> + 01 234 567 89</p>
        </div>
        <!-- Grid column -->
      </div>
      <!-- Grid row -->
    </div>
  </section>
  <!-- Section: Links  -->

  <!-- Copyright -->
  <div class="text-center p-4" style="background-color: rgba(0, 0, 0, 0.05);">
    © 2021 Copyright:
    <a class="text-reset fw-bold" href="https://mdbootstrap.com/">MDBootstrap.com</a>
  </div>
  <!-- Copyright -->
</footer>
<!-- Footer -->

    <!-- MDBootstrap JavaScript -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.js"></script>
</body>
</html>

