package com.library.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.library.util.DatabaseInitializer;

/**
 * Servlet implementation class InitServlet
 * This servlet initializes the database schema when the application starts.
 */
@WebServlet(name = "InitServlet", urlPatterns = { "/init" }, loadOnStartup = 1)
public class InitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InitServlet() {
        super();
    }

    /**
     * @see HttpServlet#init()
     */
    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize the database schema
        DatabaseInitializer.initializeDatabase();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.getWriter().println("<h1>Database Initialization</h1>");
        response.getWriter().println("<p>Database schema has been initialized successfully.</p>");
        response.getWriter().println("<p><a href='index.jsp'>Go to Home</a></p>");
    }
}


