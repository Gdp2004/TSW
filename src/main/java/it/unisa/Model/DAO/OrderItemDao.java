package it.unisa.Model.DAO;



import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import it.unisa.Model.DriverManagerConnectionPool;
import it.unisa.Model.OrderItem;

public class OrderItemDao {

    public List<OrderItem> doRetrieveByOrderId(int orderId) {
        String sql = "SELECT order_item_id, order_id, isbn, quantity, unit_price "
                   + "FROM OrderItem WHERE order_id=?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            List<OrderItem> list = new ArrayList<>();
            while (rs.next()) {
                OrderItem oi = new OrderItem();
                oi.setOrderItemId(rs.getInt("order_item_id"));
                oi.setOrderId(orderId);
                oi.setIsbn(rs.getString("isbn"));
                oi.setQuantity(rs.getInt("quantity"));
                oi.setUnitPrice(rs.getBigDecimal("unit_price"));
                list.add(oi);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public OrderItem doRetrieveById(int id) {
        String sql = "SELECT * FROM OrderItem WHERE order_item_id=?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                OrderItem oi = new OrderItem();
                oi.setOrderItemId(id);
                oi.setOrderId(rs.getInt("order_id"));
                oi.setIsbn(rs.getString("isbn"));
                oi.setQuantity(rs.getInt("quantity"));
                oi.setUnitPrice(rs.getBigDecimal("unit_price"));
                return oi;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSave(OrderItem item) {
        String sql = "INSERT INTO OrderItem(order_id, isbn, quantity, unit_price) VALUES(?,?,?,?)";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getOrderId());
            ps.setString(2, item.getIsbn());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getUnitPrice());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                item.setOrderItemId(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDelete(int id) {
        String sql = "DELETE FROM OrderItem WHERE order_item_id=?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
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

