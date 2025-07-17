package it.unisa.Controller;

import java.io.IOException;
import javax.sql.DataSource;

import it.unisa.Model.Books;
import it.unisa.Model.DAO.BooksDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/bookdetailservlet")
public class BookDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BookDetailServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {



        // 1) Recupera il DataSource dal ServletContext
        DataSource ds = (DataSource) getServletContext().getAttribute("DataSource");
        if (ds == null) {
            throw new ServletException("DataSource non trovato nel contesto.");
        }
        
        String isbn = request.getParameter("isbn");
        if (isbn == null || isbn.isBlank()) {
          response.sendRedirect(request.getContextPath()+"/all.jsp");
          return;
        }

        // 2) Usa il DAO con il DataSource per caricare le immagini
        BooksDao dao = new BooksDao(ds);
        Books books = dao.findByIsbn(isbn);


        // 3) (Opzionale) Puoi salvarli in sessione se ti serve in JSP/JS
        if (books == null) {
            response.sendRedirect(request.getContextPath()+"/all.jsp");
            return;
          }

          request.setAttribute("books", books);
          request.getRequestDispatcher("/jsp/Product.jsp")
             .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {
        doGet(request, response);
}

}