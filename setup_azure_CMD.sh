#!/bin/bash

#Set variables
PROJECT_DIR="$HOME/azureautomation/"
SUBSCRIPTION="Internal-susaha"

# Upadate ubuntu and add gpg key
sudo apt-get update -y sudo apt-get upgrade -y
sudo apt-get install curl apt-transport-https lsb-release gpg -y
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

# Adding azure repo to ubuntu repo list

AZ_REPO=$(lsb_release -cs)            
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update -y

# Installing tools 
sudo apt install python3-pip git
pip3 install virtualenv  

#setup virtualenv
cd $PROJECT_DIR
VIRTENV="$HOME/.local/bin/virtualenv"
$VIRTENV mytestenv 
source mytestenv/bin/activate
pip3 install azure azure-cli-core

#connect azure subscriptions
az login 

# Lookup subscription status and default subscriptions
az account list --output table
az account set --subscription  $SUBSCRIPTION
az ad sp create-for-rbac --sdk-auth

# Create azure environemnt 
az group create -l eastus --n PyAzrg
az network vnet create -g PyAzrg -n azure-pytest-vnet --address-prefix 10.0.0.0/16 --subnet-name azure-pytest-subnet --subnet-prefix 10.0.0.0/24
az network public-ip create -g PyAzrg -n azpy1-ip --allocation-method Dynamic --version IPv4
az network nic create -g PyAzrg --vnet-name azure-pytest-vnet --subnet azure-pytest-subnet -n pyaz-nic1 --public-ip-address azpy1-ip

# Deploying VM
pwd && ls -la
/usr/bin/python3 $PROJECT_DIR/compute.py
az vm list --resource-group PyAzrg
