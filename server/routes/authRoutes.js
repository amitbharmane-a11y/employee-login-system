const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const { registerEmployee, loginEmployee, getMe } = require('../controllers/authController');
const { protect } = require('../middleware/authMiddleware');

router.post(
  '/register',
  protect,
  [
    body('employeeId').notEmpty().withMessage('Employee ID is required'),
    body('name').notEmpty().withMessage('Name is required'),
    body('email').isEmail().withMessage('Please include a valid email'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  ],
  registerEmployee
);

router.post('/login', loginEmployee);
router.get('/me', protect, getMe);

module.exports = router;