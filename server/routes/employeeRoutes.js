const express = require('express');
const router = express.Router();
const { getAllEmployees, getEmployeeById, updateEmployee, deleteEmployee } = require('../controllers/employeeController');
const { protect, admin } = require('../middleware/authMiddleware');
const { body } = require('express-validator');

router.get('/', protect, admin, getAllEmployees);
router.get('/:id', protect, admin, getEmployeeById);
router.put(
  '/:id',
  protect,
  admin,
  [
    body('email').optional().isEmail().withMessage('Please include a valid email'),
  ],
  updateEmployee
);
router.delete('/:id', protect, admin, deleteEmployee);

module.exports = router;