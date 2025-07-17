<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.List, java.util.Map, java.util.HashMap,
                 javax.naming.Context, javax.naming.InitialContext, javax.sql.DataSource,
                 it.unisa.Model.Books, it.unisa.Model.DAO.BooksDao" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Carrello</title>

  <!-- FontAwesome per le icone -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

  <!-- CSS esterni -->
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/styles/Nav-bar-1.css"/>
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Cart.css"/>

  <style>
    /* Freccia per tornare alla home */
    .back-to-home {
      font-size: 2rem;
      color: #2C6FA0;
      text-decoration: none;
      margin: 20px;
      display: inline-flex;
      align-items: center;
    }
    .back-to-home i {
      margin-right: 8px;
    }
    /* Tabella */
    table {
      width: 100%; border-collapse: collapse; margin-top: 20px;
    }
    th, td {
      border: 1px solid #ddd; padding: 10px; text-align: left;
    }
    th { background: #f2f2f2; }
    /* Righe e sommario */
    .empty-cart { text-align: center; font-size: 1.5rem; color: #555; margin-top: 40px; }
    .cart-container { width: 80%; margin: 0 auto; padding: 20px; }
    .cart-item-image { width: 50px; border-radius: 4px; }
    .cart-summary {
      display: flex; justify-content: space-between; font-size: 1.2rem;
      font-weight: bold; margin-top: 20px;
    }
    .checkout-button {
      background: #2C6FA0; color: #fff; border: none; padding: 12px 24px;
      border-radius: 4px; cursor: pointer; font-size: 1rem;
    }
    .checkout-button:hover { background: #1a4b6e; }
  </style>
</head>
<body>

  <%-- Navbar e logo --%>
  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <%-- Freccia per tornare alla home --%>
  <a href="${pageContext.request.contextPath}/Home.jsp" class="back-to-home">
    <i class="fa-solid fa-arrow-left"></i><span>Home</span>
  </a>

<%
  // Inizializza il carrello in sessione se non esiste
  @SuppressWarnings("unchecked")
  Map<String,Integer> cart = (Map<String,Integer>) session.getAttribute("cart");
  if (cart == null) {
    cart = new HashMap<>();
    session.setAttribute("cart", cart);
    session.setAttribute("cartSize", 0);
  }

  // Connessione DB e DAO per i dati dei libri
  Context initCtx = new InitialContext();
  Context envCtx  = (Context) initCtx.lookup("java:comp/env");
  DataSource ds   = (DataSource) envCtx.lookup("jdbc/Database");
  BooksDao dao    = new BooksDao(ds);

  // Se il carrello è vuoto
  if (cart.isEmpty()) {
%>
    <div class="empty-cart">Il tuo carrello è vuoto.</div>
<%
  } else {
    double totalPrice = 0;
%>
    <div class="cart-container">
      <h1>Il tuo Carrello</h1>
      <table>
        <thead>
          <tr>
            <th>Immagine</th>
            <th>Titolo</th>
            <th>Quantità</th>
            <th>Prezzo</th>
            <th>Totale</th>
          </tr>
        </thead>
        <tbody>
        <%
          for (Map.Entry<String,Integer> e : cart.entrySet()) {
            String isbn = e.getKey();
            int qty    = e.getValue();
            Books book = dao.findByIsbn(isbn);
            if (book != null) {
              double lineTotal = book.getPrice().doubleValue() * qty;
              totalPrice += lineTotal;
        %>
          <tr>
            <td><img class="cart-item-image"
                     src="<%= request.getContextPath() %>/images/Covers/<%= book.getImagePath() %>"
                     alt="<%= book.getTitle() %>"></td>
            <td><%= book.getTitle() %></td>
            <td><%= qty %></td>
            <td>&euro;<%= book.getPrice() %></td>
            <td>&euro;<%= String.format("%.2f", lineTotal) %></td>
          </tr>
        <%
            }
          }
        %>
        </tbody>
      </table>
      <div class="cart-summary">
        <span>Totale Carrello:</span>
        <span>&euro;<%= String.format("%.2f", totalPrice) %></span>
      </div>
      <form action="<%= request.getContextPath() %>/Checkout.jsp" method="post">
        <button type="submit" class="checkout-button">Procedi al Checkout</button>
      </form>
    </div>
<%
  }
%>

  <%@ include file="/jsp/Footer.jsp" %>
</body>
</html>
