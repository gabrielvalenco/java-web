package com.library.model;

import java.util.Date;

/**
 * Entity class representing a book loan in the library system.
 */
public class Loan {
    private Long id;
    private Book book;
    private User user;
    private Date loanDate;
    private Date returnDate;
    private boolean returned;
    
    public Loan() {
    }
    
    public Loan(Book book, User user, Date loanDate, Date returnDate) {
        this.book = book;
        this.user = user;
        this.loanDate = loanDate;
        this.returnDate = returnDate;
        this.returned = false;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Date getLoanDate() {
        return loanDate;
    }

    public void setLoanDate(Date loanDate) {
        this.loanDate = loanDate;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public boolean isReturned() {
        return returned;
    }

    public void setReturned(boolean returned) {
        this.returned = returned;
    }
    
    @Override
    public String toString() {
        return "Loan [id=" + id + ", book=" + book.getTitle() + ", user=" + user.getName() + 
               ", loanDate=" + loanDate + ", returnDate=" + returnDate + ", returned=" + returned + "]";
    }
}
