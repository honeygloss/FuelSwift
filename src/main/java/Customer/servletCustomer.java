package Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/servletCustomer")
public class servletCustomer extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public servletCustomer() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        //String idStr = request.getParameter("id");
        String name = request.getParameter("fullName");
        String email = request.getParameter("email");
        String plateNo = request.getParameter("plateNo");
        String geranNo = request.getParameter("vin");
        String vehicleType = request.getParameter("vehicleType");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Check for null or empty parameters
        if (name == null || name.isEmpty() ||
            email == null || email.isEmpty() ||
            plateNo == null || plateNo.isEmpty() ||
            geranNo == null || geranNo.isEmpty() ||
            vehicleType == null || vehicleType.isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            
            out.println("Error: All fields are required!");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            //int id = Integer.parseInt(idStr); // Parse ID after null check

            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuelswift", "root", "root");
            ps = con.prepareStatement("INSERT INTO customer (fullName, email, plateNo, geranNo, vehicleType, password, confirmPassword) VALUES (?, ?, ?, ?, ?, ?, ?)");

            
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, plateNo);
            ps.setString(4, geranNo);
            ps.setString(5, vehicleType);
            ps.setString(6, password);
            ps.setString(7, confirmPassword);

            ps.executeUpdate();
            response.sendRedirect("Login.jsp");
        } catch (NumberFormatException e) {
            out.println("Error: ID must be a valid integer.");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        out.close();
    }
}
