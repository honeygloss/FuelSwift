import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class CustomerDAO {
	 private String jdbcURL = "jdbc:mysql://localhost:3306/yourdatabase";
	    private String jdbcUsername = "root";
	    private String jdbcPassword = "password";

	    private static final String SELECT_ALL_CUSTOMERS = "SELECT * FROM customers";

	    public CustomerDAO() {}

	    protected Connection getConnection() {
	        Connection connection = null;
	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } catch (ClassNotFoundException e) {
	            e.printStackTrace();
	        }
	        return connection;
	    }

	    public List<Customer> selectAllCustomers() {
	        List<Customer> customers = new ArrayList<>();
	        try (Connection connection = getConnection();
	             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_CUSTOMERS);) {
	            ResultSet rs = preparedStatement.executeQuery();
	            while (rs.next()) {
	                int id = rs.getInt("id");
	                String name = rs.getString("name");
	                String email = rs.getString("email");
	                customers.add(new Customer(id, name, email));
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return customers;
	    }
	}