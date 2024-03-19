#!/bin/bash

##################################################################################################
# Fresh install script.                                                                          #
##################################################################################################
echo " "
echo " "
echo " "
# System Update
echo "----------------------------------------------------------------"
echo "Commence System Update"
echo "----------------------------------------------------------------"
sudo apt update
echo "----------------------------------------------------------------"
echo "System Update Completed"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# Install Nala
echo "----------------------------------------------------------------"
echo "Install Nala"
echo "----------------------------------------------------------------"
sudo apt install nala -y
echo "----------------------------------------------------------------"
echo "Install Nala Completed"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# Install other tools
echo "----------------------------------------------------------------"
echo "Install other tools"
echo "----------------------------------------------------------------"
sudo nala install curl -y
sudo nala install gpg -y
sudo nala install wget -y
echo "----------------------------------------------------------------"
echo "Install tools Completed"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# System Upgrade
echo "----------------------------------------------------------------"
echo "Commence System Upgrade"
echo "----------------------------------------------------------------"
sudo nala update && sudo nala upgrade -y
echo "----------------------------------------------------------------"
echo "System Upgrade Completed"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# Install Homebridge
echo "----------------------------------------------------------------"
echo "Install Homebridge"
echo "----------------------------------------------------------------"
curl -sSfL https://repo.homebridge.io/KEY.gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/homebridge.gpg  > /dev/null
echo "deb [signed-by=/usr/share/keyrings/homebridge.gpg] https://repo.homebridge.io stable main" | sudo tee /etc/apt/sources.list.d/homebridge.list > /dev/null
sudo nala update
sudo nala install homebridge -y
sudo hb-service update-node
echo "----------------------------------------------------------------"
echo "Homebridge install Completed"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# Docker setup
echo "----------------------------------------------------------------"
echo "Commence Docker Setup"
echo "----------------------------------------------------------------"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh &&
sudo usermod -aG docker dennis
echo "----------------------------------------------------------------"
echo "Docker Setup Completed"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# Portainer setup
echo "----------------------------------------------------------------"
echo "Commence Portainer Setup"
echo "----------------------------------------------------------------"
sudo docker run -d -p 9000:9000 --name=portainer --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
echo "----------------------------------------------------------------"
echo "Portainer Interface is reachable at homebridge.local:9000"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# Watch Tower setup
echo "----------------------------------------------------------------"
echo "Commence Watch Tower Setup"
echo "----------------------------------------------------------------"
sudo docker run --name="watchtower" -d --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo "----------------------------------------------------------------"
echo "Watch Tower Setup Completed"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# MQTT Install
echo "----------------------------------------------------------------"
echo "Commence MQTT Setup"
echo "----------------------------------------------------------------"
sudo mkdir mosquitto &&
sudo mkdir mosquitto/config/ &&
sudo mkdir mosquitto/data/ &&
sudo wget https://raw.githubusercontent.com/EddieDSuza/maxilife/main/mosquitto.conf -P /home/dennis/mosquitto/config/ &&
sudo docker run -it --name MQTT --restart unless-stopped --net=host -tid -p 1883:1883 -v $(pwd)/mosquitto:/mosquitto/ eclipse-mosquitto
echo "----------------------------------------------------------------"
echo "MQTT Setup Completed"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# Z2M setup
echo "----------------------------------------------------------------"
echo "Commence Zigbee2MQTT Setup"
echo "----------------------------------------------------------------"
wget https://raw.githubusercontent.com/EddieDSuza/techwitheddie/main/configuration.yaml -P data
echo " "
sudo docker run --name zigbee2mqtt --device=/dev/ttyUSB0 --net host --restart unless-stopped -v $(pwd)/data:/app/data -v /run/udev:/run/udev:ro -e TZ=Asia/Dubai koenkk/zigbee2mqtt
echo "----------------------------------------------------------------"
echo "Z2M Interface is reachable at homebridge.local:8081"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# scrypted setup
echo "----------------------------------------------------------------"
echo "Commence Scrypted Setup"
echo "----------------------------------------------------------------"
sudo docker run --name="scrypted" --network host -d --restart unless-stopped -v ~/.scrypted/volume:/server/volume koush/scrypted
echo "----------------------------------------------------------------"
echo "Scrypted Interface is reachable at homebridge.local:10443 or port 11080"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# HEIMDALL setup
echo "----------------------------------------------------------------"
echo "Commence HEIMDALL Setup"
echo "----------------------------------------------------------------"
sudo mkdir /home/kodestar &&
sudo mkdir /home/kodestar/docker
echo " "
sudo docker run --name=heimdall -d --restart unless-stopped -v /home/kodestar/docker/heimdall:/config -e PGID=1000 -e PUID=1000 -p 8201:80 -p 8200:443 linuxserver/heimdall
echo " "
echo "----------------------------------------------------------------"
echo "HEIMDALL Interface is reachable at homebridge.local:8201"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
# CasaOS setup
echo "----------------------------------------------------------------"
echo "Commence CASAOS Setup"
echo "----------------------------------------------------------------"
echo " "
curl -fsSL https://get.casaos.io | sudo bash
echo "----------------------------------------------------------------"
echo "CasaOS installation complete"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
echo "----------------------------------------------------------------"
echo "ALL PACKAGES INSTALLED WITH NO ERRORS"
echo "----------------------------------------------------------------"
echo " "
echo " "
echo " "
echo "Rebooting Now"
sudo reboot
