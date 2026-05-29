FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    qemu-kvm \
    qemu-utils \
    qemu-system-x86 \
    wget \
    curl \
    novnc \
    websockify \
    supervisor \
    && apt clean

WORKDIR /windows

# Download Tiny10 / Windows Lite ISO manually later
# Put your ISO as /windows/win10lite.iso

# Create virtual disk
RUN qemu-img create -f qcow2 /windows/win10.qcow2 30G

EXPOSE 3389
EXPOSE 6080

CMD qemu-system-x86_64 \
    -m 6G \
    -cpu host \
    -smp 2 \
    -hda /windows/win10.qcow2 \
    -cdrom /windows/win10lite.iso \
    -boot d \
    -vga std \
    -net nic \
    -net user,hostfwd=tcp::3389-:3389 \
    -vnc :0
