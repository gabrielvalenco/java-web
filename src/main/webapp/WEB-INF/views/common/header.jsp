<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle} - Biblioteca</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-book-open me-2"></i>Biblioteca
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link ${param.currentPage == 'home' ? 'active' : ''}" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-home me-1"></i>Início
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.currentPage == 'books' ? 'active' : ''}" href="${pageContext.request.contextPath}/books">
                            <i class="fas fa-book me-1"></i>Livros
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.currentPage == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/users">
                            <i class="fas fa-users me-1"></i>Usuários
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.currentPage == 'loans' ? 'active' : ''}" href="${pageContext.request.contextPath}/loans">
                            <i class="fas fa-exchange-alt me-1"></i>Empréstimos
                        </a>
                    </li>
                </ul>
                <form class="d-flex search-form" action="${pageContext.request.contextPath}/search" method="get">
                    <input class="form-control me-2" type="search" name="query" placeholder="Pesquisar..." aria-label="Search">
                    <button class="btn btn-outline-light" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
        </div>
    </nav>

    <!-- Notifications container -->
    <div id="notifications" class="position-fixed top-0 end-0 p-3" style="z-index: 1050"></div>

    <!-- Content Wrapper -->
    <div class="content-wrapper">
        <div class="container">
            <!-- Page content will be inserted here -->
