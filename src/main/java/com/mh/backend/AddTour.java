package com.mh.backend;

import com.mh.DBConnection;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
//import java.util.ArrayList;
import java.util.Collection;
//import java.util.List;
//import java.util.Collection;
//import java.util.stream.Collectors;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;



@WebServlet("/AddTour")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddTour extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
//        String imageFileName = null;
    	int tourId=-1;
    	Connection conn = null;
    	PreparedStatement stmt=null, stmt1=null, stmt2=null, stmt3=null, stmt4=null;
    	ResultSet rs = null;
        
    	//bus details
        String busCompany = "";
        String source = "";
        int busTicket = 0;
        Time busArrivalTime = null;
        Time busDepartureTime = null;
        int busSeats = 0;
        String busImg = "";
        
        //Train details
        String trainCompany = "";
        int trainTicket = 0;
        Time trainArrivalTime = null;
        Time trainDepartureTime = null;
        int trainSeats = 0;
        String trainImg = "";
        
        //Flight details
        String flightCompany = "";
        int flightTicket = 0;
        Time flightArrivalTime = null;
        Time flightDepartureTime = null;
        int flightSeats = 0;
        String flightImg = "";
        
        //Transportation is selected or not
        boolean isBusSelected = false;
        boolean isTrainSelected = false;
        boolean isFlightSelected = false;
        
        int rowsInserted1=0;
        int rowsInserted2=0;
        int rowsInserted3=0;
        int rowsInserted4=0;
        
