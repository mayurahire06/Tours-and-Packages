<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
	<!-- MDBootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.css" rel="stylesheet" />
    <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
   
</head>
<%
    // User authentication check
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("adminEmail") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
%>

<body>
<%@include file="./includes/header.jsp"%>

<div class="container">
    <h2>Admin Dashboard</h2>
    <div class="row stats-row">
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5>Total Tours</h5>
                    <p>${tourCount}</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5>Total Bookings</h5>
                    <p>${bookingCount}</p>
                </div>
            </div>
        </div>
        <!-- Add more stats -->
    </div>
    <div class="row stats-row">
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5>Total Tours</h5>
                    <p>${tourCount}</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5>Total Bookings</h5>
                    <p>${bookingCount}</p>
                </div>
            </div>
        </div>
        <!-- Add more stats -->
    </div>
    <div class="row stats-row">
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5>Total Tours</h5>
                    <p>${tourCount}</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5>Total Bookings</h5>
                    <p>${bookingCount}</p>
                </div>
            </div>
        </div>
        <!-- Add more stats -->
    </div>
</div>
<%@include file="./includes/footer.jsp"%>
 <!-- MDBootstrap JavaScript -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.js"></script>
</body>
</html>