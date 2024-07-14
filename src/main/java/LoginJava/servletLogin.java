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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

//@WebServlet("/loginServlet")
public class servletLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");
            ps = con.prepareStatement("SELECT * FROM customer WHERE custEmail = ? AND custPassword = ?");
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                
                String fullName = rs.getString("fullname");

                session.setAttribute("fullName", fullName);
                session.setAttribute("email", email);
                session.setAttribute("userType", "customer");
                
                // Add cookies
                Cookie emailCookie = new Cookie("email", email);
                emailCookie.setMaxAge(60*60*24); // 1 day
                response.addCookie(emailCookie);

                Cookie fullNameCookie = new Cookie("fullName", fullName);
                fullNameCookie.setMaxAge(60*60*24); // 1 day
                response.addCookie(fullNameCookie);

                Cookie userTypeCookie = new Cookie("userType", "customer");
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
                    HttpSession session = request.getSession();
                    session.setAttribute("user", email);

                    String staffName = rs.getString("fullname");
                    String staffEmail = rs.getString("email");

                    session.setAttribute("staffName", staffName);
                    session.setAttribute("staffEmail", staffEmail);
                    session.setAttribute("userType", "staff");
                    
                 // Add cookies
                    Cookie emailCookie = new Cookie("email", staffEmail);
                    emailCookie.setMaxAge(60*60*24); // 1 day
                    response.addCookie(emailCookie);

                    Cookie staffNameCookie = new Cookie("fullName", staffName);
                    staffNameCookie.setMaxAge(60*60*24); // 1 day
                    response.addCookie(staffNameCookie);

                    Cookie userTypeCookie = new Cookie("userType", "staff");
                    userTypeCookie.setMaxAge(60*60*24); // 1 day
                    response.addCookie(userTypeCookie);
                    
                 // Get top pump stations sales by month
                    Map<String, Map<String, Double>> topPumpStationsByMonth = getTopPumpStationsByMonth(con);
                    session.setAttribute("topPumpStationsByMonth", topPumpStationsByMonth);

                    // Get weekly total payments by month
                    Map<String, Map<Integer, Double>> weeklyTotalByMonth = getWeeklyTotalPaymentsByMonth(con);
                    session.setAttribute("weeklyTotalByMonth", weeklyTotalByMonth);

                    String contextPath = request.getContextPath();
                    response.sendRedirect(contextPath + "/HomePage/home.jsp"); // Redirect to staff home page
                } else {
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
}
