# Función para instalar Winget
function InstalarWinget {
    # Verificar si Winget está instalado
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Output "Winget no encontrado. Instalando..."

        # Obtén la URL de descarga más reciente
        $URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
        $URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json | Select-Object -ExpandProperty "assets" | Where-Object "browser_download_url" -Match '.msixbundle' | Select-Object -ExpandProperty "browser_download_url"

        # Descarga el archivo
        Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing

        # Instala el paquete descargado
        Add-AppxPackage -Path "Setup.msix"

        # Elimina el archivo de instalación descargado
        Remove-Item "Setup.msix"
    } else {
        Write-Output "Winget encontrado."
    }
}

# Función para verificar e instalar un programa usando winget
function VerificarEInstalar {
    param (
        [Parameter(Mandatory=$true)] [string] $nombre,
        [Parameter(Mandatory=$true)] [string] $id
    )
    if (Get-Command $nombre -ErrorAction SilentlyContinue) {
        Write-Output "$nombre está instalado."
    } else {
        Write-Output "Instalando $nombre ..."
        winget install --id=$id -e
    }
}

# Instalar Winget si no está presente
InstalarWinget

# Verificar si Git está instalado
VerificarEInstalar -nombre "git" -id "Git.Git"

# Verificar si Java está instalado
VerificarEInstalar -nombre "java" -id "Microsoft.OpenJDK.21"

function DescargarYConfigurarMods {
    $modsDir = "$env:APPDATA\.minecraft\mods"

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

    # Eliminar mods existentes
    Remove-Item -Path "$modsDir\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Mover mods y limpiar
    New-Item -Path $modsDir -ItemType Directory -Force | Out-Null
    Move-Item -Path "mods/*" -Destination $modsDir
    Set-Location -Path $env:USERPROFILE
    Remove-Item -Path $tempDir -Recurse -Force
}

function InstalarForge {
    if (-not (Test-Path "$env:APPDATA\.minecraft\versions\1.20.1-forge-47.3.0")) {
        Write-Output "Forge not found. Installing..."
        $installerPath2 = "$env:USERPROFILE\Downloads\forge-1.20.1-47.3.0-installer.jar"
        Invoke-WebRequest -Uri "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.0/forge-1.20.1-47.3.0-installer.jar" -OutFile $installerPath2
        java -jar forge-1.20.1-47.3.0-installer.jar --installClient
        Start-Process -FilePath $installerPath2
    } else {
        Write-Output "Forge found."
    }
}

DescargarYConfigurarMods
InstalarForge
