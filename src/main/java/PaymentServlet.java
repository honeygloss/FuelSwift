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
        String paymentMethod = request.getParameter("paymentMethod");
        String cardNumber = request.getParameter("cardNumber");
        String cardCvv = request.getParameter("cardCvv");
        String cardExpiryDate = request.getParameter("cardExpiryDate");
        String cardHolderName = request.getParameter("cardHolderName");
        String transactionDate = request.getParameter("transactionDate");

        double amount = Double.parseDouble(request.getParameter("amount"));
        double litres = Double.parseDouble(request.getParameter("litres"));
        double totalPayment = Double.parseDouble(request.getParameter("totalPayment"));
        int pointsEarned = Integer.parseInt(request.getParameter("pointsEarned"));
        int pointsRedeemed = Integer.parseInt(request.getParameter("pointsRedeemed"));

        Connection conn = null;
        PreparedStatement pstmtTransaction = null;
        PreparedStatement pstmtRefuelVehicle = null;
        PreparedStatement pstmtCustomer = null;

        try {
            // Establish database connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Insert into TRANSACTION table
            String insertTransactionSql = "INSERT INTO TRANSACTION (TRANSACTION_ID, PAYMENT_METHOD, CARD_NUM, CARD_CVV, CARD_EXPIRYDATE, CARDHOLDER_NAME, TRANSACTION_DATE) VALUES (?, ?, ?, ?, ?, ?, ?)";
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
            String insertRefuelVehicleSql = "INSERT INTO REFUEL_VEHICLE (AMOUNT, LITRES, TOTAL_PYMT, PTS_EARNED, PTS_REDEEMED) VALUES (?, ?, ?, ?, ?)";
            pstmtRefuelVehicle = conn.prepareStatement(insertRefuelVehicleSql);
            pstmtRefuelVehicle.setDouble(1, amount);
            pstmtRefuelVehicle.setDouble(2, litres);
            pstmtRefuelVehicle.setDouble(3, totalPayment);
            pstmtRefuelVehicle.setInt(4, pointsEarned);
            pstmtRefuelVehicle.setInt(5, pointsRedeemed);
            pstmtRefuelVehicle.executeUpdate();

            // Update CUSTOMER table
            String updateCustomerSql = "UPDATE CUSTOMER SET PTS = PTS + ? - ? WHERE CUST_ID = ?";
            pstmtCustomer = conn.prepareStatement(updateCustomerSql);
            pstmtCustomer.setInt(1, pointsEarned);
            pstmtCustomer.setInt(2, pointsRedeemed);
            pstmtCustomer.setString(3, customerId);
            pstmtCustomer.executeUpdate();

            // Redirect to success page or send success response
            response.sendRedirect("success.html");
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle error, redirect to error page or send error response
            response.sendRedirect("error.html");
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
