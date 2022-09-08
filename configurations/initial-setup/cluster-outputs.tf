output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${data.confluent_environment.workshop_env.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.basic.id}
  EOT

  sensitive = true
}
