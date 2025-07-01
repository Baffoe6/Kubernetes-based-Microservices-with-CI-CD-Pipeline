import os
from pymongo import MongoClient
import logging

# MongoDB connection
client = None
database = None

def init_database():
    global client, database
    try:
        mongo_uri = os.environ.get('MONGO_URI', 'mongodb://localhost:27017/')
        db_name = os.environ.get('DB_NAME', 'products_db')
        
        client = MongoClient(mongo_uri)
        database = client[db_name]
        
        # Test connection
        client.admin.command('ping')
        logging.info('Connected to MongoDB successfully')
        
        # Create indexes
        database.products.create_index('name')
        database.products.create_index('category')
        
    except Exception as e:
        logging.error(f'Database connection failed: {e}')
        raise e

def get_database():
    global database
    if database is None:
        init_database()
    return database

def get_collection(collection_name):
    db = get_database()
    return db[collection_name]
