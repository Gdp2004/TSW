package it.unisa.Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CartItem {
    private int cartItemId;
    private String cartId;
    private String isbn;
    private int quantity;
    private BigDecimal unitPrice;
    private LocalDateTime addedAt;

    public CartItem() {
        // costruttore di default
    }

    public CartItem(int cartItemId, String cartId, String isbn, int quantity, BigDecimal unitPrice, LocalDateTime addedAt) {
        this.cartItemId = cartItemId;
        this.cartId = cartId;
        this.isbn = isbn;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.addedAt = addedAt;
    }

    public int getCartItemId() {
        return cartItemId;
    }
    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public String getCartId() {
        return cartId;
    }
    public void setCartId(String cartId) {
        this.cartId = cartId;
    }

    public String getIsbn() {
        return isbn;
    }
    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public LocalDateTime getAddedAt() {
        return addedAt;
    }
    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }

    @Override
    public String toString() {
        return "CartItem{" +
               "cartItemId=" + cartItemId +
               ", cartId='" + cartId + '\'' +
               ", isbn='" + isbn + '\'' +
               ", quantity=" + quantity +
               ", unitPrice=" + unitPrice +
               ", addedAt=" + addedAt +
               '}';
    }
}
