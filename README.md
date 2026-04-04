#Monitoring Réseau & CI/CD Pipeline

Ce projet met en place une infrastructure de surveillance automatisée pour un parc de serveurs Linux.

##Technologies
- **Ansible** : Configuration de l'infrastructure.
- **Jenkins** : Orchestration des tests (CI/CD).
- **Robot Framework** : Tests de connectivité réseau.
- **Prometheus & Grafana** : Monitoring et Visualisation.
- **Docker** : Déploiement des services.

##Résultat
Le système vérifie chaque minute la latence entre les serveurs. Si une panne survient, Jenkins lève une alerte rouge.

![Screenshot de Grafana](lien_vers_ta_photo)
