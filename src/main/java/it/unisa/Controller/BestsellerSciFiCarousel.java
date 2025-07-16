package it.unisa.Controller;

import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import it.unisa.Model.Books;
import it.unisa.Model.DAO.BooksDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class BestsellerSciFiCarousel
 */
@WebServlet("/bestsellers-sci-fi")
public class BestsellerSciFiCarousel extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public BestsellerSciFiCarousel() {
        super();
        // TODO Auto-generated constructor stub
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

// 2) Usa il DAO con il DataSource per caricare le immagini
BooksDao dao = new BooksDao(ds);
List<Books> bestsellers_sci_fi = dao.findByCategory("10");


// 3) (Opzionale) Puoi salvarli in sessione se ti serve in JSP/JS
request.getSession().setAttribute("bestsellers-sci-if", bestsellers_sci_fi);

// 4) Redirect alla pagina di provenienza per forzare il reload
String referer = request.getContextPath() + "/Home.jsp";
if (referer != null && !referer.isEmpty()) {
response.sendRedirect(referer);
} else {
// fallback: ricarica la home del progetto
response.sendRedirect(request.getContextPath() + "/Home.jsp");
}
}

@Override
protected void doPost(HttpServletRequest request,
             HttpServletResponse response)
             throws ServletException, IOException {
doGet(request, response);
}

}
