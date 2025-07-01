# PowerShell script to start services locally on Windows

Write-Host "Starting microservices locally..." -ForegroundColor Green

# Build Docker images
Write-Host "Building Docker images..." -ForegroundColor Yellow
docker-compose build

# Start services
Write-Host "Starting services..." -ForegroundColor Yellow
docker-compose up -d

# Wait for services to be ready
Write-Host "Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Health checks
Write-Host "Checking service health..." -ForegroundColor Yellow
try {
    $usersHealth = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get
    Write-Host "Users Service: $($usersHealth.status)" -ForegroundColor Green
} catch {
    Write-Host "Users Service: Not responding" -ForegroundColor Red
}

try {
    $productsHealth = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get
    Write-Host "Products Service: $($productsHealth.status)" -ForegroundColor Green
} catch {
    Write-Host "Products Service: Not responding" -ForegroundColor Red
}

Write-Host "`nServices are running!" -ForegroundColor Green
Write-Host "Users Service: http://localhost:3000" -ForegroundColor Cyan
Write-Host "Products Service: http://localhost:5000" -ForegroundColor Cyan
Write-Host "Prometheus: http://localhost:9090" -ForegroundColor Cyan
Write-Host "Grafana: http://localhost:3001 (admin/admin)" -ForegroundColor Cyan
