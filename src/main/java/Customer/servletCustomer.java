package Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/servletCustomer")
public class servletCustomer extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public servletCustomer() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String fullname = request.getParameter("fullName");
        String email = request.getParameter("email");
        String plateNo = request.getParameter("plateNo");
        String vin = request.getParameter("vin");
        String vehicleType = request.getParameter("vehicleType");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Check for null or empty parameters
        if (fullname == null || fullname.isEmpty() ||
            email == null || email.isEmpty() ||
            plateNo == null || plateNo.isEmpty() ||
            vin == null || vin.isEmpty() ||
            vehicleType == null || vehicleType.isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            
            out.println("Error: All fields are required!");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmtCustomer = null;
        PreparedStatement pstmtVehicle = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");

            // Check if the customer already exists
            if (emailExists(conn, email)) {
                out.println("Error: A customer with this email already exists.");
                return;
            }

            // Insert into customer table
            String sqlCustomer = "INSERT INTO customer (custName, custEmail, custPass, pts) VALUES (?, ?, ?, ?)";
            pstmtCustomer = conn.prepareStatement(sqlCustomer, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmtCustomer.setString(1, fullname);
            pstmtCustomer.setString(2, email);
            pstmtCustomer.setString(3, password);
            pstmtCustomer.setInt(4, 0);

            System.out.println("Executing customer insert: " + pstmtCustomer);
            pstmtCustomer.executeUpdate();

            // Retrieve generated customer ID
            String customerID = getCustomerID(conn, email);
            if (customerID == null) {
                out.println("Error: Failed to retrieve customer ID.");
                return;
            }

            System.out.println("Retrieved customer ID: " + customerID);

            // Insert into vehicle table
            String sqlVehicle = "INSERT INTO vehicle (vehPlateNo, vehType, vin, custID) VALUES (?, ?, ?, ?)";
            pstmtVehicle = conn.prepareStatement(sqlVehicle);
            pstmtVehicle.setString(1, plateNo);
            pstmtVehicle.setString(2, vehicleType);
            pstmtVehicle.setString(3, vin);
            pstmtVehicle.setString(4, customerID); // Use the retrieved customer ID

            System.out.println("Executing vehicle insert: " + pstmtVehicle);
            int rowsAffected = pstmtVehicle.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("/FuelSwift/Login/Login.jsp");
            } else {
                out.println("Error: Vehicle data was not inserted.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            try {
                if (pstmtCustomer != null) pstmtCustomer.close();
                if (pstmtVehicle != null) pstmtVehicle.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        out.close();
    }

    private boolean emailExists(Connection conn, String email) throws SQLException {
        String sql = "SELECT COUNT(*) AS count FROM customer WHERE custEmail = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next() && rs.getInt("count") > 0) {
                    return true;
                }
            }
        }
        return false;
    }

    private String getCustomerID(Connection conn, String email) throws SQLException {
        String sql = "SELECT custID FROM customer WHERE custEmail = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("custID");
                }
            }
        }
        return null;
    }
}
