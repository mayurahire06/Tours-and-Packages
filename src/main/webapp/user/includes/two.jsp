<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.mh.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tour Package Details</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

</head>

<%
    // Retrieve the existing session (do not create a new one)
    HttpSession session1 = request.getSession(false);

    // Check if the session is null or does not contain the "username" attribute
    if (session1 == null || session1.getAttribute("user") == null) {
        // Redirect to the login page if the user is not logged in
        response.sendRedirect(request.getContextPath() + "/user/loginRegister.jsp");
        return; // Stop further execution of the JSP page
    }
%>

<body class="m-2 p-6">
    <div class="container max-w-[1440px] bg-white shadow-lg rounded-lg pt-4 border-2 border-gray-300">
        <h1 class="text-4xl font-serif font-bold m-2">Denali Experience Tour from Talkeetna</h1>
        <div class="flex gap-4 mr-4 h-[600px] mb-4">

        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String firstImage = "../images/1.jpeg"; // Default image
            String[] images = new String[0]; // Array to hold images

            try {
                conn = DBConnection.getConnection();
                String query = "SELECT GROUP_CONCAT(image_path SEPARATOR ',') AS image_paths FROM images WHERE images_id = ?";
                pstmt = conn.prepareStatement(query);
                
                String idParam = request.getParameter("id");
                int id = 0;
                if (idParam != null && !idParam.trim().isEmpty()) {
                    try {
                        id = Integer.parseInt(idParam);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }
                }

                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String imagePaths = rs.getString("image_paths");
                    if (imagePaths != null && !imagePaths.trim().isEmpty()) {
                        images = imagePaths.split(",");
                        for (int i = 0; i < images.length; i++) {
                            images[i] = images[i].trim().replace("\\", "/").replace("./", "");
                        }
                        firstImage = request.getContextPath() + "/" + images[0];
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        %>

            <!-- First Section: Small Images -->
            <div class="w-md flex flex-col items-center pl-4 mt-4">
                <div class="overflow-y-auto flex flex-col space-y-4 pt-2 rounded-lg h-[600px] w-52 border-2 border-gray-300">
                    <% for (String img : images) { %>
                        <img src="<%= request.getContextPath() + "/" + img %>" 
                             class="h-28 w-full cursor-pointer border rounded-md object-cover hover:shadow-lg hover:border-blue-500 transition duration-300" 
                             onclick="changeImage('<%= request.getContextPath() + "/" + img %>')" />
                    <% } %>
                </div>
            </div>

            <!-- Second Section: Large Image Display -->
            <div class="w-[800px] flex flex-col mt-4 items-center border-2 border-gray-300 rounded-lg p-2 hover:shadow-lg transition duration-300">
                <img id="mainImage" src="<%= firstImage %>" class="w-full h-[500px] rounded-lg shadow-md object-cover" />
            </div>

            <!-- Third Section: Tour Info -->
            <div class="w-[350px] flex flex-col items-center pl-2 mt-4 border-2 border-gray-300 rounded-lg p-4 hover:bg-gray-100 transition duration-300">
                <p class="text-gray-600 mb-4">Alaska, USA</p>
                <div class="mb-6 w-full">
                    <p class="text-xl font-semibold">From ₹31,071.49 per person</p>
                    <p class="underline underline-offset-1 text-sm text-gray-500">Lowest Price Guarantee</p>
                </div>
                <div class="mb-6 w-full">
                    <label for="date" class="block text-sm font-medium text-gray-700">Select Date and Travelers</label>
                    <input type="date" id="date" name="date" class="mt-1 block w-full p-2 border border-gray-300 rounded-md hover:border-blue-500 transition duration-300" value="2025-02-05">
                    <input type="number" id="travelers" name="travelers" class="mt-1 block w-full p-2 border border-gray-300 rounded-md hover:border-blue-500 transition duration-300" value="6" min="1">
                </div>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 w-full transition duration-300">Update Search</button>
                <div class="mt-4 text-sm text-gray-600">
                    <p>Free cancellation up to 24 hours before the experience starts (local time)</p>
                </div>
                <div class="mt-6">
                    <a href="#" class="text-blue-500 hover:text-blue-600 transition duration-300">See More</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function changeImage(src) {
            document.getElementById("mainImage").src = src;
        }
    </script>

</body>
</html>
