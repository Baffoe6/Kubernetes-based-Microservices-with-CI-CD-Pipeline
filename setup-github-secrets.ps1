# GitHub Repository Secrets Setup for Docker Hub
# Run this script to get step-by-step instructions

Write-Host "🔧 Docker Hub Secrets Setup for GitHub Actions" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "⚠️  CRITICAL: Your Docker token was exposed publicly!" -ForegroundColor Red
Write-Host "You MUST regenerate it immediately for security!" -ForegroundColor Red
Write-Host ""

Write-Host "📋 Step-by-Step Instructions:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1️⃣  REGENERATE DOCKER HUB TOKEN:" -ForegroundColor Green
Write-Host "   • Open: https://hub.docker.com" -ForegroundColor White
Write-Host "   • Login with: baffoe6" -ForegroundColor White
Write-Host "   • Go to: Account Settings → Security → Access Tokens" -ForegroundColor White
Write-Host "   • DELETE the old exposed token" -ForegroundColor White
Write-Host "   • Create new token:" -ForegroundColor White
Write-Host "     - Name: GitHub Actions" -ForegroundColor Gray
Write-Host "     - Permissions: Read, Write, Delete" -ForegroundColor Gray
Write-Host "   • COPY the new token (starts with dckr_pat_)" -ForegroundColor White
Write-Host ""

Write-Host "2️⃣  ADD SECRETS TO GITHUB:" -ForegroundColor Green
Write-Host "   • Open: https://github.com/Baffoe6/Kubernetes-based-Microservices-with-CI-CD-Pipeline/settings/secrets/actions" -ForegroundColor White
Write-Host "   • Click: 'New repository secret'" -ForegroundColor White
Write-Host ""
Write-Host "   Add Secret #1:" -ForegroundColor Cyan
Write-Host "   Name: DOCKER_USERNAME" -ForegroundColor White
Write-Host "   Value: baffoe6" -ForegroundColor White
Write-Host ""
Write-Host "   Add Secret #2:" -ForegroundColor Cyan
Write-Host "   Name: DOCKER_PASSWORD" -ForegroundColor White
Write-Host "   Value: [paste your NEW token here]" -ForegroundColor White
Write-Host ""

Write-Host "3️⃣  VERIFY SETUP:" -ForegroundColor Green
Write-Host "   • Go to Actions tab in your GitHub repo" -ForegroundColor White
Write-Host "   • Run the 'Test Docker Secrets' workflow manually" -ForegroundColor White
Write-Host "   • Or push a commit to trigger the main CI/CD pipeline" -ForegroundColor White
Write-Host ""

Write-Host "✅ Expected Results:" -ForegroundColor Green
Write-Host "   • Docker login should succeed" -ForegroundColor White
Write-Host "   • Images will be pushed to:" -ForegroundColor White
Write-Host "     - baffoe6/users-service:latest" -ForegroundColor Gray
Write-Host "     - baffoe6/products-service:latest" -ForegroundColor Gray
Write-Host ""

Write-Host "🔗 Quick Links:" -ForegroundColor Yellow
Write-Host "   Docker Hub: https://hub.docker.com" -ForegroundColor Blue
Write-Host "   GitHub Secrets: https://github.com/Baffoe6/Kubernetes-based-Microservices-with-CI-CD-Pipeline/settings/secrets/actions" -ForegroundColor Blue
Write-Host ""

Write-Host "❓ Need Help?" -ForegroundColor Yellow
Write-Host "   If you're still having issues after setting up the secrets," -ForegroundColor White
Write-Host "   check the GitHub Actions logs for more detailed error messages." -ForegroundColor White
