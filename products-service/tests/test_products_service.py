import os
import sys
import json
from unittest.mock import patch, Mock

# Add the src directory to the Python path in a more robust way
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
src_dir = os.path.join(project_root, 'src')

# Ensure the src directory is in the Python path
if src_dir not in sys.path:
    sys.path.insert(0, src_dir)

# Set testing environment
os.environ['TESTING'] = 'true'

def test_health_endpoint():
    """Test the health endpoint"""
    with patch('config.database.init_database'):
        from app import create_app
        app = create_app()
        app.config['TESTING'] = True
        client = app.test_client()
        
        response = client.get('/health/')
        assert response.status_code == 200
        
        data = json.loads(response.data)
        assert data['status'] == 'healthy'
        assert data['service'] == 'products-service'

def test_liveness_endpoint():
    """Test the liveness endpoint"""
    with patch('config.database.init_database'):
        from app import create_app
        app = create_app()
        app.config['TESTING'] = True
        client = app.test_client()
        
        response = client.get('/health/live')
        assert response.status_code == 200
        
        data = json.loads(response.data)
        assert data['status'] == 'alive'

def test_404_error_handler():
    """Test 404 error handler"""
    with patch('config.database.init_database'):
        from app import create_app
        app = create_app()
        app.config['TESTING'] = True
        client = app.test_client()
        
        response = client.get('/nonexistent')
        assert response.status_code == 404
        
        data = json.loads(response.data)
        assert data['success'] is False
        assert 'error' in data

def test_products_get_empty():
    """Test get products endpoint returns empty list with proper mocking"""
    
    # Create proper mocks for the MongoDB cursor chain
    mock_cursor = Mock()
    mock_cursor.skip.return_value = mock_cursor
    mock_cursor.limit.return_value = mock_cursor
    mock_cursor.sort.return_value = []  # Empty list of products
    
    mock_collection = Mock()
    mock_collection.find.return_value = mock_cursor
    mock_collection.count_documents.return_value = 0
    
    # Create a more specific database mock
    mock_database = {}
    mock_database['products'] = mock_collection
    
    with patch('config.database.init_database'), \
         patch('config.database.get_database', return_value=mock_database):
        from app import create_app
        app = create_app()
        app.config['TESTING'] = True
        client = app.test_client()
        
        response = client.get('/products/')
        assert response.status_code == 200
        
        data = json.loads(response.data)
        assert data['success'] is True
        assert data['data'] == []
        assert 'pagination' in data
        assert data['pagination']['total'] == 0

def test_products_post_validation():
    """Test product creation validation"""
    with patch('config.database.init_database'):
        from app import create_app
        app = create_app()
        app.config['TESTING'] = True
        client = app.test_client()
        
        # Test with empty data
        response = client.post('/products/', json={})
        assert response.status_code == 400
        
        data = json.loads(response.data)
        assert data['success'] is False
        assert 'error' in data
