<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="javax.naming.Context,javax.naming.InitialContext,javax.sql.DataSource,it.unisa.Model.DAO.BooksDao,it.unisa.Model.Books,java.util.List" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Libri Casuali</title>
  <!-- FontAwesome per le icone -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  <style>
    /* Container a griglia */
    .books-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      padding: 1rem;
      justify-content: flex-start;
    }
    /* Card singola */
    .book-card {
      width: 160px;
      text-align: center;
      font-family: sans-serif;
    }
    .book-card .image-wrapper {
      position: relative;
    }
    .book-card img.cover {
      width: 100%;
      height: auto;
      border-radius: 4px;
    }
    /* Icona cuore in alto a destra */
    .book-card .favorite-icon {
      position: absolute;
      top: 8px;
      right: 8px;
      color: #fff;
      text-shadow: 0 0 5px rgba(0,0,0,0.5);
      font-size: 1.2rem;
      cursor: pointer;
    }
    .book-card h3 {
      font-size: 0.9rem;
      margin: 0.5rem 0 0.25rem;
      height: 2.4em;      /* due righe circa */
      overflow: hidden;
    }
    .book-card p.author {
      font-size: 0.8rem;
      color: #555;
      margin: 0 0 0.5rem;
    }
    .book-card .quick-add {
      display: inline-block;
      padding: 0.3rem 0.5rem;
      font-size: 0.75rem;
      border: 1px solid #2C6FA0;
      background: #fff;
      color: #2C6FA0;
      border-radius: 4px;
      text-transform: uppercase;
      cursor: pointer;
    }
    .book-card .quick-add:hover {
      background: #2C6FA0;
      color: #fff;
    }
  </style>
</head>
<body>

<%

Context initCtx = new InitialContext();
Context envCtx  = (Context) initCtx.lookup("java:comp/env");
DataSource ds   = (DataSource) envCtx.lookup("jdbc/Database");

BooksDao dao            = new BooksDao(ds);
    
    List<Books> randomBooks = dao.findRandom();
%>

<h1>Libri Casuali</h1>

<div class="books-grid">
<%
    if (randomBooks != null) {
        for (Books b : randomBooks) {
%>
  <div class="book-card">
    <div class="image-wrapper">
      <img class="cover"
           src="<%=request.getContextPath()%>/images/Covers/<%=b.getImagePath()%>"
           alt="Copertina di <%=b.getTitle()%>"/>
      <i class="fa-regular fa-heart favorite-icon"></i>
    </div>
    <h3><%= b.getTitle() %></h3>
    <p class="author">by <%= b.getAuthor() %></p>
    <button class="quick-add">Quick Add</button>
  </div>
<%
        }
    }
%>
</div>

</body>
</html>
