download_mods() {
    # Check if the current directory is empty
    if [ -z "$(ls -A)" ]; then
        echo "Directory is empty. Proceeding with download."
    else
        echo "Directory is not empty. Deleting all contents."
        rm -rf ./* ./.*
    fi

    # Download mods from the GitHub repository
    git init
    git remote add origin https://github.com/DereckAn/minecraft.git
    git config core.sparseCheckout true
    echo "mods/*" > .git/info/sparse-checkout
    git pull origin main

    # Move contents of mods folder to current directory and clean up
    mv mods/* .
    rm -rf mods .git
}

download_mods