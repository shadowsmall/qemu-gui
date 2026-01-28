<div align="center">

# 🖥️ QEMU GUI 
**La virtualisation simplifiée. La performance du C++ alliée à l'élégance du Python.**

[![Language - Python](https://img.shields.io/badge/Interface-Python_3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Language - C++](https://img.shields.io/badge/Engine-C++_17-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white)](https://isocpp.org/)
[![Platform - Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![License - MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](https://opensource.org/licenses/MIT)

---



</div>

## 🎯 À propos
**QEMU GUI** n'est pas qu'une simple interface. C'est une solution hybride conçue pour éliminer les frustrations courantes de la virtualisation (souris qui saute, configurations complexes, clavier mal mappé). En utilisant un **moteur de lancement en C++**, nous garantissons une exécution directe et optimisée des processus QEMU.

---

## ⚡ Fonctionnalités Clés

| 🛠️ Technologie | ✨ Avantage utilisateur |
| :--- | :--- |
| **Moteur C++ Natif** | Démarrage ultra-rapide et gestion optimisée des ressources système. |
| **Smart Mouse Capture** | Mode `usb-tablet` intégré pour une synchronisation parfaite du curseur. |
| **Dual Boot Mode** | Basculez entre **UEFI (OVMF)** et **BIOS Legacy** en un clic. |
| **Audio HD** | Pilotes `intel-hda` activés par défaut pour un son cristallin. |
| **AZERTY Native** | Mapping automatique du clavier français (fr). |

---

## 🚀 Installation Rapide

### 1. Prérequis
```bash
sudo apt update && sudo apt install -y python3-pyqt6 qemu-system-x86 qemu-utils ovmf g++
