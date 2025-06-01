<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Loan List - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .actions {
            white-space: nowrap;
        }
        .overdue {
            background-color: #ffdddd;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Loan List</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Home</a>
            <a href="${pageContext.request.contextPath}/loans/new" class="btn btn-primary">Add New Loan</a>
        </div>
        
        <table class="table table-striped">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Book</th>
                    <th>Loan Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="loan" items="${loans}">
                    <c:set var="isOverdue" value="${loan.returnDate == null && loan.dueDate.before(now)}" />
                    <tr class="${isOverdue ? 'overdue' : ''}">
                        <td>${loan.id}</td>
                        <td>${loan.user.name}</td>
                        <td>${loan.book.title}</td>
                        <td>${loan.loanDate}</td>
                        <td>${loan.dueDate}</td>
                        <td>${loan.returnDate != null ? loan.returnDate : 'Not returned'}</td>
                        <td>
                            <c:choose>
                                <c:when test="${loan.returnDate != null}">
                                    <span class="badge badge-success">Returned</span>
                                </c:when>
                                <c:when test="${isOverdue}">
                                    <span class="badge badge-danger">Overdue</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">Borrowed</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="actions">
                            <a href="${pageContext.request.contextPath}/loans/view/${loan.id}" class="btn btn-info btn-sm">View</a>
                            <a href="${pageContext.request.contextPath}/loans/edit/${loan.id}" class="btn btn-warning btn-sm">Edit</a>
                            <c:if test="${loan.returnDate == null}">
                                <a href="${pageContext.request.contextPath}/loans/return/${loan.id}" class="btn btn-success btn-sm" onclick="return confirm('Confirm return of this book?')">Return</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/loans/delete/${loan.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this loan record?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty loans}">
                    <tr>
                        <td colspan="8" class="text-center">No loans found</td>
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

