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
    /* 5 items per slide: 100%/5 = 20% each */
    .book-col {
      flex: 0 0 20%;
      max-width: 20%;
      /* padding for spacing */
      padding: 0 0.75rem;
      box-sizing: border-box;
      text-align: center;
    }
    
    .book-col img {
      width: 100%;
      height: 300px;
      object-fit: cover;
      margin-bottom: 0.5rem;
      border-radius: 4px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    .book-col h6 {
      font-size: 1rem;
      margin-bottom: 0.25rem;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .book-col small {
      font-size: 0.85rem;
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
    .carousel-control-button.prev { left: -50px; }
    .carousel-control-button.next { right: -50px; }
  </style>
</head>
<body>

<%
  DataSource ds = (DataSource)application.getAttribute("DataSource");
  List<Books> all = new BooksDao(ds).findByCategory(1);
  // prendo fino a 12, ma mostro 5 per slide
  List<Books> books = (all.size() > 12) ? all.subList(0, 12) : all;
  final int perSlide = 5;
%>

<div class="container my-4 position-relative" id="bestseller-carousel">
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