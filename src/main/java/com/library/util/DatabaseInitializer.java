package com.library.util;

import com.library.dao.*;

/**
 * Utility class for initializing the database schema.
 */
public class DatabaseInitializer {
    
    /**
     * Initialize the database schema by creating all required tables.
     */
    public static void initializeDatabase() {
        // Create tables in the correct order to respect foreign key constraints
        new CategoryDAO().createTable();
        new UserDAO().createTable();
        new PublisherDAO().createTable();
        new BookDAO().createTable();
        new BookUserDAO().createTable();
        new LoanDAO().createTable();
        
        System.out.println("Database schema initialized successfully.");
    }
}
