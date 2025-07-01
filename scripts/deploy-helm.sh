#!/bin/bash

# Deploy using Helm
echo "Deploying with Helm..."

# Add Helm repositories (if needed)
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo update

# Install or upgrade the release
helm upgrade --install microservices ./helm/microservices \
  --namespace microservices \
  --create-namespace \
  --wait \
  --timeout 10m

echo "Helm deployment complete!"
echo "Check status with: helm status microservices -n microservices"
