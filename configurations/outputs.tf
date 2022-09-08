output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${confluent_environment.staging.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.basic.id}
  EOT

  sensitive = true
}
