<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>UniBook</title>
  
  <link rel="stylesheet" href="styles/Home.css">
  <link rel="stylesheet" href="styles/Advertisement-1.css">
  <link rel="stylesheet" href="styles/Nav-bar-1.css">
  <link rel="stylesheet" href="styles/Logo-Search-Cart.css">
  <link rel="stylesheet" href="styles/Bestseller-List.css">
  <link rel="stylesheet" href="styles/Culturia.css">

  
  <script src="scripts/Advertisement-1.js" defer></script>
  <script src="scripts/Logo-Search-Bar.js" defer></script>
  
</head>

<body>


	<!-- HEADER + TOP ADVERTISEMENT -->
	
	<%@ include file="jsp/Advertisement-1.jsp" %>
	
	<!-- NAVIGATION BAR -->
	
	<div id="container-Nav-bar-1">
	
		<%@ include file="jsp/Nav-bar-1.jsp" %>
	
	</div>
	
	
	<!-- LOGO + SEARCH BAR + CART/CHECKOUT -->
	
	<%@ include file="jsp/Logo-Search-Cart.jsp" %>
	
	<!-- BESTSELLER CULTURIA -->
	
	<%@ include file="jsp/Culturia.jsp" %>
	
	<!-- BESTSELLERS CAROUSEL -->
	
	<%@ include file="jsp/BestSellersCarousels/Bestseller-List.jsp" %>
	
	<!-- COMING SOON CAROUSEL -->
	
	<%@ include file="jsp/BestSellersCarousels/ComingSoon-List.jsp" %>
	
	<!-- 2 NAVIGATION BAR -->
	
	<%@ include file="jsp/Nav-bar-2.jsp" %>
	
	<!-- BESTSELLER SCI-FI CAROUSEL -->
	
	<%@ include file="jsp/BestSellersCarousels/Bestseller-Sci-Fi.jsp" %>
	
	<!-- BESTSELLER HISTORY CAROUSEL -->
	
	<%@ include file="jsp/BestSellersCarousels/Bestseller-History.jsp" %>
	
	<!-- BESTSELLER NARRATIVE CAROUSEL -->
	
	<%@ include file="jsp/BestSellersCarousels/Bestseller-Narrative.jsp" %>
	
	<!-- BESTSELLER ART CAROUSEL -->
	
	<%@ include file="jsp/BestSellersCarousels/Bestseller-Art.jsp" %>
	
	<!-- BESTSELLER TECHNOLOGY CAROUSEL -->
	
	<%@ include file="jsp/BestSellersCarousels/Bestseller-Technology.jsp" %>
	
	<!-- BESTSELLER KIDS CAROUSEL -->
	
	<%@ include file="jsp/BestSellersCarousels/Bestseller-Kids.jsp" %>
	
	<!-- NEWSLETTER + FOOTER -->
	
	<%@ include file="jsp/Footer.jsp" %>
	

</body>
</html>
