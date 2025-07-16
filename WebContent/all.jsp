<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.List, java.util.Map, java.util.HashMap, it.unisa.Model.Books, it.unisa.Model.DAO.BooksDao" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>All Books</title>
  <link rel="stylesheet" href="styles/Cart.css">
  
  <!-- FontAwesome per le icone -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

  <!-- CSS -->
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/styles/Nav-bar-1.css"/>
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>

  <style>
    .books-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 1rem;
      padding: 1rem;
    }
    .book-card {
      text-align: center;
      font-family: sans-serif;
    }
    .book-card img.cover {
      width: 100%;
      height: 150px;
      object-fit: contain;
      border-radius: 4px;
      background: #fff;
      display: block;
      margin: 0 auto .5rem;
    }
    .image-wrapper {
      position: relative;
    }
    .favorite-icon {
      position: absolute;
      top: 6px;
      right: 6px;
      color: #fff;
      font-size: 1rem;
      cursor: pointer;
    }
    .book-card h3 {
      font-size: .85rem;
      margin: .4rem 0 .2rem;
      height: 2em;
      overflow: hidden;
    }
    .book-card p.author {
      font-size: .75rem;
      color: #555;
      margin: 0 0 .4rem;
    }
    .quick-add {
      padding: .25rem .4rem;
      font-size: .7rem;
      border: 1px solid #2C6FA0;
      background: #fff;
      color: #2C6FA0;
      border-radius: 4px;
      text-transform: uppercase;
      cursor: pointer;
      text-decoration: none;
    }
    .quick-add:hover {
      background: #2C6FA0;
      color: #fff;
    }
    @media (max-width: 768px) {
      .books-grid {
        grid-template-columns: repeat(2, 1fr);
      }
    }
    @media (max-width: 480px) {
      .books-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>

<%
    // Controllo se l'utente è loggato
    Boolean logged = Boolean.TRUE.equals(session.getAttribute("logged"));
    String email = (String) session.getAttribute("email");

    // Recupero o genero la lista randomBooks in sessione
    @SuppressWarnings("unchecked")
    List<Books> randomBooks = (List<Books>) session.getAttribute("randomBooks");
    if (randomBooks == null) {
        Context initCtx = new InitialContext();
        Context envCtx  = (Context) initCtx.lookup("java:comp/env");
        DataSource ds   = (DataSource) envCtx.lookup("jdbc/Database");
        BooksDao dao    = new BooksDao(ds);
        randomBooks     = dao.findRandom();
        session.setAttribute("randomBooks", randomBooks);
    }
    
    // Recupero il carrello dalla sessione (se esiste) o inizializzo un nuovo carrello
    Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart);
    }

    // Verifica l'azione di aggiunta al carrello
    String isbnToAdd = request.getParameter("isbn");
    if (isbnToAdd != null && !isbnToAdd.isEmpty()) {
        // Se l'articolo è già nel carrello, incremento la quantità
        cart.put(isbnToAdd, cart.getOrDefault(isbnToAdd, 0) + 1);
        session.setAttribute("cartSize", cart.size()); // Aggiorno la dimensione del carrello
    }
%>

<%@ include file="/jsp/Nav-bar-1.jsp" %>
<%@ include file="/jsp/Logo-Search-Cart.jsp" %>

<h1>All Books</h1>

<div class="books-grid">
  <%
      if (randomBooks != null && !randomBooks.isEmpty()) {
        for (Books b : randomBooks) {
  %>
    <div class="book-card">
      <div class="image-wrapper">
        <img class="cover"
             src="<%= request.getContextPath() %>/images/Covers/<%= b.getImagePath() %>"
             alt="Copertina di <%= b.getTitle() %>"/>
        <i class="fa-regular fa-heart favorite-icon"></i>
      </div>
      <h3><%= b.getTitle() %></h3>
      <p class="author">by <%= b.getAuthor() %></p>

      <% if (logged) { %>
        <!-- Quick Add form per aggiungere un prodotto al carrello -->
        <form action="<%= request.getContextPath() %>/AddToCartServlet" method="post" style="display:inline;">
          <input type="hidden" name="isbn" value="<%= b.getIsbn() %>"/>
          <button type="submit" class="quick-add">Quick Add</button>
        </form>
      <% } else { %>
        <a href="<%= request.getContextPath() %>/jsp/LoginForm.jsp?mode=login"
           class="quick-add">Quick Add</a>
      <% } %>

    </div>
  <%
      }
    } else {
  %>
    <p>Nessun libro da mostrare.</p>
  <%
    }
  %>
</div>

<%@ include file="/jsp/Footer.jsp" %>

</body>
</html>
