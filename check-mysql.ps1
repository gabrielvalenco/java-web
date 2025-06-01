# Script para verificar o banco de dados MySQL
Write-Host "Verificando o status do MySQL..."

# Verifica se o MySQL está em execução verificando a porta 3306
$mysqlRunning = Test-NetConnection -ComputerName localhost -Port 3306 -InformationLevel Quiet

if ($mysqlRunning) {
    Write-Host "MySQL está em execução na porta 3306" -ForegroundColor Green
} else {
    Write-Host "MySQL NÃO está em execução na porta 3306" -ForegroundColor Red
    Write-Host "Por favor, verifique se o Laragon está iniciado e o serviço MySQL está ativo."
}

# Verifica a existência do banco de dados 'library_db'
Write-Host "`nVerificando a existência do banco de dados 'library_db'..."
Write-Host "Nota: Este teste só funcionará se o MySQL estiver em execução e o usuário 'root' sem senha estiver configurado."

try {
    # Tenta executar o mysql.exe para listar os bancos de dados
    # Ajuste o caminho do mysql.exe conforme necessário
    $mysqlExePath = "mysql"
    $output = & $mysqlExePath -u root -e "SHOW DATABASES LIKE 'library_db';" 2>&1
    
    if ($output -match "library_db") {
        Write-Host "Banco de dados 'library_db' encontrado!" -ForegroundColor Green
    } else {
        Write-Host "Banco de dados 'library_db' NÃO encontrado!" -ForegroundColor Red
        Write-Host "Você precisa criar o banco de dados 'library_db' no MySQL."
    }
} catch {
    Write-Host "Erro ao verificar o banco de dados: $_" -ForegroundColor Red
    Write-Host "Verifique se o MySQL está instalado e o comando mysql está disponível no PATH."
}

Write-Host "`nVerificação concluída."
