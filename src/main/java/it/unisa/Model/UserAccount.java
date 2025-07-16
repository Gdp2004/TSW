package it.unisa.Model;

import java.time.LocalDateTime;

public class UserAccount {
    private int userId;
    private String email;
    private String passwordHash;
    private String name;
    private String surname;
    private LocalDateTime createdAt;
    private boolean isAdmin;

    public UserAccount() {
        // costruttore di default
    }

    public UserAccount(int userId, String email, String passwordHash, String name, String surname, LocalDateTime createdAt, boolean isAdmin) {
        this.userId = userId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.name = name;
        this.surname = surname;
        this.createdAt = createdAt;
        this.isAdmin = isAdmin;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() { return surname; }

    public void setSurname(String surname) { this.surname = surname; }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setAdmin(boolean admin) { this.isAdmin = admin;}
    public boolean getIsAdmin() { return isAdmin; }

    @Override
    public String toString() {
        return "UserAccount{" +
               "userId=" + userId +
               ", email='" + email + '\'' +
               ", passwordHash='" + passwordHash + '\'' +
               ", name='" + name + '\'' +
               ", surname='" + surname +
               ", createdAt=" + createdAt +
               ", isAdmin="   + isAdmin +
               '}';
    }
}
