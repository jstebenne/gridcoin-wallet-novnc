## Custom Dockerfile
FROM consol/debian-xfce-vnc
ENV REFRESHED_AT 2026-06-09

ENV GRC_VERSION 5.5.1.0 

# Switch to root user to install additional software
USER 0

# Install Gridcoin
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      wget && \
    wget -O /tmp/gridcoin.deb \
      https://github.com/gridcoin-community/Gridcoin-Research/releases/download/${GRC_VERSION}/gridcoinresearch-qt_${GRC_VERSION}.bookworm-1_amd64.deb && \
    apt-get install -y /tmp/gridcoin.deb && \
    rm -f /tmp/gridcoin.deb && \
    rm -rf /var/lib/apt/lists/* 

RUN mkdir -p /headless/.config/autostart
COPY autostart/gridcoin.desktop /headless/.config/autostart/gridcoin.desktop
RUN chown -R 1000:1000 /headless/.config

## switch back to default user
USER 1000