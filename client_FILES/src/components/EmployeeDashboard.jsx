import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../api';
import moment from 'moment';
import './EmployeeDashboard.css';

const EmployeeDashboard = () => {
  const { user, logout } = useAuth();
  const [currentTime, setCurrentTime] = useState(new Date());
  const [todayAttendance, setTodayAttendance] = useState(null);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    fetchTodayAttendance();

    return () => clearInterval(timer);
  }, []);

  const fetchTodayAttendance = async () => {
    try {
      const response = await api.get('/attendance/today');
      setTodayAttendance(response.data);
    } catch (error) {
      if (error.response?.status !== 404) {
        setMessage('Error fetching attendance');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleCheckIn = async () => {
    try {
      const response = await api.post('/attendance/checkin');
      setTodayAttendance(response.data);
      setMessage('Checked in successfully!');
      setTimeout(() => setMessage(''), 3000);
    } catch (error) {
      setMessage(error.response?.data?.message || 'Error checking in');
      setTimeout(() => setMessage(''), 3000);
    }
  };

  const handleCheckOut = async () => {
    try {
      const response = await api.post('/attendance/checkout');
      setTodayAttendance(response.data);
      setMessage('Checked out successfully!');
      setTimeout(() => setMessage(''), 3000);
    } catch (error) {
      setMessage(error.response?.data?.message || 'Error checking out');
      setTimeout(() => setMessage(''), 3000);
    }
  };

  return (
    <div className="employee-dashboard">
      <header className="dashboard-header">
        <div>
          <h1>Welcome, {user?.name}</h1>
          <p>Employee ID: {user?.employeeId}</p>
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
        {message && (
          <div className={`message ${message.includes('Error') ? 'error' : 'success'}`}>
            {message}
          </div>
        )}

        <div className="attendance-card">
          <h2>Today's Attendance</h2>
          {loading ? (
            <p>Loading...</p>
          ) : todayAttendance && todayAttendance.checkIn ? (
            <div className="attendance-status">
              <div className="status-item">
                <span className="label">Check In:</span>
                <span className="value">
                  {moment(todayAttendance.checkIn.time).format('HH:mm:ss')}
                  {todayAttendance.checkIn.late && (
                    <span className="late-badge">Late ({todayAttendance.checkIn.lateMinutes} min)</span>
                  )}
                </span>
              </div>
              <div className="status-item">
                <span className="label">Check Out:</span>
                <span className="value">
                  {todayAttendance.checkOut?.time
                    ? moment(todayAttendance.checkOut.time).format('HH:mm:ss')
                    : 'Not checked out'}
                  {todayAttendance.checkOut?.early && (
                    <span className="early-badge">Early ({todayAttendance.checkOut.earlyMinutes} min)</span>
                  )}
                </span>
              </div>
              <div className="status-item">
                <span className="label">Status:</span>
                <span className={`status-badge ${todayAttendance.status}`}>
                  {todayAttendance.status}
                </span>
              </div>
              {todayAttendance.totalHours > 0 && (
                <div className="status-item">
                  <span className="label">Total Hours:</span>
                  <span className="value">{todayAttendance.totalHours.toFixed(2)} hours</span>
                </div>
              )}
            </div>
          ) : (
            <p>No attendance record for today</p>
          )}

          <div className="attendance-actions">
            {!todayAttendance?.checkIn?.time ? (
              <button onClick={handleCheckIn} className="btn-checkin">
                Check In
              </button>
            ) : !todayAttendance?.checkOut?.time ? (
              <button onClick={handleCheckOut} className="btn-checkout">
                Check Out
              </button>
            ) : (
              <p className="completed">Attendance completed for today</p>
            )}
          </div>
        </div>

        <div className="quick-links">
          <a href="/history" className="link-card">
            <h3>View Attendance History</h3>
            <p>Last 30 days</p>
          </a>
        </div>
      </div>
    </div>
  );
};

export default EmployeeDashboard;