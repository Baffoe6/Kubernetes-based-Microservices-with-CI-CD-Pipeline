// Test setup file
process.env.NODE_ENV = 'test';
process.env.DB_HOST = 'localhost';
process.env.DB_PORT = '5432';
process.env.DB_NAME = 'test_db';
process.env.DB_USER = 'test';
process.env.DB_PASSWORD = 'test';

// Increase timeout for all tests
jest.setTimeout(10000);
