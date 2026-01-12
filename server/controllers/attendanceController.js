const Attendance = require('../models/Attendance');
const Employee = require('../models/Employee');
const moment = require('moment');

// @desc    Mark check-in
// @route   POST /api/attendance/checkin
// @access  Private
const checkIn = async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    let attendance = await Attendance.findOne({
      employeeId: req.user._id,
      date: { $gte: today, $lt: tomorrow }
    });

    if (attendance && attendance.checkIn.time) {
      return res.status(400).json({ message: 'Already checked in today' });
    }

    const employee = await Employee.findById(req.user._id);
    const checkInTime = new Date();
    const workStartTime = moment(employee.workStartTime, 'HH:mm');
    const checkInMoment = moment(checkInTime);
    const isLate = checkInMoment.isAfter(workStartTime);
    const lateMinutes = isLate ? checkInMoment.diff(workStartTime, 'minutes') : 0;

    if (attendance) {
      attendance.checkIn = {
        time: checkInTime,
        location: req.body.location || 'Office',
        late: isLate,
        lateMinutes
      };
      await attendance.save();
    } else {
      attendance = await Attendance.create({
        employeeId: req.user._id,
        date: today,
        checkIn: {
          time: checkInTime,
          location: req.body.location || 'Office',
          late: isLate,
          lateMinutes
        },
        status: 'present'
      });
    }

    res.json(attendance);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Mark check-out
// @route   POST /api/attendance/checkout
// @access  Private
const checkOut = async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const attendance = await Attendance.findOne({
      employeeId: req.user._id,
      date: { $gte: today, $lt: tomorrow }
    });

    if (!attendance || !attendance.checkIn.time) {
      return res.status(400).json({ message: 'Please check in first' });
    }

    if (attendance.checkOut.time) {
      return res.status(400).json({ message: 'Already checked out today' });
    }

    const employee = await Employee.findById(req.user._id);
    const checkOutTime = new Date();
    const workEndTime = moment(employee.workEndTime, 'HH:mm');
    const checkOutMoment = moment(checkOutTime);
    const isEarly = checkOutMoment.isBefore(workEndTime);
    const earlyMinutes = isEarly ? workEndTime.diff(checkOutMoment, 'minutes') : 0;

    const totalHours = (checkOutTime - attendance.checkIn.time) / (1000 * 60 * 60);

    attendance.checkOut = {
      time: checkOutTime,
      location: req.body.location || 'Office',
      early: isEarly,
      earlyMinutes
    };
    attendance.totalHours = totalHours;
    await attendance.save();

    res.json(attendance);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get today's attendance
// @route   GET /api/attendance/today
// @access  Private
const getTodayAttendance = async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const attendance = await Attendance.findOne({
      employeeId: req.user._id,
      date: { $gte: today, $lt: tomorrow }
    }).populate('employeeId', 'name employeeId');

    if (!attendance) {
      return res.json({ message: 'No attendance record for today' });
    }

    res.json(attendance);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get personal attendance history (last 30 days)
// @route   GET /api/attendance/history
// @access  Private
const getAttendanceHistory = async (req, res) => {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const attendance = await Attendance.find({
      employeeId: req.user._id,
      date: { $gte: thirtyDaysAgo }
    }).sort({ date: -1 }).populate('employeeId', 'name employeeId');

    res.json(attendance);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  checkIn,
  checkOut,
  getTodayAttendance,
  getAttendanceHistory,
};