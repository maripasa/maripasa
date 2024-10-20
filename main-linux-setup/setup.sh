
# i3 kitty pulseaudio flameshot feh git python3 brightnessctl gnome-pomodoro 

# x spotify x firealpaca x libreoffice x cargo x ohmybash ungoogled_chromium bitwarden lvim

# i3 config, lvim config (hack), i3status config
# mkdir: repositories, projects, downloads, videos, documents, images, audio 

# Light list of programs

ARCH_PROGRAMS=("flameshot" "python3" "gnome-pomodoro" "spotify-launcher" "libreoffice")
DEBIAN_PROGRAMS=("flameshot" "python3" "gnome-pomodoro" "libreoffice")

DEBIAN_LIGHT_PROGRAMS=("i3" "kitty" "feh" "pulseaudio" "git" "brighnessctl")
ARCH_LIGHT_PROGRAMS=("i3" "kitty" "feh" "pulseaudio" "git" "brighnessctl")

install_spotify_debian() {
    echo "Downloading Spotify..."
    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install spotify-client
}

install_firealpaca_linux() {
    echo "Downloading FireAlpaca AppImage..."
    wget -O firealpaca.appimage https://firealpaca.com/download/linux

    echo "Installing FireAlpaca..."
    sudo mv firealpaca.appimage /usr/local/bin/firealpaca
    sudo chmod +x /usr/local/bin/firealpaca
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
    if [ "$light" = "true" ]; then
        echo "Installing light Debian programs..."
        sudo apt install -y ${DEBIAN_LIGHT_PROGRAMS[@]}

    else
        echo "Installing full Debian programs..."
        sudo apt install -y ${DEBIAN_LIGHT_PROGRAMS[@]}
        sudo apt install -y ${DEBIAN_PROGRAMS[@]}
        
        install_spotify_debian 

        install_firealpaca_linux
        install_cargo_linux
        install_ohmybash_linux
    fi
}

# Function to install Arch programs
install_arch() {
    local light=$1
    if [ "$light" = "true" ]; then
        echo "Installing light Arch programs..."
        sudo pacman -S --noconfirm ${ARCH_LIGHT_PROGRAMS[@]}
    else
        echo "Installing full Arch programs..."
        sudo pacman -S --noconfirm ${ARCH_PROGRAMS[@]}

        install_firealpaca_linux
        install_cargo_linux
        install_ohmybash_linux
    fi
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
        install_debian $light_install
        ;;
    arch)
        install_arch $light_install
        ;;
    *)
        error_exit "Invalid OS type '$os_choice'."
        ;;
esac
