#include <iostream>
#include <vector>
#include <unistd.h>
#include <string>

int main(int argc, char* argv[]) {
    // Ordre : disk, ram, cpu, iso, uefi, kbd, vram, sboot, net, audio, usb
    if (argc < 12) return 1;

    std::vector<char*> args;
    args.push_back((char*)"qemu-system-x86_64");
    args.push_back((char*)"-enable-kvm");
    args.push_back((char*)"-cpu"); args.push_back((char*)"host");
    args.push_back((char*)"-m"); args.push_back(argv[2]);
    args.push_back((char*)"-smp"); args.push_back(argv[3]);

    // Disque & ISO
    std::string drive = "file=" + std::string(argv[1]) + ",format=qcow2";
    args.push_back((char*)"-drive"); args.push_back((char*)drive.c_str());
    if (std::string(argv[4]) != "None") {
        args.push_back((char*)"-cdrom"); args.push_back(argv[4]);
    }

    // Graphismes (VMware-style avec 3D)
    std::string vga_opts = "virtio-vga-gl,vgamem_mb=" + std::string(argv[7]);
    args.push_back((char*)"-device"); args.push_back((char*)vga_opts.c_str());
    args.push_back((char*)"-display"); args.push_back((char*)"gtk,gl=on,zoom-to-fit=on");

    // Réseau (NAT par défaut)
    args.push_back((char*)"-netdev");
    std::string netdev = "user,id=net0,hostfwd=tcp::2222-:22"; // NAT + SSH forward
    args.push_back((char*)netdev.c_str());
    args.push_back((char*)"-device");
    std::string net_type = std::string(argv[9]) + ",netdev=net0";
    args.push_back((char*)net_type.c_str());

    // Audio
    args.push_back((char*)"-device"); args.push_back((char*)"intel-hda");
    args.push_back((char*)"-device");
    std::string audio_type = "hda-" + std::string(argv[10]);
    args.push_back((char*)audio_type.c_str());

    // USB 3.0
    if (std::string(argv[11]) == "1") {
        args.push_back((char*)"-device"); args.push_back((char*)"qemu-xhci");
    }

    // Boot
    if (std::string(argv[5]) == "1") {
        args.push_back((char*)"-bios"); args.push_back((char*)"/usr/share/ovmf/OVMF.fd");
    }
    args.push_back((char*)"-k"); args.push_back(argv[6]);

    args.push_back(nullptr);
    execvp(args[0], args.data());
    return 1;
}
