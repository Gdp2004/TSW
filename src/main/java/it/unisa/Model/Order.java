package it.unisa.Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Order {
    private int orderId;
    private String cartId;
    private Integer userId;
    private String status;
    private BigDecimal totalAmount;
    private LocalDateTime createdAt;

    public Order() {
        // costruttore di default
    }

    public Order(int orderId, String cartId, Integer userId, String status, BigDecimal totalAmount, LocalDateTime createdAt) {
        this.orderId = orderId;
        this.cartId = cartId;
        this.userId = userId;
        this.status = status;
        this.totalAmount = totalAmount;
        this.createdAt = createdAt;
    }

    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
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

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Order{" +
               "orderId=" + orderId +
               ", cartId='" + cartId + '\'' +
               ", userId=" + userId +
               ", status='" + status + '\'' +
               ", totalAmount=" + totalAmount +
               ", createdAt=" + createdAt +
               '}';
    }
}
