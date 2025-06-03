<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Usuários" />
    <jsp:param name="currentPage" value="users" />
</jsp:include>

<!-- Page Header -->
<div class="row mb-4">
    <div class="col-md-6">
        <h1><i class="fas fa-users me-2"></i>Usuários</h1>
        <p class="lead">Gerenciamento de usuários da biblioteca</p>
    </div>
    <div class="col-md-6 text-end">
        <a href="${pageContext.request.contextPath}/users/new" class="btn btn-primary">
            <i class="fas fa-user-plus me-1"></i>Novo Usuário
        </a>
    </div>
</div>

<!-- Filter and Search -->
<div class="card mb-4">
    <div class="card-body">
        <form id="filterForm" class="row g-3">
            <!-- User type filter removed as it's not available in the model -->
            <div class="col-md-6">
                <label for="searchInput" class="form-label">Buscar</label>
                <input type="text" class="form-control" id="searchInput" placeholder="Nome, email ou telefone...">
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
        <span class="text-muted">Mostrando <span id="resultsCounter">${users.size()}</span> usuários</span>
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

<!-- Users Table -->
<div class="table-responsive">
    <table class="table table-hover">
        <thead>
            <tr>
                <th><a href="#" class="sort-column" data-column="id">ID <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="name">Nome <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="email">Email <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="phone">Telefone <i class="fas fa-sort"></i></a></th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.id}</td>
                    <td>
                        <div class="d-flex align-items-center">
                            <span class="avatar-circle bg-primary me-2">${fn:substring(user.name, 0, 1).toUpperCase()}</span>
                            <strong>${user.name}</strong>
                        </div>
                    </td>
                    <td>
                        <a href="mailto:${user.email}">${user.email}</a>
                    </td>
                    <td>
                        <c:if test="${not empty user.phone}">
                            <a href="tel:${user.phone}" class="text-decoration-none">
                                <i class="fas fa-phone-alt me-1 text-muted"></i>${user.phone}
                            </a>
                        </c:if>
                    </td>
                    <td>
                        <div class="d-flex gap-1 flex-wrap">
                            <a href="${pageContext.request.contextPath}/users/view/${user.id}" class="btn btn-sm btn-outline-primary" title="Visualizar">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/users/edit/${user.id}" class="btn btn-sm btn-outline-primary" title="Editar">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/users/loans/${user.id}" class="btn btn-sm btn-outline-info" title="Empréstimos">
                                <i class="fas fa-book"></i>
                            </a>
                            <a class="btn btn-sm btn-outline-danger confirm-action" 
                               href="${pageContext.request.contextPath}/users/delete/${user.id}" 
                               data-confirm-message="Tem certeza que deseja excluir este usuário?" title="Excluir">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty users}">
                <tr>
                    <td colspan="5" class="text-center py-5">
                        <div class="text-muted">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <p class="h5">Nenhum usuário encontrado</p>
                            <p>Tente ajustar seus filtros ou <a href="${pageContext.request.contextPath}/users/new">adicione um novo usuário</a></p>
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
        // Apply initials to avatars
        document.querySelectorAll('.avatar-circle').forEach(avatar => {
            const userName = avatar.nextElementSibling.textContent.trim();
            if (userName) {
                avatar.textContent = userName.charAt(0).toUpperCase();
            } else {
                avatar.textContent = 'U';
            }
        });
        
        // Filter functionality
        const userTypeFilter = document.getElementById('userTypeFilter');
        const searchInput = document.getElementById('searchInput');
        const resetFilters = document.getElementById('resetFilters');
        const resultsCounter = document.getElementById('resultsCounter');
        
        function applyFilters() {
            const searchText = searchInput.value.toLowerCase();
            
            // Elements to filter
            const rows = document.querySelectorAll('tbody tr');
            
            let visibleCount = 0;
            
            rows.forEach(row => {
                const rowText = row.textContent.toLowerCase();
                const textMatch = !searchText || rowText.includes(searchText);
                
                if (textMatch) {
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
        if (searchInput) searchInput.addEventListener('input', applyFilters);
        
        if (resetFilters) {
            resetFilters.addEventListener('click', function() {
                if (searchInput) searchInput.value = '';
                applyFilters();
            });
        }
        
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
                icon.className = currentSortDirection === 'asc' ? 'fas fa-sort-up' : 'fas fa-sort-down';
                
                // Sort the table
                sortTable(columnName, currentSortDirection);
            });
        });
        
        function sortTable(column, direction) {
            const table = document.querySelector('table');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr:not([style*="display: none"])'));
            
            // Sort rows
            rows.sort((a, b) => {
                let valueA, valueB;
                
                const columnMap = {
                    'id': 0,
                    'name': 1,
                    'email': 2,
                    'phone': 3
                };
                
                const cellIndex = columnMap[column];
                
                if (column === 'id') {
                    valueA = parseInt(a.cells[cellIndex].textContent.trim()) || 0;
                    valueB = parseInt(b.cells[cellIndex].textContent.trim()) || 0;
                } else if (column === 'name') {
                    // Extract name from the strong element
                    const nameElA = a.cells[cellIndex].querySelector('strong');
                    const nameElB = b.cells[cellIndex].querySelector('strong');
                    valueA = nameElA ? nameElA.textContent.trim().toLowerCase() : '';
                    valueB = nameElB ? nameElB.textContent.trim().toLowerCase() : '';
                } else {
                    valueA = a.cells[cellIndex].textContent.trim().toLowerCase();
                    valueB = b.cells[cellIndex].textContent.trim().toLowerCase();
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
        
        // Confirmation action for delete buttons
        document.querySelectorAll('.confirm-action').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const message = this.getAttribute('data-confirm-message') || 'Tem certeza?';
                if (confirm(message)) {
                    window.location.href = this.getAttribute('href');
                }
            });
        });
        
        // Print functionality
        document.getElementById('printResults').addEventListener('click', function() {
            window.print();
        });
        
        // CSV Export
        document.getElementById('exportCSV').addEventListener('click', function() {
            const rows = document.querySelectorAll('table tbody tr:not([style*="display: none"])');
            let csvContent = 'ID,Nome,Email,Telefone\n';
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length >= 4) {
                    // Extract name from the strong element
                    const nameEl = cells[1].querySelector('strong');
                    const name = nameEl ? nameEl.textContent.trim() : cells[1].textContent.trim();
                    
                    const rowData = [
                        cells[0].textContent.trim(),
                        name,
                        cells[2].textContent.trim(),
                        cells[3].textContent.trim()
                    ];
                    
                    // Escape commas and quotes
                    const formattedRowData = rowData.map(cell => {
                        const formattedCell = cell.replace(/"/g, '""');
                        return `"${formattedCell}"`;
                    });
                    
                    csvContent += formattedRowData.join(',') + '\n';
                }
            });
            
            // Create download link
            const encodedUri = encodeURI('data:text/csv;charset=utf-8,' + csvContent);
            const link = document.createElement('a');
            link.setAttribute('href', encodedUri);
            link.setAttribute('download', 'usuarios_biblioteca.csv');
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    });
</script>

<style>
    .avatar-circle {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        border-radius: 50%;
        color: white;
        font-weight: bold;
    }
</style>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
