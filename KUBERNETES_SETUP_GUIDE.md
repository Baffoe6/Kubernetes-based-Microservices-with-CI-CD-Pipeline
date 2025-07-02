# Kubernetes Setup Guide for Windows

This guide will help you set up a local Kubernetes environment to test your microservices deployment.

## Option 1: Docker Desktop with Kubernetes (Recommended for Windows)

### Prerequisites
- Docker Desktop for Windows installed
- At least 4GB RAM allocated to Docker
- WSL2 enabled (recommended)

### Steps:
1. **Start Docker Desktop**
   - Open Docker Desktop application
   - Wait for it to fully start (Docker icon should be green)

2. **Enable Kubernetes in Docker Desktop**
   - Click on Docker Desktop icon in system tray
   - Go to Settings → Kubernetes
   - Check "Enable Kubernetes"
   - Click "Apply & Restart"
   - Wait for Kubernetes to start (status should show "Running")

3. **Verify Installation**
   ```powershell
   kubectl cluster-info
   kubectl get nodes
   ```

4. **Set Context (if needed)**
   ```powershell
   kubectl config use-context docker-desktop
   ```

## Option 2: Minikube

### Installation:
```powershell
# Install using Chocolatey
choco install minikube

# Or download manually from: https://minikube.sigs.k8s.io/docs/start/
```

### Start Minikube:
```powershell
# Start with default driver
minikube start

# Or with specific driver (recommended)
minikube start --driver=hyperv
# or
minikube start --driver=docker
```

### Verify:
```powershell
kubectl cluster-info
minikube status
```

## Option 3: Kind (Kubernetes in Docker)

### Installation:
```powershell
# Install using Chocolatey
choco install kind

# Or download from: https://kind.sigs.k8s.io/docs/user/quick-start/
```

### Create Cluster:
```powershell
kind create cluster --name microservices
kubectl cluster-info --context kind-microservices
```

## After Kubernetes Setup

### 1. Install Helm (if not already installed)
```powershell
# Using Chocolatey
choco install kubernetes-helm

# Or using Scoop
scoop install helm
```

### 2. Verify Everything Works
```powershell
kubectl get nodes
kubectl get namespaces
helm version
```

### 3. Deploy Your Microservices

#### Option A: Using Helm (Recommended)
```powershell
# Navigate to your project directory
cd "C:\Users\BAFFO\Downloads\Kubernetes based Microservices with CICD Pipeline"

# Deploy with Helm
helm install microservices ./helm/microservices
```

#### Option B: Using kubectl
```powershell
# Deploy all manifests
kubectl apply -f k8s/

# Check deployment status
kubectl get pods
kubectl get services
```

### 4. Access Services
```powershell
# Port forward to access services locally
kubectl port-forward service/users-service 3000:3000
kubectl port-forward service/products-service 5000:5000

# Or use minikube service (if using minikube)
minikube service users-service --url
minikube service products-service --url
```

## Troubleshooting

### Common Issues:

1. **"The connection to the server localhost:8080 was refused"**
   - Kubernetes is not running
   - Solution: Start Docker Desktop Kubernetes or minikube

2. **"error: You must be logged in to the server (Unauthorized)"**
   - Context not set properly
   - Solution: `kubectl config use-context docker-desktop`

3. **Docker Desktop not starting**
   - Restart Docker Desktop
   - Check Windows features: Hyper-V, WSL2
   - Increase resource allocation

4. **Pods stuck in Pending**
   - Not enough resources
   - Solution: Increase Docker memory/CPU limits

### Useful Commands:
```powershell
# Check cluster status
kubectl cluster-info

# List all contexts
kubectl config get-contexts

# Switch context
kubectl config use-context docker-desktop

# Check pods in all namespaces
kubectl get pods --all-namespaces

# Describe a pod for troubleshooting
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Delete all resources
kubectl delete -f k8s/
# or
helm uninstall microservices
```

## What to Do Next

1. Choose one of the Kubernetes options above
2. Set up the cluster
3. Test with `kubectl cluster-info`
4. Deploy your microservices
5. Test the deployment with port-forwarding or service URLs

The easiest option for Windows is **Docker Desktop with Kubernetes enabled**.