//        String imageFileName = null;
        try {
        	
            // package parameters
        	int catId = Integer.parseInt(request.getParameter("catId"));
        	String title = request.getParameter("title");
        	String description = request.getParameter("description");
        	int price = Integer.parseInt(request.getParameter("price"));
        	Date startDate = Date.valueOf(request.getParameter("start_date"));
        	Date endDate = Date.valueOf(request.getParameter("end_date"));
        	int duration = Integer.parseInt(request.getParameter("duration"));
        	int capacity = Integer.parseInt(request.getParameter("capacity"));
        	String destination = request.getParameter("destination");
        	String transportation[] = request.getParameterValues("transportation");
        	int pdprice = Integer.parseInt(request.getParameter("pdprice"));
        	Part filePart = request.getPart("itinerary");

            if (filePart == null || filePart.getSize() == 0) {
                System.out.println("No file received!");
                response.getWriter().write("No file uploaded.");
                return;
            }
            
            
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String UPLOAD_DIR = "C:/uploads"; // Use an absolute directory path
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String filePath = UPLOAD_DIR + File.separator + fileName;
            filePart.write(filePath);

            System.out.println("File uploaded to: " + filePath);

            // Redirect to the list page
            //response.sendRedirect(request.getContextPath() + "/client/listItinerary.jsp");
            
            ///////////////////////


          //for single image
//            private String singleImage(Part img, String uploadDir) throws IOException {
//                
//                // Ensure the part is not null and contains a file
//                if (img == null || img.getSize() <= 0) {
//                    throw new IOException("No image file uploaded.");
//                }
//
//                // Get file name
//                String imageFileName = Paths.get(img.getSubmittedFileName()).getFileName().toString();
//
//                // Create directory if it does not exist
//                File dir = new File(uploadDir);
//                if (!dir.exists()) {
//                    dir.mkdirs();
//                }
//
//                // Define file path
//                String imagePath = uploadDir + File.separator + imageFileName;
//
//                // Save file
//                try (InputStream inputStream = img.getInputStream();
//                     OutputStream outputStream = Files.newOutputStream(Paths.get(imagePath))) {
//                    byte[] buffer = new byte[1024];
//                    int bytesRead;
//                    while ((bytesRead = inputStream.read(buffer)) != -1) {
//                        outputStream.write(buffer, 0, bytesRead);
//                    }
//                }
//                return imagePath;
//            }
            ///
            
            //
            //
            
            
            
            
            
            
            
            
            
        	String hotelName = request.getParameter("hotelName");
        	String hotelLocation = request.getParameter("hotelLocation");
        	
        	
        	// Check which transportation selected
            if (transportation != null) {
                for (String transport : transportation) {
                    if (transport.equalsIgnoreCase("bus")) {
                        isBusSelected = true;  
                    }
                    if (transport.equalsIgnoreCase("train")) {
                    	isTrainSelected = true;
                    }
                    if (transport.equalsIgnoreCase("flight")) {
                    	isFlightSelected = true;
                    }
                }
                source = request.getParameter("source");
                
          	   //Bus selected
	        	if(isBusSelected) {
		            busCompany = request.getParameter("busCompany");
		            busTicket = Integer.parseInt(request.getParameter("busTicket"));
		            busArrivalTime = Time.valueOf(request.getParameter("busArrivalTime") + ":00");
		            busDepartureTime = Time.valueOf(request.getParameter("busDepartureTime") + ":00");
		            busSeats = Integer.parseInt(request.getParameter("busSeats"));
		           
		            Part imagePart = request.getPart("busImg");
		            busImg = singleImage(imagePart, ".\\tour_bus");
	        	}
	        	
	        	//Train selected
	        	if(isTrainSelected) {
		            trainCompany = request.getParameter("trainCompany");
		            trainTicket = Integer.parseInt(request.getParameter("trainTicket"));
		            trainArrivalTime = Time.valueOf(request.getParameter("trainArrivalTime") + ":00");
		            trainDepartureTime = Time.valueOf(request.getParameter("trainDepartureTime") + ":00");
		            trainSeats = Integer.parseInt(request.getParameter("trainSeats"));
		            
		            Part imagePart = request.getPart("trainImg");
		            trainImg = singleImage(imagePart, ".\\tour_train");
	        	}
	        	
	        	//Flight selected
	        	if(isFlightSelected) {
		            flightCompany = request.getParameter("flightCompany");
		            flightTicket = Integer.parseInt(request.getParameter("flightTicket"));
		            flightArrivalTime = Time.valueOf(request.getParameter("flightArrivalTime") + ":00");
		            flightDepartureTime = Time.valueOf(request.getParameter("flightDepartureTime") + ":00");
		            flightSeats = Integer.parseInt(request.getParameter("flightSeats"));
		            
		            Part imagePart = request.getPart("flightImg");
		            flightImg = singleImage(imagePart, ".\\tour_flight");
	        	}
            }
       

        	
        	// Convert transportation array to a comma-separated string
        	String transportString = (transportation != null) ? String.join(",", transportation) : "Not Available";
        	
            // Database insertion
            	conn = DBConnection.getConnection();
            	String sql1 = "INSERT INTO tour (cat_id, title, descr, price, s_date, e_date, duration, capacity, dest, transport, pdprice, itinerary) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            	stmt1 = conn.prepareStatement(sql1, PreparedStatement.RETURN_GENERATED_KEYS);
                stmt1.setInt(1, catId);
                stmt1.setString(2, title);
                stmt1.setString(3, description);
                stmt1.setInt(4, price);
                stmt1.setDate(5, startDate);
                stmt1.setDate(6, endDate);
                stmt1.setInt(7, duration);
                stmt1.setInt(8, capacity);
                stmt1.setString(9, destination);
                stmt1.setString(10, transportString);
                stmt1.setInt(11, pdprice);
                stmt1.setString(12, filePath);
//                stmt1.setString(12, imagePath);
                
                rowsInserted1 = stmt1.executeUpdate();
                if (rowsInserted1 > 0) {
                	
                	// Get the generated tour_id
                	rs = stmt1.getGeneratedKeys();
                   // tourId = -1;
                    if (rs.next()) {
                        tourId = rs.getInt(1);
                    }
                    
                    
                    //call to images
                    uploadImages(request, response, tourId, conn);
                    
                    
                    //Insert Hotel details
                    String sql = "INSERT INTO hotel (t_id, hotel_name, area) VALUES (?, ?, ?)";
                	stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, tourId);
                    stmt.setString(2, hotelName);
                    stmt.setString(3, hotelLocation);
                    
                    stmt.executeUpdate();
                    
                    //check is bus selected
                   if (isBusSelected) {
		               String sql2 = "INSERT INTO bus (t_id, bus_company, source, busTicket, arrival_time, departure_time, available_seats, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			           stmt2 = conn.prepareStatement(sql2);
			           
			           stmt2.setInt(1, tourId);
			           stmt2.setString(2, busCompany);
			           stmt2.setString(3, source);
			           stmt2.setDouble(4, busTicket);
			           stmt2.setTime(5, busArrivalTime);
			           stmt2.setTime(6, busDepartureTime);
			           stmt2.setInt(7, busSeats);
			           stmt2.setString(8, busImg);
			           rowsInserted2 = stmt2.executeUpdate();
		        
                   }
                   
                  //check is train selected
                   if (isTrainSelected) {
		               String sql3 = "INSERT INTO train (t_id, train_company, source, trainTicket, arrival_time, departure_time, available_seats, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			           stmt3 = conn.prepareStatement(sql3);
			           
			           stmt3.setInt(1, tourId);
			           stmt3.setString(2, trainCompany);
			           stmt3.setString(3, source);
			           stmt3.setDouble(4, trainTicket);
			           stmt3.setTime(5, trainArrivalTime);
			           stmt3.setTime(6, trainDepartureTime);
			           stmt3.setInt(7, trainSeats);
			           stmt3.setString(8, trainImg);
			           rowsInserted3 = stmt3.executeUpdate();

                   }
                   
                  //check is flight selected
                   if (isFlightSelected) {
		               String sql4 = "INSERT INTO flight (t_id, flight_company, source, flightTicket, arrival_time, departure_time, available_seats, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			           stmt4 = conn.prepareStatement(sql4);
			           
			           stmt4.setInt(1, tourId);
			           stmt4.setString(2, flightCompany);
			           stmt4.setString(3, source);
			           stmt4.setDouble(4, flightTicket);
			           stmt4.setTime(5, flightArrivalTime);
			           stmt4.setTime(6, flightDepartureTime);
			           stmt4.setInt(7, flightSeats);
			           stmt4.setString(8, flightImg);
			           rowsInserted4 = stmt4.executeUpdate();

                   }
                   
                   if(rowsInserted1 > 0 || rowsInserted2 > 0 || rowsInserted3 > 0 || rowsInserted4 > 0)
                	   response.sendRedirect(request.getContextPath() + "/admin/addTour.jsp?success=true");
                   else
                	   response.sendRedirect(request.getContextPath() + "/admin/addTour.jsp?error=1");
	            }	
                else{
	                response.sendRedirect(request.getContextPath() + "/admin/addTour.jsp?error=2");
	            }
        }
         catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            //request.getRequestDispatcher("/admin/addTour.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (stmt1 != null) stmt1.close();
                if (stmt2 != null) stmt2.close();
                if (stmt3 != null) stmt3.close();
                if (stmt4 != null) stmt4.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    //for single image
    private String singleImage(Part img, String uploadDir) throws IOException {
        
        // Ensure the part is not null and contains a file
        if (img == null || img.getSize() <= 0) {
            throw new IOException("No image file uploaded.");
        }

        // Get file name
        String imageFileName = Paths.get(img.getSubmittedFileName()).getFileName().toString();

        // Create directory if it does not exist
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // Define file path
        String imagePath = uploadDir + File.separator + imageFileName;

        // Save file
        try (InputStream inputStream = img.getInputStream();
             OutputStream outputStream = Files.newOutputStream(Paths.get(imagePath))) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }
        return imagePath;
    }
    
    
  //for multiple images
    private void uploadImages(HttpServletRequest request, HttpServletResponse response, int tourId, Connection conn) throws ServletException, IOException {
        String UPLOAD_DIR = "tour_uploads"; // Directory inside webapps
        String uploadPath = getServletContext().getRealPath("/") + UPLOAD_DIR;

        // Create directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Collection<Part> fileParts;
        try {
            fileParts = request.getParts(); // Get all uploaded files
        } catch (IllegalStateException e) {
            response.getWriter().println("Error retrieving files: " + e.getMessage());
            return;
        }

        for (Part filePart : fileParts) {
            if ("images".equals(filePart.getName()) && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String filePath = UPLOAD_DIR + File.separator + fileName; // Relative path

                // Save file to server
                File file = new File(uploadPath, fileName);
                try (InputStream inputStream = filePart.getInputStream();
                     OutputStream outputStream = Files.newOutputStream(file.toPath())) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                }

                // Insert relative image path into the database
                String sql = "INSERT INTO images (t_id, image_path) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, tourId);
                    stmt.setString(2, filePath);
                    stmt.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.getWriter().println("Database Error: " + e.getMessage());
                }
            }
        }
    }

    
}




