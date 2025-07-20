package it.unisa.Controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/profileupdateservlet")
public class ProfileUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DataSource ds;

    @Override
    public void init() throws ServletException {
        try {
            Context ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Database");
        } catch (NamingException e) {
            throw new ServletException("Impossibile trovare DataSource", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        HttpSession session = request.getSession();
        String name    = request.getParameter("nome");
        String surname = request.getParameter("surname");
        String email   = request.getParameter("email");
        String pwd     = request.getParameter("password");
        // Costruisci dinamicamente l'UPDATE SQL
        StringBuilder sql = new StringBuilder("UPDATE UserAccount SET name=?, surname=?, email=?");
        boolean updatePwd = (pwd != null && !pwd.trim().isEmpty());
        if (updatePwd) {
            sql.append(", password_hash=?");
        }
        sql.append(" WHERE email=?");

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setString(idx++, name);
            ps.setString(idx++, surname);
            ps.setString(idx++, email);
            if (updatePwd) {
                ps.setString(idx++, hashPassword(pwd));
            }
            ps.setString(idx, email);

            int updated = ps.executeUpdate();
            if (updated > 0) {
                // Aggiorna anche la sessione
                session.setAttribute("nome", name);
                session.setAttribute("email", email);
                session.setAttribute("profileUpdateSuccess", true);
            } else {
                session.setAttribute("profileUpdateSuccess", false);
            }
        } catch (SQLException e) {
            throw new ServletException("Errore aggiornamento profilo", e);
        }

        // Redirect indietro alla pagina impostazioni (puoi mostrare un messaggio di conferma)
        response.sendRedirect(request.getContextPath() + "/Impostazioni.jsp");
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            byte[] digest = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            throw new RuntimeException("SHA-512 non supportato", ex);
        }
    }
}
