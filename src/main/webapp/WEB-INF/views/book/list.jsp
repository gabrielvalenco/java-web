<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Livros" />
    <jsp:param name="currentPage" value="books" />
</jsp:include>

<!-- Page Header -->
<div class="row mb-4">
    <div class="col-md-6">
        <h1><i class="fas fa-book me-2"></i>Livros</h1>
        <p class="lead">Gerenciamento do acervo da biblioteca</p>
    </div>
    <div class="col-md-6 text-end">
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/books/new" class="btn btn-primary">
                <i class="fas fa-plus me-1"></i>Novo Livro
            </a>
            <button id="viewToggle" class="btn btn-outline-secondary">
                <i class="fas fa-th-large"></i>
            </button>
        </div>
    </div>
</div>

<!-- Filter and Search -->
<div class="card mb-4">
    <div class="card-body">
        <form id="filterForm" class="row g-3">
            <div class="col-md-3">
                <label for="categoryFilter" class="form-label">Categoria</label>
                <select id="categoryFilter" class="form-select">
                    <option value="">Todas</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.id}">${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <label for="yearFilter" class="form-label">Ano de Publicação</label>
                <select id="yearFilter" class="form-select">
                    <option value="">Todos</option>
                    <c:forEach var="year" items="${publicationYears}">
                        <option value="${year}">${year}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <label for="searchInput" class="form-label">Buscar</label>
                <input type="text" class="form-control" id="searchInput" placeholder="Título, autor ou ISBN...">
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
        <span class="text-muted">Mostrando <span id="resultsCounter">${books.size()}</span> livros</span>
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

<!-- List View -->
<div id="listView" class="table-responsive">
    <table class="table table-hover">
        <thead>
            <tr>
                <th><a href="#" class="sort-column" data-column="id">ID <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="title">Título <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="author">Autor <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="isbn">ISBN <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="year">Ano <i class="fas fa-sort"></i></a></th>
                <th><a href="#" class="sort-column" data-column="category">Categoria <i class="fas fa-sort"></i></a></th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="book" items="${books}">
                <tr data-category="${book.category != null ? book.category.id : ''}" data-year="${book.publicationYear}">
                    <td>${book.id}</td>
                    <td>
                        <strong>${book.title}</strong>
                    </td>
                    <td>${book.author}</td>
                    <td>
                        <span class="badge bg-light text-dark">${book.isbn}</span>
                    </td>
                    <td>${book.publicationYear}</td>
                    <td>
                        <c:choose>
                            <c:when test="${book.category != null}">
                                <span class="badge bg-info">${book.category.name}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Não categorizado</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="d-flex gap-1 flex-wrap">
                            <a href="${pageContext.request.contextPath}/books/view/${book.id}" class="btn btn-sm btn-outline-primary" title="Visualizar">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/books/edit/${book.id}" class="btn btn-sm btn-outline-primary" title="Editar">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/books/loan/${book.id}" class="btn btn-sm btn-outline-info" title="Emprestar">
                                <i class="fas fa-exchange-alt"></i>
                            </a>
                            <a class="btn btn-sm btn-outline-danger confirm-action" 
                               href="${pageContext.request.contextPath}/books/delete/${book.id}" 
                               data-confirm-message="Tem certeza que deseja excluir este livro?" title="Excluir">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty books}">
                <tr>
                    <td colspan="7" class="text-center py-5">
                        <div class="text-muted">
                            <i class="fas fa-book fa-3x mb-3"></i>
                            <p class="h5">Nenhum livro encontrado</p>
                            <p>Tente ajustar seus filtros ou <a href="${pageContext.request.contextPath}/books/new">adicione um novo livro</a></p>
                        </div>
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<!-- Grid View (initially hidden) -->
<div id="gridView" class="row row-cols-1 row-cols-md-3 g-4" style="display: none;">
    <c:forEach var="book" items="${books}">
        <div class="col" data-category="${book.category != null ? book.category.id : ''}" data-year="${book.publicationYear}">
            <div class="card h-100">
                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                    <span class="badge bg-primary">${book.publicationYear}</span>
                    <c:if test="${book.category != null}">
                        <span class="badge bg-info">${book.category.name}</span>
                    </c:if>
                </div>
                <div class="card-body">
                    <h5 class="card-title">${book.title}</h5>
                    <h6 class="card-subtitle mb-2 text-muted">${book.author}</h6>
                    <p class="card-text">
                        <small class="text-muted">ISBN: ${book.isbn}</small>
                    </p>
                </div>
                <div class="card-footer">
                    <div class="btn-group w-100">
                        <a href="${pageContext.request.contextPath}/books/view/${book.id}" class="btn btn-sm btn-outline-primary" title="Visualizar">
                            <i class="fas fa-eye"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/books/edit/${book.id}" class="btn btn-sm btn-outline-primary" title="Editar">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/books/loan/${book.id}" class="btn btn-sm btn-outline-info" title="Emprestar">
                            <i class="fas fa-exchange-alt"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/books/delete/${book.id}" class="btn btn-sm btn-outline-danger confirm-action" data-confirm-message="Tem certeza que deseja excluir este livro?" title="Excluir">
                            <i class="fas fa-trash"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
    
    <c:if test="${empty books}">
        <div class="col-12 text-center py-5">
            <div class="text-muted">
                <i class="fas fa-book fa-3x mb-3"></i>
                <p class="h5">Nenhum livro encontrado</p>
                <p>Tente ajustar seus filtros ou <a href="${pageContext.request.contextPath}/books/new">adicione um novo livro</a></p>
            </div>
        </div>
    </c:if>
