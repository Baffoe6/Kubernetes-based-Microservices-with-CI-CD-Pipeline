# Kubernetes-based Microservices with CI/CD Pipeline

This project demonstrates a complete microservices architecture using modern DevOps practices.

## Architecture Overview

- **Users Service**: REST API for user management (Node.js)
- **Products Service**: REST API for product management (Python/Flask)
- **Database**: PostgreSQL for users, MongoDB for products
- **Orchestration**: Kubernetes
- **Packaging**: Helm charts
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus + Grafana

## Services

### Users Service (Node.js)
- Port: 3000
- Database: PostgreSQL
- Endpoints:
  - GET /users
  - POST /users
  - GET /users/:id
  - PUT /users/:id
  - DELETE /users/:id

### Products Service (Python/Flask)
- Port: 5000
- Database: MongoDB
- Endpoints:
  - GET /products
  - POST /products
  - GET /products/:id
  - PUT /products/:id
  - DELETE /products/:id

## Quick Start

### Prerequisites
- Docker & Docker Compose
- Kubernetes cluster (minikube, k3s, or cloud provider)
- Helm 3
- kubectl

### Local Development
```bash
# Start services with Docker Compose
docker-compose up -d

# Access services
curl http://localhost:3000/users
curl http://localhost:5000/products
```

### Kubernetes Deployment
```bash
# Deploy with Helm
helm install microservices ./helm/microservices

# Or deploy with kubectl
kubectl apply -f k8s/
```

## Project Structure
```
.
├── users-service/          # Node.js users microservice
├── products-service/       # Python products microservice
├── k8s/                   # Kubernetes manifests
├── helm/                  # Helm charts
├── .github/workflows/     # GitHub Actions CI/CD
├── monitoring/            # Prometheus & Grafana configs
├── docker-compose.yml     # Local development
└── README.md
```

## CI/CD Pipeline

The GitHub Actions pipeline:
1. Runs tests for both services
2. Builds Docker images
3. Pushes to container registry
4. Deploys to Kubernetes cluster
5. Runs health checks

## Monitoring

- **Prometheus**: Metrics collection
- **Grafana**: Visualization dashboards
- **Health checks**: Liveness and readiness probes
