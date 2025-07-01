const request = require('supertest');
const app = require('../src/app');

describe('Users Service', () => {
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

  describe('Users Endpoints', () => {
    test('GET /users should return users list', async () => {
      const response = await request(app)
        .get('/users')
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });

    test('POST /users should create a new user', async () => {
      const userData = {
        name: 'John Doe',
        email: 'john.doe@example.com'
      };

      const response = await request(app)
        .post('/users')
        .send(userData)
        .expect(201);
      
      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe(userData.name);
      expect(response.body.data.email).toBe(userData.email);
    });

    test('POST /users should validate required fields', async () => {
      const response = await request(app)
        .post('/users')
        .send({})
        .expect(400);
      
      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('required');
    });
  });
});
