# Verificar si Homebrew esta instalado
if ! which brew >/dev/null; then
        echo "Homebrew not found. Installing..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew found."
fi

# Verificar si Git está instalado
if ! command -v git &> /dev/null; then
    echo "Git no está instalado. Instalándolo..."
    brew install git
else
    echo "Git found."
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    # Verificar si Java está instalado
    if type -p java > /dev/null; then
        echo "Java found."
    else
        echo "Java no está instalado. Instalando la última versión de Java..."
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
    fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    # Verificar si Java está instalado
    if type -p java > /dev/null; then
        echo "Java found."
    else
        echo "Java no está instalado. Instalando la última versión de Java..."
        # Actualizar la lista de paquetes
        sudo apt update
        # Instalar Java
        sudo apt install openjdk-22-jdk
        echo "Java ha sido instalado."
    fi
else
    echo "Sistema operativo no soportado."
    exit 1
fi

# Cambiar al directorio de descargas
cd ~/Downloads

# Verificar si existe la carpeta "mods" y eliminarla
if [ -d "mods" ]; then
    rm -rf mods
fi

# Crear una carpeta temporal
mkdir temp
cd temp

# Descargando unicamente la carpeta mods del repositorio 
git init 
git remote add origin https://github.com/DereckAn/minecraft.git
git config core.sparseCheckout true
git sparse-checkout  set mods
git pull origin main 

# Mover la carpeta "mods" a Downloads
mv mods ../

# Regresar a la carpeta Downloads y eliminar la carpeta temporal
cd ..
rm -rf temp

# Verificar si existe la carpeta "$HOME/Library/Application Support/minecraft/mods"
# Si no existe, crearla
mkdir -p "$HOME/Library/Application Support/minecraft/mods"

# Mover el contenido de la carpeta "~/Downloads/mods" a "$HOME/Library/Application Support/minecraft/mods"
mv mods/* "$HOME/Library/Application Support/minecraft/mods/"

# Definir la ruta y versión de Forge
FORGE_VERSION="1.20.1-47.3.0"
FORGE_INSTALLER="forge-${FORGE_VERSION}-installer.jar"

# Determinar el sistema operativo y establecer la ruta de Minecraft Forge
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    MINECRAFT_FORGE_DIR="$HOME/Library/Application Support/minecraft/versions/${FORGE_VERSION}"
    # MINECRAFT_DIR="$HOME/Library/Application Support/minecraft"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    MINECRAFT_FORGE_DIR="$HOME/.minecraft/versions/${FORGE_VERSION}"
    # MINECRAFT_DIR="$HOME/.minecraft"
else
    echo "Sistema operativo no soportado."
    exit 1
fi

# Verificar si la versión específica de Forge ya está instalada
if [ -d "${MINECRAFT_FORGE_DIR}" ]; then
    echo "Minecraft Forge ${FORGE_VERSION} ya está instalado."
else
    echo "Minecraft Forge ${FORGE_VERSION} no está instalado. Procediendo con la instalación..."

    cd
    cd ~/Downloads

    mkdir -p minecraftForge
    cd minecraftForge

    # Descargar el archivo forge installer si no existe
    if [ ! -f "${FORGE_INSTALLER}" ]; then
        echo "Descargando Minecraft Forge ${FORGE_VERSION}..."
        curl -O "https://maven.minecraftforge.net/net/minecraftforge/forge/${FORGE_VERSION}/${FORGE_INSTALLER}"
    else
        echo "El instalador de Minecraft Forge ${FORGE_VERSION} ya está descargado."
    fi

    # Ejecutar el instalador de Forge como cliente
    echo "Instalando Minecraft Forge ${FORGE_VERSION}..."
    java -jar "${FORGE_INSTALLER}" --installClient
fi