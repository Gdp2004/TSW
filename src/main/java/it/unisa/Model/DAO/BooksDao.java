package it.unisa.Model.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import it.unisa.Model.Books;
import it.unisa.Model.DriverManagerConnectionPool;

public class BooksDao {

    public void insert(Books b) {
        String sql = "INSERT INTO Book(isbn, title, author, description, " +
                     "price, stock_qty, image_data, image_mime, image_name, category_id) " +
                     "VALUES(?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getIsbn());
            ps.setString(2, b.getTitle());
            ps.setString(3, b.getAuthor());
            ps.setString(4, b.getDescription());
            ps.setBigDecimal(5, b.getPrice());
            ps.setInt(6, b.getStockQty());
            if (b.getImageData() != null) {
                ps.setBytes(7, b.getImageData());
                ps.setString(8, b.getImageMime());
                ps.setString(9, b.getImageName());
            } else {
                ps.setNull(7, Types.LONGVARBINARY);
                ps.setNull(8, Types.VARCHAR);
                ps.setNull(9, Types.VARCHAR);
            }
            if (b.getCategoryId() != null) {
                ps.setInt(10, b.getCategoryId());
            } else {
                ps.setNull(10, Types.INTEGER);
            }

            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Books findByIsbn(String isbn) {
        String sql = "SELECT isbn, title, author, description, price, stock_qty, " +
                     "image_data, image_mime, image_name, category_id " +
                     "FROM Book WHERE isbn=?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, isbn);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) return null;

            Books b = new Books();
            b.setIsbn(rs.getString("isbn"));
            b.setTitle(rs.getString("title"));
            b.setAuthor(rs.getString("author"));
            b.setDescription(rs.getString("description"));
            b.setPrice(rs.getBigDecimal("price"));
            b.setStockQty(rs.getInt("stock_qty"));
            b.setImageData(rs.getBytes("image_data"));
            b.setImageMime(rs.getString("image_mime"));
            b.setImageName(rs.getString("image_name"));
            b.setCategoryId(rs.getObject("category_id", Integer.class));
            return b;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Books> findAll(int offset, int limit) {
        String sql = "SELECT isbn, title, author, description, price, stock_qty, " +
                     "image_data, image_mime, image_name, category_id " +
                     "FROM Book LIMIT ?, ?";
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
                b.setImageData(rs.getBytes("image_data"));
                b.setImageMime(rs.getString("image_mime"));
                b.setImageName(rs.getString("image_name"));
                b.setCategoryId(rs.getObject("category_id", Integer.class));
                list.add(b);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Books b) {
        String sql = "UPDATE Book SET title=?, author=?, description=?, price=?, " +
                     "stock_qty=?, image_data=?, image_mime=?, image_name=?, category_id=? " +
                     "WHERE isbn=?";
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setString(3, b.getDescription());
            ps.setBigDecimal(4, b.getPrice());
            ps.setInt(5, b.getStockQty());
            if (b.getImageData() != null) {
                ps.setBytes(6, b.getImageData());
                ps.setString(7, b.getImageMime());
                ps.setString(8, b.getImageName());
            } else {
                ps.setNull(6, Types.LONGVARBINARY);
                ps.setNull(7, Types.VARCHAR);
                ps.setNull(8, Types.VARCHAR);
            }
            if (b.getCategoryId() != null) {
                ps.setInt(9, b.getCategoryId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            ps.setString(10, b.getIsbn());

            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(String isbn) {
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
