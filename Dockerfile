FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Enable 32bit architecture
RUN dpkg --add-architecture i386

# Update system and install packages
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
    wine \
    wine32 \
    firefox \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Set root password
RUN echo "root:root" | chpasswd

# Allow all users in xrdp
RUN sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config || true

# XFCE session
RUN echo "startxfce4" > /root/.xsession

# Configure XRDP
RUN adduser xrdp ssl-cert

RUN sed -i 's/crypt_level=high/crypt_level=low/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini && \
    echo "startxfce4" > /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

# Create start script
RUN echo '#!/bin/bash\n\
service dbus start\n\
service xrdp start\n\
tail -f /dev/null' > /start.sh && chmod +x /start.sh

EXPOSE 3389

CMD ["/start.sh"]
