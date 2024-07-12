import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/Transaction/transactionServlet")
public class TransactionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Extract data from the request
        String pumpNum = request.getParameter("pumpNum");
        String currentPts = request.getParameter("currentPts");
        String totAmount = request.getParameter("totAmount");
        String amount = request.getParameter("amount");
        String locNum = request.getParameter("locNum");
        String transactionId = request.getParameter("transactionId");
        String pointsEarned = request.getParameter("pointsEarned");
        String points = request.getParameter("points");
        String litres = request.getParameter("litres");
        String dateFuel = request.getParameter("dateFuel");
        String cardType = request.getParameter("cardType");
        String cardNumber = request.getParameter("cardNumber");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");
        String cardHolder = request.getParameter("cardHolder");

        // Print the received data (for debugging purposes)
        System.out.println("Received transaction data:");
        System.out.println("Pump Number: " + pumpNum);
        System.out.println("Current Points: " + currentPts);
        System.out.println("Total Amount: " + totAmount);
        System.out.println("Amount: " + amount);
        System.out.println("Location Number: " + locNum);
        System.out.println("Transaction ID: " + transactionId);
        System.out.println("Points Earned: " + pointsEarned);
        System.out.println("Points: " + points);
        System.out.println("Litres: " + litres);
        System.out.println("Date Fuel: " + dateFuel);
        System.out.println("Card Type: " + cardType);
        System.out.println("Card Number: " + cardNumber);
        System.out.println("Expiry Date: " + expiryDate);
        System.out.println("CVV: " + cvv);
        System.out.println("Card Holder: " + cardHolder);

        
        // Send a response back to the client
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("<p>Transaction successful</p>");
    }
}
