#!/bin/sh

echo "What is your OS? (Enter 1 for macOS, 2 for Linux, or 3 for Windows)"
read os

while [ "$os" != "1" ] && [ "$os" != "2" ] && [ "$os" != "3" ]; do
    echo "Invalid input. Please enter 1 for macOS, 2 for Linux, or 3 for Windows."
    read os
done

# NOTE: Dejar este if para que corrobore si tiene git installado. 
if [ $os = "1" ]; then 
    echo "You have selected macOS"
    if ! which brew >/dev/null; then # check if Homebrew is already installed
        echo "Homebrew not found. Installing..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew found."
    fi
    if ! which git >/dev/null; then
        echo "Git not found. Installing..."
        brew install git
    else
        echo "Git found."
    fi


    if [ -d "$HOME/.java" ]; then # note: Check if Java JDK Development Kit 21.0.1 is already installed
        echo "Java already installed"
    else
        echo "Installing Java - JDK Development Kit 21.0.1"
        sh -c "$(curl -fsSL https://download.oracle.com/java/21/latest/jdk-21_macos-x64_bin.tar.gz)" &
        wait

        if [ $? -eq 0 ]; then # note: check if last command was successful
            echo "Successfully JDK Development Kit 21.0.1"
        else
            echo "Error installing JDK Development Kit 21.0.1"
        fi
    fi


    if [ -d "$HOME/.minecraft/versions/forge" ]; then # note: Check if Minecraft Forge is already installed
        echo "Forge Minecraft ya está instalado"
    else
        echo "Descargando e instalando Forge Minecraft 1.20.1-47-1-0"
        sh -c "$(curl -fsSL https://github.com/DereckAn/minecraft/blob/main/forge-1.20.1-47.1.0-installer.jar)" &
        wait

        if [ $? -eq 0 ]; then # note: check if last command was successful
            echo "Minecraft Forge instalado con éxito"
        else
            echo "Error al instalar Forge"
        fi
fi


    # ! I think I do not need java SE Development Kit 11.0.21
    # if [ -d "$HOME/.java" ]; then # note: Check if Java Java SE Development Kit 11.0.21 is already installed 
    #     echo "Java already installed"
    # else
    #     echo "Installing Java - Java SE Development Kit 11.0.21"
    #     sh -c "$(curl -fsSL https://www.oracle.com/java/technologies/downloads/#license-lightbox)" &
    #     wait

    #     if [ $? -eq 0 ]; then # note: check if last command was successful
    #         echo "Successfully Java SE Development Kit 11.0.21"
    #     else
    #         echo "Error installing Java SE Development Kit 11.0.21"
    #     fi
    # fi


    if [ $? -eq 0 ]; then # check if last command was successful
        echo "Installing Minecraft mods"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        sed -i '' 's#robbyrussell#powerlevel10k/powerlevel10k#g' ~/.zshrc
        echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc
        echo "Installing plugins"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        sed -i '' 's/plugins=(git)/plugins=(git jump zsh-autosuggestions sublime zsh-history-substring-search jsontools zsh-syntax-highlighting zsh-interactive-cd)/g' ~/.zshrc
        echo "Please restart your terminal for changes to take effect"
        # code for macOS
    else
        echo "Error installing Oh My Zsh"
        exit 1
    fi

    echo "Installing raycast"
    brew install raycast

elif [ $os = "2" ]; then

    # code for Ubuntu
    echo "Checking for git..."
    if ! [ -x "$(command -v git)" ]; then
        echo "Error: git is not installed. Please install git and run the script again."
        echo "Installing git..."
        sudo apt-get install git
        exit 1
    fi
    echo "Installing ZSH"
    sudo apt-get install zsh
    echo "Setting ZSH as default shell"
    chsh -s $(which zsh)
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh already installed"
    else
        echo "Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
        wait
        if [ $? -eq 0 ]; then
            echo "Successfully installed Oh My Zsh"
        else
            echo "Error installing Oh My Zsh"
        fi
    fi
    if [ $? -eq 0 ]; then
        echo "Installing Powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        sed -i -e 's#robbyrussell#powerlevel10k/powerlevel10k#g' ~/.zshrc
        echo "Installing plugins"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        sed -i -e 's/plugins=(git)/plugins=(git jump zsh-autosuggestions sublime zsh-history-substring-search jsontools zsh-syntax-highlighting zsh-interactive-cd)/g' ~/.zshrc
        echo "Please restart your terminal for changes to take effect"
    fi

elif [ $os = "3" ]; then

    # code for Fedora
    echo "Checking for git..."
    if ! [ -x "$(command -v git)" ]; then
        echo "Error: git is not installed. Please install git and run the script again."
        echo "Installing git..."
        sudo dnf install git
        exit 1
    fi
    echo "Installing ZSH"
    sudo dnf install zsh
    echo "Setting ZSH as default shell"
    chsh -s $(which zsh)
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh already installed"
    else
        echo "Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
        wait
        if [ $? -eq 0 ]; then
            echo "Successfully installed Oh My Zsh"
        else
            echo "Error installing Oh My Zsh"
        fi
    fi
    if [ $? -eq 0 ]; then
        echo "Installing Powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        sed -i -e 's#robbyrussell#powerlevel10k/powerlevel10k#g' ~/.zshrc
        echo "Installing plugins"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        sed -i -e 's/plugins=(git)/plugins=(git jump zsh-autosuggestions sublime zsh-history-substring-search jsontools zsh-syntax-highlighting zsh-interactive-cd)/g' ~/.zshrc
        echo "Please restart your terminal for changes to take effect"
    fi

else
    echo "Error installing Oh My Zsh"
fi