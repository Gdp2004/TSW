package it.unisa.Controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginFormServlet")
public class LoginFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DataSource dataSource;

    @Override
    public void init() throws ServletException {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/Database");
        } catch (NamingException e) {
            throw new ServletException("Errore durante il lookup del DataSource", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String mode = request.getParameter("mode"); // "login" o "register"
        if (mode == null) {
            // Nessun mode specificato: fallback a login
            response.sendRedirect(request.getContextPath() + "/jsp/LoginForm.jsp?mode=login");
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String hashedPassword = toHash(password);

        try (Connection conn = dataSource.getConnection()) {
            if ("login".equals(mode)) {
                // LOGIN
                String sql = "SELECT * FROM UserAccount WHERE email = ? AND password_hash = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, email);
                    stmt.setString(2, hashedPassword);

                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        session.setAttribute("logged", true);
                        session.setAttribute("nome", rs.getString("name"));
                        session.setAttribute("email", rs.getString("email"));
                        session.setAttribute("utenteRegistrato", true);
                        response.sendRedirect(request.getContextPath() + "/Home.jsp");
                    } else {
                        // Login fallito: mostra errore
                        session.setAttribute("utenteRegistrato", true);
                        response.sendRedirect(request.getContextPath() + "/jsp/LoginForm.jsp?mode=login&errore=login");
                    }
                }
            } else if ("register".equals(mode)) {
                // REGISTRAZIONE
                String nome = request.getParameter("nome");
                String cognome = request.getParameter("cognome");

                // Controlla se l'email esiste già
                String checkSql = "SELECT * FROM UserAccount WHERE email = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setString(1, email);
                    ResultSet rs = checkStmt.executeQuery();
                    if (rs.next()) {
                        // Email già registrata
                        session.setAttribute("utenteRegistrato", false);
                        response.sendRedirect(request.getContextPath() + "/jsp/LoginForm.jsp?mode=register&errore=esiste");
                        return;
                    }
                }

                // Inserisci nuovo utente
                String insertSql = "INSERT INTO UserAccount (name, surname, email, password_hash, isAdmin) VALUES (?, ?, ?, ?, false)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setString(1, nome);
                    insertStmt.setString(2, cognome);
                    insertStmt.setString(3, email);
                    insertStmt.setString(4, hashedPassword);
                    insertStmt.executeUpdate();
                }

                // Registrazione riuscita: setta sessione e redirect home
                session.setAttribute("logged", true);
                session.setAttribute("utenteRegistrato", true);
                session.setAttribute("nome", nome);
                session.setAttribute("email", email);
                response.sendRedirect(request.getContextPath() + "/Home.jsp");
            } else {
                // Mode non valido, fallback
                response.sendRedirect(request.getContextPath() + "/jsp/LoginForm.jsp?mode=login");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private String toHash(String password) {
        String hashString = null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-512");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            hashString = sb.toString();
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Errore hashing password: " + e);
        }
        return hashString;
    }
}
