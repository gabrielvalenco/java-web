package com.library.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.library.model.Book;
import com.library.model.User;
import com.library.util.DatabaseUtil;

/**
 * Data Access Object for the many-to-many relationship between Book and User.
 */
public class BookUserDAO {
    
    /**
     * Create the book_user table in the database.
     * This represents the many-to-many relationship between books and users.
     */
    public void createTable() {
        String sql = "CREATE TABLE IF NOT EXISTS book_user (" +
                "book_id BIGINT NOT NULL, " +
                "user_id BIGINT NOT NULL, " +
                "PRIMARY KEY (book_id, user_id), " +
                "FOREIGN KEY (book_id) REFERENCES books(id), " +
                "FOREIGN KEY (user_id) REFERENCES users(id)" +
                ")";
                
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Associate a book with a user.
     * 
     * @param bookId Book ID
     * @param userId User ID
     * @return true if successful, false otherwise
     */
    public boolean addBookToUser(Long bookId, Long userId) {
        String sql = "INSERT INTO book_user (book_id, user_id) VALUES (?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, bookId);
            pstmt.setLong(2, userId);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Remove association between a book and a user.
     * 
     * @param bookId Book ID
     * @param userId User ID
     * @return true if successful, false otherwise
     */
    public boolean removeBookFromUser(Long bookId, Long userId) {
        String sql = "DELETE FROM book_user WHERE book_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, bookId);
            pstmt.setLong(2, userId);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Find all books associated with a user.
     * 
     * @param userId User ID
     * @return List of books associated with the user
     */
    public List<Book> findBooksByUser(Long userId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.* FROM books b " +
                     "JOIN book_user bu ON b.id = bu.book_id " +
                     "WHERE bu.user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Book book = new Book();
                    book.setId(rs.getLong("id"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setIsbn(rs.getString("isbn"));
                    book.setPublicationYear(rs.getInt("publication_year"));
                    books.add(book);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return books;
    }
    
    /**
     * Find all users associated with a book.
     * 
     * @param bookId Book ID
     * @return List of users associated with the book
     */
    public List<User> findUsersByBook(Long bookId) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.* FROM users u " +
                     "JOIN book_user bu ON u.id = bu.user_id " +
                     "WHERE bu.book_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, bookId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getLong("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    users.add(user);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return users;
    }
}
