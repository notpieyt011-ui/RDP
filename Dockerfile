FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Enable 32-bit support
RUN dpkg --add-architecture i386

# Update and install packages
RUN apt update && apt install -y \
    xrdp \
    xfce4 \
    xfce4-goodies \
    xorg \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    policykit-1 \
    pulseaudio \
    pulseaudio-utils \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    wine64 \
    wine32 \
    firefox \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt update && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Set root password
RUN echo "root:root" | chpasswd

# Allow anybody to start X
RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

# XFCE session
RUN echo "startxfce4" > /root/.xsession && chmod 700 /root/.xsession

# Generate machine-id for dbus
RUN mkdir -p /var/run/dbus && \
    dbus-uuidgen > /var/lib/dbus/machine-id

# XRDP configuration
RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini

# XRDP startwm
RUN echo '#!/bin/sh\nstartxfce4' > /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

# Add xrdp user to ssl-cert group
RUN adduser xrdp ssl-cert

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose RDP port
EXPOSE 3389

CMD ["/start.sh"]
