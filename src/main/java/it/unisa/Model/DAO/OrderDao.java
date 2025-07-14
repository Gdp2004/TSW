package it.unisa.Model.DAO;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


import it.unisa.Model.Order;

public class OrderDao {
	
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

    public List<Order> doRetrieveAll(int offset, int limit) {
        String sql = "SELECT order_id, cart_id, user_id, status, total_amount, created_at "
                   + "FROM `Order` LIMIT ?, ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            List<Order> list = new ArrayList<>();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setCartId(rs.getString("cart_id"));
                o.setUserId(rs.getObject("user_id", Integer.class));
                o.setStatus(rs.getString("status"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                list.add(o);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Order doRetrieveById(int id) {
        String sql = "SELECT * FROM `Order` WHERE order_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setOrderId(id);
                o.setCartId(rs.getString("cart_id"));
                o.setUserId(rs.getObject("user_id", Integer.class));
                o.setStatus(rs.getString("status"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return o;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSave(Order order) {
        String sql = "INSERT INTO `Order`(cart_id, user_id, status, total_amount) VALUES(?,?,?,?)";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, order.getCartId());
            if (order.getUserId() != null) ps.setInt(2, order.getUserId());
            else ps.setNull(2, Types.INTEGER);
            ps.setString(3, order.getStatus());
            ps.setBigDecimal(4, order.getTotalAmount());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                order.setOrderId(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doUpdate(Order order) {
        String sql = "UPDATE `Order` SET status=?, total_amount=? WHERE order_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, order.getStatus());
            ps.setBigDecimal(2, order.getTotalAmount());
            ps.setInt(3, order.getOrderId());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDelete(int id) {
        String sql = "DELETE FROM `Order` WHERE order_id=?";
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
