        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-5 bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5 class="text-white">Biblioteca</h5>
                    <p class="text-light">Sistema de gerenciamento de biblioteca para controle de empréstimos, acervo e usuários.</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5 class="text-white">Links Úteis</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/" class="text-light">Início</a></li>
                        <li><a href="${pageContext.request.contextPath}/books" class="text-light">Livros</a></li>
                        <li><a href="${pageContext.request.contextPath}/users" class="text-light">Usuários</a></li>
                        <li><a href="${pageContext.request.contextPath}/loans" class="text-light">Empréstimos</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-3">
                    <h5 class="text-white">Estatísticas</h5>
                    <p class="text-light">Livros cadastrados: <span id="bookCount" class="badge bg-primary">--</span></p>
                    <p class="text-light">Usuários cadastrados: <span id="userCount" class="badge bg-primary">--</span></p>
                    <p class="text-light">Empréstimos ativos: <span id="activeLoansCount" class="badge bg-primary">--</span></p>
                </div>
            </div>
            <hr class="border-secondary">
            <div class="text-center">
                <p class="text-light mb-0">&copy; 2025 Biblioteca. Todos os direitos reservados.</p>
            </div>
        </div>
    </footer>

    <!-- JavaScript Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
    
    <!-- Footer stats -->
    <script>
        $(document).ready(function() {
            // Fetch and update footer statistics
            $.ajax({
                url: '${pageContext.request.contextPath}/api/stats',
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    $('#bookCount').text(data.bookCount || 0);
                    $('#userCount').text(data.userCount || 0);
                    $('#activeLoansCount').text(data.activeLoansCount || 0);
                },
                error: function() {
                    console.log('Erro ao carregar estatísticas');
                }
            });
        });
    </script>
</body>
</html>
