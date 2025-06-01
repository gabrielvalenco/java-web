<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Loan Details - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .loan-details {
            margin-top: 20px;
        }
        .overdue {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Loan Details</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/loans" class="btn btn-secondary">Back to Loan List</a>
            <a href="${pageContext.request.contextPath}/loans/edit/${loan.id}" class="btn btn-warning">Edit Loan</a>
            <c:if test="${loan.returnDate == null}">
                <a href="${pageContext.request.contextPath}/loans/return/${loan.id}" class="btn btn-success" onclick="return confirm('Confirm return of this book?')">Mark as Returned</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/loans/delete/${loan.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this loan record?')">Delete Loan</a>
        </div>
        
        <div class="card loan-details">
            <div class="card-header">
                <h2>Loan #${loan.id}</h2>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h3>Loan Information</h3>
                        <p><strong>Loan Date:</strong> ${loan.loanDate}</p>
                        <p><strong>Due Date:</strong> ${loan.dueDate}</p>
                        <p>
                            <strong>Return Date:</strong> 
                            <c:choose>
                                <c:when test="${loan.returnDate != null}">
                                    ${loan.returnDate}
                                </c:when>
                                <c:otherwise>
                                    <span class="${loan.dueDate.before(now) ? 'overdue' : ''}">
                                        Not returned ${loan.dueDate.before(now) ? '(OVERDUE)' : ''}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <p>
                            <strong>Status:</strong>
                            <c:choose>
                                <c:when test="${loan.returnDate != null}">
                                    <span class="badge badge-success">Returned</span>
                                </c:when>
                                <c:when test="${loan.dueDate.before(now)}">
                                    <span class="badge badge-danger">Overdue</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">Borrowed</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    
                    <div class="col-md-6">
                        <h3>Book Information</h3>
                        <p><strong>Title:</strong> <a href="${pageContext.request.contextPath}/books/view/${loan.book.id}">${loan.book.title}</a></p>
                        <p><strong>Author:</strong> ${loan.book.author}</p>
                        <p><strong>ISBN:</strong> ${loan.book.isbn}</p>
                        <p><strong>Category:</strong> ${loan.book.category.name}</p>
                        
                        <h3 class="mt-4">User Information</h3>
                        <p><strong>Name:</strong> <a href="${pageContext.request.contextPath}/users/view/${loan.user.id}">${loan.user.name}</a></p>
                        <p><strong>Email:</strong> ${loan.user.email}</p>
                        <p><strong>Phone:</strong> ${loan.user.phone}</p>
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

