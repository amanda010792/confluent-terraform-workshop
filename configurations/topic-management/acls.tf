// 'application-manager' service account is required in this configuration to create 'orders' topic and grant ACLs
// to 'app-producer' and 'app-consumer' service accounts.
resource "confluent_service_account" "application-manager" {
  display_name = "application-manager"
  description  = "Service account to manage Kafka cluster"
}

resource "confluent_role_binding" "application-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.application-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.basic.rbac_crn
}

resource "confluent_api_key" "application-manager-kafka-api-key" {
  display_name = "application-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'application-manager' service account"
  owner {
    id          = confluent_service_account.application-manager.id
    api_version = confluent_service_account.application-manager.api_version
    kind        = confluent_service_account.application-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.basic.id
    api_version = confluent_kafka_cluster.basic.api_version
    kind        = confluent_kafka_cluster.basic.kind

    environment {
      id = data.confluent_environment.workshop_env.id
    }
  }

  # The goal is to ensure that confluent_role_binding.application-manager-kafka-cluster-admin is created before
  # confluent_api_key.application-manager-kafka-api-key is used to create instances of
  # confluent_kafka_topic, confluent_kafka_acl resources.

  # 'depends_on' meta-argument is specified in confluent_api_key.application-manager-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic, confluent_kafka_acl resources instead.
  depends_on = [
    confluent_role_binding.application-manager-kafka-cluster-admin
  ]
}
