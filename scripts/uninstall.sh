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
        # Try system-wide first, then user-local
        if [ -w "/usr/local/bin/rel" ]; then
            INSTALL_DIR="/usr/local/bin"
        else
            INSTALL_DIR="$HOME/.local/bin"
        fi
        ;;
    "msys" | "mingw" | "cygwin")
        # Windows (Git Bash, WSL, Cygwin)
        if [ -n "$APPDATA" ] && [ -f "$APPDATA/../Local/Programs/rel/bin/rel" ]; then
            INSTALL_DIR="$APPDATA/../Local/Programs/rel/bin"
        else
            INSTALL_DIR="/usr/local/bin"
        fi
        ;;
    *)
        INSTALL_DIR="/usr/local/bin"
        ;;
esac

INSTALL_PATH="$INSTALL_DIR/rel"
BINARY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/rel"

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
    printf "\n${RED}Uninstallation interrupted.${NC}\n"
    exit 1
}

uninstall_rel() {
    printf "\n${BLUE}Starting REL CLI uninstallation...${NC}\n"
    printf "  - OS: $OS\n"
    printf "  - Installation path: $INSTALL_PATH\n"

    # Check if installed
    if [ ! -f "$INSTALL_PATH" ]; then
        printf "${YELLOW}ℹ️  REL CLI is not installed at $INSTALL_PATH.${NC}\n"
        
        # Try alternative locations if not found
        if [ "$OS" = "linux" ] && [ "$INSTALL_DIR" = "$HOME/.local/bin" ] && [ -f "/usr/local/bin/rel" ]; then
            printf "${YELLOW}ℹ️  Found system-wide installation. Trying to uninstall...${NC}\n"
            INSTALL_PATH="/usr/local/bin/rel"
        elif [ "$OS" = "msys" ] || [ "$OS" = "mingw" ] || [ "$OS" = "cygwin" ]; then
            if [ -f "/usr/local/bin/rel" ]; then
                INSTALL_PATH="/usr/local/bin/rel"
            fi
        else
            printf "${GREEN}✅ REL CLI is not installed on this system.${NC}\n"
            exit 0
        fi
    fi

    # Remove the binary
    printf "${YELLOW}Removing REL CLI from $INSTALL_PATH...${NC}\n"
    
    if [ -w "$(dirname "$INSTALL_PATH")" ]; then
        rm -f "$INSTALL_PATH"
    else
        sudo rm -f "$INSTALL_PATH"
    fi

    # Check if uninstallation was successful
    if [ ! -f "$INSTALL_PATH" ]; then
        printf "✅ ${GREEN}REL CLI has been successfully uninstalled.${NC}\n"
        
        # Remove empty parent directories if possible
        local parent_dir="$(dirname "$INSTALL_PATH")"
        if [ -d "$parent_dir" ] && [ -z "$(ls -A "$parent_dir" 2>/dev/null)" ]; then
            rmdir "$parent_dir" 2>/dev/null || sudo rmdir "$parent_dir" 2>/dev/null || true
        fi
    else
        printf "${RED}❌ Error: Failed to uninstall REL CLI.${NC}\n"
        printf "   You may need to run this script with administrator privileges.\n"
        exit 1
    fi
}

trap cleanup INT

print_banner
uninstall_rel