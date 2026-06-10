# Gridcoin Wallet noVNC

Run the Gridcoin Qt wallet in Docker with an XFCE desktop, browser-based noVNC access, and optional direct VNC access. 
This image is primarily intended for Unraid, but it can also be used on any Docker host.

The container is based on the ConSol Debian XFCE VNC image, exposes noVNC on port 6901 and VNC on port 5901, and is 
configured so the Gridcoin wallet starts automatically when the desktop session launches.

## Features

- Gridcoin Qt wallet in a containerized desktop session.
- Browser access through noVNC.
- Optional direct VNC access.
- Automatic wallet launch on container start.
- Persistent Gridcoin data directory.
- Optional BOINC data directory mapping.
- Configurable VNC password and screen resolution.
- Suitable for Unraid templates and manual Docker use.

## Image

```bash
docker pull ghcr.io/jstebenne/gridcoin-wallet-novnc:latest
```

The image is published to GitHub Container Registry as `ghcr.io/jstebenne/gridcoin-wallet-novnc:latest`.

## Unraid

This project is mainly designed for Unraid. The recommended setup is to use an Unraid Docker template that maps the 
Gridcoin appdata directory, optional BOINC data directory, and the exposed web/VNC ports, with appdata typically stored 
under /mnt/user/appdata/... on Unraid systems.

### Recommended Unraid settings

| Setting           | Value                         |
|-------------------|-------------------------------|
| noVNC port        | `6901`                        |
| VNC port          | `5901`                        |
| Gridcoin TCP port | `32749`                       |
| Gridcoin RPC port | `15715`                       |
| Gridcoin appdata  | `/headless/.GridcoinResearch` |
| BOINC data dir    | `/var/lib/boinc-client`       |
| VNC password      |                               |
| Resolution        |                               |


### Suggested Unraid path mappings

| Host path                               | Container path               | Access     |
|-----------------------------------------|------------------------------|------------|
| /mnt/user/appdata/gridcoin-wallet-novnc | /headless/.GridcoinResearch  | Read-write |
| /mnt/user/appdata/boinc                 | /var/lib/boinc-client        | Read-only  |

Using the Unraid appdata share is the common approach because it keeps persistent container data in the expected location and works well with backup workflows.

## Docker usage

You can also run the image directly on any Docker host.

Basic example

```bash
docker run -d \
  --name=gridcoin-wallet-novnc \
  -p 6901:6901 \
  -p 5901:5901 \
  -v /path/to/gridcoin:/headless/.GridcoinResearch \
  ghcr.io/jstebenne/gridcoin-wallet-novnc:latest
```

Then open:

```text
http://127.0.0.1:6901
```

The base XFCE VNC container family uses port 6901 for noVNC and port 5901 for standard VNC access.

Example with password, resolution, BOINC, and Gridcoin ports

```bash
docker run -d \
  --name=gridcoin-wallet-novnc \
  -p 6901:6901 \
  -p 5901:5901 \
  -p 32749:32749 \
  -p 15715:15715 \
  -e VNC_PW=change-me \
  -e VNC_RESOLUTION=1920x1080 \
  -v /path/to/gridcoin:/headless/.GridcoinResearch \
  -v /path/to/boinc:/var/lib/boinc-client:ro \
  ghcr.io/jstebenne/gridcoin-wallet-novnc:latest
```

The BOINC mapping is intended to be read-only, and the Gridcoin TCP port 32749 and RPC port 15715 match commonly documented defaults for Gridcoin setups.

### Volumes

| Container path              | Purpose                                                   |
|-----------------------------|-----------------------------------------------------------|
| /headless/.GridcoinResearch | Gridcoin wallet data, configuration, and blockchain files |
| /var/lib/boinc-client       | Optional BOINC data directory, recommended as read-only   |

### Ports

| Port      | Purpose                   |
|-----------|---------------------------|
| 6901/tcp  | noVNC web access          |
| 5901/tcp  | Direct VNC access         |
| 32749/tcp | Gridcoin P2P network port |
| 15715/tcp | Gridcoin RPC port         |

## Behavior

The Gridcoin wallet is configured to start automatically when the desktop session launches, so after the container starts and the XFCE session is ready, the wallet should already be running in the remote desktop environment.

## Notes

- This is an unofficial container project and is not an official Gridcoin release.
- Exposing port 32749 helps accept inbound peer connections, but it is not strictly required just to use the wallet.
- Exposing the RPC port is not enough by itself; the wallet must also be configured to allow RPC connections.
- Browser access through noVNC is the easiest way to use the container on Unraid or other headless servers.

## Security

- Change the default VNC password before exposing the container outside a trusted network.
- Do not expose RPC publicly unless you have configured authentication and understand the risk.
- Back up your persistent Gridcoin data regularly.
