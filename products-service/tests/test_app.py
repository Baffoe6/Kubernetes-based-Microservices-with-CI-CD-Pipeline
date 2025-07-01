import pytest
import json
from src.app import create_app

@pytest.fixture
def app():
    app = create_app()
    app.config['TESTING'] = True
    return app

@pytest.fixture
def client(app):
    return app.test_client()

def test_health_endpoint(client):
    """Test health check endpoint"""
    response = client.get('/health/')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert data['service'] == 'products-service'

def test_liveness_endpoint(client):
    """Test liveness check endpoint"""
    response = client.get('/health/live')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'alive'
    assert data['service'] == 'products-service'

def test_get_products(client):
    """Test get products endpoint"""
    response = client.get('/products/')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['success'] is True
    assert 'data' in data
    assert isinstance(data['data'], list)

def test_create_product(client):
    """Test create product endpoint"""
    product_data = {
        'name': 'Test Product',
        'description': 'A test product',
        'price': 29.99,
        'category': 'Electronics',
        'stock': 100
    }
    response = client.post('/products/', json=product_data)
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['success'] is True
    assert data['data']['name'] == product_data['name']

def test_create_product_validation(client):
    """Test product validation"""
    response = client.post('/products/', json={})
    assert response.status_code == 400
    data = json.loads(response.data)
    assert data['success'] is False
