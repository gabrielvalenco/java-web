# Create a directory to download the files
$downloadDir = ".\jakarta-libs-download"
if (!(Test-Path -Path $downloadDir)) {
    New-Item -ItemType Directory -Path $downloadDir
}

# URLs for Jakarta libraries
$libraries = @{
    "jakarta.servlet-api-6.0.0.jar" = "https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar"
    "jakarta.servlet.jsp-api-3.1.1.jar" = "https://repo1.maven.org/maven2/jakarta/servlet/jsp/jakarta.servlet.jsp-api/3.1.1/jakarta.servlet.jsp-api-3.1.1.jar"
    "jakarta.servlet.jsp.jstl-api-3.0.0.jar" = "https://repo1.maven.org/maven2/jakarta/servlet/jsp/jstl/jakarta.servlet.jsp.jstl-api/3.0.0/jakarta.servlet.jsp.jstl-api-3.0.0.jar"
    "jakarta.servlet.jsp.jstl-3.0.1.jar" = "https://repo1.maven.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/3.0.1/jakarta.servlet.jsp.jstl-3.0.1.jar"
}

# Download each library
foreach ($library in $libraries.GetEnumerator()) {
    $outputFile = Join-Path -Path $downloadDir -ChildPath $library.Key
    Write-Host "Downloading $($library.Key)..."
    
    try {
        Invoke-WebRequest -Uri $library.Value -OutFile $outputFile
        Write-Host "Downloaded to $outputFile"
    }
    catch {
        Write-Host "Failed to download $($library.Key): $_"
    }
}

Write-Host "`nDownloads completed.`n"

# Backup the old libraries
$backupDir = ".\lib-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$libDir = ".\src\main\webapp\WEB-INF\lib"

Write-Host "Backing up old libraries to $backupDir..."
New-Item -ItemType Directory -Path $backupDir
Copy-Item -Path "$libDir\javax.servlet-api-4.0.1.jar" -Destination $backupDir
Copy-Item -Path "$libDir\javax.servlet.jsp-api-2.3.3.jar" -Destination $backupDir
Copy-Item -Path "$libDir\jstl-1.2.jar" -Destination $backupDir

# Copy the new libraries to WEB-INF/lib
Write-Host "Installing new libraries to $libDir..."
Copy-Item -Path "$downloadDir\*.jar" -Destination $libDir

Write-Host "Library update completed."
Write-Host "Please restart your server for the changes to take effect."
