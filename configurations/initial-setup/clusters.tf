data "confluent_environment" "workshop_env" {
  id = var.confluent_cloud_env_id
}

# Update the config to use a cloud provider and region of your choice.
# https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster
resource "confluent_kafka_cluster" "basic" {
  display_name = var.confluent_cloud_cluster_name
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2"
  basic {}
  environment {
    id = data.confluent_environment.workshop_env.id
  }
}
