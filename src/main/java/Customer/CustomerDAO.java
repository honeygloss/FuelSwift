package Customer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class CustomerDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/fuelswift";
    private String jdbcUsername = "root";
    private String jdbcPassword = "root";

    private static final String INSERT_CUSTOMERS_SQL = "INSERT INTO customers" + "  (name, email, plateNo, geranNo, vehicleType, password, confirmPassword) VALUES " +
        " (?, ?, ?, ?, ?, ?, ?);";

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

    public void saveCustomer(Customer customer) throws SQLException {
        try (Connection connection = getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(INSERT_CUSTOMERS_SQL)) {
            preparedStatement.setString(1, customer.getName());
            preparedStatement.setString(2, customer.getEmail());
            preparedStatement.setString(3, customer.getPlateNo());
            preparedStatement.setString(4, customer.getGeranNo());
            preparedStatement.setString(5, customer.getVehicleType());
            preparedStatement.setString(6, customer.getPassword());
            preparedStatement.setString(7, customer.getConfirmPassword());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

