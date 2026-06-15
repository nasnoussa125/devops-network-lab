# Provisioning IaC de la stack de supervision (Prometheus / Grafana / node-exporter)
# via le provider Docker de Terraform.
#
# Cette configuration est une alternative "Infrastructure as Code" au
# docker-compose.yml situé à la racine du projet : les deux décrivent la
# même stack de supervision, mais avec deux outils différents
# (docker-compose vs Terraform), pour démonstration des compétences IaC.
#
# Usage :
#   cd infrastructure/terraform
#   terraform init
#   terraform apply -auto-approve
#
# Pré-requis : Docker en cours d'exécution sur la machine hôte.

terraform {
  required_version = ">= 1.5"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# --- Réseau dédié à la stack de supervision ---
resource "docker_network" "monitoring" {
  name = "monitoring_tf"
}

# --- Images ---
resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_image" "node_exporter" {
  name = "prom/node-exporter:latest"
}

# --- Volumes persistants ---
resource "docker_volume" "prometheus_data" {
  name = "prometheus_data_tf"
}

resource "docker_volume" "grafana_data" {
  name = "grafana_data_tf"
}

# --- Conteneurs ---
resource "docker_container" "prometheus" {
  name  = "prometheus_tf"
  image = docker_image.prometheus.image_id

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    host_path      = abspath("${path.module}/../../prometheus.yml")
    container_path = "/etc/prometheus/prometheus.yml"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  networks_advanced {
    name = docker_network.monitoring.name
  }
}

resource "docker_container" "grafana" {
  name  = "grafana_tf"
  image = docker_image.grafana.image_id

  env = [
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}"
  ]

  ports {
    internal = 3000
    external = 3000
  }

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  networks_advanced {
    name = docker_network.monitoring.name
  }

  depends_on = [docker_container.prometheus]
}

resource "docker_container" "node_exporter" {
  name  = "node-exporter_tf"
  image = docker_image.node_exporter.image_id

  ports {
    internal = 9100
    external = 9100
  }

  networks_advanced {
    name = docker_network.monitoring.name
  }
}
