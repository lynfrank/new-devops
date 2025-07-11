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

mkdir -p /var/lib/jenkins/init.groovy.d

cat <<EOF > /var/lib/jenkins/init.groovy.d/basic-security.groovy
import jenkins.model.*
import hudson.security.*
import jenkins.install.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("paul", "Justice2024!")
instance.setSecurityRealm(hudsonRealm)

def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "paul")
instance.setAuthorizationStrategy(strategy)

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
instance.save()
EOF

chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d

systemctl enable jenkins
systemctl restart jenkins
