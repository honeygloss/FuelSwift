import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

import Transaction.TransactionHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    // Retrieve parameters from request
	    String cardType = request.getParameter("cardType");
	    String cardNumber = request.getParameter("cTitle");
	    String expiryDate = request.getParameter("cExpiry");
	    String cvv = request.getParameter("cCvv");
	    String cardHolder = request.getParameter("cName");
	    String title = request.getParameter("title"); // name of the petrol station
	    String pumpNum = request.getParameter("pumpNum"); // pump number
	    String currentPtsStr = request.getParameter("currentPts");
	    String totAmountStr = request.getParameter("totAmount");
	    String pointsRedStr = request.getParameter("pointsRed");
	    String amountStr = request.getParameter("amount");
	    String locNum = request.getParameter("locNum");
	    String transactionId = request.getParameter("transactionId");
	    String pointsEarnedStr = request.getParameter("pointsEarned");
	    String pointsStr = request.getParameter("points");
	    String litresStr = request.getParameter("litres");
	    String dateFuel = request.getParameter("dateFuel");
	    String timeFuel = request.getParameter("timeFuel");
	    String userId = request.getParameter("userId");

	    // Convert necessary parameters to appropriate data types
	    int currentPts = Integer.parseInt(currentPtsStr);
	    double totAmount = Double.parseDouble(totAmountStr);
	    int pointsRed = Integer.parseInt(pointsRedStr);
	    double amount = Double.parseDouble(amountStr);
	    int pointsEarned = Integer.parseInt(pointsEarnedStr);
	    int points = Integer.parseInt(pointsStr);
	    double litres = Double.parseDouble(litresStr);

	    Connection conn = null;
	    PreparedStatement pstmtUpdateCustomer = null;
	    PreparedStatement pstmtInsertTransaction = null;
	    PreparedStatement pstmtInsertRefuelVehicle = null;
	    PreparedStatement pstmtGetCustId = null;
	    PreparedStatement pstmtGetTransactions = null;
	    PrintWriter out = response.getWriter();
	    
	    Date sqlDate = Date.valueOf(dateFuel);

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
	        
	     // The locNum is used as the row number to fetch
	        int rowNumber = Integer.parseInt(locNum); // Convert locNum to an integer

	        // SQL query to fetch the psID from the specified row number
	        String getPumpLocID = "SELECT psID FROM petrolstation LIMIT 1 OFFSET ?";

	        // Prepare the statement with the SQL query
	        PreparedStatement stmrPumpLoc = conn.prepareStatement(getPumpLocID);

	        // Set the row number (offset) in the query
	        stmrPumpLoc.setInt(1, rowNumber); // Subtract 1 because OFFSET is 0-based

	        
	        String psID = null;
	        // Execute the query and retrieve the result set
	        try (ResultSet rs = stmrPumpLoc.executeQuery()) {
	             // Variable to hold the psID value

	            // Check if the result set has any rows
	            if (rs.next()) {
	                // Get the value of the psID column
	                psID = rs.getString("psID");
	            }

	        }
	        
	        
	        
	     // The locNum is used as the row number to fetch
	        int pump = Integer.parseInt(pumpNum); // Convert locNum to an integer

	        // SQL query to fetch the psID from the specified row number
	        String getPumpNum = "SELECT ppID FROM petrolpump WHERE ppNum = ?";

	        // Prepare the statement with the SQL query
	        PreparedStatement smtPNum = conn.prepareStatement(getPumpNum);

	        smtPNum.setInt(1, pump); 

	        
	        String pumpID = null;
	        // Execute the query and retrieve the result set
	        try (ResultSet rs = smtPNum.executeQuery()) {
	             // Variable to hold the psID value

	            // Check if the result set has any rows
	            if (rs.next()) {
	                // Get the value of the psID column
	                pumpID = rs.getString("ppID");
	            }

	        }

	        // Step 1: Update customer points
	        String updateCustomerSql = "UPDATE customer SET pts = ? WHERE custID = ?";
	        pstmtUpdateCustomer = conn.prepareStatement(updateCustomerSql);
	        pstmtUpdateCustomer.setInt(1, points);
	        pstmtUpdateCustomer.setString(2, custID);
	        int rowsUpdated = pstmtUpdateCustomer.executeUpdate();
	        if (rowsUpdated == 0) {
	            throw new SQLException("Updating customer points failed, no rows affected.");
	        }

	        // Step 2: Insert into transaction table
	        String sql = "INSERT INTO transaction (transactionID, paymentMethod, cardNum, cardCVV, cardExpiryDate, cardHolderName, transactionDate) VALUES (?, ?, ?, ?, ?, ?, ?)";
	        pstmtInsertTransaction = conn.prepareStatement(sql);
	        pstmtInsertTransaction.setString(1, transactionId);
	        pstmtInsertTransaction.setString(2, cardType);
	        pstmtInsertTransaction.setString(3, cardNumber);
	        pstmtInsertTransaction.setString(4, cvv);
	        pstmtInsertTransaction.setString(5, expiryDate);
	        pstmtInsertTransaction.setString(6, cardHolder);
	        pstmtInsertTransaction.setDate(7, sqlDate);

	        rowsUpdated = pstmtInsertTransaction.executeUpdate();
	        if (rowsUpdated == 0) {
	            throw new SQLException("Inserting transaction failed, no rows affected.");
	        }

	        // Step 3: Insert into refuelvehicle table
	        String insertRefuelVehicleSql = "INSERT INTO refuelvehicle (amount, litres, totalPymt, ptsEarned, ptsRedeemed, time, date, custID, transactionID, psID, ppID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	        pstmtInsertRefuelVehicle = conn.prepareStatement(insertRefuelVehicleSql);
	        pstmtInsertRefuelVehicle.setDouble(1, amount);
	        pstmtInsertRefuelVehicle.setDouble(2, litres);
	        pstmtInsertRefuelVehicle.setDouble(3, totAmount);
	        pstmtInsertRefuelVehicle.setInt(4, pointsEarned);
	        pstmtInsertRefuelVehicle.setInt(5, pointsRed);
	        pstmtInsertRefuelVehicle.setString(6, timeFuel);
	        pstmtInsertRefuelVehicle.setDate(7, sqlDate);
	        pstmtInsertRefuelVehicle.setString(8, custID);
	        pstmtInsertRefuelVehicle.setString(9, transactionId);
	        pstmtInsertRefuelVehicle.setString(10, psID); // Assuming locNum is psID
	        pstmtInsertRefuelVehicle.setString(11, pumpID); // Assuming pumpNum is ppID

	        rowsUpdated = pstmtInsertRefuelVehicle.executeUpdate();
	        if (rowsUpdated == 0) {
	            throw new SQLException("Inserting refuel vehicle failed, no rows affected.");
	        }
	        
	     // Retrieve transaction history for the customer
            String getTransactionsSql = "SELECT t.transactionID, t.transactionDate, rv.amount "
                    + "FROM refuelvehicle rv "
                    + "JOIN transaction t ON rv.transactionID = t.transactionID "
                    + "WHERE rv.custID = ?";
            pstmtGetTransactions = conn.prepareStatement(getTransactionsSql);
            pstmtGetTransactions.setString(1, custID);

            ArrayList<TransactionHistory> transactions = new ArrayList<>();
            try (ResultSet rs = pstmtGetTransactions.executeQuery()) {
                while (rs.next()) {
                    String tId = rs.getString("transactionID");
                    String tDate = rs.getDate("transactionDate").toString();
                    Double tot = rs.getDouble("amount");

                    transactions.add(new TransactionHistory(tId, tDate, tot));
                }
            }

            // Set session attributes
            HttpSession session = request.getSession();
            session.setAttribute("transactions", transactions);
            session.setAttribute("points", points);

            // Redirect to dashboard page after successful operation
            response.sendRedirect("Dashboard.jsp");
            
	    } catch (ClassNotFoundException | SQLException e) {
	        e.printStackTrace();
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        out.println("Internal server error: " + e.getMessage());
	    } finally {
	        // Clean up resources
	        try {
	            if (pstmtUpdateCustomer != null) pstmtUpdateCustomer.close();
	            if (pstmtInsertTransaction != null) pstmtInsertTransaction.close();
	            if (pstmtInsertRefuelVehicle != null) pstmtInsertRefuelVehicle.close();
	            if (pstmtGetCustId != null) pstmtGetCustId.close();
	            if (conn != null) conn.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
}
