package it.unisa.Controller;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import it.unisa.Model.Books;
import it.unisa.Model.Category;
import it.unisa.Model.DAO.BooksDao;
import it.unisa.Model.DAO.CategoryDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/searchservlet")
public class SearchServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private DataSource ds;

    @Override
    public void init() throws ServletException {
        try {
            Context ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Bookstore");
        } catch (Exception e) {
            throw new ServletException("Unable to lookup DataSource", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
           throws ServletException, IOException {
        String q = req.getParameter("search-query");
        if (q == null || q.isBlank()) {
            req.setAttribute("books", List.of());
            req.getRequestDispatcher("/SearchResult.jsp").forward(req, resp);
            return;
        }

        try {
            // 1) trova le categorie che matchano
            CategoryDao cdao = new CategoryDao(ds);
            List<Category> cats = cdao.searchByKeyword(q);
            BooksDao dao = new BooksDao(ds);
            List<Books> lb = dao.searchByKeyword(q);

            if(lb == null || lb.isEmpty()) {
            	
            	List<String> catIds = (cats == null)
                        ? List.of()
                        : cats.stream()
                              .map(c -> String.valueOf(c.getCategoryId()))
                              .collect(Collectors.toList());
            	
            	lb = dao.findByCategoryIds(catIds);
            	
            }
            

            // 4) invia a JSP
            req.setAttribute("books", lb != null ? lb : List.of());
        } catch (Exception e) {
            throw new ServletException("Search failure", e);
        }

        req.getRequestDispatcher("jsp/SearchResult.jsp")
           .forward(req, resp);
    }
}
