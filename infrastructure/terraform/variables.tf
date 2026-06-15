variable "grafana_admin_password" {
  description = "Mot de passe administrateur Grafana"
  type        = string
  default     = "admin"
  sensitive   = true
}
