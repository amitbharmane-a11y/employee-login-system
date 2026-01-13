import React from 'react';
import { useAuth } from '../context/AuthContext';

const Dashboard = () => {
  const { user } = useAuth();

  return (
    <div className="dashboard-container">
      <h2>Dashboard</h2>
      <div className="dashboard-content">
        <div className="dashboard-card">
          <h3>Welcome, {user?.name || 'User'}!</h3>
          <p>You are logged in as: <strong>{user?.role || 'employee'}</strong></p>
        </div>

        <div className="dashboard-card">
          <h3>Quick Actions</h3>
          <div className="quick-actions">
            {user?.role === 'admin' ? (
              <>
                <a href="/admin" className="action-btn">Admin Panel</a>
                <a href="/employees" className="action-btn">Manage Employees</a>
                <a href="/reports" className="action-btn">Reports</a>
              </>
            ) : (
              <>
                <a href="/employee" className="action-btn">My Dashboard</a>
                <a href="/history" className="action-btn">Attendance History</a>
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;