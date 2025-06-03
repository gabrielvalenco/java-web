<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Categorias" />
    <jsp:param name="currentPage" value="categories" />
</jsp:include>

<!-- Page Header -->
<div class="row mb-4">
    <div class="col-md-6">
        <h1><i class="fas fa-tags me-2"></i>Categorias</h1>
        <p class="lead">Gerenciamento de categorias de livros</p>
    </div>
    <div class="col-md-6 text-end">
        <a href="${pageContext.request.contextPath}/categories/new" class="btn btn-primary">
            <i class="fas fa-plus me-1"></i>Nova Categoria
        </a>
    </div>
</div>

<!-- Filter and Search -->
<div class="card mb-4">
    <div class="card-body">
        <form id="filterForm" class="row g-3">
            <div class="col-md-8">
                <label for="searchInput" class="form-label">Buscar</label>
                <input type="text" class="form-control" id="searchInput" placeholder="Buscar por nome ou descrição...">
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
        <span class="text-muted">Mostrando <span id="resultsCounter">${categories.size()}</span> categorias</span>
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

<!-- Categories Table -->
<div class="table-responsive">
    <table class="table table-hover">
        <thead>
            <tr>
                <th><a href="#" class="sort-column" data-column="id">ID <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="name">Nome <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="description">Descrição <i class="fas fa-sort"></i></a></th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="category" items="${categories}">
                <tr>
                    <td>${category.id}</td>
                    <td>
                        <span class="badge bg-info text-white rounded-pill px-3 py-2">${category.name}</span>
                    </td>
                    <td>${category.description}</td>
                    <td>
                        <div class="d-flex gap-1 flex-wrap">
                            <a href="${pageContext.request.contextPath}/categories/view/${category.id}" class="btn btn-sm btn-outline-primary" title="Visualizar">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/categories/edit/${category.id}" class="btn btn-sm btn-outline-primary" title="Editar">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a class="btn btn-sm btn-outline-danger confirm-action" 
                               href="${pageContext.request.contextPath}/categories/delete/${category.id}" 
                               data-confirm-message="Tem certeza que deseja excluir esta categoria?" title="Excluir">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty categories}">
                <tr>
                    <td colspan="4" class="text-center py-5">
                        <div class="text-muted">
                            <i class="fas fa-tags fa-3x mb-3"></i>
                            <p class="h5">Nenhuma categoria encontrada</p>
                            <p>Adicione uma <a href="${pageContext.request.contextPath}/categories/new">nova categoria</a> para começar</p>
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
                    'description': 2
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
            let csvContent = 'ID,Nome,Descrição\n';
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length >= 3) {
                    const rowData = [
                        cells[0].textContent.trim(),
                        cells[1].textContent.trim(),
                        cells[2].textContent.trim()
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
            link.setAttribute('download', 'categorias_biblioteca.csv');
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
