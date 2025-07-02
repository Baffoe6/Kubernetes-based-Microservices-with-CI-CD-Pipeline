# Testing Guide and Examples

## 🧪 Comprehensive Testing Script

This document provides various ways to test the microservices project.

### 1. Unit Tests (Local - No Dependencies)

#### Users Service Tests
```powershell
cd users-service
npm test
```

#### Products Service Tests  
```powershell
cd products-service
python -m pytest tests/ -v
```

### 2. API Testing with Sample Data

#### Test Users Service
```powershell
# Health check
curl http://localhost:3000/health

# Get all users
curl http://localhost:3000/users

# Create a user
curl -X POST http://localhost:3000/users -H "Content-Type: application/json" -d '{
  "name": "John Doe",
  "email": "john.doe@example.com"
}'

# Get user by ID
curl http://localhost:3000/users/1

# Update user
curl -X PUT http://localhost:3000/users/1 -H "Content-Type: application/json" -d '{
  "name": "John Smith"
}'

# Delete user
curl -X DELETE http://localhost:3000/users/1
```

#### Test Products Service
```powershell
# Health check
curl http://localhost:5000/health

# Get all products
curl http://localhost:5000/products

# Create a product
curl -X POST http://localhost:5000/products -H "Content-Type: application/json" -d '{
  "name": "Laptop",
  "description": "High-performance laptop",
  "price": 999.99,
  "category": "Electronics",
  "stock": 50
}'

# Get products with pagination
curl "http://localhost:5000/products?page=1&limit=5&category=Electronics"
```

### 3. Load Testing with PowerShell

#### Simple Load Test
```powershell
# Test 100 concurrent requests to users service
1..100 | ForEach-Object -Parallel {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get
        Write-Host "Request $($_): $($response.status)"
    } catch {
        Write-Host "Request $($_): Failed"
    }
} -ThrottleLimit 10
```

### 4. Health Check Monitoring
```powershell
# Continuous health monitoring
while ($true) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    try {
        $usersHealth = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get
        Write-Host "$timestamp - Users Service: $($usersHealth.status)" -ForegroundColor Green
    } catch {
        Write-Host "$timestamp - Users Service: DOWN" -ForegroundColor Red
    }
    
    try {
        $productsHealth = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get
        Write-Host "$timestamp - Products Service: $($productsHealth.status)" -ForegroundColor Green
    } catch {
        Write-Host "$timestamp - Products Service: DOWN" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds 5
}
```

### 5. Database Testing

#### PostgreSQL Connection Test
```powershell
# Using Docker (when Docker is running)
docker exec -it postgres-container psql -U postgres -d users_db -c "SELECT COUNT(*) FROM users;"
```

#### MongoDB Connection Test
```powershell
# Using Docker (when Docker is running)
docker exec -it mongodb-container mongosh products_db --eval "db.products.countDocuments()"
```

### 6. Integration Testing Script

```powershell
# Complete integration test workflow
$baseUrlUsers = "http://localhost:3000"
$baseUrlProducts = "http://localhost:5000"

Write-Host "Starting Integration Tests..." -ForegroundColor Yellow

# Test 1: Health Checks
Write-Host "1. Testing health endpoints..." -ForegroundColor Cyan
try {
    $usersHealth = Invoke-RestMethod -Uri "$baseUrlUsers/health"
    $productsHealth = Invoke-RestMethod -Uri "$baseUrlProducts/health"
    Write-Host "   ✓ All services healthy" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Health check failed" -ForegroundColor Red
    exit 1
}

# Test 2: Create User
Write-Host "2. Creating test user..." -ForegroundColor Cyan
$userData = @{
    name = "Test User"
    email = "test@example.com"
} | ConvertTo-Json

try {
    $user = Invoke-RestMethod -Uri "$baseUrlUsers/users" -Method Post -Body $userData -ContentType "application/json"
    $userId = $user.data.id
    Write-Host "   ✓ User created with ID: $userId" -ForegroundColor Green
} catch {
    Write-Host "   ✗ User creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Create Product
Write-Host "3. Creating test product..." -ForegroundColor Cyan
$productData = @{
    name = "Test Product"
    description = "A test product"
    price = 29.99
    category = "Test"
    stock = 100
} | ConvertTo-Json

try {
    $product = Invoke-RestMethod -Uri "$baseUrlProducts/products" -Method Post -Body $productData -ContentType "application/json"
    $productId = $product.data._id
    Write-Host "   ✓ Product created with ID: $productId" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Product creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Retrieve Data
Write-Host "4. Retrieving data..." -ForegroundColor Cyan
try {
    $users = Invoke-RestMethod -Uri "$baseUrlUsers/users"
    $products = Invoke-RestMethod -Uri "$baseUrlProducts/products"
    Write-Host "   ✓ Retrieved $($users.count) users and $($products.data.Count) products" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Data retrieval failed" -ForegroundColor Red
}

Write-Host "Integration tests completed!" -ForegroundColor Yellow
```

### 7. Performance Testing

#### Response Time Testing
```powershell
function Test-ResponseTime {
    param([string]$Url, [string]$ServiceName)
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri $Url
        $stopwatch.Stop()
        $responseTime = $stopwatch.ElapsedMilliseconds
        Write-Host "$ServiceName response time: ${responseTime}ms" -ForegroundColor $(if($responseTime -lt 100) { "Green" } elseif($responseTime -lt 500) { "Yellow" } else { "Red" })
        return $responseTime
    } catch {
        $stopwatch.Stop()
        Write-Host "$ServiceName failed to respond" -ForegroundColor Red
        return -1
    }
}

# Test response times
1..10 | ForEach-Object {
    Write-Host "Test run $_" -ForegroundColor Cyan
    Test-ResponseTime "http://localhost:3000/health" "Users Service"
    Test-ResponseTime "http://localhost:5000/health" "Products Service"
    Start-Sleep -Seconds 1
}
```

## 🚀 Quick Test Commands

### Start Local Testing (with Docker)
```powershell
# Start services
docker-compose up -d

# Wait for services
Start-Sleep -Seconds 30

# Run health checks
Invoke-RestMethod http://localhost:3000/health
Invoke-RestMethod http://localhost:5000/health
```

### Run All Tests
```powershell
# Unit tests
cd users-service && npm test
cd ../products-service && python -m pytest

# Integration tests (run the script above)
```

### Clean Up
```powershell
# Stop all services
docker-compose down

# Remove volumes (optional)
docker-compose down -v
```
