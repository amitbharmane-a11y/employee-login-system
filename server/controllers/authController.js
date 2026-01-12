const Employee = require('../models/Employee');
const generateToken = require('../generateToken');
const { validationResult } = require('express-validator');

// @desc    Register new employee (admin only)
// @route   POST /api/auth/register
// @access  Private/Admin
const registerEmployee = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { employeeId, name, email, password, department, position, role, workStartTime, workEndTime } = req.body;

    const employeeExists = await Employee.findOne({ $or: [{ employeeId }, { email }] });

    if (employeeExists) {
      return res.status(400).json({ message: 'Employee ID or Email already exists' });
    }

    const employee = await Employee.create({
      employeeId,
      name,
      email,
      password,
      department,
      position,
      role: role || 'employee',
      workStartTime: workStartTime || '09:00',
      workEndTime: workEndTime || '18:00'
    });

    if (employee) {
      res.status(201).json({
        _id: employee._id,
        employeeId: employee.employeeId,
        name: employee.name,
        email: employee.email,
        role: employee.role,
        token: generateToken(employee._id),
      });
    } else {
      res.status(400).json({ message: 'Invalid employee data' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Auth employee & get token
// @route   POST /api/auth/login
// @access  Public
const loginEmployee = async (req, res) => {
  try {
    const { employeeId, password } = req.body;

    // Validate input
    if (!employeeId || !password) {
      return res.status(400).json({
        message: 'Employee ID and password are required'
      });
    }

    // Trim whitespace
    const cleanEmployeeId = employeeId.trim();
    const cleanPassword = password.trim();

    if (!cleanEmployeeId || !cleanPassword) {
      return res.status(400).json({
        message: 'Employee ID and password cannot be empty'
      });
    }

    const employee = await Employee.findOne({ employeeId: cleanEmployeeId }).select('+password');

    if (!employee) {
      return res.status(401).json({
        message: 'Invalid employee ID or password'
      });
    }

    if (!employee.isActive) {
      return res.status(401).json({
        message: 'Account is deactivated. Contact administrator.'
      });
    }

    const isPasswordValid = await employee.matchPassword(cleanPassword);
    if (!isPasswordValid) {
      return res.status(401).json({
        message: 'Invalid employee ID or password'
      });
    }

    res.json({
      _id: employee._id,
      employeeId: employee.employeeId,
      name: employee.name,
      email: employee.email,
      role: employee.role,
      token: generateToken(employee._id),
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      message: 'Internal server error. Please try again.'
    });
  }
};

// @desc    Get current logged in employee
// @route   GET /api/auth/me
// @access  Private
const getMe = async (req, res) => {
  try {
    const employee = await Employee.findById(req.user._id).select('-password');
    res.json(employee);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  registerEmployee,
  loginEmployee,
  getMe,
};