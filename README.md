# Terraform-Azureresource-Module

This is a terraform Module for Azure Resources ,you can use this Module to create Azure Resources 

 ## **Usage**:
Using this below module we can create `resource group`,`storageaccount`,`virtual Networks`,`subnets`,`Linux web app`,`private end points`,`DNS records`.

module "azure_resources" {

    source = "github.com/jkond/Terraform-Azureresource-Module//azure-resources" 
    location = var.location
    az_resourcegroup_name  = var.az_resourcegroup_name
    
}

Use the above step in main.tf ,The above step creates resource group 

`NOTE: You need to have the other files like Provider.tf,variables.tf and terraform.tfvars (terraform.tfvars for env variables in this example it is dev.tfvars)`

## **Steps to Perform**

`terraform init` `(Needed when we add new modules and anytime if a new provider is added )`

`terraform plan --var-file .\dev.tfvars`

`terraform apply`
