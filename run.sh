#!/bin/bash

echo "======================================="
echo "Initializing Terraform..."
echo "======================================="
terraform init

echo "======================================="
echo "Validating Terraform Configuration..."
echo "======================================="
terraform validate

echo "======================================="
echo "Creating Terraform Execution Plan..."
echo "======================================="
terraform plan

echo "======================================="
echo "Applying Terraform Configuration..."
echo "======================================="
terraform apply -auto-approve

echo "======================================="
echo "Terraform Deployment Completed!"
echo "======================================="ls