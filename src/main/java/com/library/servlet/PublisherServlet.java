package com.library.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.library.dao.PublisherDAO;
import com.library.model.Publisher;

/**
 * Servlet implementation class PublisherServlet
 * This servlet handles CRUD operations for publishers.
 */
@WebServlet("/publishers/*")
public class PublisherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PublisherDAO publisherDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PublisherServlet() {
        super();
        publisherDAO = new PublisherDAO();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List all publishers
            List<Publisher> publishers = publisherDAO.findAll();
            request.setAttribute("publishers", publishers);
            request.getRequestDispatcher("/WEB-INF/views/publisher/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/new")) {
            // Show form to create a new publisher
            request.getRequestDispatcher("/WEB-INF/views/publisher/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show form to edit an existing publisher
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Publisher publisher = publisherDAO.findById(id);
                if (publisher != null) {
                    request.setAttribute("publisher", publisher);
                    request.getRequestDispatcher("/WEB-INF/views/publisher/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete a publisher
            try {
                Long id = Long.parseLong(pathInfo.substring(8));
                boolean deleted = publisherDAO.delete(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/publishers");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/view/")) {
            // View a publisher's details
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Publisher publisher = publisherDAO.findById(id);
                if (publisher != null) {
                    request.setAttribute("publisher", publisher);
                    request.getRequestDispatcher("/WEB-INF/views/publisher/view.jsp").forward(request, response);
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
            // Create or update a publisher
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            
            if (name != null) {
                Publisher publisher;
                if ("update".equals(action)) {
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        try {
                            Long id = Long.parseLong(idStr);
                            publisher = publisherDAO.findById(id);
                            if (publisher == null) {
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
                    publisher = new Publisher();
                }
                
                publisher.setName(name);
                publisher.setAddress(address);
                publisher.setPhone(phone);
                publisher.setEmail(email);
                
                if ("update".equals(action)) {
                    publisherDAO.update(publisher);
                } else {
                    publisherDAO.save(publisher);
                }
                
                response.sendRedirect(request.getContextPath() + "/publishers");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}


