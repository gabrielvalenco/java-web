<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Publisher List - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .actions {
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Publisher List</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Home</a>
            <a href="${pageContext.request.contextPath}/publishers/new" class="btn btn-primary">Add New Publisher</a>
        </div>
        
        <table class="table table-striped">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="publisher" items="${publishers}">
                    <tr>
                        <td>${publisher.id}</td>
                        <td>${publisher.name}</td>
                        <td>${publisher.email}</td>
                        <td>${publisher.phone}</td>
                        <td class="actions">
                            <a href="${pageContext.request.contextPath}/publishers/view/${publisher.id}" class="btn btn-info btn-sm">View</a>
                            <a href="${pageContext.request.contextPath}/publishers/edit/${publisher.id}" class="btn btn-warning btn-sm">Edit</a>
                            <a href="${pageContext.request.contextPath}/publishers/delete/${publisher.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this publisher?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty publishers}">
                    <tr>
                        <td colspan="5" class="text-center">No publishers found</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

