package it.unisa.Model;

import java.math.BigDecimal;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private String isbn;
    private int quantity;
    private BigDecimal unitPrice;

    public OrderItem() {
        // costruttore di default
    }

    public OrderItem(int orderItemId, int orderId, String isbn, int quantity, BigDecimal unitPrice) {
        this.orderItemId = orderItemId;
        this.orderId     = orderId;
        this.isbn        = isbn;
        this.quantity    = quantity;
        this.unitPrice   = unitPrice;
    }

    public int getOrderItemId() {
        return orderItemId;
    }
    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
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

    @Override
    public String toString() {
        return "OrderItem{" +
               "orderItemId=" + orderItemId +
               ", orderId="     + orderId +
               ", isbn='"       + isbn + '\'' +
               ", quantity="    + quantity +
               ", unitPrice="   + unitPrice +
               '}';
    }
}