</div>

<!-- Custom JavaScript for this page -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // View toggle functionality
        const viewToggle = document.getElementById('viewToggle');
        const listView = document.getElementById('listView');
        const gridView = document.getElementById('gridView');
        const toggleIcon = viewToggle.querySelector('i');
        
        viewToggle.addEventListener('click', function() {
            if (listView.style.display !== 'none') {
                listView.style.display = 'none';
                gridView.style.display = 'flex';
                toggleIcon.className = 'fas fa-list';
                viewToggle.setAttribute('title', 'Visualização em lista');
            } else {
                listView.style.display = 'block';
                gridView.style.display = 'none';
                toggleIcon.className = 'fas fa-th-large';
                viewToggle.setAttribute('title', 'Visualização em grade');
            }
        });
        
        // Filter functionality
        const categoryFilter = document.getElementById('categoryFilter');
        const yearFilter = document.getElementById('yearFilter');
        const searchInput = document.getElementById('searchInput');
        const resetFilters = document.getElementById('resetFilters');
        const resultsCounter = document.getElementById('resultsCounter');
        
        function applyFilters() {
            const category = categoryFilter.value;
            const year = yearFilter.value;
            const searchText = searchInput.value.toLowerCase();
            
            // Elements to filter (both in list and grid views)
            const listRows = document.querySelectorAll('#listView tbody tr');
            const gridItems = document.querySelectorAll('#gridView .col');
            
            let visibleCount = 0;
            
            // Filter list view
            listRows.forEach(row => {
                const rowCategory = row.getAttribute('data-category');
                const rowYear = row.getAttribute('data-year');
                const rowText = row.textContent.toLowerCase();
                
                const categoryMatch = !category || category === rowCategory;
                const yearMatch = !year || year === rowYear;
                const textMatch = !searchText || rowText.includes(searchText);
                
                if (categoryMatch && yearMatch && textMatch) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Filter grid view (only if it's the active view)
            if (gridView.style.display !== 'none') {
                visibleCount = 0; // Reset counter for grid view
                
                gridItems.forEach(item => {
                    const itemCategory = item.getAttribute('data-category');
                    const itemYear = item.getAttribute('data-year');
                    const itemText = item.textContent.toLowerCase();
                    
                    const categoryMatch = !category || category === itemCategory;
                    const yearMatch = !year || year === itemYear;
                    const textMatch = !searchText || itemText.includes(searchText);
                    
                    if (categoryMatch && yearMatch && textMatch) {
                        item.style.display = '';
                        visibleCount++;
                    } else {
                        item.style.display = 'none';
                    }
                });
            }
            
            // Update counter
            resultsCounter.textContent = visibleCount;
        }
        
        // Add event listeners
        categoryFilter.addEventListener('change', applyFilters);
        yearFilter.addEventListener('change', applyFilters);
        searchInput.addEventListener('input', applyFilters);
        
        resetFilters.addEventListener('click', function() {
            categoryFilter.value = '';
            yearFilter.value = '';
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
                    'title': 1,
                    'author': 2,
                    'isbn': 3,
                    'year': 4,
                    'category': 5
                };
                
                const cellIndex = columnMap[column];
                
                if (column === 'id' || column === 'year') {
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
        
        // Print functionality
        document.getElementById('printResults').addEventListener('click', function() {
            window.print();
        });
        
        // CSV Export
        document.getElementById('exportCSV').addEventListener('click', function() {
            const rows = document.querySelectorAll('#listView table tbody tr:not([style*="display: none"])');
            let csvContent = 'ID,Título,Autor,ISBN,Ano de Publicação,Categoria\n';
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                const rowData = [
                    cells[0].textContent.trim(),
                    cells[1].textContent.trim(),
                    cells[2].textContent.trim(),
                    cells[3].textContent.trim(),
                    cells[4].textContent.trim(),
                    cells[5].textContent.trim()
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
            link.setAttribute('download', 'livros_biblioteca.csv');
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
