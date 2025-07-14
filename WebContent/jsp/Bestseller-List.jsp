<%@ page language="java" import="java.util.List, it.unisa.Model.Books" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Bestseller Carousel</title>
	
</head>
<body>
	
	<h2>BestSellers</h2>
	
	<%
	
		List<Books> books = (List<Books>) request.getAttribute("bestsellers");
	
		if(books != null && !books.isEmpty()){
	
	%>
	
			<div id="Bestseller-div">
			
				<%
					for(Books c: books){ 
					
				%>
				
						<img src="images/Covers/<%=c.getImagePath()%>">
						
						
				<%
				
					}
				
				%>
			
			</div>
			
			
	<%
	
		}else{
	
	%>
	
		<p>Non trovati</p>
		
		
	<%
	
		}
	
	%>
	
</body>
</html>
