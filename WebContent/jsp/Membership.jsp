<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Membership – UniBook</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Nav-bar-1.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/Logo-Search-Cart.css"/>
  <style>
    .membership-container {
      max-width: 800px; margin: 2rem auto; padding: 1rem;
      background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      font-family: sans-serif;
    }
    h1 { color: #2C6FA0; margin-bottom: 1rem; }
    p { line-height: 1.6; }
    .plans { display: flex; gap: 1rem; margin-top: 2rem; }
    .plan {
      flex: 1; border: 1px solid #ccc; border-radius: 6px;
      padding: 1rem; text-align: center;
    }
    .plan h3 { margin-top: 0; color: #2C6FA0; }
    .plan button {
      margin-top: 1rem; padding: 0.5rem 1.5rem;
      background: linear-gradient(135deg,#2C6FA0,#5BB5E5);
      color: #fff; border: none; border-radius: 4px; cursor: pointer;
    }
    .plan button:hover { opacity: 0.9; }
  </style>
</head>
<body>
  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <div class="membership-container">
    <h1>Membership UniBook</h1>
    <p>
      Diventa membro UniBook e approfitta di vantaggi esclusivi:
      sconti dedicati, spedizioni gratuite e accesso anticipato alle novità editoriale.
      Scegli il piano che fa per te!
    </p>

    <div class="plans">
      <div class="plan">
        <h3>Base</h3>
        <p>€0 / mese</p>
        <p>Accesso standard alla community</p>
        <button>Attiva</button>
      </div>
      <div class="plan">
        <h3>Premium</h3>
        <p>€4.99 / mese</p>
        <p>Spedizioni gratuite + 10% di sconto</p>
        <button>Attiva</button>
      </div>
      <div class="plan">
        <h3>Deluxe</h3>
        <p>€9.99 / mese</p>
        <p>Spedizioni gratuite + 20% di sconto + early access</p>
        <button>Attiva</button>
      </div>
    </div>
  </div>

  <%@ include file="/jsp/Footer.jsp" %>
</body>
</html>
