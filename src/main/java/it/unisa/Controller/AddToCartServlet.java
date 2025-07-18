package it.unisa.Controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

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

        // 0) Genera un cartId se non c'è ancora
        String cartId = (String) session.getAttribute("cartId");
        if (cartId == null) {
            cartId = UUID.randomUUID().toString();
            session.setAttribute("cartId", cartId);
        }

        // 1) Recupera l'ISBN e la quantità (default = 1)
        String isbn = request.getParameter("isbn");
        int quantity = 1;
        String qtyParam = request.getParameter("quantity");
        if (qtyParam != null) {
            try {
                quantity = Integer.parseInt(qtyParam);
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        // 2) Se manca l'ISBN, torna alla lista
        if (isbn == null || isbn.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/all.jsp");
            return;
        }

        // 3) Ottieni o crea la Map<String, Integer> (isbn→qty) in sessione
        @SuppressWarnings("unchecked")
        Map<String,Integer> cart = (Map<String,Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        // 4) Aggiorna la quantità per quell'ISBN
        cart.put(isbn, cart.getOrDefault(isbn, 0) + quantity);
        session.setAttribute("cart", cart);

        // 5) Ricalcola il numero totale di unità (non di tipologie)
        int totalItems = cart.values().stream().mapToInt(Integer::intValue).sum();
        session.setAttribute("cartSize", totalItems);

        // 6) Rimanda indietro aggiungendo un flag per il popup
        String referer = request.getHeader("Referer");
        String addedFlag = "added=true";
        String target;
        if (referer != null && !referer.isBlank()) {
            target = referer + (referer.contains("?") ? "&" : "?") + addedFlag;
        } else {
            // se non hai referer, di default alla pagina dei libri
            target = request.getContextPath() + "/all.jsp?" + addedFlag;
        }
        response.sendRedirect(target);
    }
}
