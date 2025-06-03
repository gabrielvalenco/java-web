<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:useBean id="now" class="java.util.Date" />

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Empréstimos" />
    <jsp:param name="currentPage" value="loans" />
</jsp:include>

<!-- Page Header -->
<div class="row mb-4">
    <div class="col-md-6">
        <h1><i class="fas fa-exchange-alt me-2"></i>Empréstimos</h1>
        <p class="lead">Gerenciamento de empréstimos de livros</p>
    </div>
    <div class="col-md-6 text-end">
        <a href="${pageContext.request.contextPath}/loans?action=new" class="btn btn-primary">
            <i class="fas fa-plus me-1"></i>Novo Empréstimo
        </a>
    </div>
</div>

<!-- Filter and Search -->
<div class="card mb-4">
    <div class="card-body">
        <form id="filterForm" class="row g-3">
            <div class="col-md-3">
                <label for="statusFilter" class="form-label">Status</label>
                <select id="statusFilter" class="form-select">
                    <option value="">Todos</option>
                    <option value="active">Em andamento</option>
                    <option value="returned">Devolvidos</option>
                    <option value="overdue">Atrasados</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="userFilter" class="form-label">Usuário</label>
                <select id="userFilter" class="form-select">
                    <option value="">Todos</option>
                    <c:forEach var="user" items="${users}">
                        <option value="${user.id}">${user.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <label for="searchInput" class="form-label">Buscar</label>
                <input type="text" class="form-control" id="searchInput" placeholder="Livro, usuário ou ID...">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="button" id="resetFilters" class="btn btn-secondary w-100">
                    <i class="fas fa-undo me-1"></i>Limpar
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Results Counter -->
<div class="d-flex justify-content-between align-items-center mb-3">
    <div>
        <span class="text-muted">Mostrando <span id="resultsCounter">${loans.size()}</span> empréstimos</span>
    </div>
    <div class="btn-group">
        <button class="btn btn-outline-secondary btn-sm" id="exportCSV">
            <i class="fas fa-file-csv me-1"></i>Exportar CSV
        </button>
        <button class="btn btn-outline-secondary btn-sm" id="printResults">
            <i class="fas fa-print me-1"></i>Imprimir
        </button>
    </div>
</div>

<!-- Loans Table -->
<div class="table-responsive">
    <table class="table table-hover">
        <thead>
            <tr>
                <th><a href="#" class="text-white sort-column" data-column="id">ID <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="text-white sort-column" data-column="user">Usuário <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="text-white sort-column" data-column="book">Livro <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="text-white sort-column" data-column="loanDate">Data Empréstimo <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="text-white sort-column" data-column="dueDate">Data Devolução Prevista <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="text-white sort-column" data-column="returnDate">Data Devolução Real <i class="fas fa-sort"></i></a></th>
                <th>Status</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="loan" items="${loans}">
                <c:set var="isOverdue" value="${loan.returnDate == null && loan.dueDate.before(now)}" />
                <tr class="${isOverdue ? 'overdue' : ''}" data-due-date="${loan.dueDate}" data-user-id="${loan.user.id}" data-status="${loan.returnDate != null ? 'returned' : (isOverdue ? 'overdue' : 'active')}">
                    <td>${loan.id}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/users?action=view&id=${loan.user.id}" class="text-decoration-none" data-bs-toggle="tooltip" title="Ver perfil do usuário">
                            ${loan.user.name}
                        </a>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/books?action=view&id=${loan.book.id}" class="text-decoration-none" data-bs-toggle="tooltip" title="Ver detalhes do livro">
                            ${loan.book.title}
                        </a>
                    </td>
                    <td><fmt:formatDate value="${loan.loanDate}" pattern="dd/MM/yyyy" /></td>
                    <td><fmt:formatDate value="${loan.dueDate}" pattern="dd/MM/yyyy" /></td>
                    <td>
                        <c:choose>
                            <c:when test="${loan.returnDate != null}">
                                <fmt:formatDate value="${loan.returnDate}" pattern="dd/MM/yyyy" />
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Não devolvido</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${loan.returnDate != null}">
                                <span class="badge bg-success status-badge">Devolvido</span>
                            </c:when>
                            <c:when test="${isOverdue}">
                                <span class="badge bg-danger status-badge">Atrasado</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning status-badge">Em andamento</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm btn-primary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                Ações
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/loans?action=view&id=${loan.id}">
                                        <i class="fas fa-eye me-1"></i>Visualizar
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/loans?action=edit&id=${loan.id}">
                                        <i class="fas fa-edit me-1"></i>Editar
                                    </a>
                                </li>
                                <c:if test="${loan.returnDate == null}">
                                    <li>
                                        <a class="dropdown-item confirm-action" href="${pageContext.request.contextPath}/loans?action=return&id=${loan.id}" data-confirm-message="Confirmar devolução deste livro?">
                                            <i class="fas fa-undo me-1"></i>Registrar Devolução
                                        </a>
                                    </li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger confirm-action" href="${pageContext.request.contextPath}/loans?action=delete&id=${loan.id}" data-confirm-message="Tem certeza que deseja excluir este empréstimo?">
                                        <i class="fas fa-trash me-1"></i>Excluir
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty loans}">
                <tr>
                    <td colspan="8" class="text-center py-5">
                        <div class="text-muted">
                            <i class="fas fa-search fa-3x mb-3"></i>
                            <p class="h5">Nenhum empréstimo encontrado</p>
                            <p>Tente ajustar seus filtros ou <a href="${pageContext.request.contextPath}/loans?action=new">adicione um novo empréstimo</a></p>
                        </div>
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<!-- Custom JavaScript for this page -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Filter functionality
        const statusFilter = document.getElementById('statusFilter');
        const userFilter = document.getElementById('userFilter');
        const searchInput = document.getElementById('searchInput');
        const resetFilters = document.getElementById('resetFilters');
        const resultsCounter = document.getElementById('resultsCounter');
        
        function applyFilters() {
            const status = statusFilter.value;
            const userId = userFilter.value;
            const searchText = searchInput.value.toLowerCase();
            
            const rows = document.querySelectorAll('table tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const rowStatus = row.getAttribute('data-status');
                const rowUserId = row.getAttribute('data-user-id');
                const rowText = row.textContent.toLowerCase();
                
                const statusMatch = !status || status === rowStatus;
                const userMatch = !userId || userId === rowUserId;
                const textMatch = !searchText || rowText.includes(searchText);
                
                if (statusMatch && userMatch && textMatch) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Update counter
            resultsCounter.textContent = visibleCount;
        }
        
        // Add event listeners
        statusFilter.addEventListener('change', applyFilters);
        userFilter.addEventListener('change', applyFilters);
        searchInput.addEventListener('keyup', applyFilters);
        
        resetFilters.addEventListener('click', function() {
            statusFilter.value = '';
            userFilter.value = '';
            searchInput.value = '';
            applyFilters();
        });
        
        // Sorting functionality
        const sortColumns = document.querySelectorAll('.sort-column');
        let currentSortColumn = null;
        let currentSortDirection = 'asc';
        
        sortColumns.forEach(column => {
            column.addEventListener('click', function(e) {
                e.preventDefault();
                
                const columnName = this.getAttribute('data-column');
                
                // Toggle direction if same column
                if (columnName === currentSortColumn) {
                    currentSortDirection = currentSortDirection === 'asc' ? 'desc' : 'asc';
                } else {
                    currentSortColumn = columnName;
                    currentSortDirection = 'asc';
                }
                
                // Update UI to show sort direction
                sortColumns.forEach(col => {
                    const icon = col.querySelector('i');
                    icon.className = 'fas fa-sort';
                });
                
                const icon = this.querySelector('i');
                icon.className = `fas fa-sort-${currentSortDirection === 'asc' ? 'up' : 'down'}`;
                
                // Sort the table
                sortTable(columnName, currentSortDirection);
            });
        });
        
        function sortTable(column, direction) {
            const table = document.querySelector('table');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            
            // Sort rows
            rows.sort((a, b) => {
                let valueA, valueB;
                
                if (column === 'id') {
                    valueA = parseInt(a.cells[0].textContent) || 0;
                    valueB = parseInt(b.cells[0].textContent) || 0;
                } else if (column === 'user') {
                    valueA = a.cells[1].textContent.trim();
                    valueB = b.cells[1].textContent.trim();
                } else if (column === 'book') {
                    valueA = a.cells[2].textContent.trim();
                    valueB = b.cells[2].textContent.trim();
                } else if (column === 'loanDate' || column === 'dueDate' || column === 'returnDate') {
                    // Parse dates for comparison
                    const indexMap = {'loanDate': 3, 'dueDate': 4, 'returnDate': 5};
                    const cellIndex = indexMap[column];
                    
                    const dateA = parseDate(a.cells[cellIndex].textContent);
                    const dateB = parseDate(b.cells[cellIndex].textContent);
                    
                    valueA = dateA ? dateA.getTime() : 0;
                    valueB = dateB ? dateB.getTime() : 0;
                } else {
                    valueA = a.cells[0].textContent.trim();
                    valueB = b.cells[0].textContent.trim();
                }
                
                // Compare values
                if (valueA < valueB) {
                    return direction === 'asc' ? -1 : 1;
                } else if (valueA > valueB) {
                    return direction === 'asc' ? 1 : -1;
                } else {
                    return 0;
                }
            });
            
            // Re-append rows in new order
            rows.forEach(row => {
                tbody.appendChild(row);
            });
        }
        
        function parseDate(dateStr) {
            if (!dateStr || dateStr.includes('Não devolvido')) return null;
            
            // Parse DD/MM/YYYY format
            const parts = dateStr.trim().split('/');
            if (parts.length === 3) {
                return new Date(parts[2], parts[1] - 1, parts[0]);
            }
            return null;
        }
        
        // Print functionality
        document.getElementById('printResults').addEventListener('click', function() {
            window.print();
        });
        
        // CSV Export
        document.getElementById('exportCSV').addEventListener('click', function() {
            const rows = document.querySelectorAll('table tbody tr:not([style*="display: none"])');
            let csvContent = 'ID,Usuário,Livro,Data Empréstimo,Data Devolução Prevista,Data Devolução Real,Status\n';
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                const rowData = [
                    cells[0].textContent.trim(),
                    cells[1].textContent.trim(),
                    cells[2].textContent.trim(),
                    cells[3].textContent.trim(),
                    cells[4].textContent.trim(),
                    cells[5].textContent.trim(),
                    cells[6].textContent.trim()
                ];
                
                // Escape commas and quotes
                const formattedRowData = rowData.map(cell => {
                    const formattedCell = cell.replace(/"/g, '""');
                    return `"${formattedCell}"`;
                });
                
                csvContent += formattedRowData.join(',') + '\n';
            });
            
            // Create download link
            const encodedUri = encodeURI('data:text/csv;charset=utf-8,' + csvContent);
            const link = document.createElement('a');
            link.setAttribute('href', encodedUri);
            link.setAttribute('download', 'emprestimos_biblioteca.csv');
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
