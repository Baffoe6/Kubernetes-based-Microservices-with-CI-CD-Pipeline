from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from datetime import datetime
import logging

from config.database import init_database, get_database
from routes.products import products_bp
from routes.health import health_bp

def create_app():
    app = Flask(__name__)
    
    # Configure CORS
    CORS(app)
    
    # Configure logging
    logging.basicConfig(level=logging.INFO)
    
    # Initialize database only if not in testing mode
    if not os.environ.get('TESTING'):
        init_database()
    
    # Register blueprints
    app.register_blueprint(health_bp, url_prefix='/health')
    app.register_blueprint(products_bp, url_prefix='/products')
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'success': False, 'error': 'Route not found'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'success': False, 'error': 'Internal server error'}), 500
    
    return app

if __name__ == '__main__':
    app = create_app()
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=os.environ.get('FLASK_ENV') == 'development')
