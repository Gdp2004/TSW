<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Prendo la variabile utenteRegistrato dalla sessione, di default false
  Boolean utenteRegistrato = (Boolean) session.getAttribute("utenteRegistrato");
  if (utenteRegistrato == null) utenteRegistrato = false;

  // Leggo i parametri dalla query string
  String errore = request.getParameter("errore");
  String mode = request.getParameter("mode"); // "login" o "register"

  // Se è presente mode uso quello per impostare la modalità, altrimenti uso sessione
  if ("login".equals(mode)) {
    utenteRegistrato = true; // mostra login
    session.setAttribute("utenteRegistrato", true);
  } else if ("register".equals(mode)) {
    utenteRegistrato = false; // mostra registrazione
    session.setAttribute("utenteRegistrato", false);
  }
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

<header class="site-header">
  <a href="<%= request.getContextPath() %>/Home.jsp" class="logo-link">
    <img src="<%= request.getContextPath() %>/images/UniBook_Text_Logo.svg" alt="Logo del sito" class="site-logo">
  </a>
</header>

<div class="form-container">
  <h2><%= utenteRegistrato ? "Accedi al tuo account" : "Crea un nuovo account" %></h2>

  <% if ("login".equals(errore)) { %>
    <div class="error-message">Email o password errati.</div>
  <% } else if ("esiste".equals(errore)) { %>
    <div class="error-message">L'email è già registrata.</div>
  <% } %>

  <form action="<%= request.getContextPath() %>/LoginFormServlet" method="post">
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
    <input type="hidden" name="mode" value="<%= utenteRegistrato ? "login" : "register" %>">
  </form>

  <div class="form-footer">
    <% if (!utenteRegistrato) { %>
      <p>Se sei già registrato, 
        <a href="<%= request.getContextPath() %>/jsp/LoginForm.jsp?mode=login">clicca qui per accedere</a>.
      </p>
    <% } else { %>
      <p>Se non hai ancora un account, 
        <a href="<%= request.getContextPath() %>/jsp/LoginForm.jsp?mode=register">clicca qui per registrarti</a>.
      </p>
    <% } %>
  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  const form = document.querySelector('form');
  const inputs = form.querySelectorAll('input');
  const isRegistration = !<%= utenteRegistrato %>;

  const validators = {
    nome: value => /^[A-Za-zÀ-ÿ\s'-]{2,30}$/.test(value),
    cognome: value => /^[A-Za-zÀ-ÿ\s'-]{2,30}$/.test(value),
    email: value => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
    password: value => /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$/.test(value)
  };

  const messages = {
    nome: "Inserisci un nome valido (solo lettere, minimo 2 caratteri).",
    cognome: "Inserisci un cognome valido (solo lettere, minimo 2 caratteri).",
    email: "Inserisci un'email valida.",
    password: "La password deve contenere almeno 6 caratteri, una lettera e un numero."
  };

  function showError(input, message) {
    let errorEl = input.nextElementSibling;
    if (!errorEl || !errorEl.classList.contains('error-message')) {
      errorEl = document.createElement('div');
      errorEl.classList.add('error-message');
      input.after(errorEl);
    }
    errorEl.textContent = message;
    input.classList.add('input-error');
  }

  function clearError(input) {
    let errorEl = input.nextElementSibling;
    if (errorEl && errorEl.classList.contains('error-message')) {
      errorEl.textContent = '';
    }
    input.classList.remove('input-error');
  }

  function validateInput(input) {
    const name = input.name;
    const value = input.value.trim();
    if (validators[name]) {
      if (!validators[name](value)) {
        showError(input, messages[name]);
        return false;
      } else {
        clearError(input);
        return true;
      }
    }
    return true;
  }

  inputs.forEach(input => {
    input.addEventListener('input', () => validateInput(input));
    input.addEventListener('change', () => validateInput(input));
  });

  form.addEventListener('submit', function (e) {
    let valid = true;
    inputs.forEach(input => {
      // Se è login, salto la validazione di nome e cognome (non presenti)
      if (!isRegistration && (input.name === "nome" || input.name === "cognome")) return;
      if (!validateInput(input)) valid = false;
    });

    if (!valid) {
      e.preventDefault();
    }
  });
});
</script>

</body>
</html>