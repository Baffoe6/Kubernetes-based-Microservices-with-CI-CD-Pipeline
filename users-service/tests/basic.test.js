const request = require('supertest');

// Mock the database module to avoid connection issues during testing
jest.mock('../src/config/database', () => ({
  pool: {
    query: jest.fn()
  },
  initDatabase: jest.fn().mockResolvedValue()
}));

const app = require('../src/app');

describe('Users Service - Basic Tests', () => {
  describe('Health Endpoints', () => {
    test('GET /health should return healthy status', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);
      
      expect(response.body.status).toBe('healthy');
      expect(response.body.service).toBe('users-service');
    });

    test('GET /health/live should return alive status', async () => {
      const response = await request(app)
        .get('/health/live')
        .expect(200);
      
      expect(response.body.status).toBe('alive');
      expect(response.body.service).toBe('users-service');
    });
  });

  describe('API Structure', () => {
    test('GET /users should have proper structure', async () => {
      // Mock successful database response
      const { pool } = require('../src/config/database');
      pool.query.mockResolvedValue({ rows: [] });

      const response = await request(app)
        .get('/users')
        .expect(200);
      
      expect(response.body).toHaveProperty('success');
      expect(response.body).toHaveProperty('data');
      expect(response.body).toHaveProperty('count');
    });

    test('POST /users should validate required fields', async () => {
      const response = await request(app)
        .post('/users')
        .send({})
        .expect(400);
      
      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('required');
    });

    test('404 for non-existent routes', async () => {
      const response = await request(app)
        .get('/non-existent')
        .expect(404);
      
      expect(response.body.error).toBe('Route not found');
    });
  });
});
