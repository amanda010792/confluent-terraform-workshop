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

variable "confluent_cloud_connect_manager_name" {
  description = "Confluent Cloud Connect Manager Service Account Name"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_application_connector_name" {
  description = "Confluent Cloud Application Connector Service Account Name"
  type        = string
  sensitive   = true
}
