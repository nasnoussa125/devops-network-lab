output "prometheus_url" {
  description = "URL d'accès à Prometheus"
  value       = "http://localhost:9090"
}

output "grafana_url" {
  description = "URL d'accès à Grafana"
  value       = "http://localhost:3000"
}

output "node_exporter_url" {
  description = "URL des métriques node-exporter"
  value       = "http://localhost:9100/metrics"
}
