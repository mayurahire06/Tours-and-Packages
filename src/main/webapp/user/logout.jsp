<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logout Page</title>
</head>
<body>
<%
    // Get the current session, if it exists
    HttpSession logoutSession = request.getSession(false);

    if (logoutSession != null) {
        session.invalidate();
    }

    // Redirect to the index page
    response.sendRedirect("loginRegister.jsp");
%>
</body>
</html>