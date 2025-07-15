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
 
</head>
<body>

<%
  DataSource ds_history = (DataSource)application.getAttribute("DataSource");
  List<Books> all_history = new BooksDao(ds_history).findByCategory("12");
  // prendo fino a 12, ma mostro 5 per slide
  List<Books> books_history = (all_history.size() > 12) ? all_history.subList(0, 12) : all_history;
  final int perSlide_history = 5;
%>

<div class="container my-4 position-relative" id="bestseller-carousel">
  <div class="d-flex justify-content-between align-items-baseline mb-3">
    <h2>Bestsellers History</h2>
    <a href="<%=request.getContextPath()%>/bestsellers-sci-fi">See All</a>
  </div>

  <div id="multiCarouselHistory" class="carousel slide">
    <!-- Prev/Next visibili -->
    <button class="btn btn-outline-primary carousel-control-button prev"
            type="button" data-bs-target="#multiCarouselHistory" data-bs-slide="prev">
      ‹ Prev
    </button>
    <button class="btn btn-outline-primary carousel-control-button next"
            type="button" data-bs-target="#multiCarouselHistory" data-bs-slide="next">
      Next ›
    </button>

    <div class="carousel-inner">
      <% if (books_history != null && !books_history.isEmpty()) {
           for (int i = 0; i < books_history.size(); i += perSlide_history) {
             String active = (i == 0) ? " active" : "";
      %>
      <div class="carousel-item<%=active%>">
        <div class="d-flex">
          <% for (int j = 0; j < perSlide_history; j++) {
               int idx = i + j;
               if (idx < books_history.size()) {
                 Books b = books_history.get(idx);
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