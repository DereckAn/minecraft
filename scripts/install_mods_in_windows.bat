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

# Verifitcar si Git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output "Git no encontrado. Instalando..."
    winget install --id Git.Git -e --source winget
} else {
    Write-Output "Git encontrado."
}

# Verifitcar si Java está instalado
if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Output "Java no encontrado. Instalando..."
    winget install Microsoft.OpenJDK.21
} else {
    Write-Output "Java encontrado."
}

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
