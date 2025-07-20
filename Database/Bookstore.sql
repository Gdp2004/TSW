-- --------------------------------------------------
-- DATABASE E SCHEMA
-- --------------------------------------------------
CREATE DATABASE IF NOT EXISTS Bookstore;
USE Bookstore;

-- --------------------------------------------------
-- 1) CATEGORIE DI LIBRI
-- --------------------------------------------------
CREATE TABLE IF NOT EXISTS Category (
  category_id   VARCHAR(50) PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  description   TEXT,
  UNIQUE KEY (name)
);

-- --------------------------------------------------
-- 2) LIBRI
-- --------------------------------------------------
CREATE TABLE IF NOT EXISTS Book (
  isbn          VARCHAR(20) PRIMARY KEY,
  title         VARCHAR(255) NOT NULL,
  author        VARCHAR(255) NOT NULL,
  description   TEXT,
  price         DECIMAL(10,2) NOT NULL,
  stock_qty     INT NOT NULL DEFAULT 0,
  image_path    VARCHAR(500) NOT NULL,
  image_blob	BLOB			NULL
);

-- --------------------------------------------------
-- 3) TABELLA DI ASSOCIAZIONE MOLTI-A-MOLTI: BOOK ↔ CATEGORY
-- --------------------------------------------------
CREATE TABLE IF NOT EXISTS BookCategory (
  isbn          VARCHAR(20) NOT NULL,
  category_id   VARCHAR(50) NOT NULL,
  PRIMARY KEY (isbn, category_id),
  FOREIGN KEY (isbn) REFERENCES Book(isbn) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
);

-- --------------------------------------------------
-- 4) UTENTI REGISTRATI
-- --------------------------------------------------
CREATE TABLE IF NOT EXISTS UserAccount (
  user_id        INT AUTO_INCREMENT PRIMARY KEY,
  email          VARCHAR(255) NOT NULL UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,
  full_name      VARCHAR(255),
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- --------------------------------------------------
-- 5) ORDINI
-- --------------------------------------------------
CREATE TABLE IF NOT EXISTS Orders (
  order_id       INT AUTO_INCREMENT PRIMARY KEY,
  cart_id        CHAR(36) NOT NULL,
  user_id        INT NULL,
  status         VARCHAR(50) NOT NULL DEFAULT 'PENDING',
  total_amount   DECIMAL(10,2) NOT NULL,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cart_id)
    REFERENCES Cart(cart_id),
  FOREIGN KEY (user_id)
    REFERENCES UserAccount(user_id)
);

