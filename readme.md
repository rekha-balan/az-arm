# Azure Resouce Manager (ARM) Demo

Define the deployment variables used by the subsequent Azure CLI commands

```bash
resource_group=vmsa-us-west2
deployment_name=testdeployment
location=westus2
```

## Working with Azure Providers

Show the Azure providers for the subscription

```bash
az provider list --query "[].{Provider:namespace, Status:registrationState}"
```

Register the Azure Storage Provider

```bash
az provider register --namespace Microsoft.Storage
```

Show the Azure Storage Provider registration status

```bahs
az provider show -n Microsoft.Storage
```

## Working with Resource Tags

Download a QuickStart template to create an Azure Storage Account

```bash
wget https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json
```

Create a Resource Group to hold the storage account

```bash
az group create --name $resource_group --location $location
```

Deploy the template to create the storage account

```bash
az group deployment create --name $deployment_name --resource-group $resource_group --template-file azuredeploy.json
```

Show the storage accounts

```bash
az storage account list
```

Assign the name of the deployed storage account to a variable

```bash
storage_account=$(az storage account list --resource-group $resource_group --query [].name --output tsv)

az storage account show --resource-group $resource_group --name $storage_account
```

Add an "Environment" tag to the Resource Group and set the value to "Test"

```bash
az group update -n $resource_group --set tags.Environment=Test
```

Query for all Resource Group tags

```bash
az group show -n $resource_group --query tags
```

Find Resource Groups with the "Environment" tag set to "Test"

```bash
az group list --tag Environment=Test
```

Update the environment from "Test" to "Prod"

```bash
az group update -n $resource_group --set tags.Environment=Prod
```

Query for all Resource Group tags again

```bash
az group show -n $resource_group --query tags
```

Apply the tag from the Resource Group to its resource

```bash
jsontag=$(az group show -n $resource_group --query tags -o tsv)
t=$(echo $jsontag | tr -d '"{},' | sed 's/: /=/g')
r=$(az resource list -g $resource_group --query [].id --output tsv)
for resid in $r
do
    az resource tag --tags Environment=$t --id $resid
done
```

List resources with the "Prod" tag

```bash
az resource list --tag Environment=Prod
```

## Working with Resource Locks

Create a lock on the previously created storage account

```bash
az lock create --name LockStorageAccount --lock-type CanNotDelete --resource-group $resource_group --resource-name $storage_account --resource-type Microsoft.Storage/storageAccounts
```

Try to delete the resource group with the locked resource

```bash
az group delete -n $resource_group
```

Show all resource locks

```bash
az lock list
```

Remove the resource lock

```bash
lockid=$(az lock show --name LockStorageAccount --resource-group $resource_group --resource-type Microsoft.Storage/storageAccounts --resource-name $storage_account --output tsv --query id)

az lock delete --ids $lockid
```

Try to delete the resource group with the locked resource again'

```bash
az group delete -n $resource_group
```