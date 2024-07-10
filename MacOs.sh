# Verificar si Homebrew esta instalado
if ! which brew >/dev/null; then
        echo "Homebrew not found. Installing..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew found."
fi

# Verificar si SVN está instalado
if ! command -v git &> /dev/null; then
    echo "Git no está instalado. Instalándolo..."
    brew install git
else
    echo "Git found."
fi


# Verificar si Java está instalado
if type -p java > /dev/null; then
    echo "Java found."
else
    echo "Java no está instalado. Instalando la última versión de Java..."
    # Verificar si Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        echo "Homebrew no está instalado. Instalándolo..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    # Instalar Java usando Homebrew
    brew install openjdk
    echo 'export PATH="/usr/local/opt/openjdk/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    echo "Java ha sido instalado."
fi

# Cambiar al directorio de descargas
cd ~/Downloads

git init 
git remote add origin https://github.com/DereckAn/minecraft.git
git config core.sparseCheckout true
git sparse-checkout set mods
git pull origin main 






set forgePath to (path to home folder as text) & "Downloads:forge-1.20.1-47.2.0-installer.jar"
if not (exists folder (path to home folder as text) & ".minecraft:versions:1.20.1-forge-47.2.0") then
    display dialog "Forge not found. Installing..." buttons {"OK"} default button 1
    do shell script "curl -o " & quoted form of POSIX path of forgePath & "https://github.com/DereckAn/minecraft/blob/main/forge_version/forge-1.20.1-47.2.0-installer.jar"
    do shell script "java -jar " & quoted form of POSIX path of forgePath & " --installClient"
    do shell script "java -jar " & quoted form of POSIX path of forgePath
else
    display dialog "Forge found." buttons {"OK"} default button 1
end if