from flask import Blueprint, jsonify
import os
from datetime import datetime

from config.database import get_database

health_bp = Blueprint('health', __name__)

@health_bp.route('/', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'service': 'products-service',
        'timestamp': datetime.utcnow().isoformat(),
        'version': '1.0.0',
        'message': 'Products service is running perfectly! 🎯'
    })

@health_bp.route('/ready', methods=['GET'])
def readiness_check():
    try:
        # Check database connection
        db = get_database()
        db.command('ping')
        
        return jsonify({
            'status': 'ready',
            'service': 'products-service',
            'database': 'connected',
            'timestamp': datetime.utcnow().isoformat()
        })
    except Exception as e:
        return jsonify({
            'status': 'not ready',
            'service': 'products-service',
            'database': 'disconnected',
            'error': str(e),
            'timestamp': datetime.utcnow().isoformat()
        }), 503

@health_bp.route('/live', methods=['GET'])
def liveness_check():
    return jsonify({
        'status': 'alive',
        'service': 'products-service',
        'timestamp': datetime.utcnow().isoformat()
    })
