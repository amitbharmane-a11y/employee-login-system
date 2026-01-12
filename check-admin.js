const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
require('dotenv').config();

// Employee model (same as in the app)
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

employeeSchema.methods.matchPassword = async function(enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

const Employee = mongoose.model('Employee', employeeSchema);

async function checkAdmin() {
  try {
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/employee_attendance');

    const admin = await Employee.findOne({ employeeId: 'ADMIN001' }).select('+password');
    if (admin) {
      console.log('Admin user found:');
      console.log('Employee ID:', admin.employeeId);
      console.log('Name:', admin.name);
      console.log('Role:', admin.role);
      console.log('Is Active:', admin.isActive);

      // Test password
      const isValidPassword = await admin.matchPassword('admin123');
      console.log('Password valid:', isValidPassword);

      const allUsers = await Employee.find({}).select('employeeId name role');
      console.log('All users in database:', allUsers);
    } else {
      console.log('Admin user not found');
    }

  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await mongoose.connection.close();
  }
}

checkAdmin();