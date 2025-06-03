        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>Biblioteca</h5>
                    <p>Sistema de gerenciamento de biblioteca para controle de empréstimos, acervo e usuários.</p>
                </div>
                <div class="col-md-4">
                    <h5>Links Úteis</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/" class="text-white">Início</a></li>
                        <li><a href="${pageContext.request.contextPath}/books" class="text-white">Livros</a></li>
                        <li><a href="${pageContext.request.contextPath}/users" class="text-white">Usuários</a></li>
                        <li><a href="${pageContext.request.contextPath}/loans" class="text-white">Empréstimos</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Estatísticas</h5>
                    <p>Livros cadastrados: <span id="bookCount">--</span></p>
                    <p>Usuários cadastrados: <span id="userCount">--</span></p>
                    <p>Empréstimos ativos: <span id="activeLoansCount">--</span></p>
                </div>
            </div>
            <hr class="bg-white">
            <div class="text-center">
                <p>&copy; 2025 Biblioteca. Todos os direitos reservados.</p>
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
