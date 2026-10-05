# Home Lab

My personal home lab setup, managed with Docker Compose. Each service stack lives in its own directory with its own `docker-compose.yml`, `start.sh`, and `down.sh`.

> ⚠️ **Note:** This setup has been built procedurally over time rather than tested as a clean first-time install from scratch. If you're setting this up fresh, you may hit issues I haven't encountered - PRs and issues welcome.

---

## Stacks

| Stack | Services |
|---|---|
| [Home Assistant](#home-assistant) | Home automation |
| [Minecraft](#minecraft) | Crafty controller, LuckPerms DB, Playit tunnel |
| [Nextcloud](#nextcloud) | File storage, MariaDB, Redis |
| [Media Stack](#media-stack) | Jellyfin, Radarr, Prowlarr, qBittorrent, Gluetun VPN |

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

Then fill in the values in `.env`. See [Environment Variables](#environment-variables) below.

### 3. Start a stack

Each stack has its own `start.sh`:

```bash
cd media-stack
chmod +x start.sh
./start.sh
```

The media stack's `start.sh` will also create the necessary directories before starting.

---

## Stacks

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

Full media automation stack. Gluetun routes Prowlarr through ProtonVPN (WireGuard). Radarr handles movie automation, qBittorrent handles downloading, and Jellyfin serves everything.

```bash
cd media-stack && ./start.sh
```

**Ports:**
| Service | Port |
|---|---|
| Jellyfin | `JELLYFIN_PORT` |
| Radarr | `RADARR_PORT` |
| Prowlarr | `PROWLARR_PORT` |
| qBittorrent Web UI | `QBITTORRENT_PORT` |

**Media directory layout:**
```
media-stack/media/
├── downloads/
└── movies/
```

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
| `PROWLARR_PORT` | Prowlarr web UI port |
| `QBITTORRENT_PORT` | qBittorrent web UI port |
| `QBITTORRENT_TORRENT_PORT` | qBittorrent torrent port (default: `6881`) |

---

## Stopping a Stack

Each stack has a `down.sh`:

```bash
cd media-stack && ./down.sh
```
