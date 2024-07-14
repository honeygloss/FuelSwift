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

@WebServlet("/AddVehicleServlet")
public class AddVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database URL, username, and password (Update these as per your database configuration)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from request
        String plateNumber = request.getParameter("addPlateNumber");
        String vehicleType = request.getParameter("addVehicleType");
        String vin = request.getParameter("addVIN");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Prepare SQL insert statement
            String sql = "INSERT INTO vehicle (vehPlateNo, vehType, vin) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, plateNumber);
            pstmt.setString(2, vehicleType);
            pstmt.setString(3, vin);

            // Execute insert
            int rowsInserted = pstmt.executeUpdate();

            // Set response content type
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();

            if (rowsInserted > 0) {
                // Send success response
                response.setStatus(HttpServletResponse.SC_OK);
                out.println("Vehicle added successfully.");
            } else {
                // Send failure response
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Failed to add vehicle.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Internal server error: " + e.getMessage());
        } finally {
            // Clean up resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
