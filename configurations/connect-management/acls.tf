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

  # The goal is to ensure that confluent_role_binding.application-manager-kafka-cluster-admin is created before
  # confluent_api_key.application-manager-kafka-api-key is used to create instances of
  # confluent_kafka_topic, confluent_kafka_acl resources.

  # 'depends_on' meta-argument is specified in confluent_api_key.application-manager-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic, confluent_kafka_acl resources instead.
  depends_on = [
    confluent_role_binding.connect-manager-kafka-cluster-admin
  ]
}

resource "confluent_service_account" "connect-consumer" {
  display_name = "connect-consumer"
  description  = "Service account to consume from 'orders' topic of 'inventory' Kafka cluster"
}

resource "confluent_api_key" "connect-consumer-kafka-api-key" {
  display_name = "connect-consumer-kafka-api-key"
  description  = "Kafka API Key that is owned by 'connect-consumer' service account"
  owner {
    id          = confluent_service_account.connect-consumer.id
    api_version = confluent_service_account.connect-consumer.api_version
    kind        = confluent_service_account.connect-consumer.kind
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

resource "confluent_kafka_acl" "connect-producer-write-on-topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = data.confluent_kafka_topic.orders.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.connect-producer.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.connect-manager-kafka-api-key.id
    secret = confluent_api_key.connect-manager-kafka-api-key.secret
  }
}


resource "confluent_service_account" "connect-producer" {
  display_name = "connect-producer"
  description  = "Service account to produce to 'orders' topic of 'inventory' Kafka cluster"
}

resource "confluent_api_key" "connect-producer-kafka-api-key" {
  display_name = "connect-producer-kafka-api-key"
  description  = "Kafka API Key that is owned by 'connect-producer' service account"
  owner {
    id          = confluent_service_account.connect-producer.id
    api_version = confluent_service_account.connect-producer.api_version
    kind        = confluent_service_account.connect-producer.kind
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

// Note that in order to consume from a topic, the principal of the consumer ('app-consumer' service account)
// needs to be authorized to perform 'READ' operation on both Topic and Group resources:
// confluent_kafka_acl.app-consumer-read-on-topic, confluent_kafka_acl.app-consumer-read-on-group.
// https://docs.confluent.io/platform/current/kafka/authorization.html#using-acls
resource "confluent_kafka_acl" "connect-consumer-read-on-topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = data.confluent_kafka_topic.orders.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.connect-consumer.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.connect-manager-kafka-api-key.id
    secret = confluent_api_key.connect-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "connect-consumer-read-on-group" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  resource_type = "GROUP"
  // The existing values of resource_name, pattern_type attributes are set up to match Confluent CLI's default consumer group ID ("confluent_cli_consumer_<uuid>").
  // https://docs.confluent.io/confluent-cli/current/command-reference/kafka/topic/confluent_kafka_topic_consume.html
  // Update the values of resource_name, pattern_type attributes to match your target consumer group ID.
  // https://docs.confluent.io/platform/current/kafka/authorization.html#prefixed-acls
  resource_name = "confluent_cli_consumer_"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connect-consumer.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.connect-manager-kafka-api-key.id
    secret = confluent_api_key.connect-manager-kafka-api-key.secret
  }
}

