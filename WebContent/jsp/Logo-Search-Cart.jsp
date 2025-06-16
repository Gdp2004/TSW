<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Solo gestione del carrello
  Integer cartSize = (Integer) session.getAttribute("cartSize");
  if (cartSize == null) {
    cartSize = 0;
    session.setAttribute("cartSize", cartSize);
  }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="styles/Logo-Search-Cart.css">
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  <!-- carichiamo il JS con defer per assicurarci che il DOM sia pronto -->
  <script src="scripts/Logo-Search-Bar.js" defer></script>
  <title>UniBook</title>
</head>
<body>

  <div id="header-wrapper">
    <div id="logo-unibook">
      <img src="images/UniBook_Text_Logo.svg" alt="Logo UniBook">
    </div>

    <div id="bar-row">
      <!-- Bottone client-side, senza form -->
      <button id="dropdown-button">
        All <i class="fa-solid fa-chevron-down"></i>
      </button>

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
