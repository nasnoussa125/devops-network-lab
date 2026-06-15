# Dossier `infrastructure/`

Ce dossier regroupe tout ce qui ne relève pas directement de la stack de
supervision principale (`docker-compose.yml` / `prometheus.yml` à la racine,
cf. [README.md racine](../README.md)).

## `docker/` — Stack "simulation d'entreprise"

`docker-compose.yml` indépendant déployant un serveur web **Nginx**, une base
**PostgreSQL** (mot de passe injecté via `${DB_PASSWORD}`, voir
`.env.example`) et une instance **Jenkins** dédiée (image custom, build via
`Dockerfile`), sur le réseau `production_network`.

| Composant     | Image/Version           | Port hôte | Rôle                          |
|----------------|-------------------------|-----------|-------------------------------|
| web-server     | nginx:alpine             | 8080      | Serveur web applicatif        |
| app-database   | postgres:15-alpine       | 5433      | Base de données               |
| jenkins        | build local (Dockerfile)| 8081, 50000 | CI/CD (instance dédiée)      |

Validée par les scripts de recette dans `ivvq/scripts/` (voir README racine).

## `terraform/` — Provisioning IaC (alternatif)

Configuration Terraform (provider `kreuzwerker/docker`) provisionnant la
**même stack de supervision** que `docker-compose.yml` (Prometheus, Grafana,
node-exporter), pour démonstration d'une approche IaC déclarative
équivalente. Voir `main.tf`, `variables.tf`, `outputs.tf`.

## `cisco/` — Configuration réseau cible

`base_vlan.ios` : configuration Cisco IOS de base (VLAN 10 LAN_INTERNE,
VLAN 20 DMZ_SERVEURS, ports d'accès + trunk), correspondant à la topologie
modélisée dans `tosca/blueprints/topology.yaml`. Non testée sur équipement
réel/simulé à ce stade (cf. "Limites connues" du README racine).

## Prérequis généraux

- Docker >= 24.0 et docker compose >= 2.0
- Terraform >= 1.5 (pour `terraform/`)
- Python 3.8+ (pour Robot Framework et `validate_stack.py`)
