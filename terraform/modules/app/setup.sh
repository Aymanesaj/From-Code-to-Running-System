#!/bin/bash
sudo yum update -y

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin git
sudo systemctl enable --now docker
sudo usermod -aG docker opc
echo "Docker installed at $(date)" > /home/opc/setup_complete.txt
git clone https://github.com/Aymanesaj/SysRun.git && cd SysRun && docker compose up -d