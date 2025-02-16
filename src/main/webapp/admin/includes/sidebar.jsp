<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Side bar</title>

</head>
<body>

<aside class="sidebar bg-dark text-white" id="sidebar">
    <div class="sidebar-header p-3 text-center">
        <h3><i class="fas fa-plane"></i> Admin Panel</h3>
    </div>
    
    <nav class="sidebar-nav">
        <ul class="nav flex-column">
            <!-- Dashboard -->
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>

            <!-- Tours Management -->
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="collapse" href="#toursMenu">
                    <i class="fas fa-suitcase"></i> Tours Management <i class="fas fa-chevron-down float-end"></i>
                </a>
                <div class="collapse" id="toursMenu">
                    <ul class="nav flex-column ps-4">
                        <li><a href="${pageContext.request.contextPath}/admin/tours" class="nav-link">All Tours</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/tours?action=new" class="nav-link">Add New Tour</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/categories" class="nav-link">Tour Categories</a></li>
                    </ul>
                </div>
            </li>

            <!-- Bookings -->
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="collapse" href="#bookingsMenu">
                    <i class="fas fa-receipt"></i> Bookings <i class="fas fa-chevron-down float-end"></i>
                </a>
                <div class="collapse" id="bookingsMenu">
                    <ul class="nav flex-column ps-4">
                        <li><a href="${pageContext.request.contextPath}/admin/bookings" class="nav-link">All Bookings</a></li>
                        <li><a href="#" class="nav-link">Pending Bookings</a></li>
                        <li><a href="#" class="nav-link">Confirmed Bookings</a></li>
                    </ul>
                </div>
            </li>

            <!-- Users Management -->
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="collapse" href="#usersMenu">
                    <i class="fas fa-users"></i> Users <i class="fas fa-chevron-down float-end"></i>
                </a>
                <div class="collapse" id="usersMenu">
                    <ul class="nav flex-column ps-4">
                        <li><a href="${pageContext.request.contextPath}/admin/users" class="nav-link">All Users</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/users?action=new" class="nav-link">Add New User</a></li>
                        <li><a href="#" class="nav-link">User Roles</a></li>
                    </ul>
                </div>
            </li>

            <!-- Logout -->
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/logout" class="nav-link text-danger">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </nav>
</aside>

</body>
</html>