FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    xfce4 \
    xfce4-goodies \
    xrdp \
    dbus-x11 \
    sudo \
    wget \
    curl \
    nano \
    firefox-esr \
    chromium \
    net-tools \
    && apt clean

# Root password
RUN echo "root:root" | chpasswd

# XFCE session
RUN echo "startxfce4" > /root/.xsession

# XRDP setup
RUN adduser xrdp ssl-cert

RUN sed -i 's/crypt_level=high/crypt_level=low/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini

# Start script
RUN echo '#!/bin/bash\n\
service dbus start\n\
service xrdp start\n\
tail -f /dev/null' > /start.sh && chmod +x /start.sh

EXPOSE 3389

CMD ["/start.sh"]
