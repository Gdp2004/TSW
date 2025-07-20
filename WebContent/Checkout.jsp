<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.Map,
                 javax.naming.Context,
                 javax.naming.InitialContext,
                 javax.sql.DataSource,
                 it.unisa.Model.Books,
                 it.unisa.Model.DAO.BooksDao" %>
<%
    // Carica il carrello da sessione
    @SuppressWarnings("unchecked")
    Map<String,Integer> cart = (Map<String,Integer>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/all.jsp");
        return;
    }

    // DAO per i dettagli dei libri
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("jdbc/Bookstore");
    BooksDao dao    = new BooksDao(ds);

    double totalPrice = 0;
    for (Map.Entry<String,Integer> e : cart.entrySet()) {
        Books b = dao.findByIsbn(e.getKey());
        if (b != null) {
            totalPrice += b.getPrice().doubleValue() * e.getValue();
        }
    }

    // Controllo se l'utente è loggato
    Boolean logged = Boolean.TRUE.equals(session.getAttribute("logged"));
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Checkout – UniBook</title>

  <!-- FontAwesome -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  <!-- Navbar e Logo -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Nav-bar-1.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>

  <style>
   
  /* Reset leggero */
  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: #f4f7fa;
    color: #333;
  }

  .checkout-container {
    max-width: 900px;
    margin: 3rem auto;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    overflow: hidden;
    padding: 2rem;
  }

  .checkout-container h1 {
    font-size: 2rem;
    color: #2C6FA0;
    margin-bottom: 1.5rem;
    text-align: center;
  }

  /* Table */
  table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 8px;
    margin-bottom: 2rem;
  }

  table thead th {
    text-align: left;
    font-weight: 600;
    font-size: 0.95rem;
    padding: 0.75rem 1rem;
    background: #e8f0f8;
    color: #2C6FA0;
    border-bottom: none;
  }

  table tbody tr {
    background: #fafbfc;
  }

  table td {
    padding: 0.75rem 1rem;
    vertical-align: middle;
    font-size: 0.9rem;
    color: #555;
  }

  table td img {
    width: 60px;
    height: 80px;
    object-fit: cover;
    border-radius: 4px;
  }

  /* Summary */
  .summary {
    text-align: right;
    font-size: 1.3rem;
    font-weight: 600;
    color: #2C6FA0;
    margin-bottom: 2rem;
  }

  /* Form sections */
  .section {
    margin-bottom: 2rem;
  }

  .section h2 {
    font-size: 1.2rem;
    color: #2C6FA0;
    margin-bottom: 0.75rem;
    border-bottom: 2px solid #e8f0f8;
    padding-bottom: 0.25rem;
  }

  .section label {
    display: block;
    font-weight: 500;
    margin: 0.75rem 0 0.25rem;
    color: #444;
  }

  .section input[type="text"],
  .section textarea {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 1px solid #ccd6e0;
    border-radius: 6px;
    font-size: 0.95rem;
    background: #f9fafb;
    transition: border-color 0.2s;
  }

  .section input[type="text"]:focus,
  .section textarea:focus {
    outline: none;
    border-color: #2C6FA0;
    background: #fff;
  }

  /* Payment methods */
  .payment-methods {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
  }

  .payment-field {
    flex: 1 1 30%;
    padding: 1rem;
    border: 2px solid #e4e9f0;
    border-radius: 8px;
    text-align: center;
    cursor: pointer;
    transition: border-color 0.3s, background 0.3s;
    background: #f9fafb;
  }

  .payment-field i {
    display: block;
    font-size: 2.5rem;
    color: #708090;
    margin-bottom: 0.5rem;
  }

  .payment-field div {
    font-size: 0.95rem;
    font-weight: 500;
    color: #333;
  }

  .payment-field:hover,
  .payment-field.selected {
    border-color: #2C6FA0;
    background: #eaf4fb;
  }

  .payment-field input {
    position: absolute;
    opacity: 0;
    pointer-events: none;
  }

  /* Place order button */
  .place-order {
    display: block;
    width: 100%;
    padding: 1rem;
    background: #2C6FA0;
    color: #fff;
    border: none;
    border-radius: 6px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    text-transform: uppercase;
    transition: background 0.2s;
  }

  .place-order:hover {
    background: #1a4b6e;
  }

  /* Login prompt */
  .login-prompt {
    text-align: center;
    margin: 3rem 0;
    font-size: 1rem;
    color: #555;
  }
  .login-prompt a {
    color: #2C6FA0;
    font-weight: 600;
    text-decoration: none;
  }
  .login-prompt a:hover {
    text-decoration: underline;
  }

  /* Responsive */
  @media (max-width: 768px) {
    .checkout-container {
      padding: 1rem;
    }
    table thead {
      display: none;
    }
    table, table tbody, table tr, table td {
      display: block;
      width: 100%;
    }
    table tr {
      margin-bottom: 1rem;
    }
    table td {
      text-align: right;
      padding-left: 50%;
      position: relative;
    }
    table td::before {
      content: attr(data-label);
      position: absolute;
      left: 1rem;
      width: calc(50% - 2rem);
      text-align: left;
      font-weight: 600;
      color: #2C6FA0;
    }
  }

    
  </style>

  <script>
    // evidenziazione scelta metodo pagamento
    document.addEventListener('DOMContentLoaded', () => {
      document.querySelectorAll('.payment-field').forEach(field => {
        field.addEventListener('click', () => {
          document.querySelectorAll('.payment-field').forEach(f=>f.classList.remove('selected'));
          field.classList.add('selected');
          field.querySelector('input').checked = true;
        });
      });
    });
  </script>
