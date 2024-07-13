package Customer;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Customer.Customer;

/**
 * Servlet implementation class custInfoServlet
 */
@WebServlet("/custInfoServlet")
public class custInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public custInfoServlet() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		 String customerId = request.getParameter("id");

	        if (customerId == null || customerId.isEmpty()) {
	            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Customer ID is missing");
	            return;
	        }

	        Customer customer = getCustomerById(customerId);

	        if (customer == null) {
	            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
	            return;
	        }

	        request.setAttribute("customer", customer);
	        request.getRequestDispatcher("custInfo.jsp").forward(request, response);
	}

	private Customer getCustomerById(String customerId) {
        Customer customer = null;
        String query = "SELECT * FROM customer WHERE id = ?";

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

        	preparedStatement.setString(1, customerId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    customer = new Customer(
                        resultSet.getString("id"),
                        resultSet.getString("name"),
                        resultSet.getString("email"),
                        resultSet.getString("plateNo"),
                        resultSet.getString("geranNo"),
                        resultSet.getString("vehicleType"),
                        resultSet.getString("password"),
                        resultSet.getString("confirmPassword"),
                        resultSet.getString("gender"),
                        resultSet.getString("phoneNo")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customer;
    }
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
