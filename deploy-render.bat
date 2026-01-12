@echo off
echo ===========================================
echo  🚀 EMPLOYEE LOGIN SYSTEM - RENDER DEPLOYMENT
echo ===========================================
echo.
echo This script will guide you through deploying
echo your Employee Login System to Render.
echo.
echo Press any key to continue...
pause >nul

echo.
echo STEP 1: GitHub Repository Setup
echo ===============================
echo.
echo 1. Go to https://github.com/new
echo 2. Repository name: employee-login-system
echo 3. Make it public
echo 4. DON'T initialize with README
echo 5. Click "Create repository"
echo.
echo Press any key when you've created the repository...
pause >nul

echo.
echo STEP 2: Push Code to GitHub
echo ===========================
echo.
echo Run these commands (copy and paste):
echo.
echo git remote add origin https://github.com/YOUR_USERNAME/employee-login-system.git
echo git branch -M main
echo git push -u origin main
echo.
echo Replace YOUR_USERNAME with your GitHub username.
echo.
echo Press any key after you've pushed the code...
pause >nul

echo.
echo STEP 3: MongoDB Atlas Setup
echo ===========================
echo.
echo 1. Go to https://cloud.mongodb.com
echo 2. Sign up/Login
echo 3. Create a new project
echo 4. Build a cluster (choose FREE tier)
echo 5. Create database user:
echo    - Username: employeeadmin
echo    - Password: Create a strong password
echo 6. Configure network access:
echo    - Add IP Address: 0.0.0.0/0
echo 7. Connect your application:
echo    - Choose "Connect your application"
echo    - Driver: Node.js
echo    - Copy the connection string
echo.
echo Save your connection string, you'll need it!
echo.
echo Press any key when MongoDB Atlas is ready...
pause >nul

echo.
echo STEP 4: Deploy to Render (Multi-Service)
echo ========================================
echo.
echo Option 1: Multi-Service Deployment (Recommended)
echo ------------------------------------------------
echo.
echo 1. Go to https://render.com
echo 2. Sign up/Login with GitHub
echo 3. Click "New" → "Blueprint"
echo 4. Connect your GitHub repository
echo 5. Render will detect render.yaml
echo 6. Configure services:
echo.
echo    Backend Service (employee-backend):
echo    - Service Type: Web Service
echo    - Runtime: Node
echo    - Build Command: npm install
echo    - Start Command: npm start
echo    - Root Directory: server
echo.
echo    Environment Variables:
echo    NODE_ENV = production
echo    PORT = 10000
echo    MONGO_URI = [Your MongoDB Atlas connection string]
echo    JWT_SECRET = employee-jwt-secret-render-2024-secure-key
echo    CORS_ORIGIN = [Leave empty for now]
echo.
echo    Frontend Service (employee-frontend):
echo    - Service Type: Static Site
echo    - Build Command: npm install && npm run build
echo    - Publish Directory: build
echo    - Root Directory: client
echo.
echo    Environment Variables:
echo    REACT_APP_API_URL = [Your backend URL]/api
echo.
echo 7. Click "Create Blueprint"
echo.
echo Press any key when Render deployment is complete...
pause >nul

echo.
echo STEP 5: Update CORS Setting
echo ===========================
echo.
echo 1. Copy your Render frontend URL
echo 2. Go to your backend service settings
echo 3. Update CORS_ORIGIN with your frontend URL
echo 4. Save and redeploy
echo.
echo Press any key when CORS is updated...
pause >nul

echo.
echo ===========================================
echo  🎉 RENDER DEPLOYMENT COMPLETE!
echo ===========================================
echo.
echo Your Employee Login System is now live on Render!
echo.
echo 🌐 Frontend URL: [Your Render frontend URL]
echo 🔗 Backend API: [Your Render backend URL]/api
echo 🗄️ Database: MongoDB Atlas
echo.
echo 👤 Login Credentials:
echo    Employee ID: ADMIN001
echo    Password: admin123
echo.
echo ⚠️ IMPORTANT: Change the default admin password!
echo.
echo 🧪 Test your Render deployment:
echo 1. Go to your Render frontend URL
echo 2. Login with admin credentials
echo 3. Try creating a new employee
echo 4. Test attendance features
echo.
echo 📚 Render Features:
echo - Automatic SSL/HTTPS
echo - Global CDN
echo - Auto-scaling
echo - Free tier available
echo - GitHub integration
echo.
echo Press any key to exit...
pause >nul