#!/bin/bash

LOG_FILE="/var/log/install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Début de l'installation à $(date)"

apt-get update
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
echo "deb [signed-by=/usr/share/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
apt-get update
apt-get install -y fontconfig openjdk-17-jre jenkins

usermod -aG docker jenkins

systemctl enable jenkins
systemctl restart jenkins
