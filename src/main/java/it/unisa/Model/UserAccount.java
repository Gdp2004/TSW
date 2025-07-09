package it.unisa.Model;

import java.time.LocalDateTime;

public class UserAccount {
    private int userId;
    private String email;
    private String passwordHash;
    private String fullName;
    private LocalDateTime createdAt;

    public UserAccount() {
        // costruttore di default
    }

    public UserAccount(int userId, String email, String passwordHash, String fullName, LocalDateTime createdAt) {
        this.userId = userId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.createdAt = createdAt;
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

    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "UserAccount{" +
               "userId=" + userId +
               ", email='" + email + '\'' +
               ", passwordHash='" + passwordHash + '\'' +
               ", fullName='" + fullName + '\'' +
               ", createdAt=" + createdAt +
               '}';
    }
}
