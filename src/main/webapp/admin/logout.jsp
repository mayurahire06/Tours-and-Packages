<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>Logging Out</title>
</head>
<body>

<%
    // Get the current session, if it exists
    HttpSession logoutSession = request.getSession(false);

    if (logoutSession != null) {
        // Invalidate the session to log out the user
        session.invalidate();
    }

    // Redirect to the index page
    response.sendRedirect("login.jsp");
%>
    <!-- <script>
        alert("You have been logged out!");
        window.location.href = "login.jsp";
    </script>-->
</body>
</html>
