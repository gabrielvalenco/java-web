<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${book != null ? 'Edit' : 'Add'} Book - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${book != null ? 'Edit' : 'Add'} Book</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">Back to Book List</a>
        </div>
        
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/books" method="post">
                    <input type="hidden" name="action" value="${book != null ? 'update' : 'create'}">
                    <c:if test="${book != null}">
                        <input type="hidden" name="id" value="${book.id}">
                    </c:if>
                    
                    <div class="form-group">
                        <label for="title">Title</label>
                        <input type="text" class="form-control" id="title" name="title" value="${book != null ? book.title : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="author">Author</label>
                        <input type="text" class="form-control" id="author" name="author" value="${book != null ? book.author : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="isbn">ISBN</label>
                        <input type="text" class="form-control" id="isbn" name="isbn" value="${book != null ? book.isbn : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="publicationYear">Publication Year</label>
                        <input type="number" class="form-control" id="publicationYear" name="publicationYear" value="${book != null ? book.publicationYear : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="categoryId">Category</label>
                        <select class="form-control" id="categoryId" name="categoryId">
                            <option value="">-- Select Category --</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}" ${book != null && book.category != null && book.category.id == category.id ? 'selected' : ''}>${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">${book != null ? 'Update' : 'Create'} Book</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

