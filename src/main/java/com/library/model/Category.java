package com.library.model;

import java.util.HashSet;
import java.util.Set;

/**
 * Entity class representing a book category in the library system.
 */
public class Category {
    private Long id;
    private String name;
    private String description;
    private Set<Book> books = new HashSet<>(); // One-to-Many relationship (Category has many Books)
    
    public Category() {
    }
    
    public Category(String name, String description) {
        this.name = name;
        this.description = description;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Set<Book> getBooks() {
        return books;
    }

    public void setBooks(Set<Book> books) {
        this.books = books;
    }
    
    public void addBook(Book book) {
        this.books.add(book);
        book.setCategory(this);
    }
    
    public void removeBook(Book book) {
        this.books.remove(book);
        book.setCategory(null);
    }
    
    @Override
    public String toString() {
        return "Category [id=" + id + ", name=" + name + ", description=" + description + "]";
    }
}
