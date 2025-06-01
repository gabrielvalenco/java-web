<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${user != null ? 'Edit' : 'Add'} User - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${user != null ? 'Edit' : 'Add'} User</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">Back to User List</a>
        </div>
        
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/users" method="post">
                    <input type="hidden" name="action" value="${user != null ? 'update' : 'create'}">
                    <c:if test="${user != null}">
                        <input type="hidden" name="id" value="${user.id}">
                    </c:if>
                    
                    <div class="form-group">
                        <label for="name">Name</label>
                        <input type="text" class="form-control" id="name" name="name" value="${user != null ? user.name : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${user != null ? user.email : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${user != null ? user.phone : ''}">
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3">${user != null ? user.address : ''}</textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">${user != null ? 'Update' : 'Create'} User</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

