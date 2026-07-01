#!/bin/bash

set -e

echo "============================"
echo " Updating system packages"
echo "============================"

sudo apt update -y

echo "============================"
echo " Installing Java (OpenJDK 21)"
echo "============================"

sudo apt install -y fontconfig openjdk-21-jre

java -version

echo "============================"
echo " Adding Jenkins repository key"
echo "============================"

sudo mkdir -p /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "============================"
echo " Adding Jenkins repo"
echo "============================"

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "============================"
echo " Updating package index"
echo "============================"

sudo apt update -y

echo "============================"
echo " Installing Jenkins"
echo "============================"

sudo apt install -y jenkins

echo "============================"
echo " Starting Jenkins service"
echo "============================"

sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "============================"
echo " Jenkins installation completed"
echo " Access: http://<EC2-PUBLIC-IP>:8080"
echo "============================"