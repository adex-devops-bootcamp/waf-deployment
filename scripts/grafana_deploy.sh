#!/bin/bash
set -e

#----------------------------
# Update system
#----------------------------
echo "Updating system..."
sudo apt update -y
sudo apt upgrade -y


#----------------------------
# Pre-requisites Packages
#----------------------------
echo "Installing prerequisite packages..."
sudo apt-get install -y apt-transport-https wget gnupg


#----------------------------
# Import the GPG key:
#----------------------------
echo "Importing the GPG key"
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null


#----------------------------
# For stable releases
#----------------------------
echo "For Stable Releases"
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list


#-----------------------------------
# Update list of Available Packages
#-----------------------------------
echo "Updating the list of available packages"
sudo apt-get update


#----------------------------
# To install Grafana OSS
#----------------------------
echo "Installing Grafana"
sudo apt-get install grafana -y



#----------------------------
# Starting Grafana
#----------------------------
sudo systemctl start grafana-server
sudo systemctl enable grafana-server



#----------------------------
# Show access URL
#----------------------------
PUBLIC_IP=$(curl -s icanhazip.com)
echo "Grafana is running! Access it at: http://$PUBLIC_IP:3000"


