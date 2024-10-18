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

# Verificar si Git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output "Git no encontrado. Instalando..."
    winget install --id Git.Git -e --source winget
} else {
    Write-Output "Git encontrado."
    git --version
}

# Verificar si Java está instalado
if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Output "Java no encontrado. Instalando..."
    winget install Microsoft.OpenJDK.21
} else {
    Write-Output "Java encontrado."
    java --version
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

function InstalarFabric {
    $minecraftVersion = "1.21"
    $fabricInstallerPath = "$env:USERPROFILE\Downloads\fabric-installer.jar"
    $minecraftDir = "$env:APPDATA\.minecraft"

    if (-not (Test-Path "$minecraftDir\versions\$minecraftVersion-fabric")) {
        Write-Output "Fabric not found. Installing..."
        Invoke-WebRequest -Uri "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.11.2/fabric-installer-0.11.2.jar" -OutFile $fabricInstallerPath
        java -jar $fabricInstallerPath client -mcversion $minecraftVersion -dir $minecraftDir
        Remove-Item $fabricInstallerPath
    } else {
        Write-Output "Fabric found."
    }
}

DescargarYConfigurarMods
InstalarFabric