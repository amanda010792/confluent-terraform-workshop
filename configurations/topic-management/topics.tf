
resource "confluent_kafka_topic" "orders" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  topic_name    = "orders"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.application-manager-kafka-api-key.id
    secret = confluent_api_key.application-manager-kafka-api-key.secret
  }
}
