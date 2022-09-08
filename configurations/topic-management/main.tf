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
    id = data.confluent_environment.workshop_env
  }
}
