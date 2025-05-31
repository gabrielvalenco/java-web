<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${publisher != null ? 'Edit' : 'Add'} Publisher - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${publisher != null ? 'Edit' : 'Add'} Publisher</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/publishers" class="btn btn-secondary">Back to Publisher List</a>
        </div>
        
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/publishers" method="post">
                    <input type="hidden" name="action" value="${publisher != null ? 'update' : 'create'}">
                    <c:if test="${publisher != null}">
                        <input type="hidden" name="id" value="${publisher.id}">
                    </c:if>
                    
                    <div class="form-group">
                        <label for="name">Name</label>
                        <input type="text" class="form-control" id="name" name="name" value="${publisher != null ? publisher.name : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3">${publisher != null ? publisher.address : ''}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${publisher != null ? publisher.phone : ''}">
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${publisher != null ? publisher.email : ''}">
                    </div>
                    
                    <button type="submit" class="btn btn-primary">${publisher != null ? 'Update' : 'Create'} Publisher</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
