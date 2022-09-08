terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.4.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

data "confluent_environment" "workshop_env" {
  id = var.confluent_cloud_env_id
}

data "confluent_kafka_cluster" "basic" {
  id = var.confluent_cloud_cluster_id
  environment {
    id = data.confluent_environment.workshop_env.id
  }
}

data "confluent_kafka_topic" "orders" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  topic_name    = "orders"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.connect-manager-kafka-api-key.id
    secret = confluent_api_key.connect-manager-kafka-api-key.secret
  }
}
