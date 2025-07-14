package it.unisa.Model.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import it.unisa.Model.Books;

public class BooksDao {

    private final DataSource ds;

    public BooksDao(DataSource ds) {
        this.ds = ds;
    }

    public void insert(Books b) {
        String sql = """
            INSERT INTO Book(
              isbn, title, author, description,
              price, stock_qty, image_path, category_id
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getIsbn());
            ps.setString(2, b.getTitle());
            ps.setString(3, b.getAuthor());
            ps.setString(4, b.getDescription());
            ps.setBigDecimal(5, b.getPrice());
            ps.setInt(6, b.getStockQty());

            if (b.getImagePath() != null) {
                ps.setString(7, b.getImagePath());
            } else {
                ps.setNull(7, Types.VARCHAR);
            }

            if (b.getCategoryId() != null) {
                ps.setInt(8, b.getCategoryId());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT failed");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database insert error", e);
        }
    }

    public Books findByIsbn(String isbn) {
        String sql = """
            SELECT isbn, title, author, description,
                   price, stock_qty, image_path, category_id
              FROM Book
             WHERE isbn = ?
            """;
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, isbn);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Books b = new Books();
                b.setIsbn(rs.getString("isbn"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setDescription(rs.getString("description"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStockQty(rs.getInt("stock_qty"));
                b.setImagePath(rs.getString("image_path"));
                b.setCategoryId(rs.getObject("category_id", Integer.class));
                return b;
            } else {
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database query error", e);
        }
    }

    public List<Books> findAll(int offset, int limit) {
        String sql = """
            SELECT isbn, title, author, description,
                   price, stock_qty, image_path, category_id
              FROM Book
             LIMIT ?, ?
            """;
        try (Connection con = ds.getConnection();
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
                b.setImagePath(rs.getString("image_path"));
                b.setCategoryId(rs.getObject("category_id", Integer.class));
                list.add(b);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException("Database query error", e);
        }
    }

    public void update(Books b) {
        String sql = """
            UPDATE Book SET
              title       = ?,
              author      = ?,
              description = ?,
              price       = ?,
              stock_qty   = ?,
              image_path  = ?,
              category_id = ?
             WHERE isbn = ?
            """;
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setString(3, b.getDescription());
            ps.setBigDecimal(4, b.getPrice());
            ps.setInt(5, b.getStockQty());

            if (b.getImagePath() != null) {
                ps.setString(6, b.getImagePath());
            } else {
                ps.setNull(6, Types.VARCHAR);
            }

            if (b.getCategoryId() != null) {
                ps.setInt(7, b.getCategoryId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.setString(8, b.getIsbn());

            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE failed");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database update error", e);
        }
    }

    public void delete(String isbn) {
        String sql = "DELETE FROM Book WHERE isbn = ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, isbn);

            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("DELETE failed");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database delete error", e);
        }
    }

    public List<Books> findByCategory(int categoryId) {
        String sql = "SELECT title, image_path FROM Book WHERE category_id = ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            ResultSet rs = ps.executeQuery();
            List<Books> list = new ArrayList<>();

            while (rs.next()) {
                Books b = new Books();
                b.setTitle(rs.getString("title"));
                b.setImagePath(rs.getString("image_path"));
                b.setCategoryId(categoryId);
                list.add(b);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException("Database query error", e);
        }
    }

}
