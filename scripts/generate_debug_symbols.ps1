# PowerShell script to generate debug symbols for Google Play Console
# Run this after building the release AAB

Write-Host "🔍 Generating debug symbols for Google Play Console..." -ForegroundColor Green

# Set paths
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$FlutterBuildDir = Join-Path $ProjectRoot "build\app\intermediates"
$SymbolsDir = Join-Path $ProjectRoot "symbols"

# Create symbols directory
if (!(Test-Path $SymbolsDir)) {
    New-Item -ItemType Directory -Path $SymbolsDir -Force | Out-Null
    Write-Host "📁 Created symbols directory: $SymbolsDir" -ForegroundColor Blue
}

Write-Host "🔎 Looking for native debug symbols..." -ForegroundColor Yellow

$FoundSymbols = $false

# Copy ARM64 symbols
$Arm64Dir = Join-Path $FlutterBuildDir "merged_native_libs\release\out\lib\arm64-v8a"
if (Test-Path $Arm64Dir) {
    $Arm64SymbolsDir = Join-Path $SymbolsDir "arm64-v8a"
    New-Item -ItemType Directory -Path $Arm64SymbolsDir -Force | Out-Null
    Get-ChildItem -Path $FlutterBuildDir -Filter "*.so" -Recurse | Where-Object { $_.FullName -like "*arm64-v8a*" } | Copy-Item -Destination $Arm64SymbolsDir
    Write-Host "✅ Copied ARM64 symbols" -ForegroundColor Green
    $FoundSymbols = $true
}

# Copy ARMv7 symbols
$ArmV7Dir = Join-Path $FlutterBuildDir "merged_native_libs\release\out\lib\armeabi-v7a"
if (Test-Path $ArmV7Dir) {
    $ArmV7SymbolsDir = Join-Path $SymbolsDir "armeabi-v7a"
    New-Item -ItemType Directory -Path $ArmV7SymbolsDir -Force | Out-Null
    Get-ChildItem -Path $FlutterBuildDir -Filter "*.so" -Recurse | Where-Object { $_.FullName -like "*armeabi-v7a*" } | Copy-Item -Destination $ArmV7SymbolsDir
    Write-Host "✅ Copied ARMv7 symbols" -ForegroundColor Green
    $FoundSymbols = $true
}

# Copy x86_64 symbols
$X64Dir = Join-Path $FlutterBuildDir "merged_native_libs\release\out\lib\x86_64"
if (Test-Path $X64Dir) {
    $X64SymbolsDir = Join-Path $SymbolsDir "x86_64"
    New-Item -ItemType Directory -Path $X64SymbolsDir -Force | Out-Null
    Get-ChildItem -Path $FlutterBuildDir -Filter "*.so" -Recurse | Where-Object { $_.FullName -like "*x86_64*" } | Copy-Item -Destination $X64SymbolsDir
    Write-Host "✅ Copied x86_64 symbols" -ForegroundColor Green
    $FoundSymbols = $true
}

# Copy x86 symbols
$X86Dir = Join-Path $FlutterBuildDir "merged_native_libs\release\out\lib\x86"
if (Test-Path $X86Dir) {
    $X86SymbolsDir = Join-Path $SymbolsDir "x86"
    New-Item -ItemType Directory -Path $X86SymbolsDir -Force | Out-Null
    Get-ChildItem -Path $FlutterBuildDir -Filter "*.so" -Recurse | Where-Object { $_.FullName -like "*x86*" -and $_.FullName -notlike "*x86_64*" } | Copy-Item -Destination $X86SymbolsDir
    Write-Host "✅ Copied x86 symbols" -ForegroundColor Green
    $FoundSymbols = $true
}

# Create symbols zip file
if ($FoundSymbols) {
    $ZipPath = Join-Path $ProjectRoot "native-debug-symbols.zip"
    if (Test-Path $ZipPath) {
        Remove-Item $ZipPath
    }
    
    # Use PowerShell to create zip
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($SymbolsDir, $ZipPath)
    
    Write-Host "📦 Created native-debug-symbols.zip" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 Debug symbols generated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Upload the AAB file to Google Play Console" -ForegroundColor White
    Write-Host "2. In the Play Console, go to the specific release" -ForegroundColor White
    Write-Host "3. Find the 'Native debug symbols' section" -ForegroundColor White
    Write-Host "4. Upload the native-debug-symbols.zip file" -ForegroundColor White
    Write-Host ""
    Write-Host "📁 Symbols file location: $ZipPath" -ForegroundColor Blue
} else {
    Write-Host "⚠️  No native libraries found. This might be normal if your app doesn't use native code." -ForegroundColor Yellow
    Write-Host "   If you're using Flutter plugins with native code, try building first:" -ForegroundColor Yellow
    Write-Host "   flutter build appbundle --release" -ForegroundColor White
}
