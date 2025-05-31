package com.library.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.library.model.Book;
import com.library.model.Loan;
import com.library.model.User;
import com.library.util.DatabaseUtil;

/**
 * Data Access Object for Loan entity.
 */
public class LoanDAO {
    
    /**
     * Create the loans table in the database.
     */
    public void createTable() {
        String sql = "CREATE TABLE IF NOT EXISTS loans (" +
                "id BIGINT PRIMARY KEY AUTO_INCREMENT, " +
                "book_id BIGINT NOT NULL, " +
                "user_id BIGINT NOT NULL, " +
                "loan_date DATE NOT NULL, " +
                "return_date DATE, " +
                "returned BOOLEAN DEFAULT FALSE, " +
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
     * Save a loan to the database.
     * 
     * @param loan Loan to save
     * @return the saved Loan with generated ID
     */
    public Loan save(Loan loan) {
        String sql = "INSERT INTO loans (book_id, user_id, loan_date, return_date, returned) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setLong(1, loan.getBook().getId());
            pstmt.setLong(2, loan.getUser().getId());
            pstmt.setDate(3, new java.sql.Date(loan.getLoanDate().getTime()));
            
            if (loan.getReturnDate() != null) {
                pstmt.setDate(4, new java.sql.Date(loan.getReturnDate().getTime()));
            } else {
                pstmt.setNull(4, java.sql.Types.DATE);
            }
            
            pstmt.setBoolean(5, loan.isReturned());
            
            pstmt.executeUpdate();
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    loan.setId(generatedKeys.getLong(1));
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return loan;
    }
    
    /**
     * Find a loan by its ID.
     * 
     * @param id Loan ID
     * @return Loan if found, null otherwise
     */
    public Loan findById(Long id) {
        String sql = "SELECT l.*, b.id as book_id, b.title as book_title, b.author as book_author, " +
                     "u.id as user_id, u.name as user_name, u.email as user_email " +
                     "FROM loans l " +
                     "JOIN books b ON l.book_id = b.id " +
                     "JOIN users u ON l.user_id = u.id " +
                     "WHERE l.id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractLoanFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find all loans in the database.
     * 
     * @return List of all loans
     */
    public List<Loan> findAll() {
        List<Loan> loans = new ArrayList<>();
        String sql = "SELECT l.*, b.id as book_id, b.title as book_title, b.author as book_author, " +
                     "u.id as user_id, u.name as user_name, u.email as user_email " +
                     "FROM loans l " +
                     "JOIN books b ON l.book_id = b.id " +
                     "JOIN users u ON l.user_id = u.id";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                loans.add(extractLoanFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return loans;
    }
    
    /**
     * Find all active loans (not returned) for a specific user.
     * 
     * @param userId User ID
     * @return List of active loans for the user
     */
    public List<Loan> findActiveByUser(Long userId) {
        List<Loan> loans = new ArrayList<>();
        String sql = "SELECT l.*, b.id as book_id, b.title as book_title, b.author as book_author, " +
                     "u.id as user_id, u.name as user_name, u.email as user_email " +
                     "FROM loans l " +
                     "JOIN books b ON l.book_id = b.id " +
                     "JOIN users u ON l.user_id = u.id " +
                     "WHERE l.user_id = ? AND l.returned = FALSE";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    loans.add(extractLoanFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return loans;
    }
    
    /**
     * Update a loan in the database.
     * 
     * @param loan Loan to update
     * @return true if successful, false otherwise
     */
    public boolean update(Loan loan) {
        String sql = "UPDATE loans SET book_id = ?, user_id = ?, loan_date = ?, return_date = ?, returned = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, loan.getBook().getId());
            pstmt.setLong(2, loan.getUser().getId());
            pstmt.setDate(3, new java.sql.Date(loan.getLoanDate().getTime()));
            
            if (loan.getReturnDate() != null) {
                pstmt.setDate(4, new java.sql.Date(loan.getReturnDate().getTime()));
            } else {
                pstmt.setNull(4, java.sql.Types.DATE);
            }
            
            pstmt.setBoolean(5, loan.isReturned());
            pstmt.setLong(6, loan.getId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a loan from the database.
     * 
     * @param id Loan ID to delete
     * @return true if successful, false otherwise
     */
    public boolean delete(Long id) {
        String sql = "DELETE FROM loans WHERE id = ?";
        
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
     * Extract a Loan object from a ResultSet.
     * 
     * @param rs ResultSet to extract from
     * @return Extracted Loan
     * @throws SQLException if a database access error occurs
     */
    private Loan extractLoanFromResultSet(ResultSet rs) throws SQLException {
        Loan loan = new Loan();
        loan.setId(rs.getLong("id"));
        
        // Set book
        Book book = new Book();
        book.setId(rs.getLong("book_id"));
        book.setTitle(rs.getString("book_title"));
        book.setAuthor(rs.getString("book_author"));
        loan.setBook(book);
        
        // Set user
        User user = new User();
        user.setId(rs.getLong("user_id"));
        user.setName(rs.getString("user_name"));
        user.setEmail(rs.getString("user_email"));
        loan.setUser(user);
        
        // Set dates
        loan.setLoanDate(new Date(rs.getDate("loan_date").getTime()));
        
        java.sql.Date returnDate = rs.getDate("return_date");
        if (returnDate != null) {
            loan.setReturnDate(new Date(returnDate.getTime()));
        }
        
        loan.setReturned(rs.getBoolean("returned"));
        
        return loan;
    }
}
