import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from request
        String customerId = request.getParameter("customerId");
        String paymentMethod = request.getParameter("cardType");
        String cardNumber = request.getParameter("cardNumber");
        String cardCvv = request.getParameter("cvv");
        String cardExpiryDate = request.getParameter("expiryDate");
        String cardHolderName = request.getParameter("cardHolder");
        String transactionDate = request.getParameter("transactionDate");
        String time = request.getParameter("timeFuel");
        String date = request.getParameter("dateFuel");
        String psID = request.getParameter("psID");
        String ppID = request.getParameter("ppID");

        double amount = Double.parseDouble(request.getParameter("amount"));
        double litres = Double.parseDouble(request.getParameter("litres"));
        double totalPayment = Double.parseDouble(request.getParameter("totAmount"));
        int pointsEarned = Integer.parseInt(request.getParameter("pointsEarned"));
        int pointsRedeemed = Integer.parseInt(request.getParameter("pointsRed"));

        Connection conn = null;
        PreparedStatement pstmtTransaction = null;
        PreparedStatement pstmtRefuelVehicle = null;
        PreparedStatement pstmtCustomer = null;

        try {
            // Establish database connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Insert into TRANSACTION table
            String insertTransactionSql = "INSERT INTO transaction (transactionID, paymentMethod, cardNum, cardCVV, cardExpiryDate, cardHolderName, transactionDate) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmtTransaction = conn.prepareStatement(insertTransactionSql);
            String transactionId = "SFS" + UUID.randomUUID().toString().replaceAll("-", "").toUpperCase().substring(0, 7);
            pstmtTransaction.setString(1, transactionId);
            pstmtTransaction.setString(2, paymentMethod);
            pstmtTransaction.setString(3, cardNumber);
            pstmtTransaction.setString(4, cardCvv);
            pstmtTransaction.setString(5, cardExpiryDate);
            pstmtTransaction.setString(6, cardHolderName);
            pstmtTransaction.setString(7, transactionDate);
            pstmtTransaction.executeUpdate();

            // Insert into REFUEL_VEHICLE table
            String insertRefuelVehicleSql = "INSERT INTO refuelvehicle (rvID, amount, litres, totalPymt, ptsEarned, ptsRedeemed, time, date, custID, transactionID, psID, ppID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmtRefuelVehicle = conn.prepareStatement(insertRefuelVehicleSql);
            String rvId = UUID.randomUUID().toString().replaceAll("-", "").toUpperCase().substring(0, 7);
            pstmtRefuelVehicle.setString(1, rvId);
            pstmtRefuelVehicle.setDouble(2, amount);
            pstmtRefuelVehicle.setDouble(3, litres);
            pstmtRefuelVehicle.setDouble(4, totalPayment);
            pstmtRefuelVehicle.setInt(5, pointsEarned);
            pstmtRefuelVehicle.setInt(6, pointsRedeemed);
            pstmtRefuelVehicle.setString(7, time);
            pstmtRefuelVehicle.setString(8, date);
            pstmtRefuelVehicle.setString(9, customerId);
            pstmtRefuelVehicle.setString(10, transactionId);
            pstmtRefuelVehicle.setString(11, psID);
            pstmtRefuelVehicle.setString(12, ppID);
            pstmtRefuelVehicle.executeUpdate();

            // Update CUSTOMER table
            String updateCustomerSql = "UPDATE customer SET pts = pts + ? - ? WHERE custID = ?";
            pstmtCustomer = conn.prepareStatement(updateCustomerSql);
            pstmtCustomer.setInt(1, pointsEarned);
            pstmtCustomer.setInt(2, pointsRedeemed);
            pstmtCustomer.setString(3, customerId);
            pstmtCustomer.executeUpdate();

            // Redirect to success page or send success response
            response.sendRedirect("/HomePage/Home.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle error, redirect to error page or send error response
            response.sendRedirect("/HomePage/Home.jsp");
        } finally {
            try {
                if (pstmtTransaction != null) pstmtTransaction.close();
                if (pstmtRefuelVehicle != null) pstmtRefuelVehicle.close();
                if (pstmtCustomer != null) pstmtCustomer.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
