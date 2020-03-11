#!/bin/bash

# Upadate ubuntu and add gpg key
sudo apt-get update -y sudo apt-get upgrade -y
sudo apt-get install curl apt-transport-https lsb-release gpg -y
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

# Adding azure repo to ubuntu repo list

AZ_REPO=$(lsb_release -cs)            
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update -y
sudo apt-get install azure-cli azure-cli-core -y

az login 

# Create azure environemnt 
az group create -l eastus --n PyAzrg
az network vnet create -g PyAzrg -n azure-pytest-vnet --address-prefix 10.0.0.0/16 --subnet-name azure-pytest-subnet --subnet-prefix 10.0.0.0/24
az network public-ip create -g PyAzrg -n azpy1-ip --allocation-method Dynamic --version IPv4
az network nic create -g PyAzrg --vnet-name azure-pytest-vnet --subnet azure-pytest-subnet -n pyaz-nic1 --public-ip-address azpy1-ip
