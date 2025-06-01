# This script ensures all servlet annotations are properly updated for Jakarta EE
$servlets = Get-ChildItem -Path "C:\Users\Usuario\eclipse-workspace\web-project\src\main\java\com\library\servlet" -Filter "*Servlet.java"

foreach ($servlet in $servlets) {
    Write-Host "Checking $($servlet.Name)..."
    $content = Get-Content -Path $servlet.FullName -Raw
    
    # Check if the file has jakarta imports but still uses javax annotations
    if (($content -match 'import jakarta\.servlet') -and ($content -match '@WebServlet\(' -or $content -match '@javax\.servlet\.annotation')) {
        Write-Host "  - Updating WebServlet annotations in $($servlet.Name)"
        $content = $content -replace '@javax\.servlet\.annotation\.WebServlet', '@jakarta.servlet.annotation.WebServlet'
        $content | Set-Content -Path $servlet.FullName
    }
    
    # Check for any remaining javax imports that we might have missed
    if ($content -match 'import javax\.') {
        Write-Host "  - Found remaining javax imports in $($servlet.Name):"
        $imports = [regex]::Matches($content, 'import javax\.[^;]+;')
        foreach ($import in $imports) {
            Write-Host "    * $($import.Value)"
        }
    }
    
    # Add error handling for NumberFormatException in UserServlet
    if ($servlet.Name -eq "UserServlet.java" -and $content -match "catch \(NumberFormatException e\)") {
        Write-Host "  - Fixing NumberFormatException handling in UserServlet.java"
        $updatedContent = $content -replace "catch \(NumberFormatException e\) \{[^}]*\}", "catch (NumberFormatException | IllegalArgumentException e) {`n                response.sendError(HttpServletResponse.SC_BAD_REQUEST);`n            }"
        if ($updatedContent -ne $content) {
            $updatedContent | Set-Content -Path $servlet.FullName
            Write-Host "  - Updated exception handling in UserServlet.java"
        }
    }
}

# Verify web.xml and context.xml are properly configured
$webXmlPath = "C:\Users\Usuario\eclipse-workspace\web-project\src\main\webapp\WEB-INF\web.xml"
$webXml = Get-Content -Path $webXmlPath -Raw
if ($webXml -match 'version="6.0"' -and $webXml -match 'jakarta.ee/xml/ns/jakartaee') {
    Write-Host "web.xml is configured correctly for Jakarta EE"
} else {
    Write-Host "web.xml may not be properly configured for Jakarta EE"
}

$contextXmlPath = "C:\Users\Usuario\eclipse-workspace\web-project\src\main\webapp\META-INF\context.xml"
$contextXml = Get-Content -Path $contextXmlPath -Raw
Write-Host "Context path is set to: $(([regex]::Match($contextXml, 'path="([^"]+)"')).Groups[1].Value)"

Write-Host "`nUpdate complete! Please rebuild and redeploy your application."
