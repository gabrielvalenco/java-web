<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard" />
    <jsp:param name="currentPage" value="home" />
</jsp:include>

<!-- Dashboard Header -->
<div class="row mb-4">
    <div class="col-md-6">
        <h1 class="display-4"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</h1>
        <p class="lead">Bem-vindo ao Sistema de Gerenciamento de Biblioteca</p>
    </div>
    <div class="col-md-6 text-end">
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/books?action=new" class="btn btn-primary">
                <i class="fas fa-plus me-1"></i>Novo Livro
            </a>
            <a href="${pageContext.request.contextPath}/users?action=new" class="btn btn-success">
                <i class="fas fa-user-plus me-1"></i>Novo Usuário
            </a>
            <a href="${pageContext.request.contextPath}/loans?action=new" class="btn btn-warning">
                <i class="fas fa-exchange-alt me-1"></i>Novo Empréstimo
            </a>
        </div>
    </div>
</div>

<!-- Stats Cards -->
<div class="row mb-4">
    <div class="col-md-3 mb-4">
        <div class="card dashboard-card bg-white">
            <div class="card-body">
                <h5 class="card-title">Total de Livros</h5>
                <div class="stat-value" data-target="${totalBooks}">0</div>
                <div class="stat-label">Livros cadastrados</div>
                <i class="fas fa-book stat-icon"></i>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-sm btn-primary w-100">
                    <i class="fas fa-arrow-right me-1"></i>Ver Todos
                </a>
            </div>
        </div>
    </div>
    
    <div class="col-md-3 mb-4">
        <div class="card dashboard-card bg-white">
            <div class="card-body">
                <h5 class="card-title">Total de Usuários</h5>
                <div class="stat-value" data-target="${totalUsers}">0</div>
                <div class="stat-label">Usuários cadastrados</div>
                <i class="fas fa-users stat-icon"></i>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/users" class="btn btn-sm btn-primary w-100">
                    <i class="fas fa-arrow-right me-1"></i>Ver Todos
                </a>
            </div>
        </div>
    </div>
    
    <div class="col-md-3 mb-4">
        <div class="card dashboard-card bg-white">
            <div class="card-body">
                <h5 class="card-title">Empréstimos Ativos</h5>
                <div class="stat-value" data-target="${activeLoans}">0</div>
                <div class="stat-label">Empréstimos em andamento</div>
                <i class="fas fa-exchange-alt stat-icon"></i>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/loans" class="btn btn-sm btn-primary w-100">
                    <i class="fas fa-arrow-right me-1"></i>Ver Todos
                </a>
            </div>
        </div>
    </div>
    
    <div class="col-md-3 mb-4">
        <div class="card dashboard-card bg-white">
            <div class="card-body">
                <h5 class="card-title">Empréstimos Atrasados</h5>
                <div class="stat-value text-danger" data-target="${overdueLoans}">0</div>
                <div class="stat-label">Empréstimos em atraso</div>
                <i class="fas fa-exclamation-triangle stat-icon"></i>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/loans?filter=overdue" class="btn btn-sm btn-danger w-100">
                    <i class="fas fa-arrow-right me-1"></i>Ver Atrasados
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Recent Activities and Quick Actions -->
<div class="row">
    <!-- Recent Activities -->
    <div class="col-md-8">
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-history me-2"></i>Atividades Recentes</h5>
            </div>
            <div class="card-body p-0">
                <div class="list-group list-group-flush">
                    <c:if test="${not empty recentLoans}">
                        <c:forEach var="loan" items="${recentLoans}">
                            <div class="list-group-item">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">Empréstimo: ${loan.book.title}</h6>
                                    <small><fmt:formatDate value="${loan.loanDate}" pattern="dd/MM/yyyy"/></small>
                                </div>
                                <p class="mb-1">Usuário: ${loan.user.name}</p>
                                <small>
                                    <span class="badge ${loan.returned ? 'bg-success' : (loan.dueDate.before(now) ? 'bg-danger' : 'bg-warning')}">
                                        ${loan.returned ? 'Devolvido' : (loan.dueDate.before(now) ? 'Atrasado' : 'Em andamento')}
                                    </span>
                                </small>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty recentLoans}">
                        <div class="list-group-item text-center text-muted py-5">
                            <i class="fas fa-info-circle mb-2 display-4"></i>
                            <p>Não há atividades recentes para exibir</p>
                        </div>
                    </c:if>
                </div>
            </div>
            <div class="card-footer text-center">
                <a href="${pageContext.request.contextPath}/loans" class="btn btn-sm btn-outline-primary">Ver Todos os Empréstimos</a>
            </div>
        </div>
    </div>
    
    <!-- Quick Actions and Books to Return Today -->
    <div class="col-md-4">
        <!-- Quick Actions -->
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-bolt me-2"></i>Ações Rápidas</h5>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/books?action=new" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Adicionar Novo Livro
                    </a>
                    <a href="${pageContext.request.contextPath}/users?action=new" class="btn btn-success">
                        <i class="fas fa-user-plus me-2"></i>Cadastrar Novo Usuário
                    </a>
                    <a href="${pageContext.request.contextPath}/loans?action=new" class="btn btn-warning">
                        <i class="fas fa-exchange-alt me-2"></i>Registrar Empréstimo
                    </a>
                    <a href="${pageContext.request.contextPath}/loans?action=return" class="btn btn-info">
                        <i class="fas fa-undo me-2"></i>Registrar Devolução
                    </a>
                    <a href="${pageContext.request.contextPath}/reports" class="btn btn-secondary">
                        <i class="fas fa-chart-bar me-2"></i>Relatórios
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Books to Return Today -->
        <div class="card">
            <div class="card-header bg-warning text-white">
                <h5 class="mb-0"><i class="fas fa-clock me-2"></i>Devoluções para Hoje</h5>
            </div>
            <div class="card-body p-0">
                <div class="list-group list-group-flush">
                    <c:if test="${not empty dueTodayLoans}">
                        <c:forEach var="loan" items="${dueTodayLoans}">
                            <div class="list-group-item">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">${loan.book.title}</h6>
                                </div>
                                <p class="mb-1">Usuário: ${loan.user.name}</p>
                                <a href="${pageContext.request.contextPath}/loans?action=return&id=${loan.id}" 
                                   class="btn btn-sm btn-outline-success">
                                    <i class="fas fa-check me-1"></i>Marcar como Devolvido
                                </a>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty dueTodayLoans}">
                        <div class="list-group-item text-center text-muted py-4">
                            <i class="fas fa-check-circle mb-2 display-4"></i>
                            <p>Não há devoluções programadas para hoje</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
