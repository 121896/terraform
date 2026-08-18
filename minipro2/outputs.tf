# outputs.tf (Root Module)

output "alb_dns_name" {
  description = "ALB DNS Name for Web Access"
  value       = module.alb.lb_dns_name
}

output "db_cluster_endpoint" {
  description = "Database Cluster Endpoint"
  value       = module.db.cluster_endpoint
}
