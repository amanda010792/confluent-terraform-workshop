data "confluent_environment" "workshop_env" {
  id = var.confluent_cloud_env_id
}

data "confluent_kafka_cluster" "workshop_cluster" {
  id = var.confluent_cloud_cluster_id
  environment {
    id = data.confluent_cloud_env_id
  }
}



resource "confluent_kafka_topic" "orders" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  topic_name    = "orders"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}
