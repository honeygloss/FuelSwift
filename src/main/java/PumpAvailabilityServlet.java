import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/FuelSwift/PumpAvailability")
public class PumpAvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Assuming these are the available pump numbers
        String availablePumps = "1,2,3,4,5,6";

        // Set the response type to plain text
        response.setContentType("text/plain");
        
        // Write the available pumps string to the response
        response.getWriter().write(availablePumps);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // You can call doGet to handle POST requests as well
        doGet(request, response);
    }
}