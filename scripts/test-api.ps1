# API Testing Script
# This script creates sample data and tests API endpoints

Write-Host "API Testing Script" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green

# Test data
$sampleUser = @{
    name = "John Doe"
    email = "john.doe@example.com"
} | ConvertTo-Json

$sampleProduct = @{
    name = "Test Laptop"
    description = "High-performance laptop for testing"
    price = 999.99
    category = "Electronics"
    stock = 50
} | ConvertTo-Json

# Base URLs (assuming services are running)
$usersBaseUrl = "http://localhost:3000"
$productsBaseUrl = "http://localhost:5000"

Write-Host "`nTesting URLs:" -ForegroundColor Yellow
Write-Host "Users Service: $usersBaseUrl" -ForegroundColor Cyan
Write-Host "Products Service: $productsBaseUrl" -ForegroundColor Cyan

function Test-ServiceHealth {
    param([string]$BaseUrl, [string]$ServiceName)
    
    try {
        $response = Invoke-RestMethod -Uri "$BaseUrl/health" -Method Get -TimeoutSec 5
        if ($response.status -eq "healthy") {
            Write-Host "   [OK] $ServiceName is healthy" -ForegroundColor Green
            return $true
        } else {
            Write-Host "   [WARNING] $ServiceName status: $($response.status)" -ForegroundColor Yellow
            return $false
        }
    } catch {
        Write-Host "   [OFFLINE] $ServiceName is not responding" -ForegroundColor Red
        return $false
    }
}

function Test-API {
    param([string]$Url, [string]$Method, [string]$Body, [string]$Description)
    
    try {
        if ($Body) {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Body $Body -ContentType "application/json" -TimeoutSec 10
        } else {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -TimeoutSec 10
        }
        
        Write-Host "   [OK] $Description" -ForegroundColor Green
        return $response
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "   [ERROR] $Description (Status: $statusCode)" -ForegroundColor Red
        return $null
    }
}

# Test 1: Health Checks
Write-Host "`n1. Health Checks..." -ForegroundColor Yellow
$usersHealthy = Test-ServiceHealth $usersBaseUrl "Users Service"
$productsHealthy = Test-ServiceHealth $productsBaseUrl "Products Service"

if (-not $usersHealthy -and -not $productsHealthy) {
    Write-Host "`nServices are not running. To start them:" -ForegroundColor Yellow
    Write-Host "1. Start Docker Desktop" -ForegroundColor White
    Write-Host "2. Run: docker-compose up -d" -ForegroundColor White
    Write-Host "3. Wait 30 seconds for services to start" -ForegroundColor White
    Write-Host "4. Run this script again" -ForegroundColor White
    exit
}

# Test 2: Users API
if ($usersHealthy) {
    Write-Host "`n2. Testing Users API..." -ForegroundColor Yellow
    
    # Get all users
    $users = Test-API "$usersBaseUrl/users" "GET" $null "Get all users"
    
    # Create a user
    $createdUser = Test-API "$usersBaseUrl/users" "POST" $sampleUser "Create user"
    
    if ($createdUser -and $createdUser.data.id) {
        $userId = $createdUser.data.id
        
        # Get user by ID
        Test-API "$usersBaseUrl/users/$userId" "GET" $null "Get user by ID"
        
        # Update user
        $updateData = @{ name = "John Smith" } | ConvertTo-Json
        Test-API "$usersBaseUrl/users/$userId" "PUT" $updateData "Update user"
        
        # Delete user (cleanup)
        Test-API "$usersBaseUrl/users/$userId" "DELETE" $null "Delete user"
    }
    
    # Test validation
    Test-API "$usersBaseUrl/users" "POST" "{}" "Validation test (should fail)"
}

# Test 3: Products API
if ($productsHealthy) {
    Write-Host "`n3. Testing Products API..." -ForegroundColor Yellow
    
    # Get all products
    $products = Test-API "$productsBaseUrl/products" "GET" $null "Get all products"
    
    # Create a product
    $createdProduct = Test-API "$productsBaseUrl/products" "POST" $sampleProduct "Create product"
    
    if ($createdProduct -and $createdProduct.data._id) {
        $productId = $createdProduct.data._id
        
        # Get product by ID
        Test-API "$productsBaseUrl/products/$productId" "GET" $null "Get product by ID"
        
        # Update product
        $updateData = @{ price = 899.99 } | ConvertTo-Json
        Test-API "$productsBaseUrl/products/$productId" "PUT" $updateData "Update product"
        
        # Delete product (cleanup)
        Test-API "$productsBaseUrl/products/$productId" "DELETE" $null "Delete product"
    }
    
    # Test pagination
    Test-API "$productsBaseUrl/products?page=1&limit=5" "GET" $null "Test pagination"
    
    # Test validation
    Test-API "$productsBaseUrl/products" "POST" "{}" "Validation test (should fail)"
}

# Test 4: Performance Test
if ($usersHealthy -or $productsHealthy) {
    Write-Host "`n4. Performance Test..." -ForegroundColor Yellow
    
    $testUrl = if ($usersHealthy) { "$usersBaseUrl/health" } else { "$productsBaseUrl/health" }
    $serviceName = if ($usersHealthy) { "Users" } else { "Products" }
    
    $times = @()
    for ($i = 1; $i -le 10; $i++) {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        try {
            Invoke-RestMethod -Uri $testUrl -Method Get -TimeoutSec 5 | Out-Null
            $stopwatch.Stop()
            $times += $stopwatch.ElapsedMilliseconds
        } catch {
            $stopwatch.Stop()
        }
    }
    
    if ($times.Count -gt 0) {
        $avgTime = ($times | Measure-Object -Average).Average
        $minTime = ($times | Measure-Object -Minimum).Minimum
        $maxTime = ($times | Measure-Object -Maximum).Maximum
        
        Write-Host "   $serviceName Service Response Times:" -ForegroundColor Cyan
        Write-Host "   Average: $([math]::Round($avgTime, 2))ms" -ForegroundColor White
        Write-Host "   Min: $minTime ms" -ForegroundColor White
        Write-Host "   Max: $maxTime ms" -ForegroundColor White
        
        if ($avgTime -lt 100) {
            Write-Host "   [EXCELLENT] Very fast response times" -ForegroundColor Green
        } elseif ($avgTime -lt 500) {
            Write-Host "   [GOOD] Good response times" -ForegroundColor Green
        } else {
            Write-Host "   [SLOW] Response times could be improved" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n===============================================" -ForegroundColor Green
Write-Host "API TESTING COMPLETED" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

if ($usersHealthy -and $productsHealthy) {
    Write-Host "Both services are running and responding correctly!" -ForegroundColor Green
    Write-Host "`nTry these URLs in your browser:" -ForegroundColor Cyan
    Write-Host "- Users: http://localhost:3000/users" -ForegroundColor White
    Write-Host "- Products: http://localhost:5000/products" -ForegroundColor White
    Write-Host "- Prometheus: http://localhost:9090" -ForegroundColor White
    Write-Host "- Grafana: http://localhost:3001 (admin/admin)" -ForegroundColor White
} elseif ($usersHealthy -or $productsHealthy) {
    Write-Host "Some services are running. Check Docker containers." -ForegroundColor Yellow
} else {
    Write-Host "Services are not running. Follow the startup instructions above." -ForegroundColor Red
}
