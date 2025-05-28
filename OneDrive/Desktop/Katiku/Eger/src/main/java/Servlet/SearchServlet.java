package Servlet;

import Util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 5621927009420502014L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the search query from the request parameter
        String query = request.getParameter("q");
        if (query == null || query.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Set the response content type to HTML
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DBConnection.getConnection()) {
            // Query to search doctors by name or specialization
            String sql = "SELECT d.Name, s.Specialization_Name " +
                         "FROM Doctor d JOIN Specialization s ON d.Specialization_ID = s.Specialization_ID " +
                         "WHERE d.Name LIKE ? OR s.Specialization_Name LIKE ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                String searchTerm = "%" + query.trim() + "%";
                stmt.setString(1, searchTerm);
                stmt.setString(2, searchTerm);

                ResultSet rs = stmt.executeQuery();

                // Build HTML response
                PrintWriter out = response.getWriter();
                if (!rs.isBeforeFirst()) { // No results found
                    out.print("<li>No results found.</li>");
                } else {
                    while (rs.next()) {
                        String doctorName = rs.getString("Name");
                        String specialization = rs.getString("Specialization_Name");
                        out.print(String.format("<li>%s (%s)</li>", doctorName, specialization));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}