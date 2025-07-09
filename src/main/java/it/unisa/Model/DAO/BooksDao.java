package it.unisa.Model.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import it.unisa.Model.Books;
import it.unisa.Model.DriverManagerConnectionPool;

public class BooksDao {

    public List<Books> doRetrieveAll(int offset, int limit) {
        String sql = "SELECT isbn, title, author, description, price, stock_qty, image_url, category_id "
                   + "FROM Book LIMIT ?, ?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            List<Books> list = new ArrayList<>();
            while (rs.next()) {
                Books b = new Books();
                b.setIsbn(rs.getString("isbn"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setDescription(rs.getString("description"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStockQty(rs.getInt("stock_qty"));
                b.setImageUrl(rs.getString("image_url"));
                b.setCategoryId(rs.getObject("category_id", Integer.class));
                list.add(b);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Books doRetrieveByISBN(String isbn) {
        String sql = "SELECT * FROM Book WHERE isbn = ?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, isbn);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Books b = new Books();
                b.setIsbn(isbn);
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setDescription(rs.getString("description"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStockQty(rs.getInt("stock_qty"));
                b.setImageUrl(rs.getString("image_url"));
                b.setCategoryId(rs.getObject("category_id", Integer.class));
                return b;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSave(Books book) {
        String sql = "INSERT INTO Book(isbn, title, author, description, price, stock_qty, image_url, category_id) "
                   + "VALUES(?,?,?,?,?,?,?,?)";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, book.getIsbn());
            ps.setString(2, book.getTitle());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getDescription());
            ps.setBigDecimal(5, book.getPrice());
            ps.setInt(6, book.getStockQty());
            ps.setString(7, book.getImageUrl());
            if (book.getCategoryId() != null) ps.setInt(8, book.getCategoryId());
            else ps.setNull(8, Types.INTEGER);
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doUpdate(Books book) {
        String sql = "UPDATE Book SET title=?, author=?, description=?, price=?, stock_qty=?, image_url=?, category_id=? "
                   + "WHERE isbn=?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setString(3, book.getDescription());
            ps.setBigDecimal(4, book.getPrice());
            ps.setInt(5, book.getStockQty());
            ps.setString(6, book.getImageUrl());
            if (book.getCategoryId() != null) ps.setInt(7, book.getCategoryId());
            else ps.setNull(7, Types.INTEGER);
            ps.setString(8, book.getIsbn());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDelete(String isbn) {
        String sql = "DELETE FROM Book WHERE isbn=?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, isbn);
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("DELETE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
