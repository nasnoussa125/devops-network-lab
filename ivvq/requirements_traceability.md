# Matrice de traçabilité IVVQ

Chaque exigence est tracée vers le(s) test(s) qui la couvrent,
selon la démarche Intégration → Vérification → Validation → Qualification.

| ID      | Exigence                                                                 | Niveau          | Test associé                              | Fichier                        | Statut      |
|---------|--------------------------------------------------------------------------|-----------------|-------------------------------------------|--------------------------------|-------------|
| EXG-01  | Prometheus doit être opérationnel et répondre sur `/-/healthy`           | Vérification    | `EXG-01 Prometheus Est Joignable`         | `tests/verification.robot`     |  Couvert  |
| EXG-02  | node-exporter doit exposer ses métriques sur `/metrics`                  | Vérification    | `EXG-02 Node Exporter Est Joignable`      | `tests/verification.robot`     | Couvert  |
| EXG-03  | Prometheus doit avoir détecté node-exporter comme cible active           | Vérification    | `EXG-03 Prometheus Scrappe Node Exporter` | `tests/verification.robot`     |  Couvert  |
| EXG-04  | Grafana doit être accessible pour la supervision temps réel              | Validation      | `EXG-04 Grafana Est Accessible`           | `tests/validation.robot`       |  Couvert  |
| EXG-05  | Le système doit exposer des métriques CPU temps réel                     | Validation      | `EXG-05 Prometheus Expose Des Metriques CPU` | `tests/validation.robot`    | Couvert  |
| EXG-06  | Le pipeline CI doit produire une preuve traçable et rejouable            | Qualification   | Archivage `results/**`                    | `Jenkinsfile` (post.always)    | Couvert  |
| EXG-07  | Une panne de service doit être détectable (alerte active)                | Validation      | Alertmanager non encore configuré         | —                              |  Partiel |

## Axes d'évolution

- **EXG-07** : configurer Alertmanager pour passer de la détection passive (target DOWN visible dans Prometheus) à une alerte push active
- Ajouter des tags `[Tags] EXG-XX` dans les fichiers Robot pour générer une matrice de couverture automatique via le rapport HTML Robot Framework
- Étendre si de nouveaux composants sont ajoutés (ELK, alertes via Alertmanager…)
- Ajouter une ligne EXG-08 si le provisioning Terraform (`infrastructure/terraform/`) est un jour couvert par un test automatisé (aujourd'hui : alternative IaC documentée, non testée par le pipeline)
