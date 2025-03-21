package com.mh.frontend;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.mh.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet({"/LoginUser", "/RegisterUser"})
public class LoginRegister extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        System.out.println(action);
        if (action.equals("/LoginUser")) {
            loginUser(request, response);
        } else if (action.equals("/RegisterUser")) {
            registerUser(request, response);
        }
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password1");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                
                session.setAttribute("uid", rs.getInt("user_id")); 
                session.setAttribute("user", rs.getString("firstname"));   
                session.setAttribute("lastname", rs.getString("lastname"));   
                response.sendRedirect("./user/index.jsp");  //redirect to another page

                //request.getRequestDispatcher(request.getContextPath() + "/welcome.jsp?success=true").forward(request, response);
                //request.getRequestDispatcher("/user/loginRegister.jsp?success=true").forward(request, response);
               //response.sendRedirect(request.getContextPath() + "/welcome.jsp");
            } else {
                //response.sendRedirect("/user/loginRegister.jsp?error=Invalid credentials");
            	request.setAttribute("errorMessage", "Invalid email or password.");           
                request.getRequestDispatcher("./user/loginRegister.jsp").forward(request, response);        
            }
        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("errorMessage", "Database connection error.");                     
            request.getRequestDispatcher("./user/loginRegister.jsp").forward(request, response);
        
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password2");
        String question = request.getParameter("question");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (firstname, lastname, phone, email, password, question) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, firstname);
            stmt.setString(2, lastname);
            stmt.setString(3, phone);
            stmt.setString(4, email);
            stmt.setString(5, password);
            stmt.setString(6, question);

            int rowsInserted = stmt.executeUpdate();
            
            if (rowsInserted > 0) {
            	System.out.println("Rows inserted: " + rowsInserted);
                //response.sendRedirect("./user/loginRegister.jsp?success=Account created successfully"); /////redirect to another page
                response.sendRedirect("./user/index.jsp");
            
            } else {
                //response.sendRedirect("./user/loginRegister.jsp?error=Registration failed");
                request.setAttribute("errorMessage", "Registration failed!!!.");                 
                request.getRequestDispatcher("./user/loginRegister.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            //response.sendRedirect("./user/loginRegister.jsp?error=Something went wrong");
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("./user/loginRegister.jsp").forward(request, response);
        }
    }
}