</head>
<body>

  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <div class="checkout-container">
    <h1>Checkout</h1>

    <!-- Riepilogo ordine -->
    <table>
      <thead>
        <tr>
          <th>Copertina</th>
          <th>Libro</th>
          <th>Quantità</th>
          <th>Prezzo Unitario</th>
          <th>Totale</th>
        </tr>
      </thead>
      <tbody>
      <%
        for (Map.Entry<String,Integer> e : cart.entrySet()) {
          Books b = dao.findByIsbn(e.getKey());
          int qty = e.getValue();
          double line = b.getPrice().doubleValue() * qty;
      %>
        <tr>
          <td>
            <img src="<%= request.getContextPath() %>/images/Covers/<%= b.getImagePath() %>"
                 alt="Copertina di <%= b.getTitle() %>"/>
          </td>
          <td><%= b.getTitle() %></td>
          <td><%= qty %></td>
          <td>&euro;<%= String.format("%.2f", b.getPrice().doubleValue()) %></td>
          <td>&euro;<%= String.format("%.2f", line) %></td>
        </tr>
      <%
        }
      %>
      </tbody>
    </table>

    <div class="summary">
      Totale ordine: &euro;<%= String.format("%.2f", totalPrice) %>
    </div>

    <%
      if (logged) {
    %>
      <!-- Form di spedizione, pagamento e metodo di pagamento -->
      <form class="section"
            action="<%= request.getContextPath() %>/placeorderservlet"
            method="post">
        <h2>1. Indirizzo di Spedizione</h2>
        <label for="addr">Indirizzo completo</label>
        <textarea id="addr" name="shippingAddress" rows="3" required></textarea>

        <h2>2. Dettagli Pagamento</h2>
        <label for="card">Numero carta di credito</label>
        <input id="card" name="cardNumber" type="text"
               placeholder="1234 5678 9012 3456" required/>

        <label for="expiry">Data di scadenza (MM/YY)</label>
        <input id="expiry" name="expiry" type="text"
               placeholder="MM/YY" required/>

        <label for="cvc">CVC</label>
        <input id="cvc" name="cvc" type="text"
               placeholder="123" required/>

        <h2>3. Metodo di pagamento</h2>
        <div class="payment-methods">
          <label class="payment-field">
            <input type="radio" name="paymentMethod" value="credit_card" required/>
            <i class="fa-solid fa-credit-card"></i>
            Carta di Credito
          </label>
          <label class="payment-field">
            <input type="radio" name="paymentMethod" value="paypal" required/>
            <i class="fa-brands fa-paypal"></i>
            PayPal
          </label>
          <label class="payment-field">
            <input type="radio" name="paymentMethod" value="bank_transfer" required/>
            <i class="fa-solid fa-building-columns"></i>
            Bonifico Bancario
          </label>
        </div>

        <button type="submit" class="place-order">Conferma Ordine</button>
      </form>
    <%
      } else {
    %>
      <div class="login-prompt">
        Devi <a href="<%=request.getContextPath()%>/jsp/LoginForm.jsp?mode=login">accedere</a>
        per completare l’ordine.
      </div>
    <%
      }
    %>

  </div>

  <%@ include file="/jsp/Footer.jsp" %>
</body>
</html>
