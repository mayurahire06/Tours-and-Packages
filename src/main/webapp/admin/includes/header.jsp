<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>Admin Header</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        /* Custom Dropdown Styling */
        .dropdown-menu {
            background-color: #343a40; /* Dark background */
            border: 1px solid #454d55; /* Dark border */
        }

        .dropdown-item {
            color: #ffffff; /* White text */
        }

        .dropdown-item:hover {
            background-color: #495057; /* Darker background on hover */
            color: #ffffff; /* White text */
        }

        .dropdown-divider {
            border-color: #454d55; /* Dark divider */
        }
    </style>
</head>
<body>
    <header class="admin-header">
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container-fluid">
                <!-- Brand Logo -->
                <a class="navbar-brand" href="adminPanel.jsp">
                    <i class="fas fa-plane"></i> Tours Admin
                </a>

                <!-- Toggle Button for Mobile -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Navbar Links -->
                <div class="collapse navbar-collapse" id="adminNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <!-- Dashboard -->
                        <li class="nav-item">
                            <a class="nav-link" href="dashboard.jsp">
                                <i class="fas fa-home"></i> Dashboard
                            </a>
                        </li>

                        <!-- Tours -->
                        <li class="nav-item">
                            <a class="nav-link" href="tours.jsp">
                                <i class="fas fa-suitcase"></i> Tours
                            </a>
                        </li>

                        <!-- Bookings -->
                        <li class="nav-item">
                            <a class="nav-link" href="bookings.jsp">
                                <i class="fas fa-receipt"></i> Bookings
                            </a>
                        </li>

                        <!-- Users -->
                        <li class="nav-item">
                            <a class="nav-link" href="users.jsp">
                                <i class="fas fa-users"></i> Users
                            </a>
                        </li>
                    </ul>

                    <!-- Profile Dropdown -->
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="profileDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-cog"></i> Admin
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
                </div>
            </div>
        </nav>
    </header>

    <!-- Bootstrap JS and Dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>