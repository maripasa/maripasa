ARCH_PROGRAMS=("flameshot" "python3" "spotify-launcher" "libreoffice" "npm" "nodejs")
DEBIAN_PROGRAMS=("flameshot" "python3" "libreoffice" "npm" "nodejs")

DEBIAN_LIGHT_PROGRAMS=("i3" "kitty" "feh" "pulseaudio" "git" "brightnessctl")
ARCH_LIGHT_PROGRAMS=("i3" "kitty" "feh" "pulseaudio" "git" "brightnessctl" "nvim")

copy_fonts(){
    unzip hack.zip
    sudo cp hack /usr/local/share/fonts/
}

copy_config(){
    chmod +x key.sh
    sudo cp key.sh /usr/local/bin/
    cp config.lua ~/.config/lvim/
    cp config ~/.config/i3/
    sudo cp i3status.conf /etc/
    if [ -d ~/Imagens/Wallpaper ]; then
        cp wallpaper.png ~/Imagens/Wallpaper/
    elif [ -d ~/Images/Wallpaper ]; then
        cp wallpaper.png ~/Images/Wallpaper/
    else
        echo "Nenhum dos diretórios de destino existe."
    fi

}

install_lvim_linux(){
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
}

install_nvim_debian() {
    sudo apt remove neovim -y
    sudo apt install ninja-build gettext cmake unzip curl -y
    git clone https://github.com/neovim/neovim
    cd neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build
    cpack -G DEB
    sudo dpkg -i --force-overwrite  nvim-linux64.deb
}

install_ungoogled_chrome_debian(){
    # Install initial packages
    sudo apt install -y devscripts equivs

    # Clone repository and switch to it (optional if are already in it)
    git clone https://github.com/ungoogled-software/ungoogled-chromium-debian.git
    cd ungoogled-chromium-debian

    # Initiate the submodules (optional if they are already initiated)
    git submodule update --init --recursive

    # Prepare the local source
    debian/rules setup

    # Install missing packages
    sudo mk-build-deps -i debian/control
    rm ungoogled-chromium-build-deps_*

    # Build the package
    dpkg-buildpackage -b -uc
}

install_ungoogled_chrome_arch(){
    # Install required dependencies. Make sure your user has access to sudo
    sudo pacman -S base-devel

    # Clone this repository
    git clone https://github.com/ungoogled-software/ungoogled-chromium-archlinux

    # Navigate into the repository
    cd ungoogled-chromium-archlinux

    # Check out the latest tag
    git checkout $(git describe --abbrev=0 --tags)

    # Start the build, this will download all necessary dependencies automatically
    makepkg -s
}
install_spotify_debian() {
    echo "Downloading Spotify..."
    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install spotify-client -y
}

install_firealpaca_linux() {
    echo "Downloading FireAlpaca AppImage..."
    wget -O firealpaca.appimage https://firealpaca.com/download/linux

    echo "Installing FireAlpaca..."
    sudo mv firealpaca.appimage /usr/local/bin/firealpaca
    sudo chmod +x /usr/local/bin/firealpaca
}

install_bitwarden_linux() {
    # Change to the directory where you want to download the AppImage
    cd ~/Downloads
    # Download the Bitwarden AppImage
    wget https://vault.bitwarden.com/download/?app=desktop&platform=linux -O Bitwarden.AppImage
    # Rename the AppImage to just 'bitwarden'
    mv Bitwarden.AppImage bitwarden
    # Move the renamed AppImage to /usr/local/bin
    sudo mv bitwarden /usr/local/bin/
    # Make it executable
    sudo chmod +x /usr/local/bin/bitwarden
}

install_cargo_linux() {
    echo "Downloading Cargo..."
    curl https://sh.rustup.rs -sSf | sh
}

install_ohmybash_linux() {
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
}

