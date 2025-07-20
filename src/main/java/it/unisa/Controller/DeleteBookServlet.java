package it.unisa.Controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deletebookservlet")
public class DeleteBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DataSource ds;

    @Override
    public void init() throws ServletException {
        try {
            Context ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Bookstore");
        } catch (NamingException e) {
            throw new ServletException("Impossibile recuperare il DataSource", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String isbn = request.getParameter("isbn");
        if (isbn == null || isbn.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ISBN non fornito");
            return;
        }

        // 1) Prepariamo le due DELETE
        final String DELETE_CATEGORIES = "DELETE FROM BookCategory WHERE isbn = ?";
        final String DELETE_BOOK       = "DELETE FROM Book         WHERE isbn = ?";

        try (Connection con = ds.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps1 = con.prepareStatement(DELETE_CATEGORIES);
                 PreparedStatement ps2 = con.prepareStatement(DELETE_BOOK)) {

                // rimuovo prima le associazioni
                ps1.setString(1, isbn);
                ps1.executeUpdate();

                // poi il libro
                ps2.setString(1, isbn);
                int deleted = ps2.executeUpdate();

                if (deleted == 0) {
                    // nessun libro cancellato: probabilmente ISBN inesistente
                    con.rollback();
                    request.getSession().setAttribute("err", "Nessun libro trovato con ISBN " + isbn);
                } else {
                    con.commit();
                    request.getSession().setAttribute("msg", "Libro con ISBN " + isbn + " eliminato con successo.");
                }
            } catch (SQLException ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException ex) {
            throw new ServletException("Errore durante l'eliminazione del libro", ex);
        }

        // Ritorno alla tab di gestione prodotti
        response.sendRedirect(request.getContextPath() + "/Impostazioni.jsp?tab=manageProducts");
    }
}
