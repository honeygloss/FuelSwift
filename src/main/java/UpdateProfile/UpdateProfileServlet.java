package UpdateProfile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;


@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fuelswift";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("user");

        if (userEmail == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String fullName = request.getParameter("fullname");
        String gender = request.getParameter("gender");
        String phoneNo = request.getParameter("phoneNo");

        try {
            // Load the database driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the connection to the database
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String updateQuery = "UPDATE customer SET fullName = ?, gender = ?, phoneNo = ? WHERE email = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
                    stmt.setString(1, fullName);
                    stmt.setString(2, gender);
                    stmt.setString(3, phoneNo);
                    stmt.setString(4, userEmail);

                    int rowsUpdated = stmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        session.setAttribute("updateSuccess", "Profile updated successfully!");
                    } else {
                        session.setAttribute("updateError", "Profile update failed!");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                session.setAttribute("updateError", "An error occurred during the update.");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            session.setAttribute("updateError", "Database driver not found.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("updateError", "An unexpected error occurred.");
        }

        response.sendRedirect("Home.jsp");
    }
}
