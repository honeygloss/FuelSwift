import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/TransactionHistoryServlet")
public class TransactionHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerId = request.getParameter("customerId");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        ArrayList<Transaction> transactions = new ArrayList<>();

        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            String query = "SELECT * FROM TRANSACTION WHERE CUSTOMER_ID = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, customerId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setTransactionId(rs.getString("TRANSACTION_ID"));
                transaction.setDate(rs.getString("TRANSACTION_DATE"));
                transaction.setAmount(rs.getDouble("TOTAL_PYMT"));
                transactions.add(transaction);
            }

            HttpSession session = request.getSession();
            session.setAttribute("transactions", transactions);

            response.sendRedirect("Home.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.html");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
