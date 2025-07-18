package it.unisa.Controller;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/removefromcartservlet")
public class RemoveFromCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/all.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/Cart.jsp");
            return;
        }

        String isbn = request.getParameter("isbn");
        if (isbn != null && cart.containsKey(isbn)) {
            int qty = cart.get(isbn);
            if (qty > 1) {
                cart.put(isbn, qty - 1);
            } else {
                cart.remove(isbn);
            }
            // aggiorna la dimensione del carrello (numero di voci)
            session.setAttribute("cartSize", cart.size());
            session.setAttribute("cart", cart);
        }

        // torna alla pagina di provenienza
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isBlank()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/Cart.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // inoltra anche le GET allo stesso comportamento
        doPost(request, response);
    }
}
