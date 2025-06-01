<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${loan != null ? 'Edit' : 'Add'} Loan - Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${loan != null ? 'Edit' : 'Add'} Loan</h1>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/loans" class="btn btn-secondary">Back to Loan List</a>
        </div>
        
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/loans" method="post">
                    <input type="hidden" name="action" value="${loan != null ? 'update' : 'create'}">
                    <c:if test="${loan != null}">
                        <input type="hidden" name="id" value="${loan.id}">
                    </c:if>
                    
                    <div class="form-group">
                        <label for="userId">User</label>
                        <select class="form-control" id="userId" name="userId" required>
                            <option value="">Select User</option>
                            <c:forEach var="user" items="${users}">
                                <option value="${user.id}" ${loan != null && loan.user.id == user.id ? 'selected' : ''}>${user.name} (${user.email})</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="bookId">Book</label>
                        <select class="form-control" id="bookId" name="bookId" required>
                            <option value="">Select Book</option>
                            <c:forEach var="book" items="${books}">
                                <option value="${book.id}" ${loan != null && loan.book.id == book.id ? 'selected' : ''}>${book.title} by ${book.author}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="loanDate">Loan Date</label>
                        <input type="date" class="form-control" id="loanDate" name="loanDate" 
                               value="${loan != null ? loan.loanDate : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="dueDate">Due Date</label>
                        <input type="date" class="form-control" id="dueDate" name="dueDate" 
                               value="${loan != null ? loan.dueDate : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="returnDate">Return Date (leave empty if not returned)</label>
                        <input type="date" class="form-control" id="returnDate" name="returnDate" 
                               value="${loan != null ? loan.returnDate : ''}">
                    </div>
                    
                    <button type="submit" class="btn btn-primary">${loan != null ? 'Update' : 'Create'} Loan</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Set default dates if creating a new loan
        document.addEventListener('DOMContentLoaded', function() {
            if (!document.querySelector('input[name="action"][value="update"]')) {
                const today = new Date();
                const twoWeeksLater = new Date(today);
                twoWeeksLater.setDate(today.getDate() + 14);
                
                document.getElementById('loanDate').valueAsDate = today;
                document.getElementById('dueDate').valueAsDate = twoWeeksLater;
            }
        });
    </script>
</body>
</html>

