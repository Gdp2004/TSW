package it.unisa.Controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Verifica se l'utente è loggato
        Boolean logged = Boolean.TRUE.equals(session.getAttribute("logged"));
        if (!logged) {
            // Non autenticato: rimanda al form di login
            response.sendRedirect(request.getContextPath() + "/jsp/LoginForm.jsp?mode=login");
            return;
        }

        // Preleva l'ISBN e la quantità passata dal form
        String isbn = request.getParameter("isbn");
        Integer quantity = 1; // Impostiamo una quantità di default di 1

        // Se la quantità viene passata tramite il parametro, la usiamo
        if (request.getParameter("quantity") != null) {
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException e) {
                quantity = 1; // Se la quantità non è valida, settiamo il valore a 1
            }
        }

        // Se l'ISBN è nullo o vuoto, rimanda alla pagina dei libri
        if (isbn == null || isbn.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/all.jsp");
            return;
        }

        // Ottiene (o inizializza) il carrello in sessione
        @SuppressWarnings("unchecked")
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        // Aggiunge o aggiorna la quantità dell'ISBN nel carrello
        cart.put(isbn, cart.getOrDefault(isbn, 0) + quantity);
        session.setAttribute("cart", cart);

        // Aggiorna la dimensione del carrello
        session.setAttribute("cartSize", cart.size());

        // Torna alla pagina di provenienza (referer) o alla home se mancante
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isBlank()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/Home.jsp");
        }
    }
}
