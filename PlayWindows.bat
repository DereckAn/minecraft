
if (-not (java -version 2>&1 | Select-String "21.0.1")) {
    Write-Output "Java not found. Installing..."
    $installerPath = "$env:USERPROFILE\Downloads\jdk-21_windows-x64_bin.exe"
    Invoke-WebRequest -Uri "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe" -OutFile $installerPath
    Start-Process -FilePath $installerPath
} else {
    Write-Output "Java found."
}

if (-not (Test-Path "$env:APPDATA\.minecraft\versions\1.20.1-forge-47.1.0")) {
    Write-Output "Forge not found. Installing..."
    $installerPath2 = "$env:USERPROFILE\Downloads\forge-1.20.1-47.1.0-installer.jar"
    Invoke-WebRequest -Uri "https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.20.1-47.1.0/forge-1.20.1-47.1.0-installer.jar" -OutFile $installerPath2
    java -jar forge-1.20.1-47.1.0-installer.jar --installClient
    Start-Process -FilePath $installerPath2
} else {
    Write-Output "Forge found."
}

$links = @(
)

$destination = "$env:APPDATA\.minecraft\mods"

if (-not (Test-Path $destination)) {
    New-Item -ItemType Directory -Path $destination
}

# Descarga mods
foreach ($link in $links) {
    $filename = Split-Path -Leaf $link
    $filepath = Join-Path -Path $destination -ChildPath $filename
    if (-not (Test-Path $filepath)) {
        Invoke-WebRequest -Uri $link -OutFile $filepath
    }
}