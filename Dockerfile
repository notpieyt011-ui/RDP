FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

# Enable i386 support
RUN dpkg --add-architecture i386

# Update and install packages
RUN apt update && apt install -y \
    xfce4 \
    xfce4-goodies \
    xrdp \
    dbus-x11 \
    sudo \
    wget \
    curl \
    nano \
    net-tools \
    firefox-esr \
    chromium \
    pulseaudio \
    policykit-1 \
    xorg \
    && apt clean

# Set root password
RUN echo "root:root" | chpasswd

# XFCE session
RUN echo "startxfce4" > /root/.xsession

# XRDP configuration
RUN adduser xrdp ssl-cert

RUN sed -i 's/crypt_level=high/crypt_level=low/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini

# Startup script
RUN echo '#!/bin/bash\n\
service dbus start\n\
service xrdp start\n\
tail -f /dev/null' > /start.sh && chmod +x /start.sh

EXPOSE 3389

CMD ["/start.sh"]
