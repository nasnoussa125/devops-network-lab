# Local DevOps Lab - Simulation de Cycle IVVQ

Ce laboratoire local virtualisé simule une infrastructure de supervision
d'entreprise et matérialise un cycle complet **Intégration → Vérification →
Validation → Qualification (IVVQ)**, automatisé via Jenkins et tracé via une
matrice d'exigences (EXG-01 à EXG-07).

## Stack technique

- **Provisioning (IaC) :** Docker Compose et Terraform (provider Docker),
  deux approches équivalentes pour monter la stack de supervision.
- **Gestion de configuration :** Ansible (installation et durcissement de
  `node_exporter` sur un serveur cible, service `systemd` via template
  Jinja2).
- **CI/CD :** Jenkins (pipeline déclaratif via `Jenkinsfile`).
- **Observabilité :** Prometheus (métriques) + Grafana (visualisation).
- **Tests automatisés :** Robot Framework (vérification et validation),
  scripts de recette Bash/Windows (`ivvq/scripts/`).
- **Modélisation d'architecture :** TOSCA (OASIS) pour la topologie réseau
  cible et la stack de supervision.

## Architecture du dépôt

Le projet est organisé en deux stacks Docker indépendantes, plus une couche
de modélisation/documentation :

### 1. Stack de supervision (racine du dépôt)

`docker-compose.yml` + `prometheus.yml` déploient **Prometheus, Grafana et
node-exporter** sur un réseau Docker dédié (`monitoring`). C'est le cœur
testé par le pipeline IVVQ :

- **Vérification (EXG-01 à EXG-03)** : `tests/verification.robot` — chaque
  composant répond-il individuellement (santé Prometheus, métriques
  node-exporter, cible détectée par Prometheus) ?
- **Validation (EXG-04, EXG-05)** : `tests/validation.robot` — le besoin
  global est-il couvert (Grafana accessible, métriques CPU temps réel
  exposées) ?
- **Qualification (EXG-06)** : le `Jenkinsfile` orchestre le déploiement et
  l'exécution des tests, puis archive les résultats comme preuve.

Une alternative IaC à `docker-compose` est fournie dans
`infrastructure/terraform/` (mêmes services, via Terraform + provider
Docker).

### 2. Stack "simulation d'entreprise" (`infrastructure/docker/`)

Une seconde stack, indépendante (réseau `production_network`), simule un
environnement applicatif d'entreprise : serveur web **Nginx**, base
**PostgreSQL** et une instance **Jenkins** dédiée. Elle est validée par des
scripts de recette technique multi-OS :

- `ivvq/scripts/run_tests.sh` (Linux/macOS) : disponibilité Nginx/PostgreSQL
  + audit "pas de secret en dur" (le mot de passe PostgreSQL est injecté via
  `${DB_PASSWORD}`).
- `ivvq/scripts/run_local_tests.bat` (Windows) : audit statique du dépôt
  (inventaire Ansible, blueprint TOSCA, stack applicative, secret externalisé,
  provisioning Terraform).
- `ivvq/scripts/validate_stack.py` : vérification HTTP des trois services de
  la stack de supervision (Prometheus, Grafana, node-exporter), sans
  dépendance réseau externe.

### 3. Configuration et modélisation cible

- `ansible/` : playbook `install_node_exporter.yml` (installation de
  `node_exporter` sur un serveur cible via SSH, service systemd), orchestré
  par `ansible/playbooks/site.yml`.
- `tosca/blueprints/` : modélisation OASIS TOSCA de la topologie réseau cible
  (VLAN LAN interne `192.168.10.0/24` + VLAN DMZ serveurs `192.168.20.0/24`)
  et de la stack de supervision en nœuds orchestrables.
- `infrastructure/cisco/base_vlan.ios` : configuration Cisco IOS de base
  (VLAN 10 LAN_INTERNE, VLAN 20 DMZ_SERVEURS, ports d'accès et trunk)
  correspondant à la topologie TOSCA ci-dessus.

## Déploiement local

### 1. Stack de supervision (Prometheus / Grafana / node-exporter)

Option A — Docker Compose :

```bash
cp .env.example .env   # puis ajuster GRAFANA_ADMIN_PASSWORD
docker-compose up -d
```

Option B — Terraform :

```bash
cd infrastructure/terraform
terraform init
terraform apply -auto-approve
```

Services exposés : Prometheus `http://localhost:9090`, Grafana
`http://localhost:3000`, node-exporter `http://localhost:9100/metrics`.

### 2. Tests Robot Framework (vérification + validation)

```bash
pip install --break-system-packages robotframework robotframework-requests
python3 -m robot --outputdir results/verification tests/verification.robot
python3 -m robot --outputdir results/validation tests/validation.robot
```

Vérification rapide (sans Robot Framework) :

```bash
python3 ivvq/scripts/validate_stack.py
# ou
bash tests/verify_stack.sh
```

### 3. Pipeline Jenkins

Le `Jenkinsfile` (à la racine) automatise les étapes ci-dessus : installation
des outils, déploiement de la stack, exécution des suites de vérification et
de validation, archivage des résultats.

### 4. Stack "simulation d'entreprise" (optionnelle)

```bash
cd infrastructure/docker
cp .env.example .env   # puis ajuster DB_PASSWORD
docker-compose up -d
cd ../..
bash ivvq/scripts/run_tests.sh          # Linux/macOS
ivvq\scripts\run_local_tests.bat        # Windows
```

### 5. Configuration Ansible (serveur cible distant)

```bash
cd ansible
ansible-playbook playbooks/site.yml -i inventory.ini
```

## Traçabilité des exigences

Voir [`ivvq/requirements_traceability.md`](ivvq/requirements_traceability.md)
pour la matrice complète EXG-01 à EXG-07 (exigence → niveau → test → fichier
→ statut).

## Limites connues / axes d'évolution

- **EXG-07** (détection de panne via alerte active) : non encore configurée
  (Alertmanager).
- Les blueprints **TOSCA** décrivent la topologie cible et la stack de
  supervision mais ne sont pas encore déployés via un orchestrateur
  (Cloudify, OpenTOSCA).
- La configuration **Cisco IOS** (`infrastructure/cisco/base_vlan.ios`)
  correspond à la topologie TOSCA mais n'a pas été testée sur un équipement
  réel ou simulé (GNS3/EVE-NG).
- Une stack **ELK** pour la centralisation des logs pourrait compléter
  l'observabilité (actuellement limitée à Prometheus/Grafana).
