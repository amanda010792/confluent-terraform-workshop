resource "confluent_connector" "source" {
  environment {
    id = data.confluent_environment.workshop_env.id
  }
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }

  config_sensitive = {}

  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "DatagenSourceConnector_0"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.application-connector.id
    "kafka.topic"              = data.confluent_kafka_topic.orders.topic_name
    "output.data.format"       = "JSON"
    "quickstart"               = "ORDERS"
    "tasks.max"                = "1"
  }

  depends_on = [
    confluent_kafka_acl.application-connector-describe-on-cluster,
    confluent_kafka_acl.application-connector-write-on-target-topic,
    confluent_kafka_acl.application-connector-create-on-data-preview-topics,
    confluent_kafka_acl.application-connector-write-on-data-preview-topics,
  ]
}
