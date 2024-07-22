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
	    String userId = request.getParameter("userID");

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    PrintWriter out = response.getWriter();
	    PreparedStatement pstmtGetCustId = null;
	    PreparedStatement pstmtGetVehicleData = null;

	    try {
	        // Load JDBC driver
	        Class.forName("com.mysql.jdbc.Driver");

	        // Establish database connection
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");
	        
	        // Retrieve custID using email
	        String getCustIdSql = "SELECT custID FROM customer WHERE custEmail = ?";
	        pstmtGetCustId = conn.prepareStatement(getCustIdSql);
	        pstmtGetCustId.setString(1, userId);
	        ResultSet rsCustId = pstmtGetCustId.executeQuery();

	        String custID = null;
	        if (rsCustId.next()) {
	            custID = rsCustId.getString("custID");
	        }

	        if (custID == null) {
	            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	            out.println("Customer not found.");
	            return;
	        }

	        // Prepare SQL update statement
	        String sql = "UPDATE vehicle SET vehPlateNo = ?, vehType = ?, vin = ? WHERE vehPlateNo = ? AND custID = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, newPlateNumber);
	        pstmt.setString(2, newVehicleType);
	        pstmt.setString(3, newVIN);
	        pstmt.setString(4, plateNumBefore);
	        pstmt.setString(5, custID);

	        // Execute update
	        int rowsUpdated = pstmt.executeUpdate();

	        if (rowsUpdated > 0) {
	            // Fetch updated vehicle data
	            String getVehicleDataSql = "SELECT * FROM vehicle WHERE custID = ?";
	            pstmtGetVehicleData = conn.prepareStatement(getVehicleDataSql);
	            pstmtGetVehicleData.setString(1, custID);
	            ResultSet rsVehicleData = pstmtGetVehicleData.executeQuery();

	            // Assuming vehicleList is an ArrayList<VehicleBean>
	            ArrayList<VehicleBean> vehicleList = new ArrayList<>();
	            while (rsVehicleData.next()) {
	                VehicleBean vehicle = new VehicleBean();
	                vehicle.setPlateNumber(rsVehicleData.getString("vehPlateNo"));
	                vehicle.setVehicleType(rsVehicleData.getString("vehType"));
	                vehicle.setVin(rsVehicleData.getString("vin"));
	                // Add other properties if needed
	                vehicleList.add(vehicle);
	            }

	            // Update session attributes
	            HttpSession session = request.getSession();
	            session.setAttribute("vehicles", vehicleList);

	            // Redirect to Dashboard
	            response.sendRedirect(request.getContextPath() + "/Dashboard.jsp");
	        } else {
	            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	            out.println("Failed to update vehicle.");
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
