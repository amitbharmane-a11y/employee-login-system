const Attendance = require('../models/Attendance');
const Employee = require('../models/Employee');
const moment = require('moment');
const PDFDocument = require('pdfkit');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;

// @desc    Get all employees attendance (daily/monthly)
// @route   GET /api/admin/attendance
// @access  Private/Admin
const getAllAttendance = async (req, res) => {
  try {
    const { date, month, year, employeeId } = req.query;
    let query = {};

    if (employeeId) {
      const employee = await Employee.findOne({ employeeId });
      if (employee) {
        query.employeeId = employee._id;
      }
    }

    if (date) {
      const startDate = new Date(date);
      startDate.setHours(0, 0, 0, 0);
      const endDate = new Date(startDate);
      endDate.setDate(endDate.getDate() + 1);
      query.date = { $gte: startDate, $lt: endDate };
    } else if (month && year) {
      const startDate = new Date(year, month - 1, 1);
      const endDate = new Date(year, month, 0, 23, 59, 59);
      query.date = { $gte: startDate, $lte: endDate };
    }

    const attendance = await Attendance.find(query)
      .populate('employeeId', 'name employeeId department position')
      .sort({ date: -1 });

    res.json(attendance);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get late arrivals and early departures
// @route   GET /api/admin/attendance/exceptions
// @access  Private/Admin
const getAttendanceExceptions = async (req, res) => {
  try {
    const { date, month, year } = req.query;
    let query = {};

    if (date) {
      const startDate = new Date(date);
      startDate.setHours(0, 0, 0, 0);
      const endDate = new Date(startDate);
      endDate.setDate(endDate.getDate() + 1);
      query.date = { $gte: startDate, $lt: endDate };
    } else if (month && year) {
      const startDate = new Date(year, month - 1, 1);
      const endDate = new Date(year, month, 0, 23, 59, 59);
      query.date = { $gte: startDate, $lte: endDate };
    }

    const attendance = await Attendance.find({
      ...query,
      $or: [
        { 'checkIn.late': true },
        { 'checkOut.early': true }
      ]
    })
      .populate('employeeId', 'name employeeId department')
      .sort({ date: -1 });

    res.json(attendance);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Bulk approve attendance
// @route   PUT /api/admin/attendance/bulk-approve
// @access  Private/Admin
const bulkApproveAttendance = async (req, res) => {
  try {
    const { attendanceIds } = req.body;

    const result = await Attendance.updateMany(
      { _id: { $in: attendanceIds } },
      {
        $set: {
          approved: true,
          approvedBy: req.user._id
        }
      }
    );

    res.json({ message: `${result.modifiedCount} attendance records approved` });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Export attendance report as CSV
// @route   GET /api/admin/attendance/export/csv
// @access  Private/Admin
const exportAttendanceCSV = async (req, res) => {
  try {
    const { date, month, year } = req.query;
    let query = {};

    if (date) {
      const startDate = new Date(date);
      startDate.setHours(0, 0, 0, 0);
      const endDate = new Date(startDate);
      endDate.setDate(endDate.getDate() + 1);
      query.date = { $gte: startDate, $lt: endDate };
    } else if (month && year) {
      const startDate = new Date(year, month - 1, 1);
      const endDate = new Date(year, month, 0, 23, 59, 59);
      query.date = { $gte: startDate, $lte: endDate };
    }

    const attendance = await Attendance.find(query)
      .populate('employeeId', 'name employeeId department position')
      .sort({ date: -1 });

    const csvWriter = createCsvWriter({
      path: 'attendance_report.csv',
      header: [
        { id: 'employeeId', title: 'Employee ID' },
        { id: 'name', title: 'Name' },
        { id: 'department', title: 'Department' },
        { id: 'date', title: 'Date' },
        { id: 'checkIn', title: 'Check In' },
        { id: 'checkOut', title: 'Check Out' },
        { id: 'totalHours', title: 'Total Hours' },
        { id: 'status', title: 'Status' },
        { id: 'late', title: 'Late' },
        { id: 'early', title: 'Early Departure' }
      ]
    });

    const records = attendance.map(record => ({
      employeeId: record.employeeId.employeeId,
      name: record.employeeId.name,
      department: record.employeeId.department || '',
      date: moment(record.date).format('YYYY-MM-DD'),
      checkIn: record.checkIn.time ? moment(record.checkIn.time).format('HH:mm:ss') : 'N/A',
      checkOut: record.checkOut.time ? moment(record.checkOut.time).format('HH:mm:ss') : 'N/A',
      totalHours: record.totalHours.toFixed(2),
      status: record.status,
      late: record.checkIn.late ? `${record.checkIn.lateMinutes} min` : 'No',
      early: record.checkOut.early ? `${record.checkOut.earlyMinutes} min` : 'No'
    }));

    await csvWriter.writeRecords(records);

    res.download('attendance_report.csv', 'attendance_report.csv', (err) => {
      if (err) {
        res.status(500).json({ message: 'Error downloading file' });
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Export attendance report as PDF
// @route   GET /api/admin/attendance/export/pdf
// @access  Private/Admin
const exportAttendancePDF = async (req, res) => {
  try {
    const { date, month, year } = req.query;
    let query = {};

    if (date) {
      const startDate = new Date(date);
      startDate.setHours(0, 0, 0, 0);
      const endDate = new Date(startDate);
      endDate.setDate(endDate.getDate() + 1);
      query.date = { $gte: startDate, $lt: endDate };
    } else if (month && year) {
      const startDate = new Date(year, month - 1, 1);
      const endDate = new Date(year, month, 0, 23, 59, 59);
      query.date = { $gte: startDate, $lte: endDate };
    }

    const attendance = await Attendance.find(query)
      .populate('employeeId', 'name employeeId department position')
      .sort({ date: -1 });

    const doc = new PDFDocument();
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'attachment; filename=attendance_report.pdf');

    doc.pipe(res);

    doc.fontSize(20).text('Attendance Report', { align: 'center' });
    doc.moveDown();

    attendance.forEach((record, index) => {
      doc.fontSize(12)
        .text(`${index + 1}. ${record.employeeId.name} (${record.employeeId.employeeId})`)
        .text(`   Date: ${moment(record.date).format('YYYY-MM-DD')}`)
        .text(`   Check In: ${record.checkIn.time ? moment(record.checkIn.time).format('HH:mm:ss') : 'N/A'}`)
        .text(`   Check Out: ${record.checkOut.time ? moment(record.checkOut.time).format('HH:mm:ss') : 'N/A'}`)
        .text(`   Total Hours: ${record.totalHours.toFixed(2)}`)
        .text(`   Status: ${record.status}`)
        .moveDown();
    });

    doc.end();
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getAllAttendance,
  getAttendanceExceptions,
  bulkApproveAttendance,
  exportAttendanceCSV,
  exportAttendancePDF,
};