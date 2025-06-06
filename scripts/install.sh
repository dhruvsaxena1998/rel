#!/usr/bin/env bash

set -eu

# Set text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS and architecture
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | tr '[:upper:]' '[:lower:]')"

# Set default installation paths
case "$OS" in
    "darwin")
        INSTALL_DIR="/usr/local/bin"
        ;;
    "linux")
        INSTALL_DIR="/usr/local/bin"
        # Check if running as root for system-wide installation
        if [ "$(id -u)" -ne 0 ]; then
            INSTALL_DIR="$HOME/.local/bin"
            mkdir -p "$INSTALL_DIR"
        fi
        ;;
    "msys" | "mingw" | "cygwin")
        # Windows (Git Bash, WSL, Cygwin)
        if [ -n "$APPDATA" ]; then
            INSTALL_DIR="$APPDATA/../Local/Programs/rel/bin"
            mkdir -p "$INSTALL_DIR"
        else
            INSTALL_DIR="/usr/local/bin"
        fi
        ;;
    *)
        echo -e "${RED}❌ Unsupported operating system: $OS${NC}"
        exit 1
        ;;
esac

INSTALL_PATH="$INSTALL_DIR/rel"
BINARY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/rel"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_banner() {
    echo -e "${GREEN}"
    echo -e "██████╗ ███████╗██╗     "
    echo -e "██╔══██╗██╔════╝██║     "
    echo -e "██████╔╝█████╗  ██║     "
    echo -e "██╔══██╗██╔══╝  ██║     "
    echo -e "██║  ██║███████╗███████╗"
    echo -e "╚═╝  ╚═╝╚══════╝╚══════╝"
    echo -e ""
    echo -e "Rule Expression Language"
    echo -e "${NC}"
}

cleanup() {
    printf "\n${RED}Installation interrupted.${NC}\n"
    rm -f "$INSTALL_PATH" 2>/dev/null || true
    exit 1
}

check_binary() {
    if [ ! -f "$BINARY_PATH" ]; then
        printf "${RED}❌ Error: Expected binary not found at $BINARY_PATH.${NC}\n"
        exit 1
    fi
}

setup_path() {
    local shell_rc=""
    case "$SHELL" in
        */zsh)
            shell_rc="$HOME/.zshrc"
            ;;
        */bash)
            shell_rc="$HOME/.bashrc"
            ;;
        */fish)
            shell_rc="$HOME/.config/fish/config.fish"
            ;;
        *)
            shell_rc="$HOME/.profile"
            ;;
    esac

    if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
        printf "\n${YELLOW}⚠️ Note: $INSTALL_DIR is not in your PATH.${NC}\n"
        printf "   Add the following line to your shell profile ($shell_rc):\n"
        printf "   ${GREEN}export PATH=\"$INSTALL_DIR:\$PATH\"${NC}\n"
        printf "   Then run: ${GREEN}source $shell_rc${NC} (or restart your terminal)\n"
    fi
}

install_binary() {
    # Make the binary executable
    chmod +x "$BINARY_PATH"
    
    # Create installation directory if it doesn't exist
    sudo mkdir -p "$(dirname "$INSTALL_PATH")" 2>/dev/null || true
    
    # Copy the binary to the installation directory
    if [ -w "$(dirname "$INSTALL_PATH")" ]; then
        cp "$BINARY_PATH" "$INSTALL_PATH"
    else
        sudo cp "$BINARY_PATH" "$INSTALL_PATH"
        sudo chmod +x "$INSTALL_PATH"
    fi
    
    # On macOS, remove Gatekeeper quarantine flag if it exists
    if [ "$OS" = "darwin" ] && [ -f "$INSTALL_PATH" ]; then
        printf "🔓 ${YELLOW}Checking macOS quarantine status...${NC}\n"
        sudo xattr -d com.apple.quarantine "$INSTALL_PATH" 2>/dev/null || true
    fi
    
    # Verify installation
    if command -v rel >/dev/null 2>&1; then
        printf "\n✅ ${GREEN}REL CLI has been successfully installed to $INSTALL_PATH${NC}\n"
    else
        printf "\n${YELLOW}⚠️  REL CLI was installed but may not be in your PATH.${NC}\n"
        setup_path
    fi
}

# Main installation function
install_rel() {
    printf "\n${BLUE}🚀 Starting REL CLI installation...${NC}\n"
    printf "  - OS: $OS\n"
    printf "  - Architecture: $ARCH\n"
    printf "  - Installing to: $INSTALL_PATH\n"
    
    check_binary
    install_binary
    setup_path
    
    printf "\n${GREEN}✨ Installation complete! Run 'rel --help' to get started.${NC}\n"
}

trap cleanup INT

print_banner
install_rel