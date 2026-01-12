import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../api';
import moment from 'moment';
import { useNavigate } from 'react-router-dom';
import './AttendanceReports.css';

const AttendanceReports = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [attendance, setAttendance] = useState([]);
  const [exceptions, setExceptions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filterType, setFilterType] = useState('date'); // 'date' or 'month'
  const [dateFilter, setDateFilter] = useState(moment().format('YYYY-MM-DD'));
  const [monthFilter, setMonthFilter] = useState(moment().format('YYYY-MM'));
  const [selectedAttendance, setSelectedAttendance] = useState([]);
  const [currentTime, setCurrentTime] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    fetchData();

    return () => clearInterval(timer);
  }, [filterType, dateFilter, monthFilter]);

  const fetchData = async () => {
    try {
      setLoading(true);
      let url = '/admin/attendance?';
      
      if (filterType === 'date') {
        url += `date=${dateFilter}`;
      } else {
        const [year, month] = monthFilter.split('-');
        url += `month=${month}&year=${year}`;
      }

      const [attendanceRes, exceptionsRes] = await Promise.all([
        api.get(url),
        api.get(`/admin/attendance/exceptions?${filterType === 'date' ? `date=${dateFilter}` : `month=${monthFilter.split('-')[1]}&year=${monthFilter.split('-')[0]}`}`)
      ]);

      setAttendance(attendanceRes.data);
      setExceptions(exceptionsRes.data);
    } catch (error) {
      console.error('Error fetching reports:', error);
    }
  };

  const handleBulkApprove = async () => {
    if (selectedAttendance.length === 0) {
      alert('Please select attendance records to approve');
      return;
    }

    try {
      await api.put('/admin/attendance/bulk-approve', {
        attendanceIds: selectedAttendance
      });
      alert(`${selectedAttendance.length} attendance records approved successfully`);
      setSelectedAttendance([]);
      fetchData();
    } catch (error) {
      alert('Error approving attendance');
    }
  };

  const handleSelectAll = (e) => {
    if (e.target.checked) {
      setSelectedAttendance(attendance.map(a => a._id));
    } else {
      setSelectedAttendance([]);
    }
  };

  const handleSelectOne = (id) => {
    if (selectedAttendance.includes(id)) {
      setSelectedAttendance(selectedAttendance.filter(a => a !== id));
    } else {
      setSelectedAttendance([...selectedAttendance, id]);
    }
  };

  const handleExportCSV = async () => {
    try {
      let url = `/admin/attendance/export/csv?`;
      if (filterType === 'date') {
        url += `date=${dateFilter}`;
      } else {
        const [year, month] = monthFilter.split('-');
        url += `month=${month}&year=${year}`;
      }

      const response = await api.get(url, { responseType: 'blob' });
      const url_blob = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url_blob;
      link.setAttribute('download', `attendance_report_${filterType === 'date' ? dateFilter : monthFilter}.csv`);
      document.body.appendChild(link);
      link.click();
    } catch (error) {
      console.error('Error exporting CSV:', error);
    }
  };

  const handleExportPDF = async () => {
    try {
      let url = `/admin/attendance/export/pdf?`;
      if (filterType === 'date') {
        url += `date=${dateFilter}`;
      } else {
        const [year, month] = monthFilter.split('-');
        url += `month=${month}&year=${year}`;
      }

      const response = await api.get(url, { responseType: 'blob' });
      const url_blob = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url_blob;
      link.setAttribute('download', `attendance_report_${filterType === 'date' ? dateFilter : monthFilter}.pdf`);
      document.body.appendChild(link);
      link.click();
    } catch (error) {
      console.error('Error exporting PDF:', error);
    }
  };

  return (
    <div className="attendance-reports">
      <header className="dashboard-header">
        <div>
          <h1>Attendance Reports</h1>
          <p>View and manage attendance data</p>
        </div>
        <div className="header-actions">
          <div className="current-time-display">
            <strong>{currentTime.toLocaleTimeString()}</strong>
          </div>
          <button onClick={() => navigate('/admin')} className="btn-back">
            Back to Dashboard
          </button>
          <button onClick={logout} className="btn-logout">Logout</button>
        </div>
      </header>

      <div className="reports-content">
        <div className="filter-section">
          <div className="filter-type">
            <label>
              <input
                type="radio"
                value="date"
                checked={filterType === 'date'}
                onChange={(e) => setFilterType(e.target.value)}
              />
              Daily Report
            </label>
            <label>
              <input
                type="radio"
                value="month"
                checked={filterType === 'month'}
                onChange={(e) => setFilterType(e.target.value)}
              />
              Monthly Report
            </label>
          </div>
          <div className="filter-inputs">
            {filterType === 'date' ? (
              <input
                type="date"
                value={dateFilter}
                onChange={(e) => setDateFilter(e.target.value)}
              />
            ) : (
              <input
                type="month"
                value={monthFilter}
                onChange={(e) => setMonthFilter(e.target.value)}
              />
            )}
          </div>
          <div className="export-actions">
            <button onClick={handleExportCSV} className="btn-export">Export CSV</button>
            <button onClick={handleExportPDF} className="btn-export">Export PDF</button>
            {selectedAttendance.length > 0 && (
              <button onClick={handleBulkApprove} className="btn-approve">
                Approve Selected ({selectedAttendance.length})
              </button>
            )}
          </div>
        </div>

        <div className="exceptions-section">
          <h2>Late Arrivals & Early Departures</h2>
          {exceptions.length === 0 ? (
            <p className="no-exceptions">No exceptions found</p>
          ) : (
            <div className="exceptions-list">
              {exceptions.map((record) => (
                <div key={record._id} className="exception-card">
                  <div className="exception-info">
                    <strong>{record.employeeId?.name}</strong> ({record.employeeId?.employeeId})
                    <span className="exception-date">
                      {moment(record.date).format('MMM DD, YYYY')}
                    </span>
                  </div>
                  <div className="exception-details">
                    {record.checkIn?.late && (
                      <span className="badge late">
                        Late: {record.checkIn.lateMinutes} minutes
                      </span>
                    )}
                    {record.checkOut?.early && (
                      <span className="badge early">
                        Early: {record.checkOut.earlyMinutes} minutes
                      </span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        <div className="attendance-section">
          <h2>
            Attendance Report ({filterType === 'date' 
              ? moment(dateFilter).format('MMM DD, YYYY')
              : moment(monthFilter).format('MMMM YYYY')})
          </h2>
          {loading ? (
            <div className="loading">Loading reports...</div>
          ) : attendance.length === 0 ? (
            <div className="no-data">No attendance records found</div>
          ) : (
            <div className="reports-table-container">
              <table className="reports-table">
                <thead>
                  <tr>
                    <th>
                      <input
                        type="checkbox"
                        onChange={handleSelectAll}
                        checked={selectedAttendance.length === attendance.length && attendance.length > 0}
                      />
                    </th>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Department</th>
                    <th>Date</th>
                    <th>Check In</th>
                    <th>Check Out</th>
                    <th>Total Hours</th>
                    <th>Status</th>
                    <th>Approved</th>
                  </tr>
                </thead>
                <tbody>
                  {attendance.map((record) => (
                    <tr key={record._id}>
                      <td>
                        <input
                          type="checkbox"
                          checked={selectedAttendance.includes(record._id)}
                          onChange={() => handleSelectOne(record._id)}
                        />
                      </td>
                      <td>{record.employeeId?.employeeId}</td>
                      <td>{record.employeeId?.name}</td>
                      <td>{record.employeeId?.department || 'N/A'}</td>
                      <td>{moment(record.date).format('MMM DD, YYYY')}</td>
                      <td>
                        {record.checkIn?.time ? (
                          <div>
                            {moment(record.checkIn.time).format('HH:mm:ss')}
                            {record.checkIn.late && (
                              <span className="badge late">Late</span>
                            )}
                          </div>
                        ) : (
                          'N/A'
                        )}
                      </td>
                      <td>
                        {record.checkOut?.time ? (
                          <div>
                            {moment(record.checkOut.time).format('HH:mm:ss')}
                            {record.checkOut.early && (
                              <span className="badge early">Early</span>
                            )}
                          </div>
                        ) : (
                          'N/A'
                        )}
                      </td>
                      <td>{record.totalHours?.toFixed(2) || '0.00'} hrs</td>
                      <td>
                        <span className={`status-badge ${record.status}`}>
                          {record.status}
                        </span>
                      </td>
                      <td>
                        <span className={`approval-badge ${record.approved ? 'approved' : 'pending'}`}>
                          {record.approved ? 'Approved' : 'Pending'}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default AttendanceReports;