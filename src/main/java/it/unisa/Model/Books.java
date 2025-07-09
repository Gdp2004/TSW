package it.unisa.Model;

import java.math.BigDecimal;

public class Books {
    private String isbn;
    private String title;
    private String author;
    private String description;
    private BigDecimal price;
    private int stockQty;
    private String imageUrl;
    private Integer categoryId;

    public Books() {
        // costruttore di default
    }

    public Books(String isbn, String title, String author, String description,
                 BigDecimal price, int stockQty, String imageUrl, Integer categoryId) {
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.description = description;
        this.price = price;
        this.stockQty = stockQty;
        this.imageUrl = imageUrl;
        this.categoryId = categoryId;
    }

    public String getIsbn() {
        return isbn;
    }
    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }
    public void setAuthor(String author) {
        this.author = author;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }
    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQty() {
        return stockQty;
    }
    public void setStockQty(int stockQty) {
        this.stockQty = stockQty;
    }

    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getCategoryId() {
        return categoryId;
    }
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    @Override
    public String toString() {
        return "Libri{" +
               "isbn='" + isbn + '\'' +
               ", title='" + title + '\'' +
               ", author='" + author + '\'' +
               ", description='" + description + '\'' +
               ", price=" + price +
               ", stockQty=" + stockQty +
               ", imageUrl='" + imageUrl + '\'' +
               ", categoryId=" + categoryId +
               '}';
    }
}
