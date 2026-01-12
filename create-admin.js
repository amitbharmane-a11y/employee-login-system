const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
require('dotenv').config();

// Employee model
const employeeSchema = new mongoose.Schema({
  employeeId: { type: String, required: true, unique: true, trim: true },
  name: { type: String, required: true, trim: true },
  email: { type: String, required: true, unique: true, trim: true, lowercase: true },
  password: { type: String, required: true, minlength: 6 },
  role: { type: String, enum: ['employee', 'admin'], default: 'employee' },
  department: { type: String, trim: true },
  position: { type: String, trim: true },
  workStartTime: { type: String, default: '09:00' },
  workEndTime: { type: String, default: '18:00' },
  isActive: { type: Boolean, default: true }
}, { timestamps: true });

// Hash password before saving
employeeSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

const Employee = mongoose.model('Employee', employeeSchema);

async function createAdmin() {
  try {
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/employee_attendance');

    const adminExists = await Employee.findOne({ employeeId: 'ADMIN001' });
    if (adminExists) {
      console.log('Admin user already exists');
      return;
    }

    const admin = new Employee({
      employeeId: 'ADMIN001',
      name: 'System Administrator',
      email: 'admin@company.com',
      password: 'admin123',
      role: 'admin',
      department: 'IT',
      position: 'Administrator'
    });

    await admin.save();
    console.log('✅ Admin user created successfully!');
    console.log('Employee ID: ADMIN001');
    console.log('Password: admin123');

  } catch (error) {
    console.error('Error creating admin:', error.message);
  } finally {
    await mongoose.connection.close();
  }
}

createAdmin();