package it.unisa.Model.DAO;



import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import it.unisa.Model.CartItem;


public class CartItemDao {
	
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

    public List<CartItem> doRetrieveByCartId(String cartId) {
        String sql = "SELECT cart_item_id, cart_id, isbn, quantity, unit_price, added_at "
                   + "FROM CartItem WHERE cart_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, cartId);
            ResultSet rs = ps.executeQuery();
            List<CartItem> list = new ArrayList<>();
            while (rs.next()) {
                CartItem ci = new CartItem();
                ci.setCartItemId(rs.getInt("cart_item_id"));
                ci.setCartId(cartId);
                ci.setIsbn(rs.getString("isbn"));
                ci.setQuantity(rs.getInt("quantity"));
                ci.setUnitPrice(rs.getBigDecimal("unit_price"));
                ci.setAddedAt(rs.getTimestamp("added_at").toLocalDateTime());
                list.add(ci);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public CartItem doRetrieveById(int id) {
        String sql = "SELECT * FROM CartItem WHERE cart_item_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CartItem ci = new CartItem();
                ci.setCartItemId(id);
                ci.setCartId(rs.getString("cart_id"));
                ci.setIsbn(rs.getString("isbn"));
                ci.setQuantity(rs.getInt("quantity"));
                ci.setUnitPrice(rs.getBigDecimal("unit_price"));
                ci.setAddedAt(rs.getTimestamp("added_at").toLocalDateTime());
                return ci;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSave(CartItem item) {
        String sql = "INSERT INTO CartItem(cart_id, isbn, quantity, unit_price) VALUES(?,?,?,?)";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, item.getCartId());
            ps.setString(2, item.getIsbn());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getUnitPrice());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                item.setCartItemId(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doUpdate(CartItem item) {
        String sql = "UPDATE CartItem SET quantity=?, unit_price=? WHERE cart_item_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, item.getQuantity());
            ps.setBigDecimal(2, item.getUnitPrice());
            ps.setInt(3, item.getCartItemId());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDelete(int id) {
        String sql = "DELETE FROM CartItem WHERE cart_item_id=?";
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
}