//for multiple images
//private void uploadImages(HttpServletRequest request, HttpServletResponse response, int tourId, Connection conn) throws ServletException, IOException {
//  
//  String UPLOAD_DIR = ".\\tour_uploads";
//  String uploadPath = System.getProperty("user.dir") + File.separator + UPLOAD_DIR;
//
//  // Create directory if it doesn't exist
//  File uploadDir = new File(uploadPath);
//  if (!uploadDir.exists()) {
//      uploadDir.mkdirs();
//  }
//
//  Collection<Part> fileParts;
//  try {
//      fileParts = request.getParts(); // Get all uploaded files
//  } catch (IllegalStateException e) {
//      response.getWriter().println("Error retrieving files: " + e.getMessage());
//      return;
//  }
//
//  for (Part filePart : fileParts) {
//      if ("images".equals(filePart.getName()) && filePart.getSize() > 0) {
//          String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
//          String filePath = UPLOAD_DIR + File.separator + fileName; // Relative path
//
//          // Save file to server
//          File file = new File(uploadPath, fileName);
//          try (InputStream inputStream = filePart.getInputStream();
//               OutputStream outputStream = Files.newOutputStream(file.toPath())) {
//              byte[] buffer = new byte[1024];
//              int bytesRead;
//              while ((bytesRead = inputStream.read(buffer)) != -1) {
//                  outputStream.write(buffer, 0, bytesRead);
//              }
//          }
//
//          // Insert image path into the database
//          String sql = "INSERT INTO images (t_id, image_path) VALUES (?, ?)";
//          try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//              stmt.setInt(1, tourId);
//              stmt.setString(2, filePath);
//              stmt.executeUpdate();
//          } catch (SQLException e) {
//              e.printStackTrace();
//              response.getWriter().println("Database Error: " + e.getMessage());
//          }
//      }
//  }
//
//  //response.getWriter().println("Files uploaded successfully!");
//}





