# Base image
FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# Labels for build information and maintainer
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer, Anton Melekhin"

# Set environment variables
ENV TITLE="Debian Openbox"
ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive

# Install packages and perform tweaks
RUN echo "**** add icon ****" && \
    curl -o /kclient/public/icon.png https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png && \
    echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        chromium \
        chromium-l10n \
        obconf \
        stterm \
        findutils \
        iproute2 \
        python3 \
        python3-apt \
        sudo \
        systemd && \
    echo "**** application tweaks ****" && \
    mv /usr/bin/chromium /usr/bin/chromium-real && \
    update-alternatives --set x-terminal-emulator /usr/bin/st && \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf /config/.cache /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Remove unwanted systemd services
RUN find /etc/systemd/system /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -print0 | xargs -0 rm -vf

# Add local files
COPY /root /

# Expose ports and volumes
EXPOSE 3000
VOLUME ["/config", "/sys/fs/cgroup"]

# Set the entrypoint to systemd
ENTRYPOINT ["/lib/systemd/systemd"]
