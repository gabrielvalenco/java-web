<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Details - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .book-details {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Book Details</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">Back to Book List</a>
            <a href="${pageContext.request.contextPath}/books/edit/${book.id}" class="btn btn-warning">Edit Book</a>
            <a href="${pageContext.request.contextPath}/books/delete/${book.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this book?')">Delete Book</a>
        </div>
        
        <div class="card book-details">
            <div class="card-header">
                <h2>${book.title}</h2>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>ID:</strong> ${book.id}</p>
                        <p><strong>Author:</strong> ${book.author}</p>
                        <p><strong>ISBN:</strong> ${book.isbn}</p>
                        <p><strong>Publication Year:</strong> ${book.publicationYear}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Category:</strong> ${book.category != null ? book.category.name : 'N/A'}</p>
                        <c:if test="${book.category != null}">
                            <p><strong>Category Description:</strong> ${book.category.description}</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

