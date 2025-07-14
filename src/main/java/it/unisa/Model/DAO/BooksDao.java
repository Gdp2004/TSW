// File: src/main/java/it/unisa/Model/LibriDAO.java
package it.unisa.Model.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import it.unisa.Model.Books;


public class BooksDao {
	
	private static DataSource ds;

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
                throw new RuntimeException("INSERT error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
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
            if (!rs.next()) return null;

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
        } catch (SQLException e) {
            throw new RuntimeException(e);
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
            throw new RuntimeException(e);
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
                throw new RuntimeException("UPDATE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(String isbn) {
        String sql = "DELETE FROM Book WHERE isbn = ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, isbn);
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("DELETE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    
    /**
     * Recupera i libri di una specifica categoria, con paginazione.
     *
     * @param categoryId l'id della categoria dei libri da cercare
     * @param offset     l’offset per LIMIT
     * @param limit      il numero massimo di righe da restituire
     * @return lista di Books appartenenti alla categoria richiesta
     */
    public List<Books> findByCategory(int categoryId, int offset, int limit) {
        String sql = """
            SELECT isbn, title, author, image_path
              FROM Book
             WHERE category_id = ?
             LIMIT ?, ?
            """;
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);

            ResultSet rs = ps.executeQuery();
            List<Books> list = new ArrayList<>();
            while (rs.next()) {
                Books b = new Books();
                b.setIsbn("isbn");
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setImagePath(rs.getString("image_path"));
                list.add(b);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
