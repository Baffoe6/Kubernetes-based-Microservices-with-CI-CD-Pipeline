# API Documentation

## Users Service API

Base URL: `http://localhost:3000` (local) or `http://users-service/` (Kubernetes)

### Endpoints

#### Health Checks
- `GET /health` - Basic health check
- `GET /health/ready` - Readiness probe
- `GET /health/live` - Liveness probe

#### Users Management
- `GET /users` - Get all users
- `POST /users` - Create new user
- `GET /users/:id` - Get user by ID
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Delete user

#### User Schema
```json
{
  "id": "integer",
  "name": "string (required, 2-100 chars)",
  "email": "string (required, valid email)",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

#### Example Requests

**Create User:**
```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'
```

**Get All Users:**
```bash
curl http://localhost:3000/users
```

## Products Service API

Base URL: `http://localhost:5000` (local) or `http://products-service/` (Kubernetes)

### Endpoints

#### Health Checks
- `GET /health` - Basic health check
- `GET /health/ready` - Readiness probe
- `GET /health/live` - Liveness probe

#### Products Management
- `GET /products` - Get all products (with pagination)
- `POST /products` - Create new product
- `GET /products/:id` - Get product by ID
- `PUT /products/:id` - Update product
- `DELETE /products/:id` - Delete product

#### Product Schema
```json
{
  "_id": "ObjectId",
  "name": "string (required, 1-100 chars)",
  "description": "string (max 500 chars)",
  "price": "number (required, >= 0)",
  "category": "string (required, 1-50 chars)",
  "stock": "integer (>= 0)",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

#### Query Parameters
- `page` - Page number (default: 1)
- `limit` - Items per page (default: 10)
- `category` - Filter by category

#### Example Requests

**Create Product:**
```bash
curl -X POST http://localhost:5000/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Laptop",
    "description": "High-performance laptop",
    "price": 999.99,
    "category": "Electronics",
    "stock": 50
  }'
```

**Get Products with Pagination:**
```bash
curl "http://localhost:5000/products?page=1&limit=5&category=Electronics"
```

## Response Format

All API responses follow this format:

**Success Response:**
```json
{
  "success": true,
  "data": "...",
  "message": "optional message"
}
```

**Error Response:**
```json
{
  "success": false,
  "error": "Error message"
}
```

## HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request (validation error)
- `404` - Not Found
- `409` - Conflict (duplicate email/data)
- `500` - Internal Server Error
- `503` - Service Unavailable (health check failure)
