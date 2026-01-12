import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../api';
import moment from 'moment';
import './AdminDashboard.css';

const AdminDashboard = () => {
  const { user, logout } = useAuth();
  const [currentTime, setCurrentTime] = useState(new Date());
  const [attendance, setAttendance] = useState([]);
  const [loading, setLoading] = useState(true);
  const [dateFilter, setDateFilter] = useState(moment().format('YYYY-MM-DD'));

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    fetchAttendance();

    return () => clearInterval(timer);
  }, [dateFilter]);

  const fetchAttendance = async () => {
    try {
      setLoading(true);
      const response = await api.get(`/admin/attendance?date=${dateFilter}`);
      setAttendance(response.data);
    } catch (error) {
      console.error('Error fetching attendance:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleExportCSV = async () => {
    try {
      const response = await api.get(`/admin/attendance/export/csv?date=${dateFilter}`, {
        responseType: 'blob'
      });
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `attendance_${dateFilter}.csv`);
      document.body.appendChild(link);
      link.click();
    } catch (error) {
      console.error('Error exporting CSV:', error);
    }
  };

  const handleExportPDF = async () => {
    try {
      const response = await api.get(`/admin/attendance/export/pdf?date=${dateFilter}`, {
        responseType: 'blob'
      });
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `attendance_${dateFilter}.pdf`);
      document.body.appendChild(link);
      link.click();
    } catch (error) {
      console.error('Error exporting PDF:', error);
    }
  };

  return (
    <div className="admin-dashboard">
      <header className="dashboard-header">
        <div>
          <h1>Admin Dashboard</h1>
          <p>Welcome, {user?.name}</p>
        </div>
        <div className="header-actions">
          <div className="current-time-display">
            <strong>{currentTime.toLocaleTimeString()}</strong>
            <span>{currentTime.toLocaleDateString()}</span>
          </div>
          <button onClick={logout} className="btn-logout">Logout</button>
        </div>
      </header>

      <div className="dashboard-content">
        <div className="filter-section">
          <label>
            Select Date:
            <input
              type="date"
              value={dateFilter}
              onChange={(e) => setDateFilter(e.target.value)}
            />
          </label>
          <div className="export-buttons">
            <button onClick={handleExportCSV} className="btn-export">Export CSV</button>
            <button onClick={handleExportPDF} className="btn-export">Export PDF</button>
          </div>
        </div>

        <div className="quick-links">
          <a href="/employees" className="link-card">
            <h3>Manage Employees</h3>
            <p>Add, edit, or delete employees</p>
          </a>
          <a href="/reports" className="link-card">
            <h3>Attendance Reports</h3>
            <p>View detailed reports and exceptions</p>
          </a>
        </div>

        <div className="attendance-table-container">
          <h2>Today's Attendance ({moment(dateFilter).format('MMM DD, YYYY')})</h2>
          {loading ? (
            <p>Loading...</p>
          ) : attendance.length === 0 ? (
            <p>No attendance records for this date</p>
          ) : (
            <table className="attendance-table">
              <thead>
                <tr>
                  <th>Employee ID</th>
                  <th>Name</th>
                  <th>Department</th>
                  <th>Check In</th>
                  <th>Check Out</th>
                  <th>Total Hours</th>
                  <th>Status</th>
                  <th>Late/Early</th>
                </tr>
              </thead>
              <tbody>
                {attendance.map((record) => (
                  <tr key={record._id}>
                    <td>{record.employeeId?.employeeId}</td>
                    <td>{record.employeeId?.name}</td>
                    <td>{record.employeeId?.department || 'N/A'}</td>
                    <td>
                      {record.checkIn?.time
                        ? moment(record.checkIn.time).format('HH:mm:ss')
                        : 'N/A'}
                      {record.checkIn?.late && (
                        <span className="badge late">Late</span>
                      )}
                    </td>
                    <td>
                      {record.checkOut?.time
                        ? moment(record.checkOut.time).format('HH:mm:ss')
                        : 'N/A'}
                      {record.checkOut?.early && (
                        <span className="badge early">Early</span>
                      )}
                    </td>
                    <td>{record.totalHours?.toFixed(2) || '0.00'} hrs</td>
                    <td>
                      <span className={`status-badge ${record.status}`}>
                        {record.status}
                      </span>
                    </td>
                    <td>
                      {record.checkIn?.late && `${record.checkIn.lateMinutes} min late`}
                      {record.checkOut?.early && `${record.checkOut.earlyMinutes} min early`}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;