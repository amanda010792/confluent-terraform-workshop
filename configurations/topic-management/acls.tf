// 'topic-manager' service account is required in this configuration to create 'orders' topic 
resource "confluent_service_account" "topic-manager" {
  display_name = var.confluent_cloud_topic_manager_name
  description  = "Service account to manage Kafka cluster"
}

resource "confluent_role_binding" "topic-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.topic-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = data.confluent_kafka_cluster.basic.rbac_crn
}

resource "confluent_api_key" "topic-manager-kafka-api-key" {
  display_name = "topic-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'topic-manager' service account"
  owner {
    id          = confluent_service_account.topic-manager.id
    api_version = confluent_service_account.topic-manager.api_version
    kind        = confluent_service_account.topic-manager.kind
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
    confluent_role_binding.topic-manager-kafka-cluster-admin
  ]
}

resource "confluent_service_account" "topic-consumer" {
  display_name = var.confluent_cloud_topic_consumer_name
  description  = "Service account to consume from 'orders' topic of 'inventory' Kafka cluster"
}

resource "confluent_api_key" "topic-consumer-kafka-api-key" {
  display_name = "topic-consumer-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-consumer' service account"
  owner {
    id          = confluent_service_account.topic-consumer.id
    api_version = confluent_service_account.topic-consumer.api_version
    kind        = confluent_service_account.topic-consumer.kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.basic.id
    api_version = data.confluent_kafka_cluster.basic.api_version
    kind        = data.confluent_kafka_cluster.basic.kind

    environment {
      id = data.confluent_environment.workshop_env.id
    }
  }
}

resource "confluent_kafka_acl" "topic-producer-write-on-topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.orders.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.topic-producer.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.topic-manager-kafka-api-key.id
    secret = confluent_api_key.topic-manager-kafka-api-key.secret
  }
}


resource "confluent_service_account" "topic-producer" {
  display_name = var.confluent_cloud_topic_producer_name
  description  = "Service account to produce to 'orders' topic of 'inventory' Kafka cluster"
}

resource "confluent_api_key" "topic-producer-kafka-api-key" {
  display_name = "topic-producer-kafka-api-key"
  description  = "Kafka API Key that is owned by 'topic-producer' service account"
  owner {
    id          = confluent_service_account.topic-producer.id
    api_version = confluent_service_account.topic-producer.api_version
    kind        = confluent_service_account.topic-producer.kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.basic.id
    api_version = data.confluent_kafka_cluster.basic.api_version
    kind        = data.confluent_kafka_cluster.basic.kind

    environment {
      id = data.confluent_environment.workshop_env.id
    }
  }
}


resource "confluent_kafka_acl" "topic-consumer-read-on-topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.orders.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.topic-consumer.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.topic-manager-kafka-api-key.id
    secret = confluent_api_key.topic-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "topic-consumer-read-on-group" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "GROUP"
  resource_name = "confluent_cli_consumer_"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.topic-consumer.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.topic-manager-kafka-api-key.id
    secret = confluent_api_key.topic-manager-kafka-api-key.secret
  }
}
