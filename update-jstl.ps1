$jspFiles = Get-ChildItem -Path "C:\Users\Usuario\eclipse-workspace\web-project\src\main\webapp" -Recurse -Filter "*.jsp"

foreach ($file in $jspFiles) {
    $content = Get-Content -Path $file.FullName -Raw

    # Substituir as URIs JSTL antigas pelas novas URIs Jakarta
    $content = $content -replace 'taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"', 'taglib uri="jakarta.tags.core" prefix="c"'
    $content = $content -replace 'taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"', 'taglib uri="jakarta.tags.fmt" prefix="fmt"'

    # Salvar o arquivo atualizado
    $content | Set-Content -Path $file.FullName

    Write-Host "Atualizado: $($file.FullName)"
}

Write-Host "Atualização concluída!"
