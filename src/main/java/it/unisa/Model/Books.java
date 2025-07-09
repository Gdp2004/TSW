package it.unisa.Model;

import java.math.BigDecimal;

public class Books {
    private String isbn;
    private String title;
    private String author;
    private String description;
    private BigDecimal price;
    private int stockQty;
    // nuovi campi per l’immagine
    private byte[] imageData;
    private String imageMime;
    private String imageName;
    // fine nuovi campi
    private Integer categoryId;

    public Books() { }

    public Books(String isbn, String title, String author, String description,
                 BigDecimal price, int stockQty,
                 byte[] imageData, String imageMime, String imageName,
                 Integer categoryId) {
        this.isbn       = isbn;
        this.title      = title;
        this.author     = author;
        this.description= description;
        this.price      = price;
        this.stockQty   = stockQty;
        this.imageData  = imageData;
        this.imageMime  = imageMime;
        this.imageName  = imageName;
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

    public byte[] getImageData() {
        return imageData;
    }
    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }

    public String getImageMime() {
        return imageMime;
    }
    public void setImageMime(String imageMime) {
        this.imageMime = imageMime;
    }

    public String getImageName() {
        return imageName;
    }
    public void setImageName(String imageName) {
        this.imageName = imageName;
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
               ", imageName='" + imageName + '\'' +
               ", imageMime='" + imageMime + '\'' +
               ", imageData=" + (imageData != null ? imageData.length + " bytes" : "null") +
               ", categoryId=" + categoryId +
               '}';
    }
}
