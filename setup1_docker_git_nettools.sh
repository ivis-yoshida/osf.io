#!/bin/bash

echo "Dockerインストール"
# 参考（https://docs.docker.com/install/linux/docker-ce/ubuntu/）
sudo apt-get -y remove docker docker-engine docker.io containerd runc
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo apt-cache madison docker-ce

echo "Dockerデーモン起動"
sudo systemctl start docker

echo "Dockerデーモンの自動起動設定の有効化"
sudo systemctl enable docker

echo "Docker Composeインストール"
# 参考（https://docs.docker.com/compose/install/）
sudo apt-get -y update
sudo curl -L https://github.com/docker/compose/releases/download/1.25.1-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Docker非sudo対応"
sudo groupadd docker
sudo systemctl restart docker
sudo gpasswd -a $USER docker

echo "Gitインストール"
sudo apt-get -y install git

echo "net-toolsインストール"
sudo apt install net-tools

echo "Docker非sudo対応の反映のためにシステム再起動"
sudo reboot

