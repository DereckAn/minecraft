

# Verificar si winget está instalado
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Output "Winget está instalado."
} else {
   # Descargar el paquete de instalación de winget
    Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -OutFile winget.appxbundle

    # Instalar winget
    Add-AppxPackage .\winget.appxbundle

    https://apps.microsoft.com/detail/9nblggh4nns1?ocid=webpdpshare
}

# Verificar si Git está instalado
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Output "Git está instalado."
} else {
    Write-Output "Instalando Git ..."
    winget install --id=Git.Git -e
}

# Verificar si Java está instalado
if (Get-Command java -ErrorAction SilentlyContinue) {
    Write-Output "Java está instalado."
} else {
    Write-Output "Instalando Java ..."
    winget install Microsoft.OpenJDK.21
}



if (-not (Test-Path "$env:APPDATA\.minecraft\versions\1.20.1-forge-47.2.0")) {
    Write-Output "Forge not found. Installing..."
    $installerPath2 = "$env:USERPROFILE\Downloads\forge-1.20.1-47.2.0-installer.jar"
    Invoke-WebRequest -Uri "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.2.0/forge-1.20.1-47.2.0-installer.jar" -OutFile $installerPath2
    java -jar forge-1.20.1-47.2.0-installer.jar --installClient
    Start-Process -FilePath $installerPath2
} else {
    Write-Output "Forge found."
}
