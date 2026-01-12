# 🚀 Render Deployment Guide - Employee Login System

## 📋 Prerequisites
- ✅ GitHub repository: `employee-login-system`
- ✅ MongoDB Atlas database (see setup below)
- ✅ Render account: https://render.com

---

## 🗄️ Step 1: Setup MongoDB Atlas (Required)

### 1.1 Create Account
1. Go to https://cloud.mongodb.com
2. Sign up/Login
3. Create project: `employee-attendance-system`

### 1.2 Create Cluster
1. Click "Build a Database"
2. Choose "M0 Cluster" (FREE)
3. Any provider/region
4. Click "Create Cluster" (wait 1-3 minutes)

### 1.3 Create Database User
1. "Database Access" → "Add New Database User"
2. Username: `employeeadmin`
3. Password: Create strong password (SAVE IT!)
4. Role: "Read and write any database"
5. Click "Add User"

### 1.4 Configure Network
1. "Network Access" → "Add IP Address"
2. "Allow Access from Anywhere" (0.0.0.0/0)
3. Click "Confirm"

### 1.5 Get Connection String
1. "Clusters" → "Connect"
2. "Connect your application"
3. Driver: Node.js
4. Copy connection string
5. Replace `<password>` with your password
6. Add database: `/employee_attendance_prod`

**Final Connection String:**
```
mongodb+srv://employeeadmin:YOUR_PASSWORD@cluster0.xxxxx.mongodb.net/employee_attendance_prod?retryWrites=true&w=majority
```

---

## 🌐 Step 2: Deploy to Render

### 2.1 Create Render Account
1. Go to https://render.com
2. Sign up/Login with GitHub

### 2.2 Deploy Blueprint
1. Click "New" → "Blueprint"
2. Connect GitHub (if not connected)
3. Search: `employee-login-system`
4. Select your repository
5. **Render detects `render.yaml` automatically**

### 2.3 Services Created
Render creates two services:

**Backend Service:**
- Name: `employee-backend`
- Type: Web Service
- Runtime: Node
- Root: `server/`
- Build: `npm install`
- Start: `npm start`

**Frontend Service:**
- Name: `employee-frontend`
- Type: Static Site
- Root: `client/`
- Build: `npm install && npm run build`
- Publish: `build/`

### 2.4 Set Environment Variables

**Backend Environment Variables:**
```
NODE_ENV = production
PORT = 10000
MONGO_URI = mongodb+srv://employeeadmin:PASSWORD@cluster0.xxxxx.mongodb.net/employee_attendance_prod?retryWrites=true&w=majority
JWT_SECRET = employee-jwt-render-2024-secure-key-change-this
CORS_ORIGIN = https://your-frontend.onrender.com
```

**Frontend Environment Variables:**
```
REACT_APP_API_URL = https://your-backend.onrender.com/api
```

### 2.5 Deploy
1. Click "Create Blueprint"
2. Wait 5-10 minutes for build
3. Services deploy automatically

---

## 🔄 Step 3: Update CORS (After Deployment)

1. Get your frontend URL: `https://employee-frontend-xxxx.onrender.com`
2. Go to backend service → "Environment"
3. Update `CORS_ORIGIN` to your frontend URL
4. Save (auto-redeploys)

---

## 🧪 Step 4: Test Your Deployment

### Access URLs:
- **Frontend**: `https://employee-frontend-xxxx.onrender.com`
- **Backend**: `https://employee-backend-xxxx.onrender.com`

### Test Login:
1. Open frontend URL
2. Login with: `ADMIN001` / `admin123`
3. Create employees
4. Test attendance features

---

## 📊 Render Configuration Details

### Free Tier Limits:
- ✅ 750 hours/month per service
- ✅ Unlimited static sites
- ✅ SSL/HTTPS included
- ✅ Global CDN
- ✅ Auto-scaling

### Service Specifications:
```
Backend:  Web Service (Node.js)
Frontend: Static Site (React)
Database: MongoDB Atlas (Cloud)
```

---

## 🔧 Troubleshooting

### Build Failures:
- Check build logs in Render dashboard
- Verify `package.json` dependencies
- Ensure Node.js compatibility

### Runtime Errors:
- Verify environment variables
- Check MongoDB connection string
- Confirm CORS_ORIGIN URL

### Login Issues:
- Admin user created automatically
- Check JWT_SECRET is set
- Verify database connection

---

## 🚀 Quick Deployment Commands

```batch
# 1. Setup MongoDB
./setup-mongodb.bat

# 2. Deploy to Render
./deploy-to-render.bat

# 3. Test deployment
# Open your Render URLs
```

---

## 🎯 Production URLs (After Deployment)

```
Frontend: https://employee-frontend-xxxx.onrender.com
Backend:  https://employee-backend-xxxx.onrender.com
API:      https://employee-backend-xxxx.onrender.com/api
```

**Login Credentials:**
- Employee ID: `ADMIN001`
- Password: `admin123`

⚠️ **Change default password immediately!**

---

## 📞 Support

**Need Help?**
1. Check Render service logs
2. Verify environment variables
3. Test MongoDB connection
4. Confirm CORS settings

**Your Employee Login System will be live in 10-15 minutes!** 🚀