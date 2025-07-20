<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="it.unisa.Model.Books" %>
<%
    Books book = (Books) request.getAttribute("books");
    if (book == null) {
        response.sendRedirect(request.getContextPath() + "/all.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= book.getTitle() %> – Dettaglio Prodotto</title>

  <!-- Navbar CSS -->
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/styles/Nav-bar-1.css"/>
  <!-- Logo-Search-Bar CSS -->
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>

  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f9f9f9;
      margin: 0;
      padding: 0;
    }
    .product-container {
      max-width: 1000px;
      margin-left: 100px;
      margin-top:50px;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      overflow: hidden;
    }
    .back-link {
      display: block;

            /* sposta più a sinistra */
  font-size: 1.25rem;
      color: #2C6FA0;
      text-decoration: none;
      font-weight: bold;
    }
    .back-link:hover {
      color: #1a4b6e;
    }
    .product-detail {
      display: flex;
      flex-wrap: wrap;
    }
    .product-image-wrapper {
      flex: 1 1 300px;
      background: #f0f0f0;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }
    .product-image {
      max-width: 100%;
      max-height: 400px;
      object-fit: contain;
      border-radius: 4px;
    }
    .product-info {
      flex: 1 1 400px;
      padding: 2rem;
    }
    .product-info h1 {
      margin-top: 0;
      font-size: 2rem;
      color: #333;
    }
    .product-info .author {
      color: #666;
      margin-bottom: 1rem;
      font-style: italic;
    }
    .product-info .description {
      line-height: 1.5;
      margin-bottom: 1.5rem;
      color: #444;
    }
    .product-info .price {
      font-size: 1.5rem;
      color: #2C6FA0;
      margin-bottom: 1.5rem;
    }
    .add-to-cart {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #2C6FA0;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
      text-transform: uppercase;
      text-decoration: none;
    }
    .add-to-cart:hover {
      background: #1a4b6e;
    }
    
    #toast {
      visibility: hidden;
      position: fixed;
      bottom: 2rem;
      right: 2rem;
      background: #2C6FA0;
      color: #fff;
      padding: 1rem 1.5rem;
      border-radius: 4px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.2);
      font-weight: bold;
      z-index: 1000;
      transition: visibility 0s, opacity 0.3s ease-in-out;
      opacity: 0;
    }
    #toast.show {
      visibility: visible;
      opacity: 1;
    }
    
    @media (max-width: 768px) {
      .product-detail {
        flex-direction: column;
      }
      .product-image-wrapper,
      .product-info {
        flex: 1 1 auto;
        padding: 1rem;
      }
      .product-image {
        max-height: 300px;
      }
    }
  </style>

</head>
<body>

  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <div class="product-container">
    <a href="<%=request.getContextPath()%>/all.jsp" class="back-link">
      &larr; Torna ai libri
    </a>
    <div class="product-detail">
      <!-- Immagine ridimensionata -->
      <div class="product-image-wrapper">
      <% String imgPath = book.getImagePath(); %>
        <img class="product-image"
     src="<%= (imgPath != null && !imgPath.isBlank())
           ? request.getContextPath() + "/images/Covers/" + imgPath
           : request.getContextPath() + "/imageservlet?isbn=" + book.getIsbn() %>"
     alt="Copertina di <%= book.getTitle() %>"/>
      </div>
      <!-- Dati libro -->
      <div class="product-info">
        <h1><%= book.getTitle() %></h1>
        <p class="author">di <%= book.getAuthor() %></p>
        <p class="description"><%= book.getDescription() %></p>
        <p class="price">Prezzo: &euro;<%= book.getPrice() %></p>
        <p class="isbn">ISBN: <%= book.getIsbn() %></p>

        <!-- Aggiungi al carrello -->
        <form action="<%=request.getContextPath()%>/AddToCartServlet" method="post">
          <input type="hidden" name="isbn" value="<%=book.getIsbn()%>"/>
          <button type="submit" class="add-to-cart" onclick="alert('✅ Libro aggiunto al carrello!');">Aggiungi al carrello</button>
        </form>
      </div>
    </div>
  </div>
  
  <div id="toast">Prodotto aggiunto al carrello!</div>

  <%@ include file="/jsp/Footer.jsp" %>
  
  <script>
  
  <script>
  // intercetta il submit di tutti i form "Aggiungi al carrello"
  document.querySelectorAll('form[action$="AddToCartServlet"]').forEach(form => {
    form.addEventListener('submit', function(e) {
      // crea un piccolo div posizionato in alto a destra
      const msg = document.createElement('div');
      msg.textContent = '✅ Prodotto aggiunto al carrello!';
      Object.assign(msg.style, {
        position: 'fixed',
        top: '1rem',
        right: '1rem',
        background: '#2C6FA0',
        color: '#fff',
        padding: '0.5rem 1rem',
        borderRadius: '4px',
        boxShadow: '0 2px 6px rgba(0,0,0,0.2)',
        zIndex: 1000,
        opacity: 0
      });
      document.body.appendChild(msg);
      // animazione fade-in
      setTimeout(() => msg.style.opacity = 1, 10);
      // rimuovilo dopo 2 secondi
      setTimeout(() => {
        msg.style.transition = 'opacity 0.5s';
        msg.style.opacity = 0;
        setTimeout(() => document.body.removeChild(msg), 500);
      }, 2000);
      // poi lascia andare avanti il submit
    });
  });
</script>

  
  </script>
</body>
</html>
