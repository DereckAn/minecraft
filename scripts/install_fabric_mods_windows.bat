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
    $downloadsDir = "$env:USERPROFILE\Downloads"

    # Eliminar carpetas si existen y crear carpeta temporal
    Remove-Item -Path "$downloadsDir\mods" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$downloadsDir\client" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$downloadsDir\resourcepacks" -Recurse -Force -ErrorAction SilentlyContinue
    $tempDir = "$env:USERPROFILE\Downloads\temp"
    New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
    Set-Location -Path $tempDir

    # Descargar mods, client y resourcepacks
    git init
    git remote add origin https://github.com/DereckAn/minecraft.git
    git config core.sparseCheckout true
    echo "mods/*`nclient/*`nresourcepacks/*" | Out-File -FilePath ".git/info/sparse-checkout" -Encoding ASCII
    git pull origin main

    # Mover carpetas a Downloads
    Move-Item -Path "mods" -Destination $downloadsDir
    Move-Item -Path "client" -Destination $downloadsDir
    Move-Item -Path "resourcepacks" -Destination $downloadsDir

    # Limpiar
    Set-Location -Path $env:USERPROFILE
    Remove-Item -Path $tempDir -Recurse -Force
}

function InstalarFabric {
    $minecraftVersion = "1.21.1"
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