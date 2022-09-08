// 'connect-manager' service account is required in this configuration to create connector and grant ACLs
// to 'connect-producer' and 'connect-consumer' service accounts.
resource "confluent_service_account" "connect-manager" {
  display_name = "connect-manager"
  description  = "Service account to manage Kafka cluster"
}

resource "confluent_role_binding" "connect-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.connect-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = data.confluent_kafka_cluster.basic.rbac_crn
}

resource "confluent_api_key" "connect-manager-kafka-api-key" {
  display_name = "connect-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'connect-manager' service account"
  owner {
    id          = confluent_service_account.connect-manager.id
    api_version = confluent_service_account.connect-manager.api_version
    kind        = confluent_service_account.connect-manager.kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.basic.id
    api_version = data.confluent_kafka_cluster.basic.api_version
    kind        = data.confluent_kafka_cluster.basic.kind

    environment {
      id = data.confluent_environment.workshop_env.id
    }
  }

  depends_on = [
    confluent_role_binding.connect-manager-kafka-cluster-admin
  ]
}
resource "confluent_service_account" "app-connector" {
  display_name = "app-connector"
  description  = "Service account of Datagen Connector"
}


resource "confluent_kafka_acl" "app-connector-describe-on-cluster" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app-connector.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.connect-manager-kafka-api-key.id
    secret = confluent_api_key.connect-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-write-on-target-topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = data.confluent_kafka_topic.orders.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app-connector.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.connect-manager-kafka-api-key.id
    secret = confluent_api_key.connect-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-create-on-data-preview-topics" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "data-preview"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.connect-manager-kafka-api-key.id
    secret = confluent_api_key.connect-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-write-on-data-preview-topics" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "data-preview"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.connect-manager-kafka-api-key.id
    secret = confluent_api_key.connect-manager-kafka-api-key.secret
  }
}
