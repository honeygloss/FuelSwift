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

        // Set available pumps as a request attribute
        request.setAttribute("availablePumps", availablePumps);

        // Forward the request to petrolPump.jsp
        request.getRequestDispatcher("/petrolPump.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // You can call doGet to handle POST requests as well
        doGet(request, response);
    }
}
