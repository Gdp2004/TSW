<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>About Us – UniBook</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Nav-bar-1.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>
  <style>
    .about-container {
      max-width: 800px; margin: 2rem auto; padding:1rem;
      background:#fff; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);
      font-family:sans-serif;
    }
    h1 { color:#2C6FA0; margin-bottom:1rem; }
    .team { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:1rem; margin-top:2rem;}
    .member {
      text-align:center; padding:1rem; border:1px solid #eee; border-radius:6px;
    }
    .member img {
      width:100px; height:100px; border-radius:50%; object-fit:cover; margin-bottom:.5rem;
    }
    .member h4 { margin:0.5rem 0 0.25rem; color:#2C6FA0; }
    .member p { margin:0; font-size:.9rem; color:#555; }
  </style>
</head>
<body>
  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <div class="about-container">
    <h1>Chi Siamo</h1>
    <p>
      UniBook è la community online per amanti dei libri di tutte le età. 
      Nato nel 2025, il nostro obiettivo è connettere lettori, autori e appassionati 
      in un unico luogo dove scoprire, condividere e acquistare i propri titoli preferiti.
    </p>

    <h2>Il nostro Team</h2>
    <div class="team">
      <div class="member">
        <h4>Gabriele di Palma</h4>
      </div>
     </div>
     
   </div>
      

  <%@ include file="/jsp/Footer.jsp" %>
</body>
</html>
