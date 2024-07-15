package StaffJava;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import Customer.Customer;
import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/staffDashboard")
public class staffDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final String jdbcUrl = "jdbc:mysql://localhost:3306/fuelswift";
    private final String jdbcUser = "root";
    private final String jdbcPassword = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        switch (action) {
            case "customers":
                showCustomers(request, response);
                break;
            case "transactions":
                showTransactions(request, response);
                break;
            case "reports":
                showReports(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
        
        String staffID = (String) session.getAttribute("staffID");
        
        if (staffID != null) {
            setStaffName(request, staffID);
        }
        
        setDashboardMetrics(session);
        RequestDispatcher dispatcher = request.getRequestDispatcher("staffDashboard.jsp");
        dispatcher.forward(request, response);
    }
    
    private void setStaffName(HttpServletRequest request, String staffID) {
        try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
             PreparedStatement preparedStatement = connection.prepareStatement("SELECT * FROM staff WHERE staffID = ?")) {
            preparedStatement.setString(1, staffID);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                String staffName = rs.getString("fullName");
                request.setAttribute("staffName", staffName);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void setDashboardMetrics(HttpSession session) {
        session.setAttribute("noTransaction", String.valueOf(getNumberOfTransactions()));
        session.setAttribute("noCust", String.valueOf(getNumberOfCustomers()));
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch additional dashboard data if needed
        request.getRequestDispatcher("staffDashboard.jsp").forward(request, response);
    }

    private void showCustomers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<Customer> customers = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
            String query = "SELECT custID, custName, custEmail, pts, gender, phoneNo FROM customer";
            
            try (PreparedStatement statement = connection.prepareStatement(query);
                 ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                	Customer customer = new Customer();
                    customer.setId(resultSet.getString("custID"));
                    customer.setName(resultSet.getString("custName"));
                    customer.setEmail(resultSet.getString("custEmail"));
                    customer.setGender(resultSet.getString("gender"));
                    customer.setPoints(resultSet.getInt("pts"));
                    customers.add(customer);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("customers", customers);
        request.getRequestDispatcher("staffDashboard.jsp?action=customers").forward(request, response);
        
        
    }

    private void showTransactions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<String> transId = new ArrayList<>();
        ArrayList<String> custName = new ArrayList<>();
        ArrayList<String> date = new ArrayList<>();
        ArrayList<String> time = new ArrayList<>();
        ArrayList<String> petrolStation = new ArrayList<>();
        ArrayList<String> amount = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
            String query = "SELECT rv.transactionID, c.custName, rv.date, rv.time, ps.psName, rv.amount " +
                           "FROM refuelvehicle rv " +
                           "JOIN customer c ON rv.custID = c.custID " +
                           "JOIN petrolstation ps ON rv.psID = ps.psID " +
                           "JOIN transaction t ON rv.transactionID = t.transactionID";
            
            try (PreparedStatement statement = connection.prepareStatement(query);
                 ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    transId.add(resultSet.getString("transactionID"));
                    custName.add(resultSet.getString("custName"));
                    date.add(resultSet.getString("date"));
                    time.add(resultSet.getString("time"));
                    petrolStation.add(resultSet.getString("psName"));
                    amount.add(resultSet.getString("amount"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("transId", transId);
        request.setAttribute("custName", custName);
        request.setAttribute("date", date);
        request.setAttribute("time", time);
        request.setAttribute("petrolStation", petrolStation);
        request.setAttribute("amount", amount);
        request.getRequestDispatcher("staffDashboard.jsp?action=transactions").forward(request, response);
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	ArrayList<String> pumpStation = new ArrayList<>();
        ArrayList<Integer> countPump = new ArrayList<>();
        ArrayList<Integer> totalAmount = new ArrayList<>();
        ArrayList<String> dateTransaction = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
            // Query for top 5 pump stations
        	String topPumpStationsQuery = "SELECT ps.psName AS pump_station, SUM(rv.amount) AS total_sales " +
                    					  "FROM refuelvehicle rv " +
                    					  "JOIN petrolstation ps ON rv.psID = ps.psID " +
                    					  "WHERE YEAR(rv.date) = YEAR(CURDATE()) " +
                    					  "GROUP BY ps.psName, MONTH(rv.date) " +
                    					  "ORDER BY total_sales DESC " +
                    					  "LIMIT 5";


            try (PreparedStatement statement = connection.prepareStatement(topPumpStationsQuery);
                 ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                	pumpStation.add(resultSet.getString("pump_station"));
                    countPump.add(resultSet.getInt("total_sales"));
                }
            }

            // Query for purchase and sales orders
            String salesOrdersQuery = "SELECT SUM(rv.amount) AS totalAmount, DATE_FORMAT(rv.date, '%Y-%u') AS week " +
                    				  "FROM refuelvehicle rv " +
                    				  "WHERE MONTH(rv.date) = MONTH(CURDATE()) " +
                    				  "GROUP BY week";

            try (PreparedStatement statement = connection.prepareStatement(salesOrdersQuery);
                 ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    totalAmount.add(resultSet.getInt("totalAmount"));
                    dateTransaction.add(resultSet.getString("week"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("pumpStation", pumpStation);
        request.setAttribute("countPump", countPump);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("dateTransaction", dateTransaction);
        request.getRequestDispatcher("staffDashboard.jsp?action=reports").forward(request, response);
    }
    
    private int getNumberOfTransactions() {
        int noTrans = 0;
        String query = "SELECT COUNT(*) FROM transaction"; // Adjust table name and query as needed

        try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            if (resultSet.next()) {
                noTrans = resultSet.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return noTrans;
    }

    private int getNumberOfCustomers() {
        int noCust = 0;
        String query = "SELECT COUNT(*) FROM customer"; // Adjust table name and query as needed

        try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            if (resultSet.next()) {
                noCust = resultSet.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return noCust;
    }

}

