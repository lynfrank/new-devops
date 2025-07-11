#!/bin/bash

# Met à jour les paquets
sudo apt-get update -y

# Installe les paquets nécessaires
sudo apt-get install -y netcat docker.io fontconfig openjdk-17-jre gnupg2 curl

# Active et démarre Docker
sudo systemctl enable docker
sudo systemctl start docker

# Ajoute la clé Jenkins et le dépôt
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Met à jour à nouveau les paquets pour Jenkins
sudo apt-get update -y

# Installe Jenkins
sudo apt-get install -y jenkins

# Ajoute Jenkins au groupe Docker
sudo usermod -aG docker jenkins

# Active et démarre Jenkins
sudo systemctl enable jenkins
sudo systemctl restart jenkins

# Attend que Jenkins soit disponible sur le port 8080
echo "⏳ Attente que Jenkins démarre sur le port 8080..."
while ! nc -z localhost 8080; do
  echo "⏱️ Jenkins pas encore prêt..."
  sleep 10
done

# Affiche le mot de passe initial admin Jenkins
echo "✅ Jenkins est prêt ! Voici le mot de passe admin Jenkins :"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
