package Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/servletCustomer")
public class servletCustomer extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("fullName");
        String email = request.getParameter("email");
        String plateNo = request.getParameter("plateNo");
        String geranNo = request.getParameter("vin");
        String vehicleType = request.getParameter("vehicleType");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        Customer customer = new Customer(0, name, email, plateNo, geranNo, vehicleType, password, confirmPassword);
        CustomerDAO customerDAO = new CustomerDAO();

        try {
            customerDAO.saveCustomer(customer);
            response.sendRedirect("Login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Register.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}

