# Kubernetes Setup Assistant for Windows
# This script helps you set up a local Kubernetes environment

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("docker-desktop", "minikube", "kind")]
    [string]$Platform = "docker-desktop"
)

Write-Host "=== Kubernetes Setup Assistant ===" -ForegroundColor Cyan
Write-Host "Platform: $Platform" -ForegroundColor Yellow
Write-Host ""

function Test-DockerRunning {
    try {
        docker info > $null 2>&1
        return $true
    } catch {
        return $false
    }
}

function Test-KubernetesRunning {
    try {
        kubectl cluster-info > $null 2>&1
        return $true
    } catch {
        return $false
    }
}

function Setup-DockerDesktop {
    Write-Host "Setting up Docker Desktop Kubernetes..." -ForegroundColor Green
    
    if (-not (Test-DockerRunning)) {
        Write-Host "❌ Docker Desktop is not running!" -ForegroundColor Red
        Write-Host "Please start Docker Desktop first, then run this script again." -ForegroundColor Yellow
        Write-Host "To enable Kubernetes:" -ForegroundColor Yellow
        Write-Host "1. Right-click Docker Desktop icon in system tray" -ForegroundColor Gray
        Write-Host "2. Go to Settings → Kubernetes" -ForegroundColor Gray
        Write-Host "3. Check 'Enable Kubernetes'" -ForegroundColor Gray
        Write-Host "4. Click 'Apply & Restart'" -ForegroundColor Gray
        return $false
    }
    
    Write-Host "✅ Docker is running" -ForegroundColor Green
    
    if (Test-KubernetesRunning) {
        Write-Host "✅ Kubernetes is already running!" -ForegroundColor Green
        kubectl config use-context docker-desktop
        return $true
    } else {
        Write-Host "❌ Kubernetes is not enabled in Docker Desktop" -ForegroundColor Red
        Write-Host "Please enable Kubernetes in Docker Desktop settings" -ForegroundColor Yellow
        return $false
    }
}

function Setup-Minikube {
    Write-Host "Setting up Minikube..." -ForegroundColor Green
    
    # Check if minikube is installed
    try {
        minikube version > $null 2>&1
    } catch {
        Write-Host "❌ Minikube is not installed!" -ForegroundColor Red
        Write-Host "Install with: choco install minikube" -ForegroundColor Yellow
        return $false
    }
    
    Write-Host "✅ Minikube is installed" -ForegroundColor Green
    
    # Start minikube
    Write-Host "Starting minikube cluster..." -ForegroundColor Yellow
    minikube start --driver=docker
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Minikube started successfully!" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ Failed to start minikube" -ForegroundColor Red
        return $false
    }
}

function Setup-Kind {
    Write-Host "Setting up Kind..." -ForegroundColor Green
    
    # Check if kind is installed
    try {
        kind version > $null 2>&1
    } catch {
        Write-Host "❌ Kind is not installed!" -ForegroundColor Red
        Write-Host "Install with: choco install kind" -ForegroundColor Yellow
        return $false
    }
    
    Write-Host "✅ Kind is installed" -ForegroundColor Green
    
    # Create cluster
    Write-Host "Creating kind cluster..." -ForegroundColor Yellow
    kind create cluster --name microservices
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Kind cluster created successfully!" -ForegroundColor Green
        kubectl config use-context kind-microservices
        return $true
    } else {
        Write-Host "❌ Failed to create kind cluster" -ForegroundColor Red
        return $false
    }
}

function Test-Setup {
    Write-Host "`n=== Testing Kubernetes Setup ===" -ForegroundColor Cyan
    
    Write-Host "Testing kubectl connection..." -ForegroundColor Yellow
    kubectl cluster-info
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ kubectl is working!" -ForegroundColor Green
    } else {
        Write-Host "❌ kubectl connection failed" -ForegroundColor Red
        return $false
    }
    
    Write-Host "`nChecking nodes..." -ForegroundColor Yellow
    kubectl get nodes
    
    Write-Host "`nChecking current context..." -ForegroundColor Yellow
    kubectl config current-context
    
    return $true
}

