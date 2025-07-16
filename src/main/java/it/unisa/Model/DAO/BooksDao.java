package it.unisa.Model.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        String insertBook = """
            INSERT INTO Book (
              isbn, title, author, description,
              price, stock_qty, image_path
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
            """;

        String insertCategory = """
            INSERT INTO BookCategory (isbn, category_id)
            VALUES (?, ?)
            """;

        try (Connection con = ds.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(insertBook)) {
                ps.setString(1, b.getIsbn());
                ps.setString(2, b.getTitle());
                ps.setString(3, b.getAuthor());
                ps.setString(4, b.getDescription());
                ps.setBigDecimal(5, b.getPrice());
                ps.setInt(6, b.getStockQty());
                ps.setString(7, b.getImagePath());

                ps.executeUpdate();
            }

            if (b.getCategoryIds() != null && !b.getCategoryIds().isEmpty()) {
                try (PreparedStatement ps = con.prepareStatement(insertCategory)) {
                    for (String categoryId : b.getCategoryIds()) {
                        ps.setString(1, b.getIsbn());
                        ps.setString(2, categoryId);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            con.commit();
        } catch (SQLException e) {
            throw new RuntimeException("Database insert error", e);
        }
    }

    public Books findByIsbn(String isbn) {
        String bookSql = """
            SELECT isbn, title, author, description,
                   price, stock_qty, image_path
              FROM Book
             WHERE isbn = ?
            """;

        String categorySql = """
            SELECT category_id FROM BookCategory WHERE isbn = ?
            """;

        try (Connection con = ds.getConnection();
             PreparedStatement psBook = con.prepareStatement(bookSql);
             PreparedStatement psCat = con.prepareStatement(categorySql)) {

            psBook.setString(1, isbn);
            ResultSet rsBook = psBook.executeQuery();

            if (!rsBook.next()) {
				return null;
			}

            Books b = new Books();
            b.setIsbn(rsBook.getString("isbn"));
            b.setTitle(rsBook.getString("title"));
            b.setAuthor(rsBook.getString("author"));
            b.setDescription(rsBook.getString("description"));
            b.setPrice(rsBook.getBigDecimal("price"));
            b.setStockQty(rsBook.getInt("stock_qty"));
            b.setImagePath(rsBook.getString("image_path"));

            psCat.setString(1, isbn);
            ResultSet rsCat = psCat.executeQuery();
            List<String> categoryIds = new ArrayList<>();
            while (rsCat.next()) {
                categoryIds.add(rsCat.getString("category_id"));
            }
            b.setCategoryIds(categoryIds);

            return b;
        } catch (SQLException e) {
            throw new RuntimeException("Database query error", e);
        }
    }

    public List<Books> findAll(int offset, int limit) {
        String bookSql = """
            SELECT isbn, title, author, description,
                   price, stock_qty, image_path
              FROM Book
             LIMIT ?, ?
            """;

        String categorySql = """
            SELECT category_id FROM BookCategory WHERE isbn = ?
            """;

        try (Connection con = ds.getConnection();
             PreparedStatement psBook = con.prepareStatement(bookSql);
             PreparedStatement psCat = con.prepareStatement(categorySql)) {

            psBook.setInt(1, offset);
            psBook.setInt(2, limit);
            ResultSet rs = psBook.executeQuery();

            List<Books> list = new ArrayList<>();

            while (rs.next()) {
                Books b = new Books();
                String isbn = rs.getString("isbn");

                b.setIsbn(isbn);
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setDescription(rs.getString("description"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStockQty(rs.getInt("stock_qty"));
                b.setImagePath(rs.getString("image_path"));

                psCat.setString(1, isbn);
                ResultSet rsCat = psCat.executeQuery();
                List<String> catIds = new ArrayList<>();
                while (rsCat.next()) {
                    catIds.add(rsCat.getString("category_id"));
                }
                b.setCategoryIds(catIds);

                list.add(b);
            }

            return list;
        } catch (SQLException e) {
            throw new RuntimeException("Database query error", e);
        }
    }

    public void update(Books b) {
        String updateBook = """
            UPDATE Book SET
              title       = ?,
              author      = ?,
              description = ?,
              price       = ?,
              stock_qty   = ?,
              image_path  = ?
             WHERE isbn = ?
            """;

        String deleteCategories = """
            DELETE FROM BookCategory WHERE isbn = ?
            """;

        String insertCategories = """
            INSERT INTO BookCategory (isbn, category_id) VALUES (?, ?)
            """;

        try (Connection con = ds.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(updateBook)) {
                ps.setString(1, b.getTitle());
                ps.setString(2, b.getAuthor());
                ps.setString(3, b.getDescription());
                ps.setBigDecimal(4, b.getPrice());
                ps.setInt(5, b.getStockQty());
                ps.setString(6, b.getImagePath());
                ps.setString(7, b.getIsbn());

                if (ps.executeUpdate() != 1) {
                    throw new RuntimeException("UPDATE failed");
                }
            }

            try (PreparedStatement psDel = con.prepareStatement(deleteCategories)) {
                psDel.setString(1, b.getIsbn());
                psDel.executeUpdate();
            }

            if (b.getCategoryIds() != null && !b.getCategoryIds().isEmpty()) {
                try (PreparedStatement psIns = con.prepareStatement(insertCategories)) {
                    for (String categoryId : b.getCategoryIds()) {
                        psIns.setString(1, b.getIsbn());
                        psIns.setString(2, categoryId);
                        psIns.addBatch();
                    }
                    psIns.executeBatch();
                }
            }

            con.commit();
        } catch (SQLException e) {
            throw new RuntimeException("Database update error", e);
        }
    }

    public void delete(String isbn) {
        String sql = "DELETE FROM Book WHERE isbn = ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, isbn);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Database delete error", e);
        }
    }

    public List<Books> findByCategory(String categoryId) {
        String sql = """
            SELECT b.isbn, b.title, b.author, b.description,
                   b.price, b.stock_qty, b.image_path
              FROM Book b
              JOIN BookCategory bc ON b.isbn = bc.isbn
             WHERE bc.category_id = ?
            """;

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoryId);
            ResultSet rs = ps.executeQuery();
            List<Books> list = new ArrayList<>();

            while (rs.next()) {
                Books b = new Books();
                String isbn = rs.getString("isbn");

                b.setIsbn(isbn);
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setDescription(rs.getString("description"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStockQty(rs.getInt("stock_qty"));
                b.setImagePath(rs.getString("image_path"));

                // Recupera anche le categorie associate
                b.setCategoryIds(getCategoryIdsByIsbn(con, isbn));

                list.add(b);
            }

            return list;
        } catch (SQLException e) {
            throw new RuntimeException("Database query error", e);
        }
    }

    private List<String> getCategoryIdsByIsbn(Connection con, String isbn) throws SQLException {
        String sql = "SELECT category_id FROM BookCategory WHERE isbn = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, isbn);
            ResultSet rs = ps.executeQuery();
            List<String> ids = new ArrayList<>();
            while (rs.next()) {
                ids.add(rs.getString("category_id"));
            }
            return ids;
        }
    }

    public List<Books> findRandom() {
        String bookSql = """
            SELECT isbn, title, author, description,
                   price, stock_qty, image_path
              FROM Book
             ORDER BY RAND()
            """;

        String categorySql = """
            SELECT category_id FROM BookCategory WHERE isbn = ?
            """;

        try (Connection con = ds.getConnection();
             PreparedStatement psBook = con.prepareStatement(bookSql);
             PreparedStatement psCat  = con.prepareStatement(categorySql);
             ResultSet rs = psBook.executeQuery()) {

            List<Books> list = new ArrayList<>();

            while (rs.next()) {
                Books b = new Books();
                String isbn = rs.getString("isbn");

                b.setIsbn(isbn);
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setDescription(rs.getString("description"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStockQty(rs.getInt("stock_qty"));
                b.setImagePath(rs.getString("image_path"));

                // Recupera le categorie associate
                psCat.setString(1, isbn);
                try (ResultSet rsCat = psCat.executeQuery()) {
                    List<String> categoryIds = new ArrayList<>();
                    while (rsCat.next()) {
                        categoryIds.add(rsCat.getString("category_id"));
                    }
                    b.setCategoryIds(categoryIds);
                }

                list.add(b);
            }

            return list;
        } catch (SQLException e) {
            throw new RuntimeException("Database query error (findRandom)", e);
        }
    }
}
