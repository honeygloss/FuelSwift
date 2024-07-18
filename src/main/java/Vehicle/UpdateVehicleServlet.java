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

@WebServlet("/UpdateVehicleServlet")
public class UpdateVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database URL, username, and password (Update these as per your database configuration)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from request
        String newPlateNumber = request.getParameter("editPlateNumber");
        String newVehicleType = request.getParameter("editVehicleType");
        String newVIN = request.getParameter("editVIN");
        String plateNumBefore = request.getParameter("plateNumBefore");
        String plateNumberAfter = request.getParameter("plateNumberAfter");

        Connection conn = null;
        PreparedStatement pstmt = null;
        PrintWriter out = response.getWriter();

        try {
            if (newPlateNumber == null || newVehicleType == null || newVIN == null || plateNumBefore == null || plateNumberAfter == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Missing required parameters.");
                return;
            }

            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Prepare SQL update statement
            String sql = "UPDATE vehicle SET vehPlateNo = ?, vehType = ?, vin = ? WHERE vehPlateNo = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPlateNumber);
            pstmt.setString(2, newVehicleType);
            pstmt.setString(3, newVIN);
            pstmt.setString(4, plateNumBefore);

            // Execute update
            int rowsUpdated = pstmt.executeUpdate();

            // Set response content type
            response.setContentType("text/html");

            if (rowsUpdated > 0) {
                // Send success response
                response.setStatus(HttpServletResponse.SC_OK);
                out.println("Vehicle details updated successfully.");
            } else {
                // Send failure response
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Failed to update vehicle details.");
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
