<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Editoras" />
    <jsp:param name="currentPage" value="publishers" />
</jsp:include>

<!-- Page Header -->
<div class="row mb-4">
    <div class="col-md-6">
        <h1><i class="fas fa-building me-2"></i>Editoras</h1>
        <p class="lead">Gerenciamento de editoras de livros</p>
    </div>
    <div class="col-md-6 text-end">
        <a href="${pageContext.request.contextPath}/publishers/new" class="btn btn-primary">
            <i class="fas fa-plus me-1"></i>Nova Editora
        </a>
    </div>
</div>

<!-- Filter and Search -->
<div class="card mb-4">
    <div class="card-body">
        <form id="filterForm" class="row g-3">
            <div class="col-md-8">
                <label for="searchInput" class="form-label">Buscar</label>
                <input type="text" class="form-control" id="searchInput" placeholder="Buscar por nome, email ou telefone...">
            </div>
            <div class="col-md-4 d-flex align-items-end">
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
        <span class="text-muted">Mostrando <span id="resultsCounter">${publishers.size()}</span> editoras</span>
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

<!-- Publishers Table -->
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
            <c:forEach var="publisher" items="${publishers}">
                <tr>
                    <td>${publisher.id}</td>
                    <td>
                        <strong>${publisher.name}</strong>
                    </td>
                    <td>
                        <c:if test="${not empty publisher.email}">
                            <a href="mailto:${publisher.email}">
                                <i class="fas fa-envelope me-1 text-muted"></i>${publisher.email}
                            </a>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${not empty publisher.phone}">
                            <a href="tel:${publisher.phone}" class="text-decoration-none">
                                <i class="fas fa-phone-alt me-1 text-muted"></i>${publisher.phone}
                            </a>
                        </c:if>
                    </td>
                    <td>
                        <div class="d-flex gap-1 flex-wrap">
                            <a href="${pageContext.request.contextPath}/publishers/view/${publisher.id}" class="btn btn-sm btn-outline-primary" title="Visualizar">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/publishers/edit/${publisher.id}" class="btn btn-sm btn-outline-primary" title="Editar">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a class="btn btn-sm btn-outline-danger confirm-action" 
                               href="${pageContext.request.contextPath}/publishers/delete/${publisher.id}" 
                               data-confirm-message="Tem certeza que deseja excluir esta editora?" title="Excluir">
                                <i class="fas fa-trash"></i>
                            </a>
                            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/books?publisher=${publisher.id}" title="Ver Livros">
                                <i class="fas fa-book"></i>
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty publishers}">
                <tr>
                    <td colspan="5" class="text-center py-5">
                        <div class="text-muted">
                            <i class="fas fa-building fa-3x mb-3"></i>
                            <p class="h5">Nenhuma editora encontrada</p>
                            <p>Adicione uma <a href="${pageContext.request.contextPath}/publishers/new">nova editora</a> para começar</p>
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
                    const rowData = [
                        cells[0].textContent.trim(),
                        cells[1].textContent.trim(),
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
            link.setAttribute('download', 'editoras_biblioteca.csv');
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
