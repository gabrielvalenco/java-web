package com.library.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.library.dao.BookDAO;
import com.library.dao.CategoryDAO;
import com.library.model.Book;
import com.library.model.Category;

/**
 * Servlet implementation class BookServlet
 * This servlet handles CRUD operations for books.
 */
@WebServlet("/books/*")
public class BookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookServlet() {
        super();
        bookDAO = new BookDAO();
        categoryDAO = new CategoryDAO();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List all books
            List<Book> books = bookDAO.findAll();
            request.setAttribute("books", books);
            request.getRequestDispatcher("/WEB-INF/views/book/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/new")) {
            // Show form to create a new book
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/views/book/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show form to edit an existing book
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Book book = bookDAO.findById(id);
                if (book != null) {
                    List<Category> categories = categoryDAO.findAll();
                    request.setAttribute("book", book);
                    request.setAttribute("categories", categories);
                    request.getRequestDispatcher("/WEB-INF/views/book/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete a book
            try {
                Long id = Long.parseLong(pathInfo.substring(8));
                boolean deleted = bookDAO.delete(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/books");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/view/")) {
            // View a book's details
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Book book = bookDAO.findById(id);
                if (book != null) {
                    request.setAttribute("book", book);
                    request.getRequestDispatcher("/WEB-INF/views/book/view.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equals(action) || "update".equals(action)) {
            // Create or update a book
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String isbn = request.getParameter("isbn");
            String publicationYearStr = request.getParameter("publicationYear");
            String categoryIdStr = request.getParameter("categoryId");
            
            if (title != null && author != null && isbn != null && publicationYearStr != null) {
                try {
                    int publicationYear = Integer.parseInt(publicationYearStr);
                    
                    Book book;
                    if ("update".equals(action)) {
                        String idStr = request.getParameter("id");
                        if (idStr != null) {
                            Long id = Long.parseLong(idStr);
                            book = bookDAO.findById(id);
                            if (book == null) {
                                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                                return;
                            }
                        } else {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                            return;
                        }
                    } else {
                        book = new Book();
                    }
                    
                    book.setTitle(title);
                    book.setAuthor(author);
                    book.setIsbn(isbn);
                    book.setPublicationYear(publicationYear);
                    
                    if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                        Long categoryId = Long.parseLong(categoryIdStr);
                        Category category = categoryDAO.findById(categoryId);
                        if (category != null) {
                            book.setCategory(category);
                        }
                    }
                    
                    if ("update".equals(action)) {
                        bookDAO.update(book);
                    } else {
                        bookDAO.save(book);
                    }
                    
                    response.sendRedirect(request.getContextPath() + "/books");
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}


