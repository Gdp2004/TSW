<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.List, java.util.Map, java.util.HashMap, it.unisa.Model.Books, it.unisa.Model.DAO.BooksDao, javax.naming.Context, javax.naming.InitialContext, javax.sql.DataSource" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Carrello</title>
  <link rel="stylesheet" href="styles/Cart.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  

  <style>
    /* Styling base per la tabella */
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    table, th, td {
      border: 1px solid #ddd;
    }

    th, td {
      padding: 10px;
      text-align: left;
    }

    th {
      background-color: #f2f2f2;
    }

    /* Stile per la riga del totale */
    .total-row {
      font-size: 1.1rem;
      font-weight: bold;
      background-color: #f9f9f9;
    }

    /* Stile per il carrello vuoto */
    .empty-cart {
      font-size: 1.5rem;
      color: #555;
      text-align: center;
      margin-top: 20px;
    }

    /* Bottone Checkout */
    .checkout-button {
      display: inline-block;
      padding: 12px 24px;
      background-color: #2C6FA0;
      color: white;
      border: none;
      border-radius: 4px;
      font-size: 1rem;
      cursor: pointer;
      text-decoration: none;
    }

    .checkout-button:hover {
      background-color: #1a4b6e;
    }

    /* Layout del carrello */
    .cart-container {
      padding: 20px;
      margin: 0 auto;
      width: 80%;
    }

    .cart-item-image {
      width: 50px;
      height: auto;
      border-radius: 5px;
    }

    .cart-item-details {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .cart-summary {
      display: flex;
      justify-content: space-between;
      font-size: 1.2rem;
      margin-top: 20px;
      font-weight: bold;
    }

    /* Aggiungere logo */
    #logo-unibook {
      text-align: center;
      margin: 20px 0;
    }

    #logo-unibook img {
      width: 150px; /* Modifica la larghezza a tua preferenza */
      height: auto;
    }

    /* Stile per la freccia per tornare alla home */
    .back-to-home {
    font-size: 2rem;  /* Freccia grande */
    color: #2C6FA0;
    text-decoration: none;
    margin-left: 30px;
    display: inline-flex; /* Usa flexbox per allineare gli elementi sulla stessa riga */
    align-items: center;  /* Allinea gli elementi verticalmente */
}

.back-to-home i {
    margin-right: 10px; /* Distanza tra la freccia e il testo */
}

.back-to-home:hover {
    color: #1a4b6e;
}

  </style>
</head>
<body>

	<%@ include file="/jsp/Nav-bar-1.jsp" %>

  <!-- Freccia per tornare alla home -->
  <a href="<%= request.getContextPath() %>/Home.jsp" class="back-to-home">
    <i class="fa-solid fa-arrow-left"></i><span>Home</span>
  </a>

<%
    // Recupero l'email dell'utente dalla sessione
    String email = (String) session.getAttribute("email");

    // Connessione al database tramite DataSource (JNDI)
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("jdbc/Database");

    // Verifico se l'utente è loggato
    if (email != null) {
        // Crea il DAO per il carrello
        BooksDao b = new BooksDao(ds);
        
        // Recupero gli articoli nel carrello dalla sessione (carrello come Map)
        @SuppressWarnings("unchecked")
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");

        // Se il carrello è vuoto
        if (cart == null || cart.isEmpty()) {
%>
            <div class="empty-cart">Il tuo carrello è vuoto.</div>
<%
        } else {
%>
            <div class="cart-container">
                <h1>Il tuo Carrello</h1>
                <table>
                    <thead>
                        <tr>
                            <th>Immagine</th>
                            <th>Titolo</th>
                            <th>Quantità</th>
                            <th>Prezzo</th>
                            <th>Totale</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            double totalPrice = 0.0;
                            // Iteriamo attraverso gli articoli nel carrello
                            for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                                String isbn = entry.getKey();
                                int quantity = entry.getValue();

                                // Recupero il libro tramite ISBN
                                Books book = b.findByIsbn(isbn);
                                if (book != null) {
                                    double itemTotal = book.getPrice().doubleValue() * quantity;
                                    totalPrice += itemTotal;
                        %>
                        <tr>
                            <td><img class="cart-item-image" src="<%= request.getContextPath() %>/images/Covers/<%= book.getImagePath() %>" alt="<%= book.getTitle() %>"></td>
                            <td><%= book.getTitle() %></td>
                            <td><%= quantity %></td>
                            <td>&euro;<%= book.getPrice() %></td>
                            <td>&euro;<%= itemTotal %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>

                <div class="cart-summary">
                    <span>Totale Carrello: </span>
                    <span>&euro;<%= totalPrice %></span>
                </div>

                <form action="<%= request.getContextPath() %>/Checkout.jsp" method="post">
                    <button type="submit" class="checkout-button">Procedi al Checkout</button>
                </form>
            </div>
<%
        }
    } else {
%>
        <p>Per visualizzare il carrello, devi prima effettuare il login.</p>
<%
    }
%>

<%@ include file="/jsp/Footer.jsp" %>

</body>
</html>
