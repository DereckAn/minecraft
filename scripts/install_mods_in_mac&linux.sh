# Funciones reutilizables para verificar e instalar dependencias
verificar_e_instalar_homebrew() {
    if ! which brew >/dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew found."
    fi
}

verificar_e_instalar_git() {
    if ! command -v git &> /dev/null; then
        echo "Git no está instalado. Instalándolo..."
        brew install git
    else
        echo "Git found."
    fi
}

verificar_e_instalar_java() {
    if ! type -p java > /dev/null; then
        echo "Java no está instalado. Instalando la última versión de Java..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # Instalación para macOS
            # Descargar el archivo DMG de Java
            curl -L -O https://download.oracle.com/java/22/latest/jdk-22_macos-aarch64_bin.dmg
            # Montar el archivo DMG
            hdiutil attach jdk-22_macos-aarch64_bin.dmg
            # Instalar Java
            sudo installer -pkg /Volumes/JDK\ 22/*.pkg -target /
            # Desmontar el archivo DMG
            hdiutil detach /Volumes/JDK\ 22
            # Eliminar el archivo DMG
            rm jdk-22_macos-aarch64_bin.dmg
            # Establecer JAVA_HOME en ~/.zshrc
            echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 22)' >> ~/.zshrc
            source ~/.zshrc
            echo "Java ha sido instalado."
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Instalación para Linux
            sudo apt update
            sudo apt install openjdk-22-jdk -y
        fi
    else
        echo "Java found."
    fi
}

# Función para descargar y configurar mods
descargar_y_configurar_mods() {
    local mods_dir
    if [[ "$OSTYPE" == "darwin"* ]]; then
        mods_dir="$HOME/Library/Application Support/minecraft/mods"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        mods_dir="$HOME/.minecraft/mods"
    fi

    # Eliminar carpeta mods si existe y crear carpeta temporal
    rm -rf $HOME/Downloads/mods
    mkdir -p $HOME/Downloads/temp && cd $_

    # Descargar mods
    git init
    git remote add origin https://github.com/DereckAn/minecraft.git
    git config core.sparseCheckout true
    git sparse-checkout set mods
    git pull origin main

    # Mover mods y limpiar
    mkdir -p "$mods_dir"
    mv mods/* "$mods_dir"
    cd .. && rm -rf temp
}

# Función para instalar Minecraft Forge
instalar_minecraft_forge() {
    local forge_version="1.20.1-47.3.0"
    local forge_dir
    if [[ "$OSTYPE" == "darwin"* ]]; then
        forge_dir="$HOME/Library/Application Support/minecraft/versions/${forge_version}"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        forge_dir="$HOME/.minecraft/versions/${forge_version}"
    fi

    if [ ! -d "$forge_dir" ]; then
        echo "Minecraft Forge $forge_version no está instalado. Procediendo con la instalación..."
        cd ~/Downloads
        curl -O "https://maven.minecraftforge.net/net/minecraftforge/forge/${forge_version}/forge-${forge_version}-installer.jar"
        java -jar "forge-${forge_version}-installer.jar"
    else
        echo "Minecraft Forge ${forge_version} ya está instalado."
    fi
    
}

# Ejecutar funciones
verificar_e_instalar_homebrew
verificar_e_instalar_git
verificar_e_instalar_java
descargar_y_configurar_mods
instalar_minecraft_forge