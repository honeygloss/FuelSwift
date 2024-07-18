package Transaction;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

@WebServlet("/TransactionHistoryServlet")
public class TransactionHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerId = request.getParameter("customerId");

        ArrayList<TransactionHistory> transactions = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "SELECT t.transactionID, t.transactionDate, rv.amount " +
                           "FROM transaction t " +
                           "JOIN refuelvehicle rv ON t.transactionID = rv.transactionID " +
                           "WHERE t.customerID = ?";
            
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setString(1, customerId);
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        String transactionId = resultSet.getString("transactionID");
                        String transactionDate = resultSet.getString("transactionDate");
                        double amount = resultSet.getDouble("amount");

                        transactions.add(new TransactionHistory(transactionId, transactionDate, amount));
                    }
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("transactions", transactions);

            RequestDispatcher dispatcher = request.getRequestDispatcher("Home.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.html");
        }
    }
}
