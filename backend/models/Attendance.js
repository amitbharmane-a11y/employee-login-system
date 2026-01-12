const mongoose = require('mongoose');

const attendanceSchema = new mongoose.Schema({
  employeeId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Employee',
    required: true
  },
  date: {
    type: Date,
    required: true,
    default: Date.now
  },
  checkIn: {
    time: {
      type: Date
    },
    location: {
      type: String
    },
    late: {
      type: Boolean,
      default: false
    },
    lateMinutes: {
      type: Number,
      default: 0
    }
  },
  checkOut: {
    time: {
      type: Date
    },
    location: {
      type: String
    },
    early: {
      type: Boolean,
      default: false
    },
    earlyMinutes: {
      type: Number,
      default: 0
    }
  },
  status: {
    type: String,
    enum: ['present', 'absent', 'half-day', 'pending'],
    default: 'pending'
  },
  totalHours: {
    type: Number,
    default: 0
  },
  approved: {
    type: Boolean,
    default: false
  },
  approvedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Employee'
  },
  notes: {
    type: String
  }
}, {
  timestamps: true
});

// Index for efficient queries
attendanceSchema.index({ employeeId: 1, date: 1 }, { unique: true });

module.exports = mongoose.model('Attendance', attendanceSchema);