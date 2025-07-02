# Manual Docker Desktop Setup Guide
# Run this script for step-by-step guidance

Write-Host "=== Docker Desktop Manual Setup Guide ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 Step-by-Step Instructions:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. 🐳 Open Docker Desktop" -ForegroundColor Green
Write-Host "   - Press Windows key + R" -ForegroundColor White
Write-Host "   - Type: docker-desktop" -ForegroundColor Gray
Write-Host "   - Press Enter" -ForegroundColor White
Write-Host "   - OR find 'Docker Desktop' in Start menu" -ForegroundColor White
Write-Host ""

Write-Host "2. ⏳ Wait for Docker Desktop to start" -ForegroundColor Green
Write-Host "   - Look for the whale icon in system tray" -ForegroundColor White
Write-Host "   - Wait until it shows 'Docker Desktop is running'" -ForegroundColor White
Write-Host "   - This can take 1-3 minutes" -ForegroundColor White
Write-Host ""

Write-Host "3. ⚙️ Enable Kubernetes" -ForegroundColor Green
Write-Host "   - Right-click the Docker whale icon in system tray" -ForegroundColor White
Write-Host "   - Click 'Settings' or 'Dashboard'" -ForegroundColor White
Write-Host "   - Go to 'Kubernetes' tab on the left" -ForegroundColor White
Write-Host "   - Check the box 'Enable Kubernetes'" -ForegroundColor White
Write-Host "   - Click 'Apply & Restart'" -ForegroundColor White
Write-Host "   - Wait for Kubernetes to start (2-5 minutes)" -ForegroundColor White
Write-Host ""

Write-Host "4. ✅ Verify Setup" -ForegroundColor Green
Write-Host "   - Come back to this terminal" -ForegroundColor White
Write-Host "   - Run the verification commands below" -ForegroundColor White
Write-Host ""

Write-Host "=== Verification Commands ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Test Docker:" -ForegroundColor Yellow
Write-Host "docker --version" -ForegroundColor Gray
Write-Host "docker info" -ForegroundColor Gray
Write-Host ""
Write-Host "Test Kubernetes:" -ForegroundColor Yellow
Write-Host "kubectl version --client" -ForegroundColor Gray
Write-Host "kubectl cluster-info" -ForegroundColor Gray
Write-Host "kubectl get nodes" -ForegroundColor Gray
Write-Host ""

Write-Host "=== Troubleshooting ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "If Docker Desktop won't start:" -ForegroundColor Yellow
Write-Host "• Restart your computer" -ForegroundColor White
Write-Host "• Check Windows features: Hyper-V, WSL2" -ForegroundColor White
Write-Host "• Run as Administrator" -ForegroundColor White
Write-Host ""
Write-Host "If Kubernetes won't enable:" -ForegroundColor Yellow
Write-Host "• Increase Docker memory to 4GB+" -ForegroundColor White
Write-Host "• Reset Kubernetes cluster in settings" -ForegroundColor White
Write-Host "• Reset Docker Desktop to factory defaults" -ForegroundColor White
Write-Host ""

Write-Host "=== Alternative: Use Docker Compose Instead ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "If Kubernetes is problematic, you can use Docker Compose:" -ForegroundColor Yellow
Write-Host "docker-compose up -d" -ForegroundColor Gray
Write-Host ""
Write-Host "This will start your microservices without Kubernetes." -ForegroundColor White
Write-Host ""

# Provide an interactive helper
$choice = Read-Host "Would you like me to wait while you set up Docker Desktop? (y/n)"

if ($choice -eq "y" -or $choice -eq "Y") {
    Write-Host ""
    Write-Host "⏳ I'll wait while you set up Docker Desktop..." -ForegroundColor Yellow
    Write-Host "Press any key when Docker Desktop is running and Kubernetes is enabled..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    Write-Host ""
    Write-Host "Testing Docker..." -ForegroundColor Yellow
    docker --version
    
    Write-Host ""
    Write-Host "Testing Docker daemon..." -ForegroundColor Yellow
    docker info
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker is working!" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "Testing Kubernetes..." -ForegroundColor Yellow
        kubectl cluster-info
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Kubernetes is working!" -ForegroundColor Green
            Write-Host ""
            Write-Host "🎉 Setup complete! You can now deploy your microservices." -ForegroundColor Green
            Write-Host ""
            Write-Host "Next steps:" -ForegroundColor Cyan
            Write-Host "kubectl apply -f k8s/" -ForegroundColor Gray
            Write-Host "kubectl get pods" -ForegroundColor Gray
        } else {
            Write-Host "❌ Kubernetes is not ready yet" -ForegroundColor Red
            Write-Host "Please make sure Kubernetes is enabled in Docker Desktop settings" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ Docker is not ready yet" -ForegroundColor Red
        Write-Host "Please make sure Docker Desktop is running" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "👍 Take your time setting up Docker Desktop." -ForegroundColor Green
    Write-Host "Run this script again when you're ready to test!" -ForegroundColor Cyan
}
