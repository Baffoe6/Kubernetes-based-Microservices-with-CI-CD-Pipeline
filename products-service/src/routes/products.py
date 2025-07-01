from flask import Blueprint, request, jsonify
from bson import ObjectId
from datetime import datetime
import logging

from config.database import get_collection
from models.product import ProductSchema

products_bp = Blueprint('products', __name__)
product_schema = ProductSchema()

def serialize_product(product):
    """Convert MongoDB document to JSON serializable format"""
    if product:
        product['_id'] = str(product['_id'])
        return product
    return None

@products_bp.route('/', methods=['GET'])
def get_products():
    try:
        collection = get_collection('products')
        
        # Query parameters
        page = int(request.args.get('page', 1))
        limit = int(request.args.get('limit', 10))
        category = request.args.get('category')
        
        skip = (page - 1) * limit
        query = {}
        
        if category:
            query['category'] = category
        
        products = list(collection.find(query).skip(skip).limit(limit).sort('created_at', -1))
        total = collection.count_documents(query)
        
        # Serialize products
        serialized_products = [serialize_product(product) for product in products]
        
        return jsonify({
            'success': True,
            'data': serialized_products,
            'pagination': {
                'page': page,
                'limit': limit,
                'total': total,
                'pages': (total + limit - 1) // limit
            }
        })
    except Exception as e:
        logging.error(f'Error fetching products: {e}')
        return jsonify({'success': False, 'error': 'Failed to fetch products'}), 500

@products_bp.route('/<product_id>', methods=['GET'])
def get_product(product_id):
    try:
        if not ObjectId.is_valid(product_id):
            return jsonify({'success': False, 'error': 'Invalid product ID'}), 400
        
        collection = get_collection('products')
        product = collection.find_one({'_id': ObjectId(product_id)})
        
        if not product:
            return jsonify({'success': False, 'error': 'Product not found'}), 404
        
        return jsonify({
            'success': True,
            'data': serialize_product(product)
        })
    except Exception as e:
        logging.error(f'Error fetching product: {e}')
        return jsonify({'success': False, 'error': 'Failed to fetch product'}), 500

@products_bp.route('/', methods=['POST'])
def create_product():
    try:
        # Validate request data
        errors = product_schema.validate(request.json)
        if errors:
            return jsonify({'success': False, 'error': errors}), 400
        
        collection = get_collection('products')
        
        # Prepare product data
        product_data = {
            'name': request.json['name'],
            'description': request.json.get('description', ''),
            'price': float(request.json['price']),
            'category': request.json['category'],
            'stock': int(request.json.get('stock', 0)),
            'created_at': datetime.utcnow(),
            'updated_at': datetime.utcnow()
        }
        
        result = collection.insert_one(product_data)
        
        # Get the created product
        created_product = collection.find_one({'_id': result.inserted_id})
        
        return jsonify({
            'success': True,
            'data': serialize_product(created_product)
        }), 201
        
    except Exception as e:
        logging.error(f'Error creating product: {e}')
        return jsonify({'success': False, 'error': 'Failed to create product'}), 500

@products_bp.route('/<product_id>', methods=['PUT'])
def update_product(product_id):
    try:
        if not ObjectId.is_valid(product_id):
            return jsonify({'success': False, 'error': 'Invalid product ID'}), 400
        
        collection = get_collection('products')
        
        # Check if product exists
        existing_product = collection.find_one({'_id': ObjectId(product_id)})
        if not existing_product:
            return jsonify({'success': False, 'error': 'Product not found'}), 404
        
        # Prepare update data
        update_data = {}
        if 'name' in request.json:
            update_data['name'] = request.json['name']
        if 'description' in request.json:
            update_data['description'] = request.json['description']
        if 'price' in request.json:
            update_data['price'] = float(request.json['price'])
        if 'category' in request.json:
            update_data['category'] = request.json['category']
        if 'stock' in request.json:
            update_data['stock'] = int(request.json['stock'])
        
        if not update_data:
            return jsonify({'success': False, 'error': 'No fields to update'}), 400
        
        update_data['updated_at'] = datetime.utcnow()
        
        collection.update_one(
            {'_id': ObjectId(product_id)},
            {'$set': update_data}
        )
        
        # Get updated product
        updated_product = collection.find_one({'_id': ObjectId(product_id)})
        
        return jsonify({
            'success': True,
            'data': serialize_product(updated_product)
        })
        
    except Exception as e:
        logging.error(f'Error updating product: {e}')
        return jsonify({'success': False, 'error': 'Failed to update product'}), 500

@products_bp.route('/<product_id>', methods=['DELETE'])
def delete_product(product_id):
    try:
        if not ObjectId.is_valid(product_id):
            return jsonify({'success': False, 'error': 'Invalid product ID'}), 400
        
        collection = get_collection('products')
        
        # Find and delete product
        deleted_product = collection.find_one_and_delete({'_id': ObjectId(product_id)})
        
        if not deleted_product:
            return jsonify({'success': False, 'error': 'Product not found'}), 404
        
        return jsonify({
            'success': True,
            'message': 'Product deleted successfully',
            'data': serialize_product(deleted_product)
        })
        
    except Exception as e:
        logging.error(f'Error deleting product: {e}')
        return jsonify({'success': False, 'error': 'Failed to delete product'}), 500
