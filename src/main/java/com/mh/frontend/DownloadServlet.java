package com.mh.frontend;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.*;

@WebServlet("/DownloadServlet")
public class DownloadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "C:/uploads";
    
    // List of allowed file extensions (modify as needed)
    private static final String[] ALLOWED_EXTENSIONS = {".txt", ".pdf", ".docx"};

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fileName = request.getParameter("filename"); // Match case with JSP parameter
        if (fileName == null || fileName.isEmpty()) {
            sendError(response, "Invalid file name", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            // Security checks
            if (!isValidFileName(fileName)) {
                sendError(response, "Invalid file name format", HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            Path filePath = Paths.get(UPLOAD_DIR, fileName).normalize();
            
            // Verify the file is within the allowed directory
            if (!filePath.startsWith(Paths.get(UPLOAD_DIR).normalize())) {
                sendError(response, "Access denied", HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            File file = filePath.toFile();
            
            if (!file.exists()) {
                sendError(response, "File not found", HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Set response headers
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"" + file.getName() + "\"");
            response.setContentLength((int) file.length());

            // Stream the file using NIO
            try (InputStream in = Files.newInputStream(filePath);
                 OutputStream out = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
            
        } catch (InvalidPathException e) {
            sendError(response, "Invalid file path", HttpServletResponse.SC_BAD_REQUEST);
        } catch (SecurityException e) {
            sendError(response, "Access denied", HttpServletResponse.SC_FORBIDDEN);
        } catch (Exception e) {
            sendError(response, "Server error", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private boolean isValidFileName(String fileName) {
        // Check for path traversal attempts
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            return false;
        }
        
        // Check file extension
        String lowerFileName = fileName.toLowerCase();
        for (String ext : ALLOWED_EXTENSIONS) {
            if (lowerFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    private void sendError(HttpServletResponse response, String message, int code) 
            throws IOException {
        response.sendError(code, message);
        log("Download error [" + code + "]: " + message);
    }
}