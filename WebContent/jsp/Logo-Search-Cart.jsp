<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="javax.naming.Context, javax.naming.InitialContext, javax.sql.DataSource" %>
<%
    // 1) Leggi la dimensione del carrello da sessione
    Integer cartSize = (Integer) session.getAttribute("cartSize");
    if (cartSize == null) {
        cartSize = 0;
        session.setAttribute("cartSize", cartSize);
    }

    // 2) Gestisci toggle del menu a tendina
    String showParam = request.getParameter("showMenu");
    boolean showMenu = showParam != null && Boolean.parseBoolean(showParam);
    boolean nextShow = !showMenu;
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>UniBook</title>

  <!-- FontAwesome per icone -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

  <!-- CSS personalizzato -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>
</head>
<body>

  <div id="header-wrapper">
    <!-- Logo -->
    <div id="logo-unibook">
      <a href="${pageContext.request.contextPath}/Home.jsp">
        <img src="${pageContext.request.contextPath}/images/UniBook_Text_Logo.svg"
             alt="Logo UniBook">
      </a>
    </div>

    <div id="bar-row">
      <!-- Dropdown “All” -->
      <div class="dropdown">
        <form method="get" action="" style="display:inline; margin:0;">
          <input type="hidden" name="showMenu" value="<%= nextShow %>"/>
          <button id="dropdown-button" type="submit"
                  class="<%= showMenu ? "active" : "" %>">
            All <i class="fa-solid fa-chevron-down"></i>
          </button>
        </form>
        <% if (showMenu) { %>
          <ul id="dropdown-menu" class="dropdown-menu show">
            <li><a href="${pageContext.request.contextPath}/all.jsp">All Books</a></li>
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

      <!-- Search form -->
      <form id="search-form" method="get" action="<%= request.getContextPath() %>/searchservlet"
            class="search-form">
        <input type="text"
               id="search-input"
               name="search-query"
               placeholder="Search by Title, Author, Keyword or ISBN"/>
        <button type="submit" class="search-btn">
          <i class="fas fa-search"></i>
        </button>
      </form>

      <!-- Cart icon with count -->
      <div id="cart">
        <a href="${pageContext.request.contextPath}/Cart.jsp"
           class="cart-link">
          <i class="fa-solid fa-cart-shopping"></i>
          <span class="cart-count"><%= cartSize %></span>
        </a>
      </div>
    </div>
  </div>

</body>
</html>
