<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="it.unisa.Model.Books,java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Books> books = (List<Books>) request.getAttribute("books");
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Risultati Ricerca – UniBook</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Nav-bar-1.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>
  <style>
    body {
      background: #f7f9fb;
      color: #333;
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 1100px;
      margin: 2rem auto;
      padding: 0 1rem;
    }
    h1 {
      font-size: 2rem;
      color: #2C6FA0;
      margin-bottom: 1.5rem;
      text-align: center;
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
      gap: 1.5rem;
    }
    .card {
      background: #fff;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0,0,0,0.05);
      transition: transform 0.2s, box-shadow 0.2s;
      display: flex;
      flex-direction: column;
    }
    .card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    .card img {
      width: 100%;
      height: 160px;
      object-fit: cover;
      background: #ececec;
    }
    .card-content {
      padding: 1rem;
      flex-grow: 1;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }
    .card-content h3 {
      font-size: 1.1rem;
      margin: 0 0 0.5rem;
      color: #2C6FA0;
    }
    .card-content p.author {
      font-size: 0.9rem;
      color: #666;
      margin: 0 0 1rem;
    }
    .card-content .btn-view {
      align-self: flex-start;
      padding: 0.5rem 1rem;
      background: linear-gradient(135deg, #2C6FA0, #5BB5E5);
      color: #fff;
      border: none;
      border-radius: 4px;
      text-decoration: none;
      font-size: 0.9rem;
      transition: background 0.2s;
    }
    .card-content .btn-view:hover {
      background: linear-gradient(135deg, #1a4b6e, #3a8ecf);
    }
    .no-results {
      text-align: center;
      color: #777;
      font-size: 1.1rem;
      padding: 2rem 0;
    }
    @media (max-width: 600px) {
      h1 { font-size: 1.5rem; }
    }
  </style>
</head>
<body>
  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <div class="container">
    <h1>Risultati per “<%= request.getParameter("search-query") %>”</h1>

    <div class="grid">
      <%
        if (books == null || books.isEmpty()) {
      %>
        <div class="no-results">Nessun risultato trovato.</div>
      <% } else {
           for (Books b : books) {
             String imgPath = b.getImagePath();
      %>
        <div class="card">
          <a href="<%= request.getContextPath() %>/bookdetailservlet?isbn=<%= b.getIsbn() %>">
            <img src="<%= (imgPath != null && !imgPath.isBlank())
                         ? request.getContextPath() + "/images/Covers/" + imgPath
                         : request.getContextPath() + "/imageservlet?isbn=" + b.getIsbn() %>"
                 alt="Copertina di <%= b.getTitle() %>"/>
          </a>
          <div class="card-content">
            <div>
              <h3><%= b.getTitle() %></h3>
              <p class="author">di <%= b.getAuthor() %></p>
            </div>
            <a class="btn-view"
               href="<%= request.getContextPath() %>/bookdetailservlet?isbn=<%= b.getIsbn() %>">
              Dettagli
            </a>
          </div>
        </div>
      <%   }
         }
      %>
    </div>
  </div>

  <%@ include file="/jsp/Footer.jsp" %>
</body>
</html>
