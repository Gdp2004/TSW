<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%  
    boolean dropdownActive = "true".equals(request.getParameter("active"));
  	String nextState     = dropdownActive ? "false" : "true";
  
  %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="styles/Logo-Search-Cart.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <script src="scripts/Logo-Search-Bar.js" defer></script> 
<title>Insert title here</title>
</head>
<body>

	<div id="logo-search-cart">
	
		<div id="logo-unibook">
		
			<img src="images/UniBook_Text_Logo.svg" alt="Logo" width="300" height="100">
		
		</div>
		
		<div id="container-search-bar">
		
			<form method="get" action="">
			
				<input type="hidden" name="active" value="<%=nextState%>">
				
				<button type="submit" id="dropdown-button" class="<%= dropdownActive ? "active" : "" %>">All
				
					<i class="fa-solid fa-chevron-down" id="dropdown-chevron"></i>
					
				</button>
				
				<input type="text" name="search-query" id="search-input" placeholder="Search by Title, Author, Keyword or ISBN">
				
				<button type="submit" class="search-btn">
				
   					<i class="fas fa-search"></i>
   					
  				</button>
			
			</form>
		
		</div>
		
		
		
		
	
	</div>

</body>
</html>