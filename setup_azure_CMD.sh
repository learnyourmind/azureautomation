#!/bin/bash

# Upadate ubuntu and add gpg key
sudo apt-get update -y sudo apt-get upgrade -y
sudo apt-get install curl apt-transport-https lsb-release gpg -y
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

# Adding azure repo to ubuntu repo list

AZ_REPO=$(lsb_release -cs)            
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update
sudo apt-get install azure-cli
az login

