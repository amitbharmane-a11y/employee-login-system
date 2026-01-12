const express = require('express');
const router = express.Router();
const {
  getAllAttendance,
  getAttendanceExceptions,
  bulkApproveAttendance,
  exportAttendanceCSV,
  exportAttendancePDF
} = require('../controllers/adminController');
const { protect, admin } = require('../middleware/authMiddleware');

router.get('/attendance', protect, admin, getAllAttendance);
router.get('/attendance/exceptions', protect, admin, getAttendanceExceptions);
router.put('/attendance/bulk-approve', protect, admin, bulkApproveAttendance);
router.get('/attendance/export/csv', protect, admin, exportAttendanceCSV);
router.get('/attendance/export/pdf', protect, admin, exportAttendancePDF);

module.exports = router;