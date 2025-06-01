<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category Details - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .category-details {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Category Details</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/categories" class="btn btn-secondary">Back to Category List</a>
            <a href="${pageContext.request.contextPath}/categories/edit/${category.id}" class="btn btn-warning">Edit Category</a>
            <a href="${pageContext.request.contextPath}/categories/delete/${category.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this category?')">Delete Category</a>
        </div>
        
        <div class="card category-details">
            <div class="card-header">
                <h2>${category.name}</h2>
            </div>
            <div class="card-body">
                <p><strong>ID:</strong> ${category.id}</p>
                <p><strong>Description:</strong> ${category.description}</p>
                
                <h3 class="mt-4">Books in this Category</h3>
                <c:if test="${not empty category.books}">
                    <table class="table table-striped">
                        <thead class="thead-light">
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Author</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${category.books}">
                                <tr>
                                    <td>${book.id}</td>
                                    <td>${book.title}</td>
                                    <td>${book.author}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/books/view/${book.id}" class="btn btn-info btn-sm">View</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
                <c:if test="${empty category.books}">
                    <p>No books in this category.</p>
                </c:if>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

