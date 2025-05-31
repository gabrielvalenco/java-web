package com.library.model;

import java.util.HashSet;
import java.util.Set;

/**
 * Entity class representing a book in the library system.
 */
public class Book {
    private Long id;
    private String title;
    private String author;
    private String isbn;
    private int publicationYear;
    private Category category; // One-to-Many relationship (Category has many Books)
    private Set<User> users = new HashSet<>(); // Many-to-Many relationship (Books can be borrowed by many Users)
    
    public Book() {
    }
    
    public Book(String title, String author, String isbn, int publicationYear) {
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.publicationYear = publicationYear;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public int getPublicationYear() {
        return publicationYear;
    }

    public void setPublicationYear(int publicationYear) {
        this.publicationYear = publicationYear;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Set<User> getUsers() {
        return users;
    }

    public void setUsers(Set<User> users) {
        this.users = users;
    }
    
    public void addUser(User user) {
        this.users.add(user);
        user.getBooks().add(this);
    }
    
    public void removeUser(User user) {
        this.users.remove(user);
        user.getBooks().remove(this);
    }

    @Override
    public String toString() {
        return "Book [id=" + id + ", title=" + title + ", author=" + author + ", isbn=" + isbn + ", publicationYear="
                + publicationYear + "]";
    }
}
