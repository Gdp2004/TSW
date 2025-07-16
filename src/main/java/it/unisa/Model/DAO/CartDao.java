package it.unisa.Model.DAO;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import it.unisa.Model.Cart;


public class CartDao {

	private static DataSource ds;

	static {
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");

			ds = (DataSource) envCtx.lookup("jdbc/Database");

		} catch (NamingException e) {
			System.out.println("Error:" + e.getMessage());
		}
	}

    public List<Cart> doRetrieveAll(int offset, int limit) {
        String sql = "SELECT cart_id, user_id, created_at, last_update FROM Cart LIMIT ?, ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            List<Cart> list = new ArrayList<>();
            while (rs.next()) {
                Cart c = new Cart();
                c.setCartId(rs.getString("cart_id"));
                c.setUserId(rs.getObject("user_id", Integer.class));
                c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                c.setLastUpdate(rs.getTimestamp("last_update").toLocalDateTime());
                list.add(c);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Cart doRetrieveById(String id) {
        String sql = "SELECT * FROM Cart WHERE cart_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Cart c = new Cart();
                c.setCartId(id);
                c.setUserId(rs.getObject("user_id", Integer.class));
                c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                c.setLastUpdate(rs.getTimestamp("last_update").toLocalDateTime());
                return c;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSave(Cart cart) {
        String sql = "INSERT INTO Cart(cart_id, user_id) VALUES(?,?)";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, cart.getCartId());
            if (cart.getUserId() != null) {
				ps.setInt(2, cart.getUserId());
			} else {
				ps.setNull(2, Types.INTEGER);
			}
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doUpdate(Cart cart) {
        String sql = "UPDATE Cart SET user_id=? WHERE cart_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (cart.getUserId() != null) {
				ps.setInt(1, cart.getUserId());
			} else {
				ps.setNull(1, Types.INTEGER);
			}
            ps.setString(2, cart.getCartId());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDelete(String id) {
        String sql = "DELETE FROM Cart WHERE cart_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("DELETE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Salva gli articoli nel carrello nel database.
     * @param cartId L'ID del carrello
     * @param cartItems Una lista di ISBN degli articoli nel carrello
     */
    public void saveCart(String cartId, List<String> cartItems) {
        String sql = "INSERT INTO CartItem (cart_id, isbn, quantity) VALUES (?, ?, 1) " +
                     "ON DUPLICATE KEY UPDATE quantity = quantity + 1";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (String isbn : cartItems) {
                ps.setString(1, cartId);
                ps.setString(2, isbn);
                ps.addBatch(); // Aggiungi l'operazione al batch
            }

            ps.executeBatch(); // Esegui tutte le operazioni in una volta

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante il salvataggio del carrello.", e);
        }
    }
}
