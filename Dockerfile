FROM ubuntu:22.04

# Workspace
WORKDIR /usr/app

# File Copy
COPY ./supervisord.conf /etc/supervisord.conf 

# APT Update
RUN apt -y update && apt -y upgrade
RUN apt install -y sudo

# Create User
ARG USERNAME=user
ARG GROUPNAME=user
ARG UID=1000
ARG GID=1000
ARG PASSWORD=user
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME



# Install Packages
RUN sudo apt install -y supervisor parprouted dhcp-helper iproute2 iputils-ping

# Add config
RUN echo "DHCPHELPER_OPTS=\"-b wlan0\"" | sudo tee /etc/default/dhcp-helper
RUN sudo /sbin/ip link set wlan0 promisc on
RUN sudo /sbin/ip link set eth0 promisc on
RUN sudo /sbin/ip link set dev eth0 up

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
