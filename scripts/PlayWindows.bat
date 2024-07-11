

# Verificar si winget está instalado
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Output "Winget está instalado."
} else {
    Write-Output "Winget no está instalado. Procediendo con la instalación."

    # Descargar el paquete de instalación de winget
    try {
        Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle" -OutFile "winget.appxbundle"
        Write-Output "Descarga completada."
    } catch {
        Write-Error "Error al descargar el paquete de instalación de winget."
        exit
    }

    # Instalar winget
    try {
        Add-AppxPackage .\winget.appxbundle
        Write-Output "Instalación completada."
    } catch {
        Write-Error "Error al instalar winget."
    }
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

function DescargarYConfigurarMods {
    $modsDir = $null
    if ($env:OS -like "Windows_NT*") {
        $modsDir = "$env:APPDATA\.minecraft\mods"
    } elseif ($env:OS -like "Darwin*") {
        $modsDir = "$HOME/Library/Application Support/minecraft/mods"
    } elseif ($env:OS -like "Linux*") {
        $modsDir = "$HOME/.minecraft/mods"
    }

    # Eliminar carpeta mods si existe y crear carpeta temporal
    Remove-Item -Path "$env:USERPROFILE\Downloads\mods" -Recurse -Force -ErrorAction SilentlyContinue
    $tempDir = "$env:USERPROFILE\Downloads\temp"
    New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
    Set-Location -Path $tempDir

    # Descargar mods
    git init
    git remote add origin https://github.com/DereckAn/minecraft.git
    git config core.sparseCheckout true
    git sparse-checkout set mods
    git pull origin main

    # Mover mods y limpiar
    New-Item -Path $modsDir -ItemType Directory -Force | Out-Null
    Move-Item -Path "mods/*" -Destination $modsDir
    Set-Location -Path $env:USERPROFILE
    Remove-Item -Path $tempDir -Recurse -Force
}


if (-not (Test-Path "$env:APPDATA\.minecraft\versions\1.20.1-forge-47.3.0")) {
    Write-Output "Forge not found. Installing..."
    $installerPath2 = "$env:USERPROFILE\Downloads\forge-1.20.1-47.3.0-installer.jar"
    Invoke-WebRequest -Uri "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.0/forge-1.20.1-47.3.0-installer.jar" -OutFile $installerPath2
    java -jar forge-1.20.1-47.3.0-installer.jar --installClient
    Start-Process -FilePath $installerPath2
} else {
    Write-Output "Forge found."
}


DescargarYConfigurarMods