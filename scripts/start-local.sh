#!/bin/bash

# Build and run locally with Docker Compose
echo "Starting microservices locally..."

# Build Docker images
echo "Building Docker images..."
docker-compose build

# Start services
echo "Starting services..."
docker-compose up -d

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 10

# Health checks
echo "Checking service health..."
curl -s http://localhost:3000/health | jq
curl -s http://localhost:5000/health | jq

echo "Services are running!"
echo "Users Service: http://localhost:3000"
echo "Products Service: http://localhost:5000"
echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3001 (admin/admin)"
