package UpdateProfile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    // Retrieve form parameters
	    String fullName = request.getParameter("custName");
	    String email = request.getParameter("custEmail");
	    String gender = request.getParameter("gender");
	    String phoneNo = request.getParameter("phoneNo");

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    PrintWriter out = response.getWriter();

	    try {
	        // Load JDBC driver
	        Class.forName("com.mysql.jdbc.Driver");

	        // Establish database connection
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");

	        // Prepare SQL update statement
	        String sql = "UPDATE customer SET custName = ?, gender = ?, phoneNo = ? WHERE custEmail = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, fullName);
	        pstmt.setString(2, gender);
	        pstmt.setString(3, phoneNo);
	        pstmt.setString(4, email);

	        // Execute update
	        int rowsUpdated = pstmt.executeUpdate();

	        // Set response content type
	        response.setContentType("text/html");

	        if (rowsUpdated > 0) {
	            // Update session attributes
	            HttpSession session = request.getSession();
	            session.setAttribute("fullName", fullName);
	            session.setAttribute("gender", gender);
	            session.setAttribute("phoneNo", phoneNo);

	            // Send success response
	            String contextPath = request.getContextPath();
	            response.sendRedirect(contextPath + "/Dashboard.jsp");
	        } else {
	            // Send failure response
	            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	            out.println("Failed to update profile information.");
	            String contextPath = request.getContextPath();
	            response.sendRedirect(contextPath + "/Dashboard.jsp");
	        }
	    } catch (ClassNotFoundException | SQLException e) {
	        e.printStackTrace();
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        out.println("Internal server error: " + e.getMessage());
	    } finally {
	        // Clean up resources
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	            if (out != null) out.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
}
