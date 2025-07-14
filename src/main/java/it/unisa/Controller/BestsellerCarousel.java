package it.unisa.Controller;

import it.unisa.Model.Books;
import it.unisa.Model.DAO.BooksDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/BestsellerCarousel")
public class BestsellerCarousel extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BestsellerCarousel() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {
        // 1) Recupera i bestseller dal DAO
        BooksDao dao = new BooksDao();
        List<Books> bestsellers = dao.findByCategory(1, 0, 10);

        // 2) Metti la lista in request
        request.setAttribute("bestsellers", bestsellers);

        // 3) Forwarda alla JSP che renderizza il carousel
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/Bestseller-List.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {
        // semplicemente reindirizza al doGet
        doGet(request, response);
    }
}
