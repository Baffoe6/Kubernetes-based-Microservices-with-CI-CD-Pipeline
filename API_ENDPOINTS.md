# Microservices API Endpoints

## 🚀 Services Overview

Your microservices are now running successfully! Here are all the available endpoints:

## Users Service (Port 3000)

### Health Check
- **GET** `http://localhost:3000/health`
  - Returns service health status

### Users API
- **GET** `http://localhost:3000/users`
  - Get all users
  
- **POST** `http://localhost:3000/users`
  - Create a new user
  - Body: `{"name": "John Doe", "email": "john@example.com"}`
  
- **GET** `http://localhost:3000/users/:id`
  - Get user by ID
  
- **PUT** `http://localhost:3000/users/:id`
  - Update user by ID
  - Body: `{"name": "Updated Name", "email": "updated@example.com"}`
  
- **DELETE** `http://localhost:3000/users/:id`
  - Delete user by ID

## Products Service (Port 5000)

### Health Check
- **GET** `http://localhost:5000/health/`
  - Returns service health status

### Products API
- **GET** `http://localhost:5000/products/`
  - Get all products (with pagination)
  
- **POST** `http://localhost:5000/products/`
  - Create a new product
  - Body: `{"name": "Laptop", "description": "High-performance laptop", "price": 999.99, "category": "Electronics"}`
  
- **GET** `http://localhost:5000/products/:id`
  - Get product by ID
  
- **PUT** `http://localhost:5000/products/:id`
  - Update product by ID
  
- **DELETE** `http://localhost:5000/products/:id`
  - Delete product by ID

## Monitoring & Observability

### Grafana Dashboard
- **URL**: `http://localhost:3001`
- **Default Login**: admin/admin
- Pre-configured dashboards for monitoring your microservices

### Prometheus Metrics
- **URL**: `http://localhost:9090`
- Metrics collection and monitoring
- Query interface for custom metrics

## Databases

### PostgreSQL (Users Service)
- **Host**: localhost
- **Port**: 5432
- **Database**: users_db
- **Username**: user
- **Password**: password

### MongoDB (Products Service)
- **Host**: localhost
- **Port**: 27017
- **Database**: products_db

## Example API Calls

### Create a User
```bash
curl -X POST "http://localhost:3000/users" \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'
```

### Create a Product
```bash
curl -X POST "http://localhost:5000/products/" \
  -H "Content-Type: application/json" \
  -d '{"name": "Laptop", "description": "High-performance laptop", "price": 999.99, "category": "Electronics"}'
```

### Get All Users
```bash
curl http://localhost:3000/users
```

### Get All Products
```bash
curl http://localhost:5000/products/
```

## 🎯 What's Working

✅ **Users Service** - Node.js/Express with PostgreSQL  
✅ **Products Service** - Python/Flask with MongoDB  
✅ **Grafana** - Monitoring dashboard  
✅ **Prometheus** - Metrics collection  
✅ **PostgreSQL** - Relational database  
✅ **MongoDB** - Document database  
✅ **Docker Compose** - Orchestration  
✅ **Health Checks** - Service monitoring  
✅ **CORS** - Cross-origin requests enabled  

## 🔧 Container Status

All services are running in Docker containers with proper health checks and inter-service communication configured.

## Next Steps for Kubernetes

Your microservices are now ready to be deployed to Kubernetes! The Docker images are built and the services are tested and working.
