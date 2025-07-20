package it.unisa.Controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

@WebServlet("/imageservlet")
public class ImageServlet extends HttpServlet {
    /**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private DataSource ds;

    @Override
    public void init() throws ServletException {
        try {
            Context init = new InitialContext();
            Context env  = (Context) init.lookup("java:/comp/env");
            ds = (DataSource) env.lookup("jdbc/Database");
        } catch (NamingException e) {
            throw new ServletException("Impossibile reperire DataSource", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
           throws ServletException, IOException {
        String isbn = req.getParameter("isbn");
        if (isbn == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String sql = "SELECT image_blob FROM Book WHERE isbn = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, isbn);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                Blob blob = rs.getBlob("image_blob");
                // opzionale: se hai anche image_path ma blob è null?
                if (blob == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                // imposta MIME type dinamicamente (se sai che è jpeg/png)
                resp.setContentType(getServletContext().getMimeType(isbn + ".jpg"));
                resp.setContentLengthLong(blob.length());

                try (InputStream in = blob.getBinaryStream();
                     var out = resp.getOutputStream()) {
                    byte[] buf = new byte[8192];
                    int len;
                    while ((len = in.read(buf)) != -1) {
                        out.write(buf, 0, len);
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Errore recupero immagine", e);
        }
    }
}
