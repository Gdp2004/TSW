<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  boolean dropdownActive = "true".equals(request.getParameter("active"));
  String nextState       = dropdownActive ? "false" : "true";
  // gestisco il numero di articoli in carrello
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
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  <title>UniBook</title>
</head>
<body>

  <div id="wrapper">
  
  		<div id="logo-search-cart">
    <div id="logo-unibook">
      <img src="images/UniBook_Text_Logo.svg" alt="Logo UniBook">
    </div>
    <div id="container-search-bar">
      <form method="get" action="" class="toggle-form">
        <input type="hidden" name="active" value="<%=nextState%>">
        <button type="submit"
                id="dropdown-button"
                class="<%= dropdownActive ? "active" : "" %>">
          All <i class="fa-solid fa-chevron-down"></i>
        </button>
      </form>
      <form method="get" action="" class="search-form">
        <input type="text"
               name="search-query"
               id="search-input"
               placeholder="Search by Title, Author, Keyword or ISBN">
        <button type="submit" class="search-btn">
          <i class="fas fa-search"></i>
        </button>
      </form>
    </div>
    <div class="cart-container">
      <a href="Cart.jsp" class="cart-link">
        <i class="fa-solid fa-cart-shopping"></i>
        <span class="cart-count"><%= cartSize %></span>
      </a>
    </div>
  </div>
  
  </div>

</body>
</html>
