package com.library.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.library.dao.CategoryDAO;
import com.library.model.Category;

/**
 * Servlet implementation class CategoryServlet
 * This servlet handles CRUD operations for categories.
 */
@WebServlet("/categories/*")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CategoryServlet() {
        super();
        categoryDAO = new CategoryDAO();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List all categories
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/views/category/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/new")) {
            // Show form to create a new category
            request.getRequestDispatcher("/WEB-INF/views/category/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show form to edit an existing category
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Category category = categoryDAO.findById(id);
                if (category != null) {
                    request.setAttribute("category", category);
                    request.getRequestDispatcher("/WEB-INF/views/category/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete a category
            try {
                Long id = Long.parseLong(pathInfo.substring(8));
                boolean deleted = categoryDAO.delete(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/categories");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/view/")) {
            // View a category's details
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Category category = categoryDAO.findById(id);
                if (category != null) {
                    request.setAttribute("category", category);
                    request.getRequestDispatcher("/WEB-INF/views/category/view.jsp").forward(request, response);
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
            // Create or update a category
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            
            if (name != null) {
                Category category;
                if ("update".equals(action)) {
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        try {
                            Long id = Long.parseLong(idStr);
                            category = categoryDAO.findById(id);
                            if (category == null) {
                                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                                return;
                            }
                        } catch (NumberFormatException e) {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                            return;
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                } else {
                    category = new Category();
                }
                
                category.setName(name);
                category.setDescription(description);
                
                if ("update".equals(action)) {
                    categoryDAO.update(category);
                } else {
                    categoryDAO.save(category);
                }
                
                response.sendRedirect(request.getContextPath() + "/categories");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}