# Function to install Debian programs
install_debian() {
    local light=$1
    local firealpaca=$2
    local ungoogled=$3

    if [ "$light" = "true" ]; then
        echo "Installing light Debian programs..."
        sudo apt install -y ${DEBIAN_LIGHT_PROGRAMS[@]}

    else
        echo "Installing full Debian programs..."
        sudo apt install -y ${DEBIAN_LIGHT_PROGRAMS[@]}
        sudo apt install -y ${DEBIAN_PROGRAMS[@]}
        
        install_cargo_linux
        if [ "$firealpaca" = "true" ]; then
            install_firealpaca_linux
        fi
        if [ "$ungoogled" = "true" ]; then
            install_ungoogled_chrome_debian
        fi
        install_spotify_debian 
        install_nvim_debian
        install_lvim_linux
        install_bitwarden_linux

    fi
    mkdir ~/Projects ~/Repositories
    copy_fonts
    copy_config
    install_ohmybash_linux
}

# Function to install Arch programs
install_arch() {
    local light=$1
    local firealpaca=$2
    local ungoogled=$3

    if [ "$light" = "true" ]; then
        echo "Installing light Arch programs..."
        sudo pacman -S --noconfirm ${ARCH_LIGHT_PROGRAMS[@]}
    else
        echo "Installing full Arch programs..."
        sudo pacman -S --noconfirm ${ARCH_PROGRAMS[@]}

        if [ "$firealpaca" = "true" ]; then
            install_firealpaca_linux
        fi
        if [ "$ungoogled" = "true" ]; then
            install_ungoogled_chrome_arch
        fi
        install_cargo_linux
        install_lvim_linux
        install_bitwarden_linux
    fi
    mkdir ~/Repositories ~/Projetos ~/Downloads ~/Videos ~/Documentos ~/Imagens/Wallpaper ~/Audio 
    copy_fonts
    copy_config
    install_ohmybash_linux
}

# Function to show help
usage() {
    echo "Usage: $0 [OPTIONS] [OS_TYPE]"
    echo "Options:"
    echo "  --help              Show this help message"
    echo "  --light             Install only light versions of programs"
    echo
    echo "OS Types:"
    echo "  debian              Install programs for Debian-based systems"
    echo "  arch                Install programs for Arch-based systems"
    echo
    echo "Examples:"
    echo "  $0                 Install all programs on detected OS"
    echo "  $0 arch            Install Arch programs"
    echo "  $0 --light debian   Install light Debian programs"
    echo "  $0 --firealpaca     Install firealpaca"
    echo "  $0 --ungoogled-chrome   Install Ungoogled-chrome"
    exit 1
}

# Function to detect OS
detect_os() {
    if [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    else
        echo "unsupported"
    fi
}

# Error function for invalid options
error_exit() {
    echo "Error: $1"
    usage
}

# Check if --help was passed
if [[ "$1" == "--help" ]]; then
    usage
fi

# Parse options
light_install=false
ungoogled_chrome=false
firealpaca=false

os_choice=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --light)
            light_install=true
            shift
            ;;
        debian|arch)
            os_choice=$1
            shift
            ;;
        --ungoogled-chrome)
            ungoogled_chrome=true
            shift
            ;;
        --firealpaca)
            firealpaca=true
            shift
            ;;
        *)
            error_exit "Invalid argument '$1'."
            ;;
    esac
done

# If no OS specified, auto-detect
if [ -z "$os_choice" ]; then
    os_choice=$(detect_os)
fi

# Check if OS is supported
if [[ "$os_choice" == "unsupported" ]]; then
    echo "Error: Unsupported OS detected: $(uname -s)"
    exit 1
fi

# Execute appropriate installation function
case "$os_choice" in
    debian)
        install_debian $light_install $firealpaca $ungoogled_chrome
        ;;
    arch)
        install_arch $light_install $firealpaca $ungoogled_chrome
        ;;
    *)
        error_exit "Invalid OS type '$os_choice'."
        ;;
esac
