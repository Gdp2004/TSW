package it.unisa.Controller;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 * Servlet implementation class ProductManagementServlet
 */
@WebServlet("/productmanagementservlet")
@MultipartConfig(
		  fileSizeThreshold = 1024 * 1024,  // 1MB
		  maxFileSize       = 5 * 1024 * 1024,  // 5MB
		  maxRequestSize    = 10 * 1024 * 1024  // 10MB
		)
public class ProductManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductManagementServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    // 1) Parametri testo
	    String isbn        = request.getParameter("isbn");
	    String title       = request.getParameter("title");
	    String author      = request.getParameter("author");
	    String description = request.getParameter("description");
	    BigDecimal price   = new BigDecimal(request.getParameter("price"));
	    int stockQty       = Integer.parseInt(request.getParameter("stock_qty"));
	    DataSource ds;

	    // 2) Categorie (più checkbox → request.getParameterValues)
	    String[] cats = request.getParameterValues("categories"); // array di category_id

	    // 3) Parte file
	    Part imagePart = request.getPart("image"); // name="image" nel form
	    InputStream imageStream = null;
	    if (imagePart != null && imagePart.getSize() > 0) {
	        imageStream = imagePart.getInputStream();
	    }

	    try {
            Context initCtx = new InitialContext();
            Context envCtx  = (Context) initCtx.lookup("java:comp/env");
            // "jdbc/Database" è il name che hai definito in <resource-ref> o in context.xml
            ds = (DataSource) envCtx.lookup("jdbc/Bookstore");
        } catch (NamingException e) {
            throw new ServletException("Impossibile reperire il DataSource", e);
        }

	    // 4) Inserimento nel DB
	    try (Connection conn = ds.getConnection()) {
	        conn.setAutoCommit(false);

	        // 4a) Inserisci in Book (con blob)
	        String insertBook =
	          "INSERT INTO Book(isbn,title,author,description,price,stock_qty,image_blob) " +
	          "VALUES (?,?,?,?,?,?,?)";
	        try (PreparedStatement p = conn.prepareStatement(insertBook)) {
	            p.setString(1, isbn);
	            p.setString(2, title);
	            p.setString(3, author);
	            p.setString(4, description);
	            p.setBigDecimal(5, price);
	            p.setInt(6, stockQty);
	            if (imageStream != null) {
	                p.setBlob(7, imageStream);
	            } else {
	                p.setNull(7, Types.BLOB);
	            }
	            p.executeUpdate();
	        }

	        // 4b) Inserisci associazioni in BookCategory
	        if (cats != null) {
	            String insertCat =
	              "INSERT INTO BookCategory(isbn,category_id) VALUES (?,?)";
	            try (PreparedStatement p2 = conn.prepareStatement(insertCat)) {
	                for (String catId : cats) {
	                    p2.setString(1, isbn);
	                    p2.setString(2, catId);
	                    p2.addBatch();
	                }
	                p2.executeBatch();
	            }
	        }

	        conn.commit();
	    } catch (SQLException e) {
	        throw new ServletException("Errore inserimento libro", e);
	    }

	    response.sendRedirect(request.getContextPath() + "/Impostazioni.jsp?tab=manageProducts&success=1");
	}


}
