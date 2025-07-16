package it.unisa.Model.DAO;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import it.unisa.Model.CartItem;

public class CartItemDao {

    private final DataSource ds;

    public CartItemDao(DataSource ds) {
        this.ds = ds;
    }

    /**
     * Recupera gli articoli nel carrello per un utente dato l'ID del carrello.
     * @param cartId L'ID del carrello.
     * @return Una lista di articoli nel carrello.
     */
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

    /**
     * Aggiunge un articolo al carrello. Se l'articolo esiste già, aggiorna la quantità.
     * @param cartId L'ID del carrello.
     * @param isbn L'ISBN del libro.
     * @param unitPrice Il prezzo unitario dell'articolo.
     */
    public void addItemToCart(String cartId, String isbn, BigDecimal unitPrice) {
        String sql = "INSERT INTO CartItem (cart_id, isbn, quantity, unit_price) " +
                     "VALUES (?, ?, 1, ?) " +
                     "ON DUPLICATE KEY UPDATE quantity = quantity + 1";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, cartId);
            ps.setString(2, isbn);
            ps.setBigDecimal(3, unitPrice);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante l'aggiunta dell'articolo al carrello", e);
        }
    }

    /**
     * Rimuove un articolo dal carrello dato l'ID del carrello e l'ISBN del libro.
     * @param cartId L'ID del carrello.
     * @param isbn L'ISBN del libro.
     */
    public void removeItemFromCart(String cartId, String isbn) {
        String sql = "DELETE FROM CartItem WHERE cart_id = ? AND isbn = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, cartId);
            ps.setString(2, isbn);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante la rimozione dell'articolo dal carrello", e);
        }
    }

    /**
     * Svuota il carrello dell'utente dato l'ID del carrello.
     * @param cartId L'ID del carrello.
     */
    public void clearCart(String cartId) {
        String sql = "DELETE FROM CartItem WHERE cart_id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, cartId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante la pulizia del carrello", e);
        }
    }

    /**
     * Salva gli articoli nel carrello nel database.
     * @param cartId L'ID del carrello.
     * @param cartItems Una lista di ISBN degli articoli nel carrello.
     */
    public void saveCart(String cartId, List<String> cartItems, BigDecimal unitPrice) {
        String sql = "INSERT INTO CartItem (cart_id, isbn, quantity, unit_price) VALUES (?, ?, 1, ?) " +
                     "ON DUPLICATE KEY UPDATE quantity = quantity + 1";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (String isbn : cartItems) {
                ps.setString(1, cartId);
                ps.setString(2, isbn);
                ps.setBigDecimal(3, unitPrice);
                ps.addBatch(); // Aggiungi l'operazione al batch
            }

            ps.executeBatch(); // Esegui tutte le operazioni in una volta
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante il salvataggio del carrello.", e);
        }
    }
}
