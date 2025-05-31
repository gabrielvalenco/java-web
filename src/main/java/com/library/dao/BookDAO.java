package com.library.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.library.model.Book;
import com.library.model.Category;
import com.library.util.DatabaseUtil;

/**
 * Data Access Object for Book entity.
 */
public class BookDAO {
    
    /**
     * Create the books table in the database.
     */
    public void createTable() {
        String sql = "CREATE TABLE IF NOT EXISTS books (" +
                "id BIGINT PRIMARY KEY AUTO_INCREMENT, " +
                "title VARCHAR(255) NOT NULL, " +
                "author VARCHAR(255) NOT NULL, " +
                "isbn VARCHAR(20) UNIQUE NOT NULL, " +
                "publication_year INT, " +
                "category_id BIGINT, " +
                "FOREIGN KEY (category_id) REFERENCES categories(id)" +
                ")";
                
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Save a book to the database.
     * 
     * @param book Book to save
     * @return the saved Book with generated ID
     */
    public Book save(Book book) {
        String sql = "INSERT INTO books (title, author, isbn, publication_year, category_id) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getIsbn());
            pstmt.setInt(4, book.getPublicationYear());
            
            if (book.getCategory() != null) {
                pstmt.setLong(5, book.getCategory().getId());
            } else {
                pstmt.setNull(5, java.sql.Types.BIGINT);
            }
            
            pstmt.executeUpdate();
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    book.setId(generatedKeys.getLong(1));
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return book;
    }
    
    /**
     * Find a book by its ID.
     * 
     * @param id Book ID
     * @return Book if found, null otherwise
     */
    public Book findById(Long id) {
        String sql = "SELECT b.*, c.id as category_id, c.name as category_name, c.description as category_description " +
                     "FROM books b LEFT JOIN categories c ON b.category_id = c.id WHERE b.id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractBookFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find all books in the database.
     * 
     * @return List of all books
     */
    public List<Book> findAll() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.id as category_id, c.name as category_name, c.description as category_description " +
                     "FROM books b LEFT JOIN categories c ON b.category_id = c.id";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return books;
    }
    
    /**
     * Update a book in the database.
     * 
     * @param book Book to update
     * @return true if successful, false otherwise
     */
    public boolean update(Book book) {
        String sql = "UPDATE books SET title = ?, author = ?, isbn = ?, publication_year = ?, category_id = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getIsbn());
            pstmt.setInt(4, book.getPublicationYear());
            
            if (book.getCategory() != null) {
                pstmt.setLong(5, book.getCategory().getId());
            } else {
                pstmt.setNull(5, java.sql.Types.BIGINT);
            }
            
            pstmt.setLong(6, book.getId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a book from the database.
     * 
     * @param id Book ID to delete
     * @return true if successful, false otherwise
     */
    public boolean delete(Long id) {
        String sql = "DELETE FROM books WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Extract a Book object from a ResultSet.
     * 
     * @param rs ResultSet to extract from
     * @return Extracted Book
     * @throws SQLException if a database access error occurs
     */
    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getLong("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setIsbn(rs.getString("isbn"));
        book.setPublicationYear(rs.getInt("publication_year"));
        
        // Set category if exists
        long categoryId = rs.getLong("category_id");
        if (!rs.wasNull()) {
            Category category = new Category();
            category.setId(categoryId);
            category.setName(rs.getString("category_name"));
            category.setDescription(rs.getString("category_description"));
            book.setCategory(category);
        }
        
        return book;
    }
}
