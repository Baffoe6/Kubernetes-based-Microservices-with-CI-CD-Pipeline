#!/bin/bash

# Deploy to Kubernetes using kubectl
echo "Deploying to Kubernetes..."

# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy databases
kubectl apply -f k8s/postgres.yaml
kubectl apply -f k8s/mongodb.yaml

# Wait for databases to be ready
echo "Waiting for databases..."
kubectl wait --for=condition=ready pod -l app=postgres -n microservices --timeout=300s
kubectl wait --for=condition=ready pod -l app=mongodb -n microservices --timeout=300s

# Deploy services
kubectl apply -f k8s/users-service.yaml
kubectl apply -f k8s/products-service.yaml

# Wait for services to be ready
echo "Waiting for services..."
kubectl wait --for=condition=ready pod -l app=users-service -n microservices --timeout=300s
kubectl wait --for=condition=ready pod -l app=products-service -n microservices --timeout=300s

echo "Deployment complete!"
echo "Get service URLs with: kubectl get services -n microservices"