function Install-Helm {
    Write-Host "`n=== Installing Helm ===" -ForegroundColor Cyan
    
    try {
        helm version > $null 2>&1
        Write-Host "✅ Helm is already installed" -ForegroundColor Green
        helm version
        return $true
    } catch {
        Write-Host "❌ Helm is not installed" -ForegroundColor Red
        Write-Host "Install with: choco install kubernetes-helm" -ForegroundColor Yellow
        
        $installHelm = Read-Host "Would you like to install Helm now? (y/n)"
        if ($installHelm -eq "y" -or $installHelm -eq "Y") {
            choco install kubernetes-helm -y
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Helm installed successfully!" -ForegroundColor Green
                return $true
            } else {
                Write-Host "❌ Failed to install Helm" -ForegroundColor Red
                return $false
            }
        }
        return $false
    }
}

function Deploy-Services {
    Write-Host "`n=== Deploying Microservices ===" -ForegroundColor Cyan
    
    $currentDir = Get-Location
    $projectDir = "C:\Users\BAFFO\Downloads\Kubernetes based Microservices with CICD Pipeline"
    
    if (-not (Test-Path $projectDir)) {
        Write-Host "❌ Project directory not found: $projectDir" -ForegroundColor Red
        return $false
    }
    
    Set-Location $projectDir
    
    Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
    
    $deployMethod = Read-Host "Deploy with Helm (h) or kubectl (k)? (h/k)"
    
    if ($deployMethod -eq "h" -or $deployMethod -eq "H") {
        if (Test-Path "./helm/microservices") {
            Write-Host "Deploying with Helm..." -ForegroundColor Yellow
            helm install microservices ./helm/microservices
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Deployed successfully with Helm!" -ForegroundColor Green
            } else {
                Write-Host "❌ Helm deployment failed" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ Helm chart not found at ./helm/microservices" -ForegroundColor Red
        }
    } else {
        if (Test-Path "./k8s") {
            Write-Host "Deploying with kubectl..." -ForegroundColor Yellow
            kubectl apply -f k8s/
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Deployed successfully with kubectl!" -ForegroundColor Green
            } else {
                Write-Host "❌ kubectl deployment failed" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ k8s directory not found" -ForegroundColor Red
        }
    }
    
    Set-Location $currentDir
}

function Show-NextSteps {
    Write-Host "`n=== Next Steps ===" -ForegroundColor Cyan
    Write-Host "1. Check pod status: kubectl get pods" -ForegroundColor White
    Write-Host "2. Check services: kubectl get services" -ForegroundColor White
    Write-Host "3. Port forward to access services:" -ForegroundColor White
    Write-Host "   kubectl port-forward service/users-service 3000:3000" -ForegroundColor Gray
    Write-Host "   kubectl port-forward service/products-service 5000:5000" -ForegroundColor Gray
    Write-Host "4. Access services at:" -ForegroundColor White
    Write-Host "   Users: http://localhost:3000/health" -ForegroundColor Gray
    Write-Host "   Products: http://localhost:5000/health" -ForegroundColor Gray
}

# Main execution
Write-Host "Starting setup for platform: $Platform" -ForegroundColor Green

$success = $false

switch ($Platform) {
    "docker-desktop" { $success = Setup-DockerDesktop }
    "minikube" { $success = Setup-Minikube }
    "kind" { $success = Setup-Kind }
}

if ($success) {
    if (Test-Setup) {
        Write-Host "✅ Kubernetes setup completed successfully!" -ForegroundColor Green
        
        Install-Helm
        
        $deploy = Read-Host "`nWould you like to deploy the microservices now? (y/n)"
        if ($deploy -eq "y" -or $deploy -eq "Y") {
            Deploy-Services
        }
        
        Show-NextSteps
    }
} else {
    Write-Host "❌ Setup failed. Please check the instructions above." -ForegroundColor Red
}

Write-Host "`n=== Setup Complete ===" -ForegroundColor Cyan
