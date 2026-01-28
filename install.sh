#!/bin/bash

# Couleurs pour le terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # Pas de couleur

echo -e "${BLUE}=== Installation de QEMU GUI ===${NC}"

# 1. Détection du gestionnaire de paquets et installation des dépendances
echo -e "${GREEN}[1/5] Installation des dépendances...${NC}"
if [ -f /etc/debian_version ]; then
    sudo apt update && sudo apt install -y python3-pyqt6 qemu-system-x86 qemu-utils ovmf g++
elif [ -f /etc/arch-release ]; then
    sudo pacman -Sy --needed python-pyqt6 qemu-full edk2-ovmf gcc
elif [ -f /etc/fedora-release ]; then
    sudo dnf install -y python3-pyqt6 qemu-kvm qemu-img edk2-ovmf gcc-c++
else
    echo -e "${RED}Distribution non reconnue. Veuillez installer manuellement : qemu, pyqt6, g++, ovmf.${NC}"
fi

# 2. Compilation du moteur C++
echo -e "${GREEN}[2/5] Compilation du moteur haute performance...${NC}"
g++ qemu_launcher.cpp -o qemu_launcher
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur de compilation !${NC}"
    exit 1
fi

# 3. Installation des binaires
echo -e "${GREEN}[3/5] Installation des fichiers système...${NC}"
sudo cp qemu_launcher /usr/local/bin/
sudo cp quemugui.py /usr/local/bin/qemugui
sudo chmod +x /usr/local/bin/qemugui

# 4. Création du raccourci menu (.desktop)
echo -e "${GREEN}[4/5] Création du raccourci menu...${NC}"
cat <<EOF | sudo tee /usr/share/applications/qemugui.desktop > /dev/null
[Desktop Entry]
Name=QEMU GUI
Comment=Gestionnaire de VM rapide
Exec=/usr/local/bin/qemugui
Icon=system-run
Type=Application
Categories=System;Emulator;
Terminal=false
EOF

# 5. Finalisation
echo -e "${GREEN}[5/5] Finalisation...${NC}"
echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}Installation terminée avec succès !${NC}"
echo -e "Lancez l'application via votre menu ou tapez : ${BLUE}qemugui${NC}"
echo -e "${BLUE}==============================================${NC}"
