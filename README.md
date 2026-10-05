# Home Lab

My personal home lab setup, managed with Docker Compose. Each service stack lives in its own directory with its own `docker-compose.yml`, `start.sh`, and `down.sh`. All stacks read their configuration from a single shared `.env` file in the repo root.

> ⚠️ **Note:** This setup has been built procedurally over time rather than tested as a clean first-time install from scratch. If you're setting this up fresh, you may hit issues I haven't encountered - PRs and issues welcome.

---

## Stacks

| Stack | Services |
|---|---|
| [Home Assistant](#home-assistant) | Home automation |
| [Minecraft](#minecraft) | Crafty controller, LuckPerms DB, Playit tunnel |
| [Nextcloud](#nextcloud) | File storage, MariaDB, Redis |
| [Media Stack](#media-stack) | Jellyfin, Radarr, Sonarr, Prowlarr, FlareSolverr, qBittorrent, Gluetun VPN |
| [Pi-hole](#pi-hole) | Network-wide DNS ad blocking |

---

## Setup

### 1. Clone the repo

```bash
git clone https://github.com/chanuka-williams/home-lab/
cd home-lab
```

### 2. Create your `.env`

```bash
cp .env.example .env
```

Then fill in the values in `.env`. See [Environment Variables](#environment-variables) below. The `.env` file is git-ignored, so your secrets stay out of the repo.

### 3. Start a stack

Each stack has its own `start.sh`:

```bash
cd media-stack
chmod +x start.sh
./start.sh
```

The media stack's `start.sh` will also create the necessary directories before starting.

---

## Stack Details

### Home Assistant

Home automation platform running in host network mode for full local network access.

```bash
cd homeassistant && ./start.sh
```

**Ports:** Uses host networking (default: `8123`)

---

### Minecraft

Crafty 4 controller for managing Minecraft servers, with a dedicated MySQL database for LuckPerms and Playit for external tunneling.

```bash
cd minecraft && ./start.sh
```

**Ports:**
| Service | Port |
|---|---|
| Crafty Web UI (HTTPS) | `CRAFTY_WEB_UI_PORT` |

---

### Nextcloud

Self-hosted file storage with MariaDB and Redis.

```bash
cd nextcloud && ./start.sh
```

> ⚠️ Environment variables are only applied on first run. After that, changes must be made directly in `nextcloud/config/config.php`.

**Ports:**
| Service | Port |
|---|---|
| Nextcloud Web UI | `NEXTCLOUD_PORT` |

---

### Media Stack

Full media automation stack. Gluetun routes Prowlarr and FlareSolverr through ProtonVPN (WireGuard). Radarr handles movie automation, Sonarr handles TV automation, qBittorrent handles downloading, and Jellyfin serves everything.

```bash
cd media-stack && ./start.sh
```

**Ports:**
| Service | Port |
|---|---|
| Jellyfin | `JELLYFIN_PORT` |
| Radarr | `RADARR_PORT` |
| Sonarr | `SONARR_PORT` |
| Prowlarr | `PROWLARR_PORT` |
| FlareSolverr | `FLARESOLVERR_PORT` |
| qBittorrent Web UI | `QBITTORRENT_PORT` |

> Prowlarr and FlareSolverr share Gluetun's network, so their ports are published on the `gluetun` container.

---

### Pi-hole

Network-wide DNS ad blocker. Point your router's DNS (or individual devices) at `SERVER_IP` to use it.

```bash
cd pihole && ./start.sh
```

**Ports:**
| Service | Port |
|---|---|
| DNS | `53` (TCP/UDP) |
| Web UI (HTTP) | `PIHOLE_HTTP_PORT` |
| Web UI (HTTPS) | `PIHOLE_HTTPS_PORT` |

The admin UI is at `http://<SERVER_IP>:<PIHOLE_HTTP_PORT>/admin`.

> ⚠️ `PIHOLE_PASSWORD` is only applied on first run. Once `pihole/etc-pihole/pihole.toml` exists, change the password with `docker exec -it pihole pihole setpassword`.

> ⚠️ Port 53 must be free on the host. On Ubuntu, `systemd-resolved` usually occupies it. Check with `sudo ss -lntup | grep ':53 '`, and if needed set `DNSStubListener=no` in `/etc/systemd/resolved.conf.d/pihole.conf` and restart `systemd-resolved`.

> 💡 Give the server a static IP or DHCP reservation, since clients (and optionally the host itself) will use that address for DNS. If the host uses Pi-hole, add a secondary DNS server so the host can still resolve names (e.g. to pull images) while the container is down.

---

## Environment Variables

Copy `.env.example` to `.env` and fill in the values.

| Variable | Description |
|---|---|
| `TZ` | Timezone (e.g. `Europe/London`) |
| **Minecraft** | |
| `CRAFTY_WEB_UI_PORT` | Crafty HTTPS web UI port |
| `LUCKPERMS_MYSQL_DATABASE` | LuckPerms database name |
| `LUCKPERMS_MYSQL_ROOT_PASSWORD` | MySQL root password |
| `LUCKPERMS_MYSQL_USER` | MySQL user |
| `LUCKPERMS_MYSQL_PASSWORD` | MySQL user password |
| `PLAYIT_KEY` | Playit agent secret key |
| **Nextcloud** | |
| `NEXTCLOUD_PORT` | Nextcloud web UI port |
| `NEXTCLOUD_MYSQL_DATABASE` | Nextcloud database name |
| `NEXTCLOUD_MYSQL_ROOT_PASSWORD` | MySQL root password |
| `NEXTCLOUD_MYSQL_USER` | MySQL user |
| `NEXTCLOUD_MYSQL_PASSWORD` | MySQL user password |
| `NEXTCLOUD_DOMAIN` | Full domain URL (e.g. `https://cloud.example.com`) |
| `NEXTCLOUD_TRUSTED_DOMAINS` | Space-separated trusted domains |
| **Media Stack** | |
| `WIREGUARD_PRIVATE_KEY` | ProtonVPN WireGuard private key |
| `LOCAL_SUBNET` | Your local subnet (e.g. `192.168.1.0/24`) |
| `SERVER_IP` | Your server's local IP address |
| `JELLYFIN_PORT` | Jellyfin web UI port |
| `JELLYFIN_DISCOVERY_PORT` | Jellyfin UDP discovery port (default: `7359`) |
| `RADARR_PORT` | Radarr web UI port |
| `SONARR_PORT` | Sonarr web UI port |
| `PROWLARR_PORT` | Prowlarr web UI port |
| `FLARESOLVERR_PORT` | FlareSolverr port (container default: `8191`) |
| `QBITTORRENT_PORT` | qBittorrent web UI port |
| `QBITTORRENT_TORRENT_PORT` | qBittorrent torrent port (default: `6881`) |
| **Pi-hole** | |
| `PIHOLE_PASSWORD` | Pi-hole web UI password (only applied on first run) |
| `PIHOLE_HTTP_PORT` | Pi-hole web UI HTTP port |
| `PIHOLE_HTTPS_PORT` | Pi-hole web UI HTTPS port |

---

## Stopping a Stack

Each stack has a `down.sh`:

```bash
cd media-stack && ./down.sh
```