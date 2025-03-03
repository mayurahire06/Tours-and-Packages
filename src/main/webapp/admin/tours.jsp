<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tours and Packages</title>
    <!-- MDBootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.css" rel="stylesheet" />
    <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <style>
    /* Tours Page Specific Styles */
    .table-hover tbody tr:hover {
        background-color: rgba(0,0,0,0.05);
    }

    .text-truncate {
        max-width: 200px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .action-buttons .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }
    </style>
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

<div class="container-fluid px-4">
    <div class="card mb-4">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h4><i class="fas fa-suitcase me-2"></i>Manage Tours</h4>
                <a href="addTour.jsp" 
                   class="btn btn-success btn-sm">
                    <i class="fas fa-plus-circle"></i> Add New Tour
                </a>
            </div>
        </div>
        
        <div class="card-body">
            <!-- Search and Filter Section -->
            <div class="row mb-3">
                <div class="col-md-4">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Search tours...">
                        <button class="btn btn-outline-secondary" type="button">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
                <div class="col-md-3">
                    <select class="form-select">
                        <option>Filter by Status</option>
                        <option>Active</option>
                        <option>Upcoming</option>
                        <option>Completed</option>
                    </select>
                </div>
            </div>

            <!-- Tours Table -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Price</th>
                            <th>Dates</th>
                            <th>Duration</th>
                            <th>Available Seats</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>${tour.title}</td>
                            <td class="text-truncate">${tour.description}</td>
                            <td>${tour.price}</td>
                            <td>${tour.dates}</td>
                            <td>${tour.duration} days</td>
                            <td>
                                <span class="badge ${tour.availableSeats > 10 ? 'badge-success' : 'badge-warning'}">
                                    ${tour.availableSeats}
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/admin/tours?action=edit&id=${tour.tourId}" 
                                       class="btn btn-sm btn-primary" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button class="btn btn-sm btn-danger delete-tour" 
                                            data-id="${tour.tourId}" title="Delete">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">Next</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this tour?</p>
            </div>
            <div class="modal-footer">
                <form id="deleteForm" method="post">
                    <input type="hidden" name="action" value="delete">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@include file="./includes/footer.jsp"%>

<script>
// Delete Tour Confirmation
document.querySelectorAll('.delete-tour').forEach(button => {
    button.addEventListener('click', function() {
        const tourId = this.dataset.id;
        const deleteForm = document.getElementById('deleteForm');
        deleteForm.action = '${pageContext.request.contextPath}/admin/tours?id=' + tourId;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    });
});
</script>

<!-- MDBootstrap JavaScript -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/5.0.0/mdb.min.js"></script>
</body>
</html>