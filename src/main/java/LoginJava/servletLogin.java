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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import Customer.Customer;
import RefuelVehicle.refuelVehicleBean;

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

                session.setAttribute("fullName", fullName);
                session.setAttribute("email", email);
                session.setAttribute("userType", "customer");
                
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
                response.sendRedirect(contextPath + "/HomePage/Home.jsp"); // Redirect to a welcome page or dashboard
            } else {
            	// If not found in customer table, check the staff table
                ps = con.prepareStatement("SELECT * FROM staff WHERE email = ? AND password = ?");
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
                   
                    Map<String, ArrayList<String>> transactions = getTransactions();
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
                    session.setAttribute("pumpStation", pumpData.get("pumpStation"));
                    session.setAttribute("countPump", pumpData.get("countPump"));
                    
                 // Get weekly total payments and dates
                    Map<String, ArrayList<?>> weeklyData = getWeeklyData();
                    session.setAttribute("totalAmount", weeklyData.get("totalAmount"));
                    session.setAttribute("dateTransaction", weeklyData.get("dateTransaction"));
                    /*
                 // Get top pump stations sales by month
                    Map<String, Map<String, Double>> topPumpStationsByMonth = getTopPumpStationsByMonth(con);
                    session.setAttribute("topPumpStationsByMonth", topPumpStationsByMonth);

                    // Get weekly total payments by month
                    Map<String, Map<Integer, Double>> weeklyTotalByMonth = getWeeklyTotalPaymentsByMonth(con);
                    session.setAttribute("weeklyTotalByMonth", weeklyTotalByMonth);*/

                    String contextPath = request.getContextPath();
                    response.sendRedirect(contextPath + "/Staff/staffDashboard.jsp"); // Redirect to staff home page
                } else {
                    System.out.println("No matching user found in database.");
                    // If not found in either table, redirect to fail.jsp
                    String contextPath = request.getContextPath();
                    response.sendRedirect(contextPath + "/Login/fail.jsp");
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Login/fail.jsp");
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

    private Map<String, Map<String, Double>> getTopPumpStationsByMonth(Connection con) throws SQLException {
   	 Map<String, Map<String, Double>> pumpStationMonthlySales = new HashMap<>();
       PreparedStatement ps = con.prepareStatement(
       		"SELECT pumpStation, DATE_FORMAT(date, '%Y-%m') AS month, SUM(totalPymt) AS total " +
       		        "FROM refuelVehicle " +
       		        "GROUP BY pumpStation, month " +
       		        "ORDER BY total DESC " +
       		        "LIMIT 5"
       );
       ResultSet rs = ps.executeQuery();
       while (rs.next()) {
           String pumpStation = rs.getString("pumpStation");
           String month = rs.getString("month");
           Double total = rs.getDouble("total");

           pumpStationMonthlySales.computeIfAbsent(pumpStation, k -> new HashMap<>()).put(month, total);
       }
       rs.close();
       ps.close();
       return pumpStationMonthlySales;
   }
   
   private Map<String, Map<Integer, Double>> getWeeklyTotalPaymentsByMonth(Connection con) throws SQLException {
       Map<String, Map<Integer, Double>> weeklyTotalByMonth = new HashMap<>();
       PreparedStatement ps = con.prepareStatement(
           "SELECT DATE_FORMAT(date, '%Y-%m') AS month, WEEK(date) AS week, SUM(totalPymt) AS total " +
           "FROM refuelVehicle " +
           "GROUP BY month, week"
       );
       ResultSet rs = ps.executeQuery();
       while (rs.next()) {
           String month = rs.getString("month");
           int week = rs.getInt("week");
           double total = rs.getDouble("total");

           weeklyTotalByMonth.computeIfAbsent(month, k -> new HashMap<>()).put(week, total);
       }
       rs.close();
       ps.close();
       return weeklyTotalByMonth;
   }
   
   private Map<String, ArrayList<?>> getWeeklyData() {
       Map<String, ArrayList<?>> weeklyData = new HashMap<>();
       ArrayList<Integer> totalAmount = new ArrayList<>();
       ArrayList<String> dateTransaction = new ArrayList<>();

       try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
           String query = "SELECT SUM(totalPymt) AS totalAmount, MAX(date) AS lastDate " +
                          "FROM refuelvehicle " +
                          "GROUP BY YEARWEEK(date)";
           PreparedStatement ps = con.prepareStatement(query);
           ResultSet rs = ps.executeQuery();

           while (rs.next()) {
               totalAmount.add(rs.getInt("totalAmount"));
               dateTransaction.add(rs.getDate("lastDate").toString());
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
   
  
   
   private Map<String, ArrayList<String>> getTransactions() {
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
	    ArrayList<Integer> countPumps = new ArrayList<>();

	    try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
	        String query = "SELECT ppNum, COUNT(*) AS count FROM petrolpump GROUP BY ppNum";
	        
	        try (PreparedStatement statement = connection.prepareStatement(query);
	             ResultSet resultSet = statement.executeQuery()) {
	            while (resultSet.next()) {
	                pumpStations.add(resultSet.getString("ppNum"));
	                countPumps.add(resultSet.getInt("count"));
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
