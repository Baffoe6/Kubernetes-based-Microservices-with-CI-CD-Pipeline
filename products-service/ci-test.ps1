#!/usr/bin/env pwsh

# CI Simulation Script for Products Service Tests
# This script simulates what GitHub Actions would do to test the products service

Write-Host "=== CI Simulation: Products Service Tests ===" -ForegroundColor Green

# Set location
Set-Location "c:\Users\BAFFO\Downloads\Kubernetes based Microservices with CICD Pipeline\products-service"

# Check if virtual environment exists
if (-not (Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

# Upgrade pip
Write-Host "Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

# Run tests
Write-Host "Running tests..." -ForegroundColor Yellow
python -m pytest tests/ -v --tb=short

# Check exit code
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ All tests passed!" -ForegroundColor Green
    Write-Host "Products service is ready for CI/CD deployment." -ForegroundColor Green
} else {
    Write-Host "❌ Tests failed!" -ForegroundColor Red
    exit 1
}

Write-Host "=== CI Simulation Complete ===" -ForegroundColor Green
