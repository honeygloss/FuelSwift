package Vehicle;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteVehicleServlet")
public class DeleteVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database URL, username, and password (Update these as per your database configuration)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the plate number to delete from the request
        String plateNumDelete = request.getParameter("plateNumDelete");

        Connection conn = null;
        PreparedStatement pstmt = null;
        PrintWriter out = response.getWriter();

        try {
            if (plateNumDelete == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Missing required parameters.");
                return;
            }

            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Prepare SQL delete statement
            String sql = "DELETE FROM vehicle WHERE vehPlateNo = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, plateNumDelete);

            // Execute delete
            int rowsDeleted = pstmt.executeUpdate();

            // Set response content type
            response.setContentType("text/html");

            if (rowsDeleted > 0) {
                // Send success response
                response.setStatus(HttpServletResponse.SC_OK);
                out.println("Vehicle deleted successfully.");
                response.sendRedirect("/HomePage/Home.jsp");
            } else {
                // Send failure response
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Failed to delete vehicle.");
                response.sendRedirect("/HomePage/Home.jsp");
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
