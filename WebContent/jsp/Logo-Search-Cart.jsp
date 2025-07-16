<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // 1) Gestione carrello
  Integer cartSize = (Integer) session.getAttribute("cartSize");
  if (cartSize == null) {
    cartSize = 0;
    session.setAttribute("cartSize", cartSize);
  }

  // 2) Lettura parametro GET per mostrare/nascondere il menu
  String showParam = request.getParameter("showMenu");
  boolean showMenu = (showParam != null) && Boolean.parseBoolean(showParam);

  // 3) Calcolo valore da inviare al prossimo click (toggle)
  boolean nextShow = !showMenu;
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Font Awesome per l’icona -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  <!-- Il tuo CSS -->
  <link rel="stylesheet" href="styles/Logo-Search-Cart.css">

  <!-- JS con defer (al momento non serve per il dropdown) -->
  <script src="scripts/Logo-Search-Bar.js" defer></script>
  <title>UniBook</title>
</head>
<body>

  <div id="header-wrapper">
    <div id="logo-unibook">
      <img src="images/UniBook_Text_Logo.svg" alt="Logo UniBook">
    </div>

    <div id="bar-row">
      <!-- WRAPPER DEL DROPDOWN -->
      <div class="dropdown">
        <form method="get" action="" style="display:inline;margin:0;">
          <input type="hidden" name="showMenu" value="<%= nextShow %>">
          <button id="dropdown-button"
                  type="submit"
                  class="<%= showMenu ? "active" : "" %>">
            All <i class="fa-solid fa-chevron-down"></i>
          </button>
        </form>
        <% if (showMenu) { %>
          <ul id="dropdown-menu" class="dropdown-menu show">
            <li><a href="<%= request.getContextPath()%>/jsp/all.jsp">All books</a></li>
            <li><a href="<%= request.getContextPath()%>/jsp/bestsellers.jsp">Bestseller</a></li>
            <li><a href="<%= request.getContextPath()%>/jsp/comingsoon.jsp">Coming Soon</a></li>
            <li><a href="<%= request.getContextPath()%>/jsp/art.jsp">Art</a></li>
            <li><a href="<%= request.getContextPath()%>/jsp/scifi.jsp">Sci-Fi</a></li>
            <li><a href="<%= request.getContextPath()%>/jsp/history.jsp">History</a></li>
            <li><a href="<%= request.getContextPath()%>/jsp/narrtive.jsp">Narrative</a></li>
            <li><a href="<%= request.getContextPath()%>/jsp/technology.jsp">Technology</a></li>
            <li><a href="<%= request.getContextPath()%>/jsp/kids.jsp">Kids</a></li>
          </ul>
        <% } %>
      </div>

      <form method="get" action="" class="search-form">
        <input type="text" id="search-input" name="search-query"
               placeholder="Search by Title, Author, Keyword or ISBN">
        <button type="submit" class="search-btn">
          <i class="fas fa-search"></i>
        </button>
      </form>

      <div id="cart">
        <a href="Cart.jsp" class="cart-link">
          <i class="fa-solid fa-cart-shopping"></i>
          <span class="cart-count"><%= cartSize %></span>
        </a>
      </div>
    </div>
  </div>

  <div id="Bestseller-Culturia">
    <a href="#">
      <img src="images/Bestseller-Culturia.png"
           alt="Libro Culturia"
           width="100%">
    </a>
  </div>

</body>
</html>
