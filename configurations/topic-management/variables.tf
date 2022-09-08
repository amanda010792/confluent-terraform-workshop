variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_env_id" {
  description = "Confluent Cloud Environment ID"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_cluster_id" {
  description = "Confluent Cloud Cluster ID (cluster created in initial setup)"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_topic_manager_sa_name" {
  description = "Confluent Cloud Topic Manager SA Name"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_topic_consumer_name" {
  description = "Confluent Cloud Topic Consumer SA Name"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_topic_producer_name" {
  description = "Confluent Cloud Topic Producer SA Name"
  type        = string
  sensitive   = true
}
