const express = require('express');
const router = express.Router();
const Joi = require('joi');
const { pool } = require('../config/database');

// Validation schema
const userSchema = Joi.object({
  name: Joi.string().min(2).max(100).required(),
  email: Joi.string().email().required()
});

const updateUserSchema = Joi.object({
  name: Joi.string().min(2).max(100),
  email: Joi.string().email()
}).min(1);

// GET /users - Get all users
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users ORDER BY created_at DESC');
    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length
    });
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch users' });
  }
});

// GET /users/:id - Get user by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, error: 'User not found' });
    }
    
    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch user' });
  }
});

// POST /users - Create new user
router.post('/', async (req, res) => {
  try {
    const { error, value } = userSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ 
        success: false, 
        error: error.details[0].message 
      });
    }

    const { name, email } = value;
    const result = await pool.query(
      'INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *',
      [name, email]
    );
    
    res.status(201).json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    if (error.code === '23505') { // Unique constraint violation
      return res.status(409).json({ 
        success: false, 
        error: 'Email already exists' 
      });
    }
    console.error('Error creating user:', error);
    res.status(500).json({ success: false, error: 'Failed to create user' });
  }
});

// PUT /users/:id - Update user
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { error, value } = updateUserSchema.validate(req.body);
    
    if (error) {
      return res.status(400).json({ 
        success: false, 
        error: error.details[0].message 
      });
    }

    const fields = Object.keys(value);
    const values = Object.values(value);
    
    if (fields.length === 0) {
      return res.status(400).json({ 
        success: false, 
        error: 'At least one field is required' 
      });
    }

    const setClause = fields.map((field, index) => `${field} = $${index + 2}`).join(', ');
    const query = `UPDATE users SET ${setClause}, updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *`;
    
    const result = await pool.query(query, [id, ...values]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, error: 'User not found' });
    }
    
    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    if (error.code === '23505') {
      return res.status(409).json({ 
        success: false, 
        error: 'Email already exists' 
      });
    }
    console.error('Error updating user:', error);
    res.status(500).json({ success: false, error: 'Failed to update user' });
  }
});

// DELETE /users/:id - Delete user
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM users WHERE id = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, error: 'User not found' });
    }
    
    res.json({
      success: true,
      message: 'User deleted successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({ success: false, error: 'Failed to delete user' });
  }
});

module.exports = router;
