/**
 * Library Management System - Main JavaScript
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Table row highlighting for overdue loans
    highlightOverdueLoans();
    
    // Search functionality
    initializeSearch();
    
    // Confirmation dialogs
    initializeConfirmations();
    
    // Form validations
    initializeFormValidations();
    
    // Initialize dynamic book grid view
    initializeBookGrid();
    
    // Dashboard animations
    animateDashboardCounters();
});

/**
 * Highlight overdue loans in the table
 */
function highlightOverdueLoans() {
    const now = new Date();
    document.querySelectorAll('tr[data-due-date]').forEach(row => {
        const dueDateStr = row.getAttribute('data-due-date');
        if (dueDateStr) {
            const dueDate = new Date(dueDateStr);
            if (dueDate < now && !row.classList.contains('returned')) {
                row.classList.add('overdue');
                // Also update status badge
                const statusBadge = row.querySelector('.status-badge');
                if (statusBadge) {
                    statusBadge.textContent = 'Atrasado';
                    statusBadge.classList.remove('badge-warning');
                    statusBadge.classList.add('badge-danger');
                }
            }
        }
    });
}

/**
 * Initialize search functionality
 */
function initializeSearch() {
    const searchInput = document.getElementById('searchInput');
    if (!searchInput) return;
    
    searchInput.addEventListener('keyup', function() {
        const searchTerm = this.value.toLowerCase();
        const tableRows = document.querySelectorAll('table tbody tr');
        
        tableRows.forEach(row => {
            const text = row.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
        
        // Update counter
        const visibleRows = document.querySelectorAll('table tbody tr:not([style*="display: none"])');
        const counter = document.getElementById('resultsCounter');
        if (counter) {
            counter.textContent = visibleRows.length;
        }
    });
}

/**
 * Initialize confirmation dialogs
 */
function initializeConfirmations() {
    document.querySelectorAll('.confirm-action').forEach(button => {
        button.addEventListener('click', function(e) {
            if (!confirm(this.getAttribute('data-confirm-message') || 'Tem certeza que deseja continuar?')) {
                e.preventDefault();
            }
        });
    });
}

/**
 * Form validations
 */
function initializeFormValidations() {
    // Example: Validate ISBN format
    const isbnInput = document.getElementById('isbn');
    if (isbnInput) {
        isbnInput.addEventListener('blur', function() {
            const isbn = this.value.replace(/-/g, '');
            if (isbn.length !== 10 && isbn.length !== 13) {
                this.classList.add('is-invalid');
                const feedback = document.createElement('div');
                feedback.className = 'invalid-feedback';
                feedback.textContent = 'ISBN deve ter 10 ou 13 dígitos';
                this.parentNode.appendChild(feedback);
            } else {
                this.classList.remove('is-invalid');
                const feedback = this.parentNode.querySelector('.invalid-feedback');
                if (feedback) {
                    feedback.remove();
                }
            }
        });
    }
    
    // Validate return date is after loan date
    const loanDateInput = document.getElementById('loanDate');
    const returnDateInput = document.getElementById('returnDate');
    if (loanDateInput && returnDateInput) {
        returnDateInput.addEventListener('change', function() {
            const loanDate = new Date(loanDateInput.value);
            const returnDate = new Date(this.value);
            
            if (returnDate < loanDate) {
                this.classList.add('is-invalid');
                const feedback = document.createElement('div');
                feedback.className = 'invalid-feedback';
                feedback.textContent = 'A data de devolução deve ser posterior à data de empréstimo';
                this.parentNode.appendChild(feedback);
            } else {
                this.classList.remove('is-invalid');
                const feedback = this.parentNode.querySelector('.invalid-feedback');
                if (feedback) {
                    feedback.remove();
                }
            }
        });
    }
}

/**
 * Initialize book grid view
 */
function initializeBookGrid() {
    const viewToggle = document.getElementById('viewToggle');
    const bookList = document.getElementById('bookList');
    const bookGrid = document.getElementById('bookGrid');
    
    if (!viewToggle || !bookList || !bookGrid) return;
    
    viewToggle.addEventListener('click', function() {
        if (bookList.classList.contains('d-none')) {
            // Switch to list view
            bookList.classList.remove('d-none');
            bookGrid.classList.add('d-none');
            this.innerHTML = '<i class="fas fa-th"></i> Grid View';
        } else {
            // Switch to grid view
            bookList.classList.add('d-none');
            bookGrid.classList.remove('d-none');
            this.innerHTML = '<i class="fas fa-list"></i> List View';
        }
    });
}

/**
 * Animate dashboard counter values
 */
function animateDashboardCounters() {
    document.querySelectorAll('.stat-value').forEach(counter => {
        const target = parseInt(counter.getAttribute('data-target'), 10);
        const duration = 1000; // 1 second animation
        const step = target / (duration / 10); // Update every 10ms
        
        let current = 0;
        const counterInterval = setInterval(() => {
            current += step;
            counter.textContent = Math.floor(current);
            
            if (current >= target) {
                counter.textContent = target;
                clearInterval(counterInterval);
            }
        }, 10);
    });
}

/**
 * Create a new notification
 */
function createNotification(message, type = 'info') {
    const notificationContainer = document.getElementById('notifications');
    if (!notificationContainer) {
        const container = document.createElement('div');
        container.id = 'notifications';
        container.className = 'position-fixed top-0 end-0 p-3';
        container.style.zIndex = '1050';
        document.body.appendChild(container);
    }
    
    const toast = document.createElement('div');
    toast.className = `toast bg-${type} text-white fade-in`;
    toast.innerHTML = `
        <div class="toast-header bg-${type} text-white">
            <strong class="me-auto">Biblioteca</strong>
            <small>Agora</small>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body">
            ${message}
        </div>
    `;
    
    document.getElementById('notifications').appendChild(toast);
    
    const bsToast = new bootstrap.Toast(toast, {
        delay: 5000
    });
    bsToast.show();
    
    // Remove toast after it's hidden
    toast.addEventListener('hidden.bs.toast', function() {
        this.remove();
    });
}
