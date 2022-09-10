output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${data.confluent_environment.workshop-env.id}
  Kafka Cluster ID: ${data.confluent_kafka_cluster.basic.id}
  Kafka topic name: ${data.confluent_kafka_topic.orders.topic_name}
  Service Accounts and their Kafka API Keys (API Keys inherit the permissions granted to the owner):
  ${confluent_service_account.connect-manager.display_name}:                     ${confluent_service_account.connect-manager.id}
  ${confluent_service_account.connect-manager.display_name}'s Kafka API Key:     "${confluent_api_key.connect-manager-kafka-api-key.id}"
  ${confluent_service_account.connect-manager.display_name}'s Kafka API Secret:  "${confluent_api_key.connect-manager-kafka-api-key.secret}"
  ${confluent_service_account.application-connector.display_name}:                    ${confluent_service_account.application-connector.id}
  ${confluent_service_account.application-connector.display_name}'s Kafka API Key:    "${confluent_api_key.application-connector-kafka-api-key.id}"
  ${confluent_service_account.application-connector.display_name}'s Kafka API Secret: "${confluent_api_key.application-connector-kafka-api-key.secret}"
  EOT

  sensitive = true
}
