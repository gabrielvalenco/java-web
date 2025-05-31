package com.library.model;

import java.util.HashSet;
import java.util.Set;

/**
 * Entity class representing a book publisher in the library system.
 */
public class Publisher {
    private Long id;
    private String name;
    private String address;
    private String phone;
    private String email;
    private Set<Book> publishedBooks = new HashSet<>();
    
    public Publisher() {
    }
    
    public Publisher(String name, String address, String phone, String email) {
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.email = email;
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Set<Book> getPublishedBooks() {
        return publishedBooks;
    }

    public void setPublishedBooks(Set<Book> publishedBooks) {
        this.publishedBooks = publishedBooks;
    }
    
    public void addBook(Book book) {
        this.publishedBooks.add(book);
    }
    
    public void removeBook(Book book) {
        this.publishedBooks.remove(book);
    }
    
    @Override
    public String toString() {
        return "Publisher [id=" + id + ", name=" + name + ", address=" + address + 
               ", phone=" + phone + ", email=" + email + "]";
    }
}
