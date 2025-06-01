$javaFiles = Get-ChildItem -Path "C:\Users\Usuario\eclipse-workspace\web-project\src\main\java" -Recurse -Filter "*.java"

foreach ($file in $javaFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $updated = $false

    # Replace javax.servlet imports with jakarta.servlet imports
    $newContent = $content -replace 'import javax\.servlet', 'import jakarta.servlet'
    
    if ($newContent -ne $content) {
        $updated = $true
        $content = $newContent
    }

    # Also replace any other javax imports that might be related
    $newContent = $content -replace 'import javax\.ws\.rs', 'import jakarta.ws.rs'
    
    if ($newContent -ne $content) {
        $updated = $true
        $content = $newContent
    }

    # Save the file only if changes were made
    if ($updated) {
        $content | Set-Content -Path $file.FullName
        Write-Host "Updated: $($file.FullName)"
    }
}

Write-Host "Servlet import update complete!"
