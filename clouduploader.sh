#!/bin/bash

# setup azure
setup() { 
    # Install az cli
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    # Login
    az login --use-device-code
    echo "You're logged in."
}

#List storage
list_storage() {
    az storage account list --output table --query "[].{name:name}"
}

# setup
echo "Welcome to clouduploader"

echo "Storage Accounts Available"
list_storage

read -p 'Storage Account you wish to upload: ' storageAccount

echo "Container Accounts Available"
az storage container list --account-name $storageAccount --output table --query "[].{name:name}"

read -p 'Container Account you wish to upload: ' myContainer

read -p 'File directory of the file you wish to upload: ' filepath
echo 'Checking if file exists...'

if [ -f "$filepath" ]
then
    echo 'File valid. We will proceed uploading the file into Azure. '
    az storage azcopy blob upload -c $myContainer --account-name $storageAccount -s "$filepath"

    echo "Completed"
    echo 'Current blob list in:'
    echo "$myContainer"

    az storage blob list \
    --container $myContainer \
    --account-name $storageAccount \
    --output table \
    --auth-mode login

else 
    echo 'File not found. Please retry again. Program will exit...' 
fi 
