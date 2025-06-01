package com.library.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.library.dao.UserDAO;
import com.library.model.User;

/**
 * Servlet implementation class UserServlet
 * This servlet handles CRUD operations for users.
 */
@WebServlet("/users/*")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserServlet() {
        super();
        userDAO = new UserDAO();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List all users
            List<User> users = userDAO.findAll();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/views/user/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/new")) {
            // Show form to create a new user
            request.getRequestDispatcher("/WEB-INF/views/user/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show form to edit an existing user
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                User user = userDAO.findById(id);
                if (user != null) {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/WEB-INF/views/user/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException | IllegalArgumentException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete a user
            try {
                Long id = Long.parseLong(pathInfo.substring(8));
                boolean deleted = userDAO.delete(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/users");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException | IllegalArgumentException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/view/")) {
            // View a user's details
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                User user = userDAO.findById(id);
                if (user != null) {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/WEB-INF/views/user/view.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException | IllegalArgumentException e) {
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
            // Create or update a user
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            if (name != null && email != null) {
                User user;
                if ("update".equals(action)) {
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        try {
                            Long id = Long.parseLong(idStr);
                            user = userDAO.findById(id);
                            if (user == null) {
                                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                                return;
                            }
                        } catch (NumberFormatException | IllegalArgumentException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
                    } else {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                } else {
                    user = new User();
                }
                
                user.setName(name);
                user.setEmail(email);
                user.setPhone(phone);
                user.setAddress(address);
                
                if ("update".equals(action)) {
                    userDAO.update(user);
                } else {
                    userDAO.save(user);
                }
                
                response.sendRedirect(request.getContextPath() + "/users");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}


