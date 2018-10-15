#!/bin/bash

resource_group=storage1-us-west2
deployment_name=testdeployment
location=westus2

echo
echo
echo "Define the deployment variables used by the subsequent Azure CLI commands"
echo
echo "resource_group=$resource_group"
echo "deployment_name=$deployment_name"
echo "location=$location"
read -n1 -r -p 'Press any key...' key

echo
echo
echo 'Working with Azure Providers'
echo
echo 'Show the Azure providers for the subscription'
echo
echo 'az provider list --query "[].{Provider:namespace, Status:registrationState}"'
read -n1 -r -p 'Press any key...' key

az provider list --query "[].{Provider:namespace, Status:registrationState}"

echo
echo
echo 'Register the Azure Storage Provider'
echo
echo 'az provider register --namespace Microsoft.Storage'
read -n1 -r -p 'Press any key...' key

az provider register --namespace Microsoft.Storage

echo
echo
echo 'Show the Azure Storage Provider registration status'
echo
echo 'az provider show -n Microsoft.Storage'
read -n1 -r -p 'Press any key...' key

az provider show -n Microsoft.Storage

echo
echo
echo 'Working with Resource Tags'
echo
echo 'Download a QuickStart template to create an Azure Storage Account'
echo
echo 'wget https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json'
read -n1 -r -p 'Press any key...' key

wget https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json

echo
echo
echo 'Create a Resource Group to hold the storage account'
echo
echo 'az group create --name $resource_group --location $location'
read -n1 -r -p 'Press any key...' key

az group create --name $resource_group --location $location

echo
echo
echo 'Deploy the template to create the storage account'
echo
echo 'az group deployment create --name $deployment_name --resource-group $resource_group --template-file azuredeploy.json'
read -n1 -r -p 'Press any key...' key

az group deployment create --name $deployment_name --resource-group $resource_group --template-file azuredeploy.json

echo
echo
echo 'Show the storage accounts'
echo
echo 'az storage account list'
read -n1 -r -p 'Press any key...' key

az storage account list

echo
echo
echo 'Assign the name of the deployed storage account to a variable'
echo
echo 'storage_account=$(az storage account list --resource-group $resource_group --query [].name --output tsv)'
read -n1 -r -p 'Press any key...' key

storage_account=$(az storage account list --resource-group $resource_group --query [].name --output tsv)

az storage account show --resource-group $resource_group --name $storage_account

echo
echo
echo 'Add an "Environment" tag to the Resource Group and set the value to "test"'
echo
echo 'az group update -n $resource_group --set tags.Environment=Test'
read -n1 -r -p 'Press any key...' key

az group update -n $resource_group --set tags.Environment=Test

echo
echo
echo 'Query for all Resource Group tags'
echo
echo 'az group show -n $resource_group --query tags'
read -n1 -r -p 'Press any key...' key

az group show -n $resource_group --query tags

echo
echo
echo 'Find Resource Groups with the "Environment" tag set to "Test"'
echo
echo 'az group list --tag Environment=Test'
read -n1 -r -p 'Press any key...' key

echo
az group list --tag Environment=Test

echo
echo
echo 'Update the environment from "Test" to "Prod"'
echo
echo 'az group update -n $resource_group --set tags.Environment=Prod'
read -n1 -r -p 'Press any key...' key

az group update -n $resource_group --set tags.Environment=Prod

echo
echo
echo 'Query for all Resource Group tags again'
echo
echo 'az group show -n $resource_group --query tags'
read -n1 -r -p 'Press any key...' key

echo
az group show -n $resource_group --query tags

echo
echo
echo 'Apply the tag from the Resource Group to its resource'
echo
echo 'jsontag=$(az group show -n $resource_group --query tags -o tsv)'
echo 't=$(echo $jsontag | tr -d "{}, | sed s/: /=/g)'
echo 'r=$(az resource list -g $resource_group --query [].id --output tsv)'
echo 'for resid in $r'
echo 'do'
echo     'az resource tag --tags Environment=$t --id $resid'
echo 'done'
read -n1 -r -p 'Press any key...' key

jsontag=$(az group show -n $resource_group --query tags -o tsv)
t=$(echo $jsontag | tr -d '"{},' | sed 's/: /=/g')
r=$(az resource list -g $resource_group --query [].id --output tsv)
for resid in $r
do
    az resource tag --tags Environment=$t --id $resid
done

echo
echo
echo 'List resources with the "Prod" tag'
echo
echo 'az resource list --tag Environment=Prod'
read -n1 -r -p 'Press any key...' key

echo
az resource list --tag Environment=Prod

echo
echo
echo 'Working with Resource Locks'
echo
echo 'Create a lock on the previously created storage account'
echo
echo 'az lock create --name LockStorageAccount --lock-type CanNotDelete --resource-group $resource_group --resource-name $storage_account --resource-type Microsoft.Storage/storageAccounts'
read -n1 -r -p 'Press any key...' key

az lock create --name LockStorageAccount --lock-type CanNotDelete --resource-group $resource_group --resource-name $storage_account --resource-type Microsoft.Storage/storageAccounts

echo
echo
echo 'Try to delete the resource group with the locked resource'
echo
echo 'az group delete -n $resource_group'
read -n1 -r -p 'Press any key...' key

az group delete -n $resource_group

echo
echo
echo 'Show all resource locks'
echo
echo 'az lock list'
read -n1 -r -p 'Press any key...' key

az lock list

echo
echo
echo 'Remove the resource lock'
echo
echo 'lockid=$(az lock show --name LockStorageAccount --resource-group $resource_group --resource-type Microsoft.Storage/storageAccounts --resource-name $storage_account --output tsv --query id)'
echo 'az lock delete --ids $lockid'
read -n1 -r -p 'Press any key...' key

lockid=$(az lock show --name LockStorageAccount --resource-group $resource_group --resource-type Microsoft.Storage/storageAccounts --resource-name $storage_account --output tsv --query id)

az lock delete --ids $lockid

echo
echo
echo 'Try to delete the resource group with the locked resource'
echo
echo 'az group delete -n $resource_group'
read -n1 -r -p 'Press any key...' key

az group delete -n $resource_group