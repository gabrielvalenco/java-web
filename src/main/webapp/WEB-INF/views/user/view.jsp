<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Details - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .user-details {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>User Details</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">Back to User List</a>
            <a href="${pageContext.request.contextPath}/users/edit/${user.id}" class="btn btn-warning">Edit User</a>
            <a href="${pageContext.request.contextPath}/users/delete/${user.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this user?')">Delete User</a>
        </div>
        
        <div class="card user-details">
            <div class="card-header">
                <h2>${user.name}</h2>
            </div>
            <div class="card-body">
                <p><strong>ID:</strong> ${user.id}</p>
                <p><strong>Email:</strong> ${user.email}</p>
                <p><strong>Phone:</strong> ${user.phone}</p>
                <p><strong>Address:</strong> ${user.address}</p>
                
                <h3 class="mt-4">Borrowed Books</h3>
                <c:if test="${not empty user.books}">
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
                            <c:forEach var="book" items="${user.books}">
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
                <c:if test="${empty user.books}">
                    <p>No books borrowed by this user.</p>
                </c:if>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
