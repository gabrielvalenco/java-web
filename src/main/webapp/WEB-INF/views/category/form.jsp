<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${category != null ? 'Edit' : 'Add'} Category - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${category != null ? 'Edit' : 'Add'} Category</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/categories" class="btn btn-secondary">Back to Category List</a>
        </div>
        
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/categories" method="post">
                    <input type="hidden" name="action" value="${category != null ? 'update' : 'create'}">
                    <c:if test="${category != null}">
                        <input type="hidden" name="id" value="${category.id}">
                    </c:if>
                    
                    <div class="form-group">
                        <label for="name">Name</label>
                        <input type="text" class="form-control" id="name" name="name" value="${category != null ? category.name : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3">${category != null ? category.description : ''}</textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">${category != null ? 'Update' : 'Create'} Category</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

