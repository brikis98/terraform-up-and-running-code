output "service_status" {
  value       = kubernetes_service.app.status
  description = "The K8S Service status"
}

output "service_endpoint" {
  value = try(
    "http://${kubernetes_service.app.status[0]["load_balancer"][0]["ingress"][0]["hostname"]}",
    "(error parsing hostname from status)"
  )
  description = "The K8S Service endpoint"
}
