package it.unisa.Model;

import java.time.LocalDateTime;

public class Cart {
    private String cartId;
    private Integer userId;
    private LocalDateTime createdAt;
    private LocalDateTime lastUpdate;

    public Cart() {
        // costruttore di default
    }

    public Cart(String cartId, Integer userId, LocalDateTime createdAt, LocalDateTime lastUpdate) {
        this.cartId = cartId;
        this.userId = userId;
        this.createdAt = createdAt;
        this.lastUpdate = lastUpdate;
    }

    public String getCartId() {
        return cartId;
    }
    public void setCartId(String cartId) {
        this.cartId = cartId;
    }

    public Integer getUserId() {
        return userId;
    }
    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getLastUpdate() {
        return lastUpdate;
    }
    public void setLastUpdate(LocalDateTime lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    @Override
    public String toString() {
        return "Cart{" +
               "cartId='" + cartId + '\'' +
               ", userId=" + userId +
               ", createdAt=" + createdAt +
               ", lastUpdate=" + lastUpdate +
               '}';
    }
}
