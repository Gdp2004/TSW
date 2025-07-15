<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
  String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <link rel="stylesheet" type="text/css" href="styles/Nav-bar-1.css">

  <title>UniBook</title>
</head>
<body>

  <nav id="nav-bar">

    <a href="Store.jsp" class="nav-link">Store</a>
    <a href="Membership.jsp" class="nav-link">Membership</a>
    <a href="About Us.jsp" class="nav-link">About Us</a>

    <a href="<%= (username != null) ? "Account.jsp" : "Login.jsp" %>" class="nav-link nav-link-account">
      <i class="fa-solid fa-user"></i>
      <span class="nav-link-text">
        <%= (username != null) ? "Ciao " + username : "Account" %>
      </span>
    </a>

    <a href="Wishlist.jsp" class="nav-link nav-link-wishlist">
      <i class="fa-regular fa-heart"></i>
      <span class="nav-link-text">Wishlist</span>
    </a>

  </nav>

</body>
</html>
