import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../api';
import moment from 'moment';
import { useNavigate } from 'react-router-dom';
import './AttendanceHistory.css';

const AttendanceHistory = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [attendance, setAttendance] = useState([]);
  const [loading, setLoading] = useState(true);
  const [currentTime, setCurrentTime] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    fetchAttendanceHistory();

    return () => clearInterval(timer);
  }, []);

  const fetchAttendanceHistory = async () => {
    try {
      setLoading(true);
      const response = await api.get('/attendance/history');
      setAttendance(response.data);
    } catch (error) {
      console.error('Error fetching attendance history:', error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'present':
        return 'green';
      case 'absent':
        return 'red';
      case 'half-day':
        return 'orange';
      default:
        return 'gray';
    }
  };

  return (
    <div className="attendance-history">
      <header className="dashboard-header">
        <div>
          <h1>Attendance History</h1>
          <p>Last 30 Days</p>
        </div>
        <div className="header-actions">
          <div className="current-time-display">
            <strong>{currentTime.toLocaleTimeString()}</strong>
          </div>
          <button onClick={() => navigate(user?.role === 'admin' ? '/admin' : '/employee')} className="btn-back">
            Back to Dashboard
          </button>
          <button onClick={logout} className="btn-logout">Logout</button>
        </div>
      </header>

      <div className="history-content">
        {loading ? (
          <div className="loading">Loading attendance history...</div>
        ) : attendance.length === 0 ? (
          <div className="no-data">No attendance records found</div>
        ) : (
          <div className="history-table-container">
            <table className="history-table">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Day</th>
                  <th>Check In</th>
                  <th>Check Out</th>
                  <th>Total Hours</th>
                  <th>Status</th>
                  <th>Remarks</th>
                </tr>
              </thead>
              <tbody>
                {attendance.map((record) => (
                  <tr key={record._id}>
                    <td>{moment(record.date).format('MMM DD, YYYY')}</td>
                    <td>{moment(record.date).format('dddd')}</td>
                    <td>
                      {record.checkIn?.time ? (
                        <div>
                          <span>{moment(record.checkIn.time).format('HH:mm:ss')}</span>
                          {record.checkIn.late && (
                            <span className="badge late">Late ({record.checkIn.lateMinutes} min)</span>
                          )}
                        </div>
                      ) : (
                        <span className="absent">Absent</span>
                      )}
                    </td>
                    <td>
                      {record.checkOut?.time ? (
                        <div>
                          <span>{moment(record.checkOut.time).format('HH:mm:ss')}</span>
                          {record.checkOut.early && (
                            <span className="badge early">Early ({record.checkOut.earlyMinutes} min)</span>
                          )}
                        </div>
                      ) : (
                        <span>-</span>
                      )}
                    </td>
                    <td>
                      {record.totalHours > 0 ? `${record.totalHours.toFixed(2)} hrs` : '-'}
                    </td>
                    <td>
                      <span className={`status-badge ${record.status}`}>
                        {record.status}
                      </span>
                    </td>
                    <td>
                      {record.checkIn?.late && `Late arrival`}
                      {record.checkOut?.early && `Early departure`}
                      {!record.checkIn?.late && !record.checkOut?.early && record.status === 'present' && 'On time'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        <div className="summary-stats">
          <div className="stat-card">
            <h3>Total Days</h3>
            <p>{attendance.length}</p>
          </div>
          <div className="stat-card">
            <h3>Present Days</h3>
            <p>{attendance.filter(a => a.status === 'present').length}</p>
          </div>
          <div className="stat-card">
            <h3>Late Arrivals</h3>
            <p>{attendance.filter(a => a.checkIn?.late).length}</p>
          </div>
          <div className="stat-card">
            <h3>Average Hours</h3>
            <p>
              {attendance.length > 0
                ? (attendance.reduce((sum, a) => sum + (a.totalHours || 0), 0) / attendance.length).toFixed(2)
                : '0.00'} hrs
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AttendanceHistory;