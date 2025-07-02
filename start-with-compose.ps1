# Alternative Setup: Use Docker Compose Instead of Kubernetes
# This will get your microservices running without needing Kubernetes

Write-Host "=== Docker Compose Setup (Alternative to Kubernetes) ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Since Docker Desktop/Kubernetes is having issues, let's use Docker Compose instead!" -ForegroundColor Yellow
Write-Host "This will run your microservices locally without needing Kubernetes." -ForegroundColor White
Write-Host ""

# Function to wait for Docker to be ready
function Wait-ForDockerCompose {
    $maxAttempts = 10
    $attempt = 0
    
    do {
        $attempt++
        Write-Host "Checking Docker status (attempt $attempt/$maxAttempts)..." -ForegroundColor Gray
        
        try {
            docker-compose --version > $null 2>&1
            if ($LASTEXITCODE -eq 0) {
                # Try a simple docker command
                docker ps > $null 2>&1
                if ($LASTEXITCODE -eq 0) {
                    return $true
                }
            }
        } catch {
            # Continue waiting
        }
        
        Start-Sleep -Seconds 10
    } while ($attempt -lt $maxAttempts)
    
    return $false
}

Write-Host "Step 1: Checking Docker Compose availability..." -ForegroundColor Green
docker-compose --version

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Docker Compose is available!" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Step 2: Checking if Docker daemon is accessible..." -ForegroundColor Green
    
    if (Wait-ForDockerCompose) {
        Write-Host "✅ Docker is ready!" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "Step 3: Building and starting services with Docker Compose..." -ForegroundColor Green
        Write-Host "This will:" -ForegroundColor White
        Write-Host "• Build your microservices" -ForegroundColor White
        Write-Host "• Start PostgreSQL and MongoDB" -ForegroundColor White
        Write-Host "• Start users-service and products-service" -ForegroundColor White
        Write-Host "• Set up monitoring (Prometheus & Grafana)" -ForegroundColor White
        Write-Host ""
        
        # Build and start services
        Write-Host "Building services..." -ForegroundColor Yellow
        docker-compose build
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Build successful!" -ForegroundColor Green
            
            Write-Host ""
            Write-Host "Starting services..." -ForegroundColor Yellow
            docker-compose up -d
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Services started!" -ForegroundColor Green
                
                Write-Host ""
                Write-Host "Step 4: Waiting for services to be ready..." -ForegroundColor Green
                Start-Sleep -Seconds 15
                
                Write-Host ""
                Write-Host "Step 5: Checking service status..." -ForegroundColor Green
                docker-compose ps
                
                Write-Host ""
                Write-Host "Step 6: Testing service health..." -ForegroundColor Green
                
                # Test users service
                try {
                    Write-Host "Testing Users Service..." -ForegroundColor Yellow
                    $response = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get -TimeoutSec 5
                    Write-Host "✅ Users Service: $($response.status)" -ForegroundColor Green
                } catch {
                    Write-Host "⚠️ Users Service: Not responding yet (may still be starting)" -ForegroundColor Yellow
                }
                
                # Test products service
                try {
                    Write-Host "Testing Products Service..." -ForegroundColor Yellow
                    $response = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 5
                    Write-Host "✅ Products Service: $($response.status)" -ForegroundColor Green
                } catch {
                    Write-Host "⚠️ Products Service: Not responding yet (may still be starting)" -ForegroundColor Yellow
                }
                
                Write-Host ""
                Write-Host "🎉 Setup Complete!" -ForegroundColor Green
                Write-Host ""
                Write-Host "=== Service URLs ===" -ForegroundColor Cyan
                Write-Host "Users Service:    http://localhost:3000" -ForegroundColor White
                Write-Host "Products Service: http://localhost:5000" -ForegroundColor White
                Write-Host "Prometheus:       http://localhost:9090" -ForegroundColor White
                Write-Host "Grafana:          http://localhost:3001 (admin/admin)" -ForegroundColor White
                Write-Host ""
                Write-Host "=== API Endpoints ===" -ForegroundColor Cyan
                Write-Host "Health Checks:" -ForegroundColor Yellow
                Write-Host "  curl http://localhost:3000/health" -ForegroundColor Gray
                Write-Host "  curl http://localhost:5000/health" -ForegroundColor Gray
                Write-Host ""
                Write-Host "Users API:" -ForegroundColor Yellow
                Write-Host "  GET    http://localhost:3000/users" -ForegroundColor Gray
                Write-Host "  POST   http://localhost:3000/users" -ForegroundColor Gray
                Write-Host ""
                Write-Host "Products API:" -ForegroundColor Yellow
                Write-Host "  GET    http://localhost:5000/products" -ForegroundColor Gray
                Write-Host "  POST   http://localhost:5000/products" -ForegroundColor Gray
                Write-Host ""
                Write-Host "=== Management Commands ===" -ForegroundColor Cyan
                Write-Host "View logs:        docker-compose logs -f" -ForegroundColor Gray
                Write-Host "Stop services:    docker-compose down" -ForegroundColor Gray
                Write-Host "Restart services: docker-compose restart" -ForegroundColor Gray
                Write-Host "View status:      docker-compose ps" -ForegroundColor Gray
                
            } else {
                Write-Host "❌ Failed to start services" -ForegroundColor Red
                Write-Host "Check the logs with: docker-compose logs" -ForegroundColor Yellow
            }
        } else {
            Write-Host "❌ Build failed" -ForegroundColor Red
            Write-Host "Check the output above for errors" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "❌ Docker daemon is not accessible" -ForegroundColor Red
        Write-Host "Please make sure Docker Desktop is running properly" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "You can try:" -ForegroundColor Yellow
        Write-Host "• Restarting Docker Desktop" -ForegroundColor White
        Write-Host "• Restarting your computer" -ForegroundColor White
        Write-Host "• Running this script as Administrator" -ForegroundColor White
    }
    
} else {
    Write-Host "❌ Docker Compose is not available" -ForegroundColor Red
    Write-Host "Please install Docker Desktop first" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== About This Setup ===" -ForegroundColor Cyan
Write-Host "This Docker Compose setup provides:" -ForegroundColor White
Write-Host "• The same microservices that would run in Kubernetes" -ForegroundColor White
Write-Host "• Local development environment" -ForegroundColor White
Write-Host "• Easy testing and debugging" -ForegroundColor White
Write-Host "• No need for Kubernetes complexity" -ForegroundColor White
Write-Host ""
Write-Host "Once Docker Desktop is stable, you can switch to Kubernetes with:" -ForegroundColor White
Write-Host "kubectl apply -f k8s/" -ForegroundColor Gray
