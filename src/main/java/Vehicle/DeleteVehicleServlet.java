package Vehicle;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/DeleteVehicleServlet")
public class DeleteVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database URL, username, and password (Update these as per your database configuration)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from request
        String plateNumDelete = request.getParameter("plateNumDelete");
        String userId = request.getParameter("userId");

        Connection conn = null;
        PreparedStatement pstmt = null;
        PrintWriter out = response.getWriter();
        PreparedStatement pstmtGetCustId = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            // Establish database connection
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");

            // Step 1: Retrieve custID using email
            String getCustIdSql = "SELECT custID FROM customer WHERE custEmail = ?";
            pstmtGetCustId = conn.prepareStatement(getCustIdSql);
            pstmtGetCustId.setString(1, userId);
            pstmtGetCustId.execute();

            String custID = null;
            try (ResultSet rs = pstmtGetCustId.getResultSet()) {
                if (rs.next()) {
                    custID = rs.getString("custID");
                }
            }

            if (custID == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Customer not found.");
                return;
            }

            // Prepare SQL delete statement
            String sql = "DELETE FROM vehicle WHERE vehPlateNo = ? AND custID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, plateNumDelete);
            pstmt.setString(2, custID);

            // Execute delete
            int rowsDeleted = pstmt.executeUpdate();

            // Set response content type
            response.setContentType("text/html");

            if (rowsDeleted > 0) {
                // Fetch updated vehicle list and update session
                HttpSession session = request.getSession();
                ArrayList<VehicleBean> vehicleList = getVehicles(custID);
                session.setAttribute("vehicles", vehicleList);

                // Send success response
                response.setStatus(HttpServletResponse.SC_OK);
                out.println("Vehicle deleted successfully.");
                String contextPath = request.getContextPath();
                response.sendRedirect(contextPath + "/Dashboard.jsp");
            } else {
                // Send failure response
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("Failed to delete vehicle.");
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

    // Method to fetch updated vehicle list
    private ArrayList<VehicleBean> getVehicles(String custID) {
        ArrayList<VehicleBean> vehicleList = new ArrayList<>();

        String query = "SELECT vehPlateNo, vehType, vin FROM vehicle WHERE custID = ?";

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");
             PreparedStatement statement = connection.prepareStatement(query)) {

            // Set the custID parameter
            statement.setString(1, custID);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    VehicleBean vehicle = new VehicleBean();
                    vehicle.setPlateNumber(resultSet.getString("vehPlateNo"));
                    vehicle.setVehicleType(resultSet.getString("vehType"));
                    vehicle.setVin(resultSet.getString("vin"));
                    vehicleList.add(vehicle);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicleList;
    }
}
