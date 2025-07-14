<%@ page import="java.util.List, javax.sql.DataSource, it.unisa.Model.DAO.BooksDao, it.unisa.Model.Books" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Bestsellers</title>
  <!-- Bootstrap CSS -->
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    rel="stylesheet"
  />
  <style>
    .book-col {
      flex: 0 0 14.2857%;
      max-width: 14.2857%;
      padding: 0 .5rem;
      text-align: center;
    }
    .book-col img {
      width: 100%;
      height: 300px;
      object-fit: cover;
      margin-bottom: .5rem;
    }
    .book-col h6 {
      font-size: 1rem;
      margin-bottom: .25rem;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .book-col small {
      font-size: .85rem;
      color: #555;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .carousel-header h2 { font-style: italic; }
    .carousel-control-button {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      z-index: 10;
    }
    .carousel-control-button.prev { left: -60px; }
    .carousel-control-button.next { right: -60px; }
  </style>
</head>
<body>

<%
  // 1) Carico tutti i bestsellers
  DataSource ds = (DataSource)application.getAttribute("DataSource");
  List<Books> all = new BooksDao(ds).findByCategory(1);
  // 2) Prendo solo i primi 12 (se ce ne sono)
  List<Books> books = (all.size() > 12) ? all.subList(0, 12) : all;
  final int perSlide = 7;
%>

<div class="container my-4 position-relative">
  <div class="d-flex justify-content-between align-items-baseline mb-3">
    <h2>Bestsellers</h2>
    <a href="<%=request.getContextPath()%>/bestsellers">See All</a>
  </div>

  <div id="multiCarousel" class="carousel slide">
    <!-- Prev/Next visibili -->
    <button class="btn btn-outline-primary carousel-control-button prev"
            type="button" data-bs-target="#multiCarousel" data-bs-slide="prev">
      ‹ Prev
    </button>
    <button class="btn btn-outline-primary carousel-control-button next"
            type="button" data-bs-target="#multiCarousel" data-bs-slide="next">
      Next ›
    </button>

    <div class="carousel-inner">
      <% if (books != null && !books.isEmpty()) {
   
           for (int i = 0; i < books.size(); i += perSlide) {
             String active = (i == 0) ? " active" : "";
      %>
      <div class="carousel-item<%=active%>">
        <div class="d-flex">
          <% for (int j = 0; j < perSlide; j++) {
               int idx = i + j;
               if (idx < books.size()) {
                 Books b = books.get(idx);
          %>
          <div class="book-col">
            <img
              src="<%=request.getContextPath()%>/images/Covers/<%=b.getImagePath()%>"
              alt="<%=b.getTitle()%>"
            />
            <h6 title="<%=b.getTitle()%>"><%=b.getTitle()%></h6>
            <small><%=b.getAuthor()%></small>
          </div>
          <%   }
             } %>
        </div>
      </div>
      <%   }
         } else { %>
      <div class="carousel-item active text-center p-5">
        Nessun bestseller disponibile
      </div>
      <% } %>
    </div>
  </div>
</div>

<!-- Bootstrap JS bundle -->
<script
  src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>
</body>
</html>