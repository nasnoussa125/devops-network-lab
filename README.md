# Local DevOps Lab - Simulation de Cycle IVVQ

Ce laboratoire local virtualisé simule une infrastructure réseau et système d'entreprise complète. L'objectif est de valider un pipeline automatisé d'Intégration, Vérification, Validation et Qualification (IVVQ).

## 🛠️ Stack Technique
- **Provisioning (IaC) :** Terraform (Provider Docker local pour l'orchestration des conteneurs).
- **Gestion de Configuration :** Ansible (Configuration des services, durcissement et déploiement des agents).
- **CI/CD :** Jenkins (Pipeline as code via Jenkinsfile).
- **Observabilité :** Prometheus + Grafana (Métriques) & Stack ELK (Centralisation des logs).
- **Automation Tests :** Robot Framework (Scénarios de validation réseau, latence, et pertes de paquets).

## 📐 Architecture Réseau (Simulée)
L'infrastructure utilise des réseaux Docker isolés pour simuler des VLANs applicatifs :
- `net-mgmt` (192.168.10.0/24) : Flux d'administration, Jenkins, et supervision.
- `net-prod` (192.168.20.0/24) : Zone de production hébergeant l'application cible.

## 🚀 Déploiement Local
1. Initialiser et appliquer la configuration Terraform pour monter l'infrastructure de base :
   ```bash
   cd terraform && terraform init && terraform apply -auto-approve