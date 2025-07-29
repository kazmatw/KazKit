#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]; then
    echo "[!] Please run as root (sudo ./install.sh)"
    exit 1
fi

SCRIPT_NAME="kazkit"
INSTALL_DIR="/usr/local/bin"

echo "[*] Installing $SCRIPT_NAME to $INSTALL_DIR..."

if [ ! -f "./$SCRIPT_NAME.sh" ]; then
    echo "[!] $SCRIPT_NAME.sh not found in current directory."
    exit 1
fi

cp "./$SCRIPT_NAME.sh" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "[+] Installation complete."
echo "[+] You can now run the tool using: $SCRIPT_NAME <IP>"
