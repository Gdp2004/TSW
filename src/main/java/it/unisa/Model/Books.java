// File: src/main/java/it/unisa/Model/Books.java
package it.unisa.Model;

import java.math.BigDecimal;
import java.util.List;

public class Books {
    private String isbn;
    private String title;
    private String author;
    private String description;
    private BigDecimal price;
    private int stockQty;
    private String imagePath;    // percorso relativo: "covers/uuid.jpg"
    private List<String> categoryIds; // lista dei category_id associati

    public Books() { }

    public Books(String isbn, String title, String author, String description,
                 BigDecimal price, int stockQty, String imagePath,
                 List<String> categoryIds) {
        this.isbn        = isbn;
        this.title       = title;
        this.author      = author;
        this.description = description;
        this.price       = price;
        this.stockQty    = stockQty;
        this.imagePath   = imagePath;
        this.categoryIds = categoryIds;
    }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public List<String> getCategoryIds() { return categoryIds; }
    public void setCategoryIds(List<String> categoryIds) { this.categoryIds = categoryIds; }

    @Override
    public String toString() {
        return "Books{" +
               "isbn='" + isbn + '\'' +
               ", title='" + title + '\'' +
               ", author='" + author + '\'' +
               ", price=" + price +
               ", stockQty=" + stockQty +
               ", imagePath='" + imagePath + '\'' +
               ", categoryIds=" + categoryIds +
               '}';
    }
}
