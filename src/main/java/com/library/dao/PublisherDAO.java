package com.library.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.library.model.Publisher;
import com.library.util.DatabaseUtil;

/**
 * Data Access Object for Publisher entity.
 */
public class PublisherDAO {
    
    /**
     * Create the publishers table in the database.
     */
    public void createTable() {
        String sql = "CREATE TABLE IF NOT EXISTS publishers (" +
                "id BIGINT PRIMARY KEY AUTO_INCREMENT, " +
                "name VARCHAR(100) NOT NULL, " +
                "address VARCHAR(255), " +
                "phone VARCHAR(20), " +
                "email VARCHAR(100)" +
                ")";
                
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Save a publisher to the database.
     * 
     * @param publisher Publisher to save
     * @return the saved Publisher with generated ID
     */
    public Publisher save(Publisher publisher) {
        String sql = "INSERT INTO publishers (name, address, phone, email) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, publisher.getName());
            pstmt.setString(2, publisher.getAddress());
            pstmt.setString(3, publisher.getPhone());
            pstmt.setString(4, publisher.getEmail());
            
            pstmt.executeUpdate();
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    publisher.setId(generatedKeys.getLong(1));
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return publisher;
    }
    
    /**
     * Find a publisher by its ID.
     * 
     * @param id Publisher ID
     * @return Publisher if found, null otherwise
     */
    public Publisher findById(Long id) {
        String sql = "SELECT * FROM publishers WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractPublisherFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find all publishers in the database.
     * 
     * @return List of all publishers
     */
    public List<Publisher> findAll() {
        List<Publisher> publishers = new ArrayList<>();
        String sql = "SELECT * FROM publishers";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                publishers.add(extractPublisherFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return publishers;
    }
    
    /**
     * Update a publisher in the database.
     * 
     * @param publisher Publisher to update
     * @return true if successful, false otherwise
     */
    public boolean update(Publisher publisher) {
        String sql = "UPDATE publishers SET name = ?, address = ?, phone = ?, email = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, publisher.getName());
            pstmt.setString(2, publisher.getAddress());
            pstmt.setString(3, publisher.getPhone());
            pstmt.setString(4, publisher.getEmail());
            pstmt.setLong(5, publisher.getId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a publisher from the database.
     * 
     * @param id Publisher ID to delete
     * @return true if successful, false otherwise
     */
    public boolean delete(Long id) {
        String sql = "DELETE FROM publishers WHERE id = ?";
        
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
     * Extract a Publisher object from a ResultSet.
     * 
     * @param rs ResultSet to extract from
     * @return Extracted Publisher
     * @throws SQLException if a database access error occurs
     */
    private Publisher extractPublisherFromResultSet(ResultSet rs) throws SQLException {
        Publisher publisher = new Publisher();
        publisher.setId(rs.getLong("id"));
        publisher.setName(rs.getString("name"));
        publisher.setAddress(rs.getString("address"));
        publisher.setPhone(rs.getString("phone"));
        publisher.setEmail(rs.getString("email"));
        return publisher;
    }
}
