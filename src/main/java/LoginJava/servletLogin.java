package LoginJava;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import Customer.Customer;
import RefuelVehicle.refuelVehicleBean;
import Transaction.Transaction;
import Transaction.TransactionHistory;
import Vehicle.VehicleBean;

//@WebServlet("/loginServlet")
public class servletLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final String jdbcUrl = "jdbc:mysql://localhost:3306/fuelswift";
    private final String jdbcUser = "root";
    private final String jdbcPassword = "root";


    public servletLogin() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("Attempting login with email: " + email + " and password: " + password);

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
        	Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");
            
            System.out.println("Database connection successful.");

            ps = con.prepareStatement("SELECT * FROM customer WHERE custEmail = ? AND custPass = ?");
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                System.out.println("Customer found in database.");
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                
                String fullName = rs.getString("custName");
                String custemail = rs.getString("custEmail");
                int pts = rs.getInt("pts");
                String custID = rs.getString("custID");
                String phoneNo = rs.getString("phoneNo");
                String gender = rs.getString("gender");

                session.setAttribute("fullName", fullName);
                session.setAttribute("email", custemail);
                session.setAttribute("points", pts);
                session.setAttribute("customerId", custID);
                session.setAttribute("userType", "customer");
                session.setAttribute("phoneNo", phoneNo);
                session.setAttribute("gender", gender);
                
             // Retrieve data from session
                ArrayList<TransactionHistory> transactions = getTransactions(custID);;
                ArrayList<VehicleBean> vehicleList = getVehicles(custID) ;
                
                // Set data as request attributes
                session.setAttribute("transactions", transactions);
                session.setAttribute("vehicles", vehicleList);
                
                // Add cookies
                Cookie emailCookie = new Cookie("email", URLEncoder.encode(email, StandardCharsets.UTF_8.toString()));
                emailCookie.setMaxAge(60*60*24); // 1 day
                response.addCookie(emailCookie);

                Cookie fullNameCookie = new Cookie("fullName", URLEncoder.encode(fullName, StandardCharsets.UTF_8.toString()));
                fullNameCookie.setMaxAge(60*60*24); // 1 day
                response.addCookie(fullNameCookie);

                Cookie userTypeCookie = new Cookie("userType", URLEncoder.encode("customer", StandardCharsets.UTF_8.toString()));
                userTypeCookie.setMaxAge(60*60*24); // 1 day
                response.addCookie(userTypeCookie);
                
                String contextPath = request.getContextPath();
                response.sendRedirect(contextPath + "/Dashboard.jsp"); // Redirect to a welcome page or dashboard
            } else {
            	// If not found in customer table, check the staff table
                ps = con.prepareStatement("SELECT * FROM staff WHERE staffID = ? AND password = ?");
                ps.setString(1, email);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    System.out.println("Staff found in database.");
                    HttpSession session = request.getSession();
                    session.setAttribute("user", email);

                    String staffName = rs.getString("fullname");
                    String staffEmail = rs.getString("email");

                    session.setAttribute("staffName", staffName);
                    session.setAttribute("staffEmail", staffEmail);
                    session.setAttribute("userType", "staff");
                    
                 // Add cookies
                    Cookie emailCookie = new Cookie("email", URLEncoder.encode(staffEmail, StandardCharsets.UTF_8.toString()));
                    emailCookie.setMaxAge(60*60*24); // 1 day
                    response.addCookie(emailCookie);

                    Cookie staffNameCookie = new Cookie("fullName", URLEncoder.encode(staffName, StandardCharsets.UTF_8.toString()));
                    staffNameCookie.setMaxAge(60*60*24); // 1 day
                    response.addCookie(staffNameCookie);

                    Cookie userTypeCookie = new Cookie("userType", URLEncoder.encode("staff", StandardCharsets.UTF_8.toString()));
                    userTypeCookie.setMaxAge(60*60*24); // 1 day
                    response.addCookie(userTypeCookie);
                    
                    ArrayList<Customer> customers = getCustomers();
                    session.setAttribute("customers", customers);
                   
                    Map<String, ArrayList<String>> transactions = Transactions();
                    session.setAttribute("transId", transactions.get("transId"));
                    session.setAttribute("custName", transactions.get("custName"));
                    session.setAttribute("date", transactions.get("date"));
                    session.setAttribute("time", transactions.get("time"));
                    session.setAttribute("petrolStation", transactions.get("petrolStation"));
                    session.setAttribute("totalAmt", transactions.get("amount"));
                
                  //get number of transaction and customer
                    session.setAttribute("noTransaction", String.valueOf(getNumberOfTransactions()));
                    session.setAttribute("noCust", String.valueOf(getNumberOfCustomers()));
                    
                 // Retrieve petrol pump data and set in session
                    Map<String, ArrayList<?>> pumpData = getCountPump();
                    ArrayList<String> pumpStation = (ArrayList<String>) pumpData.get("pumpStation");
                    ArrayList<Double> countPump = (ArrayList<Double>) pumpData.get("countPump");

                    session.setAttribute("pumpStation", pumpStation);
                    session.setAttribute("countPump", countPump);
                    
                 // Get weekly total payments and dates
                    Map<String, ArrayList<?>> weeklyData = getWeeklyData();
                    session.setAttribute("totalAmount", weeklyData.get("totalAmount"));
                    session.setAttribute("dateTransaction", weeklyData.get("dateTransaction"));
                    
                    String contextPath = request.getContextPath();
                    response.sendRedirect(contextPath + "/staffDashboard.jsp"); // Redirect to staff home page
                } else {
                    System.out.println("No matching user found in database.");
                    // If not found in either table, redirect to fail.jsp
                    String contextPath = request.getContextPath();
                    response.sendRedirect(contextPath + "/fail.jsp");
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/fail.jsp");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        out.close();
    }

    
   
	private Map<String, ArrayList<?>> getWeeklyData() {
	    Map<String, ArrayList<?>> weeklyData = new HashMap<>();
	    ArrayList<Double> totalAmount = new ArrayList<>();
	    ArrayList<String> dateTransaction = new ArrayList<>();

	    
	    try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
	        String query = "SELECT DATE_FORMAT(date, '%Y-%m-%d') AS transaction_date, SUM(amount) AS total_amount " +
	                       "FROM refuelvehicle " +
	                       "GROUP BY date " +
	                       "ORDER BY date DESC";
	        PreparedStatement ps = con.prepareStatement(query);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            dateTransaction.add(rs.getString("transaction_date"));
	            totalAmount.add(rs.getDouble("total_amount"));
	        }

	        rs.close();
	        ps.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    weeklyData.put("totalAmount", totalAmount);
	    weeklyData.put("dateTransaction", dateTransaction);
	    return weeklyData;
	}

   
   private ArrayList<Customer> getCustomers() {
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

       return customers;
   }
   
   private ArrayList<VehicleBean> getVehicles(String custID) {
	    ArrayList<VehicleBean> vehicles = new ArrayList<>();

	    try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
	        String query = "SELECT vehID, vehPlateNo, vehType, vin, custID FROM vehicle WHERE custID = ?";

	        try (PreparedStatement statement = connection.prepareStatement(query)) {
	            // Set the custID parameter in the PreparedStatement
	            statement.setString(1, custID);

	            try (ResultSet resultSet = statement.executeQuery()) {
	                while (resultSet.next()) {
	                    VehicleBean vehicle = new VehicleBean();
	                    vehicle.setVehID(resultSet.getString("vehID"));
	                    vehicle.setPlateNumber(resultSet.getString("vehPlateNo"));
	                    vehicle.setVehicleType(resultSet.getString("vehType"));
	                    vehicle.setVin(resultSet.getString("vin"));
	                    vehicle.setCustID(resultSet.getString("custID"));
	                    vehicles.add(vehicle);
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return vehicles;
	}


   private ArrayList<TransactionHistory> getTransactions(String custID) {
	    ArrayList<TransactionHistory> transactions = new ArrayList<>();

	    // SQL query to join refuelvehicle with transaction based on transactionID
	    String query = "SELECT t.transactionID, t.transactionDate, rv.amount "
                + "FROM refuelvehicle rv "
                + "JOIN transaction t ON rv.transactionID = t.transactionID "
                + "WHERE rv.custID = ?";

	    try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
	         PreparedStatement statement = connection.prepareStatement(query)) {

	        // Set the custID parameter
	        statement.setString(1, custID);

	        try (ResultSet resultSet = statement.executeQuery()) {
	            while (resultSet.next()) {
	                TransactionHistory transaction = new TransactionHistory();
	                transaction.setTransactionId(resultSet.getString("transactionID"));
	                transaction.setTransactionDate(resultSet.getDate("transactionDate").toString());
	                transaction.setAmount(resultSet.getDouble("amount"));
	                transactions.add(transaction);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return transactions;
	}


   
  
   
   private Map<String, ArrayList<String>> Transactions() {
       Map<String, ArrayList<String>> transactions = new HashMap<>();
       transactions.put("transId", new ArrayList<>());
       transactions.put("custName", new ArrayList<>());
       transactions.put("date", new ArrayList<>());
       transactions.put("time", new ArrayList<>());
       transactions.put("petrolStation", new ArrayList<>());
       transactions.put("amount", new ArrayList<>());

       try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
           String query = "SELECT rv.transactionID, c.custName, rv.date, rv.time, ps.psName, rv.amount " +
                          "FROM refuelvehicle rv " +
                          "JOIN customer c ON rv.custID = c.custID " +
                          "JOIN petrolstation ps ON rv.psID = ps.psID " +
                          "JOIN transaction t ON rv.transactionID = t.transactionID";

           try (PreparedStatement statement = connection.prepareStatement(query);
                ResultSet resultSet = statement.executeQuery()) {
               while (resultSet.next()) {
                   transactions.get("transId").add(resultSet.getString("transactionID"));
                   transactions.get("custName").add(resultSet.getString("custName"));
                   transactions.get("date").add(resultSet.getString("date"));
                   transactions.get("time").add(resultSet.getString("time"));
                   transactions.get("petrolStation").add(resultSet.getString("psName"));
                   transactions.get("amount").add(resultSet.getString("amount"));
               }
           }
       } catch (Exception e) {
           e.printStackTrace();
       }

       return transactions;
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
   
   private Map<String, ArrayList<?>> getCountPump() {
	    Map<String, ArrayList<?>> pumpData = new HashMap<>();
	    ArrayList<String> pumpStations = new ArrayList<>();
	    ArrayList<Double> countPumps = new ArrayList<>();

	    try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
	    	String query = "SELECT p.psName, SUM(r.totalPymt) AS totalPayment "
	                + "FROM refuelvehicle r "
	                + "JOIN petrolstation p ON r.psID = p.psID "
	                + "GROUP BY p.psName "
	                + "ORDER BY totalPayment DESC "
	                + "LIMIT 5";


	        // Assuming the start and end dates for the month are provided
	        // You can dynamically calculate these based on the current date
	        LocalDate startDate = LocalDate.now().withDayOfMonth(1); // Start of the current month
	        LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth()); // End of the current month

	        try (PreparedStatement statement = connection.prepareStatement(query)) {
	            statement.setDate(1, java.sql.Date.valueOf(startDate));
	            statement.setDate(2, java.sql.Date.valueOf(endDate));

	            try (ResultSet resultSet = statement.executeQuery()) {
	                while (resultSet.next()) {
	                    pumpStations.add(resultSet.getString("psName"));
	                    countPumps.add(resultSet.getDouble("totalPayment"));
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    pumpData.put("pumpStation", pumpStations);
	    pumpData.put("countPump", countPumps);

	    return pumpData;
	}


}
