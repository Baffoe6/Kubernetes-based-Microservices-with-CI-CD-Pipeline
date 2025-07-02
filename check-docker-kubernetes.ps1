# Docker Desktop and Kubernetes Setup Script
# This script will help you get Docker Desktop running and enable Kubernetes

Write-Host "=== Docker Desktop & Kubernetes Setup ===" -ForegroundColor Cyan

function Wait-ForDockerReady {
    Write-Host "Waiting for Docker Desktop to be ready..." -ForegroundColor Yellow
    $maxAttempts = 30
    $attempt = 0
    
    do {
        $attempt++
        Write-Host "Attempt $attempt/$maxAttempts..." -ForegroundColor Gray
        
        try {
            docker info > $null 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Docker Desktop is ready!" -ForegroundColor Green
                return $true
            }
        } catch {
            # Continue waiting
        }
        
        Start-Sleep -Seconds 5
    } while ($attempt -lt $maxAttempts)
    
    Write-Host "❌ Docker Desktop failed to start within $($maxAttempts * 5) seconds" -ForegroundColor Red
    return $false
}

function Test-KubernetesEnabled {
    try {
        kubectl cluster-info > $null 2>&1
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

# Check if Docker Desktop is running
Write-Host "Checking Docker Desktop status..." -ForegroundColor Yellow

$dockerProcesses = Get-Process "Docker Desktop" -ErrorAction SilentlyContinue
if ($dockerProcesses) {
    Write-Host "✅ Docker Desktop process is running" -ForegroundColor Green
    
    if (Wait-ForDockerReady) {
        Write-Host "✅ Docker daemon is ready!" -ForegroundColor Green
        
        # Test basic Docker functionality
        Write-Host "Testing Docker functionality..." -ForegroundColor Yellow
        docker run --rm hello-world
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Docker is working correctly!" -ForegroundColor Green
        } else {
            Write-Host "❌ Docker test failed" -ForegroundColor Red
        }
        
        # Check if Kubernetes is enabled
        Write-Host "`nChecking Kubernetes status..." -ForegroundColor Yellow
        
        if (Test-KubernetesEnabled) {
            Write-Host "✅ Kubernetes is already enabled and running!" -ForegroundColor Green
            kubectl cluster-info
            kubectl get nodes
        } else {
            Write-Host "❌ Kubernetes is not enabled" -ForegroundColor Red
            Write-Host "`n📝 To enable Kubernetes:" -ForegroundColor Yellow
            Write-Host "1. Right-click the Docker Desktop icon in your system tray" -ForegroundColor White
            Write-Host "2. Select 'Settings' or 'Preferences'" -ForegroundColor White
            Write-Host "3. Go to 'Kubernetes' tab" -ForegroundColor White
            Write-Host "4. Check 'Enable Kubernetes'" -ForegroundColor White
            Write-Host "5. Click 'Apply & Restart'" -ForegroundColor White
            Write-Host "6. Wait for Kubernetes to start (this can take 2-5 minutes)" -ForegroundColor White
            
            Write-Host "`n🔄 After enabling Kubernetes, run this script again to verify" -ForegroundColor Cyan
            
            $enableNow = Read-Host "`nWould you like me to open Docker Desktop settings now? (y/n)"
            if ($enableNow -eq "y" -or $enableNow -eq "Y") {
                # Try to open Docker Desktop settings
                try {
                    Start-Process "docker-desktop://dashboard/settings/kubernetes"
                    Write-Host "✅ Opening Docker Desktop settings..." -ForegroundColor Green
                } catch {
                    Write-Host "❌ Could not open settings automatically. Please open Docker Desktop manually." -ForegroundColor Red
                }
            }
        }
        
    } else {
        Write-Host "❌ Docker Desktop is not responding" -ForegroundColor Red
        Write-Host "Please restart Docker Desktop and try again" -ForegroundColor Yellow
    }
    
} else {
    Write-Host "❌ Docker Desktop is not running" -ForegroundColor Red
    Write-Host "Please start Docker Desktop first" -ForegroundColor Yellow
    
    # Try to start Docker Desktop
    $startNow = Read-Host "Would you like me to try starting Docker Desktop now? (y/n)"
    if ($startNow -eq "y" -or $startNow -eq "Y") {
        try {
            # Try common Docker Desktop locations
            $dockerPaths = @(
                "${env:ProgramFiles}\Docker\Docker\Docker Desktop.exe",
                "${env:LOCALAPPDATA}\Docker\Docker Desktop.exe",
                "C:\Program Files\Docker\Docker\Docker Desktop.exe"
            )
            
            $dockerFound = $false
            foreach ($path in $dockerPaths) {
                if (Test-Path $path) {
                    Write-Host "Starting Docker Desktop from: $path" -ForegroundColor Yellow
                    Start-Process $path
                    $dockerFound = $true
                    break
                }
            }
            
            if (-not $dockerFound) {
                Write-Host "❌ Could not find Docker Desktop executable" -ForegroundColor Red
                Write-Host "Please start Docker Desktop manually from the Start menu" -ForegroundColor Yellow
            } else {
                Write-Host "✅ Docker Desktop starting..." -ForegroundColor Green
                Write-Host "Please wait for it to fully start, then run this script again" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "❌ Failed to start Docker Desktop: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`n=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. Ensure Docker Desktop is running" -ForegroundColor White
Write-Host "2. Enable Kubernetes in Docker Desktop settings" -ForegroundColor White
Write-Host "3. Wait for Kubernetes to start" -ForegroundColor White
Write-Host "4. Run: kubectl cluster-info" -ForegroundColor White
Write-Host "5. Deploy your microservices: kubectl apply -f k8s/" -ForegroundColor White

Write-Host "`n=== Useful Commands ===" -ForegroundColor Cyan
Write-Host "Check Docker: docker info" -ForegroundColor Gray
Write-Host "Check Kubernetes: kubectl cluster-info" -ForegroundColor Gray
Write-Host "Check pods: kubectl get pods" -ForegroundColor Gray
Write-Host "Check services: kubectl get services" -ForegroundColor Gray
