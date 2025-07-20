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
  DataSource ds_scifi = (DataSource)application.getAttribute("DataSource");
  List<Books> all_scifi = new BooksDao(ds_scifi).findByCategory("10");
  // prendo fino a 12, ma mostro 5 per slide
  List<Books> books_scifi = (all_scifi.size() > 12) ? all_scifi.subList(0, 12) : all_scifi;
  final int perSlide_scifi = 5;
%>

<div class="container my-4 position-relative" id="bestseller-carousel">
  <div class="d-flex justify-content-between align-items-baseline mb-3">
    <h2>Bestsellers Sci-Fi</h2>
    <a href="<%=request.getContextPath()%>/bestsellers-sci-fi">See All</a>
  </div>

  <div id="multiCarouselScifi" class="carousel slide">
    <!-- Prev/Next visibili -->
    <button class="btn btn-outline-primary carousel-control-button prev"
            type="button" data-bs-target="#multiCarouselSCifi" data-bs-slide="prev">
      ‹ Prev
    </button>
    <button class="btn btn-outline-primary carousel-control-button next"
            type="button" data-bs-target="#multiCarouselSCifi" data-bs-slide="next">
      Next ›
    </button>

    <div class="carousel-inner">
      <% if (books_scifi != null && !books_scifi.isEmpty()) {
           for (int i = 0; i < books_scifi.size(); i += perSlide_scifi) {
             String active = (i == 0) ? " active" : "";
      %>
      <div class="carousel-item<%=active%>">
        <div class="d-flex">
          <% for (int j = 0; j < perSlide_scifi; j++) {
               int idx = i + j;
               if (idx < books_scifi.size()) {
                 Books b = books_scifi.get(idx);
          %>
          <div class="book-col">
          <a href="<%= request.getContextPath()%>/bookdetailservlet?isbn=<%= b.getIsbn()%>">
      <% String imgPath = b.getImagePath(); %>
        <img class="cover"
     src="<%= (imgPath != null && !imgPath.isBlank())
           ? request.getContextPath() + "/images/Covers/" + imgPath
           : request.getContextPath() + "/imageservlet?isbn=" + b.getIsbn() %>"
     alt="Copertina di <%= b.getTitle() %>"/>
            </a>
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