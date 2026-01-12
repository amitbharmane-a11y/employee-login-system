const Employee = require('../models/Employee');
const { validationResult } = require('express-validator');

// @desc    Get all employees
// @route   GET /api/employees
// @access  Private/Admin
const getAllEmployees = async (req, res) => {
  try {
    const { search } = req.query;
    let query = {};

    if (search) {
      query = {
        $or: [
          { name: { $regex: search, $options: 'i' } },
          { employeeId: { $regex: search, $options: 'i' } },
          { email: { $regex: search, $options: 'i' } }
        ]
      };
    }

    const employees = await Employee.find(query).select('-password').sort({ createdAt: -1 });
    res.json(employees);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get employee by ID
// @route   GET /api/employees/:id
// @access  Private/Admin
const getEmployeeById = async (req, res) => {
  try {
    const employee = await Employee.findById(req.params.id).select('-password');
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }
    res.json(employee);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update employee
// @route   PUT /api/employees/:id
// @access  Private/Admin
const updateEmployee = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, department, position, role, workStartTime, workEndTime, isActive } = req.body;

    const employee = await Employee.findById(req.params.id);

    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Check if email is already taken by another employee
    if (email && email !== employee.email) {
      const emailExists = await Employee.findOne({ email, _id: { $ne: req.params.id } });
      if (emailExists) {
        return res.status(400).json({ message: 'Email already exists' });
      }
    }

    employee.name = name || employee.name;
    employee.email = email || employee.email;
    employee.department = department !== undefined ? department : employee.department;
    employee.position = position !== undefined ? position : employee.position;
    employee.role = role || employee.role;
    employee.workStartTime = workStartTime || employee.workStartTime;
    employee.workEndTime = workEndTime || employee.workEndTime;
    employee.isActive = isActive !== undefined ? isActive : employee.isActive;

    const updatedEmployee = await employee.save();
    res.json({
      _id: updatedEmployee._id,
      employeeId: updatedEmployee.employeeId,
      name: updatedEmployee.name,
      email: updatedEmployee.email,
      department: updatedEmployee.department,
      position: updatedEmployee.position,
      role: updatedEmployee.role,
      workStartTime: updatedEmployee.workStartTime,
      workEndTime: updatedEmployee.workEndTime,
      isActive: updatedEmployee.isActive
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete employee
// @route   DELETE /api/employees/:id
// @access  Private/Admin
const deleteEmployee = async (req, res) => {
  try {
    const employee = await Employee.findById(req.params.id);

    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    await employee.deleteOne();
    res.json({ message: 'Employee removed' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getAllEmployees,
  getEmployeeById,
  updateEmployee,
  deleteEmployee,
};