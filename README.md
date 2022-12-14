# confluent-terraform-workshop

Use the Confluent Terraform provider to deploy and manage Confluent infrastructure. The Confluent Terraform provider automates the workflow for managing environments, Apache Kafka® clusters, Kafka topics, and other resources in Confluent Cloud.      

## pre-reqs 

###### login to confluent cloud 
```
confluent login --save
```


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
4. For Service Account, select "Create a New One" and name is <YOUR_NAME>-terraform-workshop-SA
5. Download your key
6. In the top right menu, select "Accounts & Access", select "Access" tab
7. Click on the organization and select "Add Role Assignment" 
8. Select the account you created (service account) and select "Organization Admin". Click Save

## run the initial setup of the cluster 

In the initial setup, you'll be provisioning the following resources: 
- A Basic Cluster (region and cloud provider can be altered in configurations/initial-setup/clusters.tf) 

And using the following data sources: 
- Cloud API Key and Secret (created above) 
- Environment (your choice, ID provided in environment variables)

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

In this step, you'll be provisioning the following resources: 
- Topic (called orders) 
- API Keys, Service Accounts and Access Control Lists (to grant necessary permissions)

And using the following data sources: 
- Basic Cluster (created above) 
- Cloud API Key and Secret (created above) 
- Environment (your choice, ID provided in environment variables)

change to the correct directory
```
cd ../topic-management
```
initialize the project 
```
terraform init
```
###### Set Environment Variables
Obtain the cluster id of the cluster you created in the previous section.     
We will need to set a specific name for the service account we use, as service accounts are at the environment level, so any clusters within an environment cannot have conflicting service account names. 

```
export TF_VAR_confluent_cloud_cluster_id="<CONFLUENT_CLOUD_CLUSTER_ID>" 
export TF_VAR_confluent_cloud_topic_manager_name="<YOUR_NAME>-topic-manager"
export TF_VAR_confluent_cloud_topic_consumer_name="<YOUR_NAME>-topic-consumer"
export TF_VAR_confluent_cloud_topic_producer_name="<YOUR_NAME>-topic-producer"
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


In this step, you'll be provisioning the following resources: 
- Datagen Source Connector 
- API Keys, Service Accounts and Access Control Lists (to grant necessary permissions)

And using the following data sources: 
- Basic Cluster (created above) 
- Cloud API Key and Secret (created above) 
- Environment (your choice, ID provided in environment variables)
- Topic (orders, created above) 

change to the correct directory
```
cd ../connect-management
```
initialize the project 
```
terraform init
```
###### Set Environment Variables
```
export TF_VAR_confluent_cloud_connect_manager_name="<YOUR_NAME>-connect-manager"
export TF_VAR_confluent_cloud_application_connector_name="<YOUR_NAME>-application-connector"
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

## Additional Resources!
[Confluent Provider on Terraform Registry](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs)     
[Confluent Terraform Provider Docs](https://docs.confluent.io/cloud/current/get-started/terraform-provider.html)     
[Confluent Example Configurations](https://github.com/confluentinc/terraform-provider-confluent/tree/master/examples/configurations)       
[Confluent Terraform Provider Webinar & Demo](https://www.confluent.io/resources/demo/confluent-terraform-provider-independent-network-lifecycle-management/?utm_source=linkedIn&utm_medium=organicsocial&utm_campaign=tm.social_cp.q3-bundle-launch)    

