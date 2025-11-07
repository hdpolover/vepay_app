# Simple script to collect debug symbols
Write-Host "Collecting debug symbols..." -ForegroundColor Green

$ProjectRoot = "D:\Work\Repos\vepay_app"
$BuildPath = "$ProjectRoot\build\app\intermediates\merged_native_libs\release\mergeReleaseNativeLibs\out\lib"
$SymbolsPath = "$ProjectRoot\symbols"

# Clean and create symbols directory
if (Test-Path $SymbolsPath) {
    Remove-Item $SymbolsPath -Recurse -Force
}
New-Item -ItemType Directory -Path $SymbolsPath -Force | Out-Null

# Copy all architectures
$Architectures = @("arm64-v8a", "armeabi-v7a", "x86", "x86_64")

foreach ($arch in $Architectures) {
    $SourcePath = "$BuildPath\$arch"
    $DestPath = "$SymbolsPath\$arch"
    
    if (Test-Path $SourcePath) {
        Copy-Item $SourcePath $DestPath -Recurse
        $files = Get-ChildItem $DestPath -Filter "*.so"
        Write-Host "Copied $($files.Count) files for $arch" -ForegroundColor Green
    }
}

# Create zip file
$ZipPath = "$ProjectRoot\native-debug-symbols.zip"
if (Test-Path $ZipPath) {
    Remove-Item $ZipPath
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($SymbolsPath, $ZipPath)

Write-Host "Created: native-debug-symbols.zip" -ForegroundColor Green
Write-Host "Location: $ZipPath" -ForegroundColor Blue

# Show file size
$FileSize = (Get-Item $ZipPath).Length / 1MB
Write-Host "Size: $([math]::Round($FileSize, 2)) MB" -ForegroundColor Yellow
