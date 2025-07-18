package it.unisa.Controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Map;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import javax.sql.DataSource;
import it.unisa.Model.DAO.BooksDao;
import it.unisa.Model.Books;

@WebServlet("/placeorderservlet")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DataSource ds;

    // Nota: rimuoviamo cart_id e OrderItem, restano solo questi campi
    private static final String INSERT_ORDER =
        "INSERT INTO Orders(user_id, user_email, shipping_address, status, total_amount, created_at) " +
        "VALUES (?, ?, ?, 'PENDING', ?, NOW())";

    @Override
    public void init() throws ServletException {
        try {
            Context ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Database");
        } catch (NamingException e) {
            throw new ServletException("Impossibile leggere DataSource", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Recupera il carrello (map isbn→qty)
        @SuppressWarnings("unchecked")
        Map<String,Integer> cart = (Map<String,Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/all.jsp");
            return;
        }

        // Recupera dati utente e spedizione
        Integer userId = (Integer) session.getAttribute("userId"); // può essere null
        String email   = (String) session.getAttribute("email");
        String address = request.getParameter("shippingAddress");

        // Calcola totale
        BooksDao bookDao = new BooksDao(ds);
        BigDecimal total = cart.entrySet().stream()
            .map(e -> {
                Books b = bookDao.findByIsbn(e.getKey());
                return b.getPrice().multiply(BigDecimal.valueOf(e.getValue()));
            })
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        
        try (Connection con = ds.getConnection()) {
            // Inserisce solo in Orders
            try (PreparedStatement ps = con.prepareStatement(
                    INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
                if (userId != null) ps.setInt(1, userId);
                else                ps.setNull(1, Types.INTEGER);
                ps.setString(2, email);
                ps.setString(3, address);
                ps.setBigDecimal(4, total);

                ps.executeUpdate();
                
            }
        } catch (Exception ex) {
            throw new ServletException("Errore durante il salvataggio dell'ordine", ex);
        }

        // Pulisci carrello in sessione
        session.removeAttribute("cart");
        session.setAttribute("cartSize", 0);

        // Redirect a pagina di conferma ordine
        request.getRequestDispatcher("/Home.jsp").forward(request, response);
    }
}
