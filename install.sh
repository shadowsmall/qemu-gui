#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# On détecte le dossier où se trouve le script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}=== Installation de QEMU GUI ===${NC}"
echo -e "Dossier source : ${SCRIPT_DIR}"

# 1. Dépendances
echo -e "${GREEN}[1/5] Installation des dépendances...${NC}"
sudo apt update && sudo apt install -y python3-pyqt6 qemu-system-x86 qemu-utils ovmf g++

# 2. Compilation (On pointe vers le chemin absolu du fichier)
echo -e "${GREEN}[2/5] Compilation du moteur...${NC}"
if [ -f "$SCRIPT_DIR/qemu_launcher.cpp" ]; then
    g++ "$SCRIPT_DIR/qemu_launcher.cpp" -o "$SCRIPT_DIR/qemu_launcher"
else
    echo -e "${RED}Erreur : qemu_launcher.cpp est introuvable dans $SCRIPT_DIR${NC}"
    exit 1
fi

# 3. Installation
echo -e "${GREEN}[3/5] Installation des fichiers...${NC}"
sudo cp "$SCRIPT_DIR/qemu_launcher" /usr/local/bin/
sudo cp "$SCRIPT_DIR/quemugui.py" /usr/local/bin/qemugui
sudo chmod +x /usr/local/bin/qemugui

# 4. Menu Desktop
echo -e "${GREEN}[4/5] Création du raccourci...${NC}"
cat <<EOF | sudo tee /usr/share/applications/qemugui.desktop > /dev/null
[Desktop Entry]
Name=QEMU GUI
Exec=/usr/local/bin/qemugui
Icon=system-run
Type=Application
Categories=System;Emulator;
Terminal=false
EOF

echo -e "${GREEN}[5/5] Terminé ! Tape 'qemugui' pour lancer.${NC}"
