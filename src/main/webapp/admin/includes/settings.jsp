<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>Admin Settings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Admin Settings</h2>
        <form>
            <div class="mb-3">
                <label class="form-label">Change Email</label>
                <input type="email" class="form-control" placeholder="Enter new email">
            </div>
            <div class="mb-3">
                <label class="form-label">Enable Notifications</label>
                <input type="checkbox" checked>
            </div>
            <button type="submit" class="btn btn-success">Save Changes</button>
        </form>
    </div>
</body>
</html>
