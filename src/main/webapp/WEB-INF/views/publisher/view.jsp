<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Publisher Details - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .publisher-details {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Publisher Details</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/publishers" class="btn btn-secondary">Back to Publisher List</a>
            <a href="${pageContext.request.contextPath}/publishers/edit/${publisher.id}" class="btn btn-warning">Edit Publisher</a>
            <a href="${pageContext.request.contextPath}/publishers/delete/${publisher.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this publisher?')">Delete Publisher</a>
        </div>
        
        <div class="card publisher-details">
            <div class="card-header">
                <h2>${publisher.name}</h2>
            </div>
            <div class="card-body">
                <p><strong>ID:</strong> ${publisher.id}</p>
                <p><strong>Address:</strong> ${publisher.address}</p>
                <p><strong>Phone:</strong> ${publisher.phone}</p>
                <p><strong>Email:</strong> ${publisher.email}</p>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

