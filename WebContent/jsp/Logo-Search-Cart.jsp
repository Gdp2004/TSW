<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="javax.naming.Context, javax.naming.InitialContext, javax.sql.DataSource,
                 it.unisa.Model.DAO.CartDao, it.unisa.Model.CartItem" %>

<%
    // Gestione carrello in sessione (recupero la dimensione del carrello)
    Integer cartSize = (Integer) session.getAttribute("cartSize");
    if (cartSize == null) {
        cartSize = 0;  // Se non esiste, inizializza a zero
        session.setAttribute("cartSize", cartSize);
    }

    // Recupero la variabile per il toggle del menu (mostrare o nascondere)
    String showParam = request.getParameter("showMenu");
    boolean showMenu = (showParam != null) && Boolean.parseBoolean(showParam);
    boolean nextShow = !showMenu;  // Calcolo il prossimo stato del menu
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>UniBook</title>

  <!-- FontAwesome per le icone -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

  <!-- CSS personalizzati -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>

  <!-- JavaScript -->
  <script src="${pageContext.request.contextPath}/scripts/Logo-Search-Bar.js" defer></script>
</head>
<body>

  <div id="header-wrapper">
    <!-- Logo -->
    <div id="logo-unibook">
      <a href="${pageContext.request.contextPath}/Home.jsp">
        <img src="${pageContext.request.contextPath}/images/UniBook_Text_Logo.svg" alt="Logo UniBook">
      </a>
    </div>

    <div id="bar-row">
      <!-- Menu a tendina -->
      <div class="dropdown">
        <form method="get" action="" style="display:inline; margin:0;">
          <input type="hidden" name="showMenu" value="<%= nextShow %>">
          <button id="dropdown-button" type="submit" class="<%= showMenu ? "active" : "" %>">
            All <i class="fa-solid fa-chevron-down"></i>
          </button>
        </form>
        <% if (showMenu) { %>
          <ul id="dropdown-menu" class="dropdown-menu show">
            <li><a href="${pageContext.request.contextPath}/all.jsp">All books</a></li>
            <li><a href="${pageContext.request.contextPath}/bestseller.jsp">Bestseller</a></li>
            <li><a href="${pageContext.request.contextPath}/comingsoon.jsp">Coming Soon</a></li>
            <li><a href="${pageContext.request.contextPath}/art.jsp">Art</a></li>
            <li><a href="${pageContext.request.contextPath}/scifi.jsp">Sci-Fi</a></li>
            <li><a href="${pageContext.request.contextPath}/history.jsp">History</a></li>
            <li><a href="${pageContext.request.contextPath}/narrative.jsp">Narrative</a></li>
            <li><a href="${pageContext.request.contextPath}/technology.jsp">Technology</a></li>
            <li><a href="${pageContext.request.contextPath}/kids.jsp">Kids</a></li>
          </ul>
        <% } %>
      </div>

      <!-- Form di ricerca -->
      <form method="get" action="" class="search-form">
        <input type="text"
               id="search-input"
               name="search-query"
               placeholder="Search by Title, Author, Keyword or ISBN">
        <button type="submit" class="search-btn">
          <i class="fas fa-search"></i>
        </button>
      </form>

      <!-- Icona carrello con contatore -->
      <div id="cart">
        <a href="${pageContext.request.contextPath}/Cart.jsp" class="cart-link">
          <i class="fa-solid fa-cart-shopping"></i>
          <span class="cart-count"><%= cartSize %></span>
        </a>
      </div>
    </div>
  </div>

  
  

</body>
</html>
