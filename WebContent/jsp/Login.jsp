<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  Boolean utenteRegistrato = (Boolean) session.getAttribute("utenteRegistrato");
  if (utenteRegistrato == null) utenteRegistrato = false;
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title><%= utenteRegistrato ? "Login" : "Registrazione" %></title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/Login.css">
  
</head>
<body>

  <div class="form-container">
    <h2><%= utenteRegistrato ? "Accedi al tuo account" : "Crea un nuovo account" %></h2>

    <form action="<%= utenteRegistrato ? "Login" : "Register" %>" method="post">
      <% if (!utenteRegistrato) { %>
        <label for="nome">Nome</label>
        <input type="text" id="nome" name="nome" required>

        <label for="cognome">Cognome</label>
        <input type="text" id="cognome" name="cognome" required>
      <% } %>

      <label for="email">Email</label>
      <input type="email" id="email" name="email" required>

      <label for="password">Password</label>
      <input type="password" id="password" name="password" required>

      <input type="submit" value="<%= utenteRegistrato ? "Accedi" : "Registrati" %>">
    </form>

    <div class="form-footer">
      <% if (!utenteRegistrato) { %>
        <p>Se sei già registrato, <a href="account.jsp?login=true">clicca qui per accedere</a>.</p>
      <% } else { %>
        <p>Se non hai ancora un account, <a href="account.jsp?register=true">clicca qui per registrarti</a>.</p>
      <% } %>
    </div>
  </div>

<%
  String loginParam = request.getParameter("login");
  String registerParam = request.getParameter("register");

  if ("true".equals(loginParam)) {
      session.setAttribute("utenteRegistrato", true);
      response.sendRedirect("account.jsp");
  } else if ("true".equals(registerParam)) {
      session.setAttribute("utenteRegistrato", false);
      response.sendRedirect("account.jsp");
  }
%>

</body>
</html>
