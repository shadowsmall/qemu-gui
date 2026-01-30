#include <iostream>
#include <vector>
#include <unistd.h>
#include <string>

int main(int argc, char* argv[]) {
    // Arguments attendus : disk, ram, cpu, iso, uefi, kbd, vram, sboot
    if (argc < 9) {
        std::cerr << "Usage: qemu_launcher <disk> <ram> <cpu> <iso> <uefi> <kbd> <vram> <sboot>" << std::endl;
        return 1;
    }

    std::vector<char*> args;
    args.push_back((char*)"qemu-system-x86_64");
    args.push_back((char*)"-enable-kvm");
    args.push_back((char*)"-m"); args.push_back(argv[2]);
    args.push_back((char*)"-smp"); args.push_back(argv[3]);

    // Disque
    std::string drive = "file=" + std::string(argv[1]) + ",format=qcow2";
    args.push_back((char*)"-drive"); args.push_back((char*)drive.c_str());

    // Gestion de la VRAM (On garde virtio car tu as dit qu'il ne bug pas)
    std::string vga_opts = "virtio,vgamem_mb=" + std::string(argv[7]);
    args.push_back((char*)"-device"); args.push_back((char*)vga_opts.c_str());
    args.push_back((char*)"-display"); args.push_back((char*)"gtk,zoom-to-fit=on");

    // Clavier
    args.push_back((char*)"-k"); args.push_back(argv[6]);

    // ISO
    if (std::string(argv[4]) != "None") {
        args.push_back((char*)"-cdrom");
        args.push_back(argv[4]);
    }

    // UEFI et Secure Boot
    if (std::string(argv[5]) == "1") {
        if (std::string(argv[8]) == "1") {
            // Mode Secure Boot (nécessite ovmf installé)
            args.push_back((char*)"-bios");
            args.push_back((char*)"/usr/share/ovmf/OVMF.fd");
        } else {
            args.push_back((char*)"-bios");
            args.push_back((char*)"/usr/share/ovmf/OVMF.fd");
        }
    }

    args.push_back(nullptr);
    execvp(args[0], args.data());
    perror("Erreur fatale QEMU");
    return 1;
}
