<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("nome");
    boolean isAdmin  = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
    // decide URL based on role
    String settingsUrl = isAdmin
        ? request.getContextPath() + "/Admin.jsp"
        : request.getContextPath() + "/Impostazioni.jsp";
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>UniBook</title>

  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/styles/Nav-bar-1.css" />
</head>
<body>

<nav id="nav-bar">
  <a href="${pageContext.request.contextPath}/Store.jsp" class="nav-link">Store</a>
  <a href="${pageContext.request.contextPath}/Membership.jsp" class="nav-link">Membership</a>
  <a href="${pageContext.request.contextPath}/About Us.jsp" class="nav-link">About Us</a>

  <% if (username != null) { %>
    <div id="accountMenu"
         class="nav-link nav-link-account"
         style="display:flex; align-items:center; gap:6px; position:relative;">
      <i class="fa-solid fa-user" style="flex-shrink:0;"></i>
      <span id="accountText" class="account-text" style="cursor:pointer;">
        Ciao, <%= username %>
      </span>

      <form id="logoutForm"
            action="<%= request.getContextPath() %>/LogOutServlet"
            method="post"
            style="display:none; margin:0;">
        <button type="submit" class="logout-button">Logout</button>
      </form>

      <a id="settingsLink"
         href="<%= settingsUrl %>"
         class="logout-button"
         style="display:none; margin:0; text-decoration:none;">
        Impostazioni
      </a>
    </div>
  <% } else { %>
    <a href="${pageContext.request.contextPath}/jsp/LoginForm.jsp"
       class="nav-link nav-link-account">
      <i class="fa-solid fa-user"></i>
      <span class="account-text">Account</span>
    </a>
  <% } %>
</nav>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const accountMenu  = document.getElementById('accountMenu');
    const accountText  = document.getElementById('accountText');
    const logoutForm   = document.getElementById('logoutForm');
    const settingsLink = document.getElementById('settingsLink');

    if (!accountMenu) return;

    accountMenu.addEventListener('mouseenter', () => {
      accountText.style.display    = 'none';
      logoutForm.style.display     = 'inline-block';
      settingsLink.style.display   = 'inline-block';
    });

    accountMenu.addEventListener('mouseleave', () => {
      logoutForm.style.display     = 'none';
      settingsLink.style.display   = 'none';
      accountText.style.display    = 'inline';
    });
  });
</script>

</body>
</html>
