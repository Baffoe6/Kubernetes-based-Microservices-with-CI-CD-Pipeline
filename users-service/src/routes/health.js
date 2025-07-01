const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');

// Health check endpoint
router.get('/', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'users-service',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0'
  });
});

// Readiness check
router.get('/ready', async (req, res) => {
  try {
    // Check database connection
    await pool.query('SELECT 1');
    res.json({
      status: 'ready',
      service: 'users-service',
      database: 'connected',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(503).json({
      status: 'not ready',
      service: 'users-service',
      database: 'disconnected',
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// Liveness check
router.get('/live', (req, res) => {
  res.json({
    status: 'alive',
    service: 'users-service',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
