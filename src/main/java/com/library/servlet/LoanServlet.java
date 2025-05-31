package com.library.servlet;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.library.dao.BookDAO;
import com.library.dao.LoanDAO;
import com.library.dao.UserDAO;
import com.library.model.Book;
import com.library.model.Loan;
import com.library.model.User;

/**
 * Servlet implementation class LoanServlet
 * This servlet handles CRUD operations for loans.
 */
@WebServlet("/loans/*")
public class LoanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LoanDAO loanDAO;
    private UserDAO userDAO;
    private BookDAO bookDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoanServlet() {
        super();
        loanDAO = new LoanDAO();
        userDAO = new UserDAO();
        bookDAO = new BookDAO();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List all loans
            List<Loan> loans = loanDAO.findAll();
            request.setAttribute("loans", loans);
            request.getRequestDispatcher("/WEB-INF/views/loan/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/new")) {
            // Show form to create a new loan
            List<User> users = userDAO.findAll();
            List<Book> books = bookDAO.findAll();
            request.setAttribute("users", users);
            request.setAttribute("books", books);
            request.getRequestDispatcher("/WEB-INF/views/loan/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show form to edit an existing loan
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Loan loan = loanDAO.findById(id);
                if (loan != null) {
                    List<User> users = userDAO.findAll();
                    List<Book> books = bookDAO.findAll();
                    request.setAttribute("users", users);
                    request.setAttribute("books", books);
                    request.setAttribute("loan", loan);
                    request.getRequestDispatcher("/WEB-INF/views/loan/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete a loan
            try {
                Long id = Long.parseLong(pathInfo.substring(8));
                boolean deleted = loanDAO.delete(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/loans");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/view/")) {
            // View a loan's details
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Loan loan = loanDAO.findById(id);
                if (loan != null) {
                    request.setAttribute("loan", loan);
                    request.getRequestDispatcher("/WEB-INF/views/loan/view.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/return/")) {
            // Return a book
            try {
                Long id = Long.parseLong(pathInfo.substring(8));
                Loan loan = loanDAO.findById(id);
                if (loan != null) {
                    loan.setReturnDate(Date.valueOf(LocalDate.now()));
                    loanDAO.update(loan);
                    response.sendRedirect(request.getContextPath() + "/loans");
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
            // Create or update a loan
            String userIdStr = request.getParameter("userId");
            String bookIdStr = request.getParameter("bookId");
            String loanDateStr = request.getParameter("loanDate");
            String dueDateStr = request.getParameter("dueDate");
            String returnDateStr = request.getParameter("returnDate");
            
            if (userIdStr != null && bookIdStr != null && loanDateStr != null && dueDateStr != null) {
                try {
                    Long userId = Long.parseLong(userIdStr);
                    Long bookId = Long.parseLong(bookIdStr);
                    Date loanDate = Date.valueOf(loanDateStr);
                    Date dueDate = Date.valueOf(dueDateStr);
                    Date returnDate = returnDateStr != null && !returnDateStr.isEmpty() ? Date.valueOf(returnDateStr) : null;
                    
                    User user = userDAO.findById(userId);
                    Book book = bookDAO.findById(bookId);
                    
                    if (user == null || book == null) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user or book");
                        return;
                    }
                    
                    Loan loan;
                    if ("update".equals(action)) {
                        String idStr = request.getParameter("id");
                        if (idStr != null) {
                            Long id = Long.parseLong(idStr);
                            loan = loanDAO.findById(id);
                            if (loan == null) {
                                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                                return;
                            }
                        } else {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                            return;
                        }
                    } else {
                        loan = new Loan();
                    }
                    
                    loan.setUser(user);
                    loan.setBook(book);
                    loan.setLoanDate(loanDate);
                    loan.setDueDate(dueDate);
                    loan.setReturnDate(returnDate);
                    
                    if ("update".equals(action)) {
                        loanDAO.update(loan);
                    } else {
                        loanDAO.save(loan);
                    }
                    
                    response.sendRedirect(request.getContextPath() + "/loans");
                } catch (IllegalArgumentException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format");
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
}
