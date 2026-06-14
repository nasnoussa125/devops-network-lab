# Infrastructure du lab

## Topologie simulée

```
                    ┌─────────────────────────────────┐
                    │       Docker Network              │
                    │       (bridge: monitoring)        │
                    │                                   │
                    │  ┌──────────┐  ┌──────────────┐  │
                    │  │Prometheus│  │   Grafana     │  │
                    │  │:9090     │◄─┤   :3000       │  │
                    │  └────┬─────┘  └──────────────┘  │
                    │       │ scrape                    │
                    │  ┌────▼─────────┐                 │
                    │  │node-exporter │                 │
                    │  │:9100         │                 │
                    │  └─────────────┘                 │
                    └─────────────────────────────────┘
                              │
                              │ Ansible (SSH)
                              ▼
                    ┌─────────────────┐
                    │ Serveur cible   │
                    │ 192.168.1.10    │
                    │ node_exporter   │
                    │ (service systemd│
                    │ installé via    │
                    │ Ansible)        │
                    └─────────────────┘
```

## Composants

| Composant      | Image/Version          | Port  | Rôle                                    |
|----------------|------------------------|-------|-----------------------------------------|
| Prometheus     | prom/prometheus:latest | 9090  | Collecte et stockage des métriques      |
| Grafana        | grafana/grafana:latest | 3000  | Visualisation et dashboards             |
| node-exporter  | prom/node-exporter:latest | 9100 | Exposition des métriques système       |
| Jenkins        | (externe au compose)   | 8080  | Orchestration CI/CD                     |

## Réseau

- Réseau Docker interne : `monitoring` (bridge)
- Les conteneurs communiquent par nom de service (DNS interne Docker)
- Seuls les ports nécessaires sont exposés sur l'hôte

## Prérequis

- Docker >= 24.0
- docker compose >= 2.0
- Python 3.8+ (pour Robot Framework)
- Jenkins avec accès à Docker sur l'hôte

## Variables d'environnement

Copier `.env.example` → `.env` et renseigner :

```bash
GRAFANA_ADMIN_PASSWORD=<mot_de_passe_fort>
```
