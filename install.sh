#!/bin/bash

# Couleurs pour le terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Détection automatique du dossier actuel (là où se trouve le script)
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}=== QEMU GUI - Installation ===${NC}"

# 1. Installation des dépendances selon la distribution
echo -e "${GREEN}[1/5] Vérification des dépendances...${NC}"
if [ -f /etc/debian_version ]; then
    sudo apt update && sudo apt install -y python3-pyqt6 qemu-system-x86 qemu-utils ovmf g++
elif [ -f /etc/arch-release ]; then
    sudo pacman -Sy --needed python-pyqt6 qemu-full edk2-ovmf gcc
elif [ -f /etc/fedora-release ]; then
    sudo dnf install -y python3-pyqt6 qemu-kvm qemu-img edk2-ovmf gcc-c++
fi

# 2. Compilation du moteur C++
echo -e "${GREEN}[2/5] Compilation du moteur...${NC}"
if [ -f "$BASE_DIR/qemu_launcher.cpp" ]; then
    g++ "$BASE_DIR/qemu_launcher.cpp" -o "$BASE_DIR/qemu_launcher"
else
    echo -e "${RED}Erreur : qemu_launcher.cpp introuvable dans $BASE_DIR${NC}"
    exit 1
fi

# 3. Installation des fichiers dans /usr/local/bin
echo -e "${GREEN}[3/5] Installation des exécutables...${NC}"
sudo cp "$BASE_DIR/qemu_launcher" /usr/local/bin/
sudo cp "$BASE_DIR/quemugui.py" /usr/local/bin/qemugui
sudo chmod +x /usr/local/bin/qemugui

# 4. Création du raccourci bureau universel
echo -e "${GREEN}[4/5] Création du raccourci système...${NC}"
cat <<EOF | sudo tee /usr/share/applications/qemugui.desktop > /dev/null
[Desktop Entry]
Name=QEMU GUI
Comment=Lanceur de machines virtuelles léger
Exec=/usr/local/bin/qemugui
Icon=system-run
Type=Application
Categories=System;Emulator;
Terminal=false
EOF

# 5. Message de succès
echo -e "${GREEN}[5/5] Installation terminée !${NC}"
echo -e "Vous pouvez maintenant lancer '${BLUE}qemugui${NC}' depuis votre menu ou le terminal."
