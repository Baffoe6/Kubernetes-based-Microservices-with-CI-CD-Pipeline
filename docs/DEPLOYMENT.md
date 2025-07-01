# Deployment Guide

## Prerequisites

- Docker & Docker Compose
- Kubernetes cluster (minikube, k3s, EKS, GKE, AKS)
- Helm 3.x
- kubectl configured
- Node.js 18+ (for local development)
- Python 3.11+ (for local development)

## Local Development

### 1. Clone the Repository
```bash
git clone <repository-url>
cd microservices-project
```

### 2. Environment Setup
```bash
# Copy environment files
cp users-service/.env.example users-service/.env
cp products-service/.env.example products-service/.env
```

### 3. Start with Docker Compose
```bash
# Build and start all services
docker-compose up -d

# Check service health
curl http://localhost:3000/health
curl http://localhost:5000/health
```

### 4. Access Services
- Users Service: http://localhost:3000
- Products Service: http://localhost:5000
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3001 (admin/admin)

## Kubernetes Deployment

### Option 1: Using kubectl

```bash
# Create namespace
kubectl create namespace microservices

# Deploy databases
kubectl apply -f k8s/postgres.yaml
kubectl apply -f k8s/mongodb.yaml

# Deploy services
kubectl apply -f k8s/users-service.yaml
kubectl apply -f k8s/products-service.yaml

# Check deployment status
kubectl get pods -n microservices
```

### Option 2: Using Helm

```bash
# Deploy with Helm
helm install microservices ./helm/microservices \
  --namespace microservices \
  --create-namespace

# Check deployment
helm status microservices -n microservices
```

### Option 3: Using Scripts

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Deploy with kubectl
./scripts/deploy-k8s.sh

# Or deploy with Helm
./scripts/deploy-helm.sh
```

## Production Deployment

### 1. Container Registry Setup

Build and push images to your registry:

```bash
# Build images
docker build -t your-registry/users-service:v1.0.0 ./users-service
docker build -t your-registry/products-service:v1.0.0 ./products-service

# Push images
docker push your-registry/users-service:v1.0.0
docker push your-registry/products-service:v1.0.0
```

### 2. Update Helm Values

Edit `helm/microservices/values.yaml`:

```yaml
usersService:
  image:
    repository: your-registry/users-service
    tag: v1.0.0

productsService:
  image:
    repository: your-registry/products-service
    tag: v1.0.0
```

### 3. Deploy to Production

```bash
helm upgrade --install microservices ./helm/microservices \
  --namespace microservices \
  --create-namespace \
  --values helm/microservices/values-prod.yaml
```

## CI/CD Setup

### GitHub Actions

1. **Set up secrets** in your GitHub repository:
   - `DOCKER_USERNAME` - Docker Hub username
   - `DOCKER_PASSWORD` - Docker Hub password/token
   - `KUBE_CONFIG_STAGING` - Base64 encoded kubeconfig for staging
   - `KUBE_CONFIG_PRODUCTION` - Base64 encoded kubeconfig for production
   - `SLACK_WEBHOOK` - Slack webhook URL (optional)

2. **Workflow triggers:**
   - Push to `develop` branch → Deploy to staging
   - Push to `main` branch → Deploy to production
   - Pull requests → Run tests only

3. **Pipeline stages:**
   - Test both services
   - Build Docker images
   - Security scanning with Trivy
   - Deploy to staging/production
   - Health checks

### Jenkins Setup

For Jenkins CI/CD, create a pipeline using the Jenkinsfile:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Test') {
            parallel {
                stage('Users Service') {
                    steps {
                        dir('users-service') {
                            sh 'npm ci'
                            sh 'npm test'
                        }
                    }
                }
                stage('Products Service') {
                    steps {
                        dir('products-service') {
                            sh 'pip install -r requirements.txt'
                            sh 'pytest'
                        }
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    sh 'docker build -t users-service ./users-service'
                    sh 'docker build -t products-service ./products-service'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'helm upgrade --install microservices ./helm/microservices'
            }
        }
    }
}
```

## Monitoring Setup

### Prometheus Configuration

Prometheus is automatically configured to scrape metrics from:
- Kubernetes API server
- Node metrics
- Pod metrics
- Service endpoints

### Grafana Dashboards

Access Grafana at http://localhost:3001 (local) or your Grafana service URL.

Default credentials: admin/admin

Import dashboards for:
- Kubernetes cluster overview
- Service metrics
- Application performance

## Troubleshooting

### Common Issues

1. **Pods not starting:**
   ```bash
   kubectl describe pod <pod-name> -n microservices
   kubectl logs <pod-name> -n microservices
   ```

2. **Database connection issues:**
   ```bash
   kubectl exec -it <pod-name> -n microservices -- bash
   # Test database connectivity from inside the pod
   ```

3. **Service discovery issues:**
   ```bash
   kubectl get services -n microservices
   kubectl get endpoints -n microservices
   ```

4. **Image pull errors:**
   - Check image names and tags
   - Verify registry credentials
   - Ensure images exist in registry

### Health Checks

All services provide health check endpoints:
- `/health` - Basic health
- `/health/ready` - Readiness probe
- `/health/live` - Liveness probe

### Scaling

Scale services based on load:

```bash
# Scale users service
kubectl scale deployment users-service --replicas=5 -n microservices

# Scale with Helm
helm upgrade microservices ./helm/microservices \
  --set usersService.replicaCount=5 \
  --reuse-values
```

## Security Considerations

1. **Use secrets for sensitive data**
2. **Enable RBAC in Kubernetes**
3. **Use network policies**
4. **Regular security scanning**
5. **Update base images regularly**
6. **Use non-root containers**
7. **Enable resource limits**
