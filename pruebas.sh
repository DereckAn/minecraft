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

mkdir mods
cd mods

git init 
git remote add origin https://github.com/DereckAn/minecraft.git
git config core.sparseCheckout true
git sparse-checkout set mods
git pull origin main 