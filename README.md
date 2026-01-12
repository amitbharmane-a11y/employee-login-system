# 🚀 Employee Login System

A complete full-stack employee attendance management system with login functionality.

## 📋 Features

- ✅ **Employee Authentication** - Secure login with JWT tokens
- ✅ **Admin Dashboard** - Manage employees and view attendance reports
- ✅ **Employee Dashboard** - Clock in/out and view personal attendance
- ✅ **Attendance Tracking** - Real-time attendance management
- ✅ **Reports & Analytics** - CSV/PDF export capabilities
- ✅ **Responsive Design** - Works on desktop and mobile
- ✅ **Production Ready** - Fully configured for deployment

## 🛠️ Tech Stack

- **Frontend**: React.js with React Router
- **Backend**: Node.js with Express.js
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT (JSON Web Tokens)
- **Deployment**: Railway (Backend) + Vercel (Frontend)

## 🚀 Quick Start (Development)

### Prerequisites
- Node.js (v18+)
- MongoDB (local or Atlas)
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd employee-login-system
   ```

2. **Install dependencies**
   ```bash
   # Backend
   cd server
   npm install

   # Frontend
   cd ../client
   npm install
   ```

3. **Set up environment variables**
   ```bash
   # Copy the example file
   cp .env.production.example .env

   # Edit with your values
   # For local development, use:
   MONGO_URI=mongodb://localhost:27017/employee_attendance
   JWT_SECRET=your-development-secret
   ```

4. **Start the application**
   ```bash
   # Terminal 1: Start MongoDB
   mongod

   # Terminal 2: Start Backend
   cd server
   npm run dev

   # Terminal 3: Start Frontend
   cd client
   npm start
   ```

5. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000/api

## 🔐 Default Login Credentials

- **Employee ID**: `ADMIN001`
- **Password**: `admin123`

## 🌐 Production Deployment

Deploy to any cloud platform with automated CI/CD!

### 🚀 Quick Interactive Deployment
```bash
# Choose your preferred platform
./deploy-anywhere.bat
```

### 🎯 Platform Options

#### Option 1: Railway + Vercel (Recommended - Automated CI/CD)
```bash
./setup-automated-deployment.ps1
```
- ✅ **Fully Automated** - GitHub Actions deployment
- ✅ **Global CDN** - Vercel edge network
- ✅ **Auto-scaling** - Railway handles traffic
- ✅ **Free Tier** - Generous limits

#### Option 2: Render (All-in-One)
```bash
./deploy-render.bat
```
- ✅ **Single Platform** - Frontend + Backend together
- ✅ **Blueprint Deployment** - Multi-service
- ✅ **Free Tier** - 750 hours/month
- ✅ **Auto SSL** - HTTPS included

#### Option 3: Choose Any Platform
```bash
./multi-cloud-deploy.ps1
```
Supports: Railway, Render, Netlify, Fly.io, DigitalOcean

### 🐳 Local Development
```bash
# Run with Docker
docker-compose up -d

# Access at:
# Frontend: http://localhost:3000
# Backend: http://localhost:5000
```

### 📚 Detailed Guides
- **[MULTI-CLOUD-DEPLOYMENT.md](./MULTI-CLOUD-DEPLOYMENT.md)** - Complete deployment guide
- **[AUTOMATED-DEPLOYMENT.md](./AUTOMATED-DEPLOYMENT.md)** - CI/CD automation
- **[RENDER-DEPLOYMENT.md](./RENDER-DEPLOYMENT.md)** - Render-specific guide

#### Option 2: Docker Deployment
```bash
# Build and run with Docker Compose
docker-compose up -d

# Access at:
# Frontend: http://localhost:3000
# Backend: http://localhost:5000
```

#### Option 3: Heroku + Netlify
1. **Backend**: `heroku create && git push heroku main`
2. **Frontend**: Deploy to [Netlify](https://netlify.com)

### Environment Variables for Production

**Backend (.env):**
```env
NODE_ENV=production
PORT=5000
MONGO_URI=mongodb+srv://user:pass@cluster.mongodb.net/employee_attendance_prod
JWT_SECRET=your-super-secure-jwt-secret
CORS_ORIGIN=https://your-frontend-domain.vercel.app
```

**Frontend:**
```env
REACT_APP_API_URL=https://your-backend-railway-url.up.railway.app/api
```

## 📁 Project Structure

```
employee-login-system/
├── client/                 # React frontend
│   ├── src/
│   │   ├── components/     # React components
│   │   ├── context/        # React context for auth
│   │   └── api.js          # API configuration
│   └── package.json
├── server/                 # Node.js backend
│   ├── controllers/        # Route controllers
│   ├── models/            # MongoDB models
│   ├── routes/            # API routes
│   ├── middleware/        # Express middleware
│   └── server.js          # Main server file
├── docker-compose.yml     # Docker deployment
├── Dockerfile*            # Docker configurations
├── deploy.sh             # Deployment script
└── DEPLOYMENT-GUIDE.md   # Detailed deployment guide
```

## 🔑 API Endpoints

### Authentication
- `POST /api/auth/login` - Employee login
- `GET /api/auth/me` - Get current user info
- `POST /api/auth/register` - Register new employee (admin only)

### Attendance
- `POST /api/attendance/checkin` - Clock in
- `POST /api/attendance/checkout` - Clock out
- `GET /api/attendance/history` - Get attendance history

### Admin (Protected)
- `GET /api/admin/attendance` - View all attendance
- `GET /api/admin/attendance/export/csv` - Export CSV
- `GET /api/admin/attendance/export/pdf` - Export PDF

## 🧪 Testing

### Manual Testing
1. Login with admin credentials
2. Create new employees
3. Test attendance clock in/out
4. Generate reports

### API Testing
```bash
# Test login endpoint (local)
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"employeeId":"ADMIN001","password":"admin123"}'

# Test Render deployment
.\verify-render.ps1
```

## 🔒 Security Features

- JWT token authentication
- Password hashing with bcrypt
- CORS protection
- Input validation and sanitization
- Rate limiting (recommended for production)
- HTTPS enforcement (production)

## 📊 Database Schema

### Employee Model
- employeeId (unique)
- name, email
- password (hashed)
- role (employee/admin)
- department, position
- timestamps

### Attendance Model
- employeeId (reference)
- date, checkIn, checkOut
- totalHours, status
- approved status

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

If you encounter issues:
1. Check the [Deployment Guide](./DEPLOYMENT-GUIDE.md)
2. Review the deployment logs
3. Verify environment variables
4. Test API endpoints directly

## 🎯 Production Checklist

- [ ] MongoDB Atlas cluster created
- [ ] Environment variables configured
- [ ] JWT secret generated (strong)
- [ ] CORS origin set correctly
- [ ] HTTPS enabled
- [ ] Default admin password changed
- [ ] Database backups configured
- [ ] Monitoring/alerts set up

---

**Ready to deploy!** 🚀

Follow the [Deployment Guide](./DEPLOYMENT-GUIDE.md) for detailed instructions.