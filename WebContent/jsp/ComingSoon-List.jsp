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
    
    .prev, .next{
    
    	color: black;
    	
    }
    
    a {
      color: #2C6FA0;
      text-decoration: none;
      font-weight: 500;
    }
    a:hover {
      text-decoration: underline;
      color: #A6D4C9;
    }
    
    .carousel-control-button {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    z-index: 10;
    border: 2px solid #A6D4C9;
    color: #2C6FA0;
    background-color: transparent;
    transition: all 0.3s ease;
  }

  .carousel-control-button.prev { left: -50px; }
  .carousel-control-button.next { right: -50px; }

  .carousel-control-button:hover {
    background-color: #A6D4C9;
    color: white;
    border-color: #A6D4C9;
  }
	
  </style>
  
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