//for multiple images
//private void uploadImages(HttpServletRequest request, HttpServletResponse response, int tourId, Connection conn) throws ServletException, IOException {
//   
//	String UPLOAD_DIR = ".\\tour_uploads";
//	String uploadPath = System.getProperty("user.dir") + File.separator + UPLOAD_DIR;
//
//   // Create directory if it doesn't exist
//   File uploadDir = new File(uploadPath);
//   if (!uploadDir.exists()) {
//       uploadDir.mkdirs();
//   }
//
//   Collection<Part> fileParts;
//   try {
//       fileParts = request.getParts(); // Get all uploaded files
//   } catch (IllegalStateException e) {
//       response.getWriter().println("Error retrieving files: " + e.getMessage());
//       return;
//   }
//
//   List<String> imagePaths = new ArrayList<>(); // List to store image paths
//
//   for (Part filePart : fileParts) {
//       if ("images".equals(filePart.getName()) && filePart.getSize() > 0) {
//           String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
//           String filePath = UPLOAD_DIR + File.separator + fileName; // Relative path
//
//           // Save file to server
//           File file = new File(uploadPath, fileName);
//           try (InputStream inputStream = filePart.getInputStream();
//                OutputStream outputStream = Files.newOutputStream(file.toPath())) {
//               byte[] buffer = new byte[1024];
//               int bytesRead;
//               while ((bytesRead = inputStream.read(buffer)) != -1) {
//                   outputStream.write(buffer, 0, bytesRead);
//               }
//           }
//
//           // Add relative file path to list
//           imagePaths.add(filePath);
//       }
//   }
//
//   // Insert image paths into the database
//   if (!imagePaths.isEmpty()) {
//       String imagePathsString = String.join(",", imagePaths);
//
//       String sql = "INSERT INTO images (t_id, image_path) VALUES (?, ?)";
//       try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//           stmt.setInt(1, tourId);
//           stmt.setString(2, imagePathsString);
//           stmt.executeUpdate();
//       } catch (SQLException e) {
//           e.printStackTrace();
//           response.getWriter().println("Database Error: " + e.getMessage());
//       }
//   }
//
////   response.getWriter().println("Files uploaded successfully!");
//}