<%@ page import="java.util.List, javax.sql.DataSource, it.unisa.Model.DAO.BooksDao, it.unisa.Model.Books" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Coming Soon</title>
  <!-- Bootstrap CSS -->
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    rel="stylesheet"
  />
  

  
</head>
<body>

<%
  DataSource ds_comingsoon = (DataSource)application.getAttribute("DataSource");
  List<Books> all_comingsoon = new BooksDao(ds_comingsoon).findByCategory("2");
  // prendo fino a 12, ma mostro 5 per slide
  List<Books> books_comingsoon = (all_comingsoon.size() > 12) ? all_comingsoon.subList(0, 12) : all_comingsoon;
  final int perSlide_comingsoon = 5;
%>

<div class="container my-4 position-relative" id="comingsoon-carousel">
  <div class="d-flex justify-content-between align-items-baseline mb-3">
    <h2>Coming Soon</h2>
    <a href="<%=request.getContextPath()%>/comingsoon">See All</a>
  </div>

  <div id="multiCarousel-comingsoon" class="carousel slide">
    <!-- Prev/Next visibili -->
    <button class="btn btn-outline-primary carousel-control-button prev"
            type="button" data-bs-target="#multiCarousel-comingsoon" data-bs-slide="prev">
      ‹ Prev
    </button>
    <button class="btn btn-outline-primary carousel-control-button next"
            type="button" data-bs-target="#multiCarousel-comingsoon" data-bs-slide="next">
      Next ›
    </button>

    <div class="carousel-inner">
      <% if (books_comingsoon != null && !books_comingsoon.isEmpty()) {
           for (int i = 0; i < books_comingsoon.size(); i += perSlide_comingsoon) {
             String active = (i == 0) ? " active" : "";
      %>
      <div class="carousel-item<%=active%>">
        <div class="d-flex">
          <% for (int j = 0; j < perSlide_comingsoon; j++) {
               int idx = i + j;
               if (idx < books_comingsoon.size()) {
                 Books b = books_comingsoon.get(idx);
          %>
          <div class="book-col">
          <a href="<%= request.getContextPath()%>/bookdetailservlet?isbn=<%= b.getIsbn()%>">
            <img
              src="<%=request.getContextPath()%>/images/Covers/<%=b.getImagePath()%>"
              alt="<%=b.getTitle()%>"
            />
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
        Nessun Coming soon disponibile
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