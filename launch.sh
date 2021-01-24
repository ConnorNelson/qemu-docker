#!/usr/bin/env sh

/usr/bin/qemu-system-x86_64 \
    -kernel /opt/linux-5.4/arch/x86/boot/bzImage \
    -fsdev local,id=root,path=/,security_model=none,writeout=immediate \
    -device virtio-9p-pci,fsdev=root,mount_tag=/dev/root \
    -nographic \
    -monitor none \
    -append "root=/dev/root rw rootfstype=9p rootflags=trans=virtio console=ttyS0 nokaslr init=/boot/init"
