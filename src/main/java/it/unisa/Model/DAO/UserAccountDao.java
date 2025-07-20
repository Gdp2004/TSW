package it.unisa.Model.DAO;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import it.unisa.Model.UserAccount;

public class UserAccountDao {

	private static DataSource ds;

	static {
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");

			ds = (DataSource) envCtx.lookup("jdbc/Bookstore");

		} catch (NamingException e) {
			System.out.println("Error:" + e.getMessage());
		}
	}

    public List<UserAccount> doRetrieveAll(int offset, int limit) {
        String sql = "SELECT user_id, email, password_hash, name, surname, created_at, isAdmin FROM UserAccount LIMIT ?, ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            List<UserAccount> list = new ArrayList<>();
            while (rs.next()) {
                UserAccount u = new UserAccount();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setName(rs.getString("name"));
                u.setSurname(rs.getString("surname"));
                u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                u.setAdmin(rs.getBoolean("isAdmin"));
                list.add(u);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public UserAccount doRetrieveById(int id) {
        String sql = "SELECT * FROM UserAccount WHERE user_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserAccount u = new UserAccount();
                u.setUserId(id);
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setName(rs.getString("name"));
                u.setSurname(rs.getString("surname"));
                u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                u.setAdmin(rs.getBoolean("isAdmin"));
                return u;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSave(UserAccount user) {
        String sql = "INSERT INTO UserAccount(email, password_hash, name, surname, isAdmin) VALUES(?,?,?,?)";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getName());
            ps.setString(4, user.getSurname());
            ps.setBoolean(5, user.getIsAdmin());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                user.setUserId(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doUpdate(UserAccount user) {
        String sql = "UPDATE UserAccount SET email=?, password_hash=?, name=?, surname=? isAdmin=? WHERE user_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getName());
            ps.setString(4, user.getSurname());
            ps.setBoolean(5, user.getIsAdmin());
            ps.setInt(6, user.getUserId());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDelete(int id) {
        String sql = "DELETE FROM UserAccount WHERE user_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("DELETE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public UserAccount findByEmailAndPassword(String email, String passwordHash) throws SQLException {
        UserAccount utente = null;

        String query = "SELECT * FROM UserAccount WHERE email = ? AND password = ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    utente = new UserAccount();
                    utente.setEmail(rs.getString("email"));
                    utente.setName((rs.getString("name")));
                    utente.setSurname(rs.getString("surname"));
                    utente.setAdmin(rs.getBoolean("isAdmin"));

                }
            }
        }

        return utente;
    }
}
