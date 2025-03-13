<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>

</head>
<body>
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
</body>
</html>