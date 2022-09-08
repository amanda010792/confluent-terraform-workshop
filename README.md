# confluent-terraform-workshop
workshop for deploying resources via confluent terraform provider

## pre-reqs 

###### Ensure Terraform 0.14+ is installed

Install Terraform version manager [tfutils/tfenv](https://github.com/tfutils/tfenv)

Alternatively, install the [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli?_ga=2.42178277.1311939475.1662583790-739072507.1660226902#install-terraform)

To ensure you're using the acceptable version of Terraform you may run the following command:
```
terraform version
```
Your output should resemble: 
```
Terraform v0.14.0 # any version >= v0.14.0 is OK
```
###### Create a Cloud API Key 

1. Open the Confluent Cloud Console
2. In the top right menu, select "Cloud API Keys"
3. Choose "Add Key" and select "Granular Access"
4. For Service Account, select "Create a New One" and name is <yourname>-terraform-workshop-SA
5. Download your key
6. In the top right menu, select "Accounts & Access", select "Access" tab
7. Click on the organization and select "Add Role Assignment" 
8. Select the account you created (service account) and select "Organization Admin". Click Save

## run the initial setup of the cluster 

change to the correct directory
```
cd configurations/initial-setup
```
initialize the project 
```
terraform init
```

###### Set Environment Variables

```
export TF_VAR_confluent_cloud_api_key="<CONFLUENT_CLOUD_API_KEY>"
export TF_VAR_confluent_cloud_api_secret="<CONFLUENT_CLOUD_API_SECRET>" 
export TF_VAR_confluent_cloud_env_id="<CONFLUENT_CLOUD_ENVIRONMENT_ID>" 
export TF_VAR_confluent_cloud_cluster_name="<YOUR_NAME>_inventory"
```

###### Deploy initial cluster

validate the terraform configs 
```
terraform validate
```
deploy the terraform planned resources
```
terraform apply
```

## deploy topics and associated acls to cluster  

change to the correct directory
```
cd configurations/topic-management
```
initialize the project 
```
terraform init
```
###### Set Environment Variables
obtain the cluster id of the cluster you created in the previous section
we will need to set a specific name for the service account we use, as service accounts are at the environment level, so any clusters within an environment cannot have conflicting service account names. 

```
export TF_VAR_confluent_cloud_cluster_id="<CONFLUENT_CLOUD_CLUSTER_ID>" 
export TF_VAR_confluent_cloud_topic_manager_name="<CONFLUENT_CLOUD_TOPIC_MANAGER_NAME>"
export TF_VAR_confluent_cloud_topic_consumer_name="<CONFLUENT_CLOUD_TOPIC_CONSUMER_NAME>"
export TF_VAR_confluent_cloud_topic_producer_name="<CONFLUENT_CLOUD_TOPIC_PRODUCER_NAME>"
```
###### Deploy topic and ACLs cluster

validate the terraform configs 
```
terraform validate
```
deploy the terraform planned resources
```
terraform apply
```
## deploy connectors and associated acls to cluster

change to the correct directory
```
cd configurations/connect-management
```
initialize the project 
```
terraform init
```
###### Set Environment Variables
```
export TF_VAR_confluent_cloud_connect_manager_name="<CONFLUENT_CLOUD_CONNECT_MANAGER_NAME>"
export TF_VAR_confluent_cloud_application_connector_name="<CONFLUENT_CLOUD_APPLICATION_CONNECTOR_NAME>"
```

###### Deploy topic and ACLs cluster

validate the terraform configs 
```
terraform validate
```
deploy the terraform planned resources
```
terraform apply
```
  
## destroy resources 
  
in configurations/connect-management run: 
```
terraform destroy
```
in configurations/topic-management run: 
```
terraform destroy
```
in configurations/initial-setup run: 
```
terraform destroy
```
