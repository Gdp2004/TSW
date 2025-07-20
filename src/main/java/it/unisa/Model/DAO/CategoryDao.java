package it.unisa.Model.DAO;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import it.unisa.Model.Category;

public class CategoryDao {

	private final DataSource ds;

	public CategoryDao(DataSource ds) {
		
		this.ds = ds;
		
	}

    public List<Category> doRetrieveAll(int offset, int limit) {
        String sql = "SELECT category_id, name, description FROM Category LIMIT ?, ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            List<Category> list = new ArrayList<>();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt(1));
                c.setName(rs.getString(2));
                c.setDescription(rs.getString(3));
                list.add(c);
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Category doRetrieveById(int id) {
        String sql = "SELECT * FROM Category WHERE category_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Category c = new Category();
                c.setCategoryId(id);
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                return c;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSave(Category category) {
        String sql = "INSERT INTO Category(name, description) VALUES(?,?)";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                category.setCategoryId(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doUpdate(Category category) {
        String sql = "UPDATE Category SET name=?, description=? WHERE category_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDelete(int id) {
        String sql = "DELETE FROM Category WHERE category_id=?";
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
    
    
    public List<Category> searchByKeyword(String q) {
        if (q == null || q.isBlank()) {
            return new ArrayList<>();
        }

        String sql = "SELECT category_id, name, description "
                   + "FROM Category "
                   + "WHERE name LIKE ? "
                   + "   OR description LIKE ? "
                   + "   OR category_id = ?";
        List<Category> results = new ArrayList<>();
        String wildcard = "%" + q.trim() + "%";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // wildcard search on name & description
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            // exact match on the ID column
            ps.setString(3, q.trim());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category c = new Category();
                    // assuming categoryId is numeric; if it's really varchar, adjust accordingly
                    try {
                        c.setCategoryId(Integer.parseInt(rs.getString("category_id")));
                    } catch (NumberFormatException ex) {
                        c.setCategoryId(0);
                    }
                    c.setName(rs.getString("name"));
                    c.setDescription(rs.getString("description"));
                    results.add(c);
                }
            }

            return results;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
