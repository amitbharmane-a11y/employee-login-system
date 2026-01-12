@echo off
echo ===========================================
echo  🚀 EMPLOYEE LOGIN SYSTEM - RENDER DEPLOYMENT
echo ===========================================
echo.
echo This will deploy your complete application to Render.
echo Requirements: GitHub repository + MongoDB Atlas
echo.
echo Press any key to start...
pause >nul

echo.
echo CHECKING REQUIREMENTS...
echo =======================
echo.

REM Check if git is available
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git is not installed. Please install Git first.
    pause
    exit /b 1
) else (
    echo ✅ Git is installed
)

REM Check if repository exists
if not exist ".git" (
    echo ❌ Not a Git repository. Please run from project root.
    pause
    exit /b 1
) else (
    echo ✅ Git repository found
)

REM Check if remote is configured
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ❌ No GitHub remote configured.
    echo Please run setup-github.bat first.
    pause
    exit /b 1
) else (
    echo ✅ GitHub remote configured
)

echo.
echo REQUIREMENTS CHECKED ✅
echo.

echo STEP 1: MongoDB Atlas Setup
echo ===========================
echo.
echo You need MongoDB Atlas for the database.
echo.
choice /c YN /m "Do you have MongoDB Atlas set up? (Y/N)"
if errorlevel 2 goto setup_mongo

echo ✅ MongoDB Atlas already set up
goto render_deploy

:setup_mongo
echo.
echo Setting up MongoDB Atlas...
echo Run: ./setup-mongodb.bat
echo.
echo After setup, run this script again.
pause
exit /b 0

:render_deploy
echo.
echo STEP 2: Deploy to Render
echo ========================
echo.
echo 1. Go to: https://render.com
echo 2. Sign up/Login with GitHub
echo 3. Click "New" → "Blueprint"
echo 4. Connect your GitHub account (if not connected)
echo 5. Search for: employee-login-system
echo 6. Select your repository
echo 7. Render will detect render.yaml automatically
echo.
echo Press any key when ready to continue...
pause >nul

echo.
echo STEP 3: Configure Services
echo ==========================
echo.
echo Render will create two services:
echo.
echo BACKEND SERVICE (employee-backend):
echo - Type: Web Service
echo - Runtime: Node
echo - Root Directory: server
echo - Build Command: npm install
echo - Start Command: npm start
echo.
echo FRONTEND SERVICE (employee-frontend):
echo - Type: Static Site
echo - Root Directory: client
echo - Build Command: npm install && npm run build
echo - Publish Directory: build
echo.
echo Press any key when services are configured...
pause >nul

echo.
echo STEP 4: Environment Variables
echo =============================
echo.
echo Set these in Render dashboard:
echo.
echo BACKEND SERVICE ENVIRONMENT VARIABLES:
echo ======================================
echo NODE_ENV = production
echo PORT = 10000
echo MONGO_URI = [Your MongoDB Atlas connection string]
echo JWT_SECRET = employee-jwt-render-2024-secure-key-change-this
echo CORS_ORIGIN = https://your-frontend.onrender.com
echo.
echo FRONTEND SERVICE ENVIRONMENT VARIABLES:
echo =======================================
echo REACT_APP_API_URL = [Your backend service URL]/api
echo.
echo IMPORTANT: Get your MongoDB connection string first!
echo.
set /p mongo_uri="Enter your MongoDB Atlas connection string: "
set /p backend_url="Enter your backend service URL (after deployment): "
set /p frontend_url="Enter your frontend service URL (after deployment): "

echo.
echo STEP 5: Deploy Services
echo =======================
echo.
echo 1. Click "Create Blueprint"
echo 2. Wait for both services to build (5-10 minutes)
echo 3. Services will be deployed automatically
echo.
echo Press any key when deployment is complete...
pause >nul

echo.
echo STEP 6: Update CORS Origin
echo ===========================
echo.
echo 1. Go to backend service → Environment
echo 2. Update CORS_ORIGIN to: %frontend_url%
echo 3. Save changes (auto-redeploys)
echo.
echo Press any key when CORS is updated...
pause >nul

echo.
echo ===========================================
echo  🎉 DEPLOYMENT COMPLETE!
echo ===========================================
echo.
echo Your Employee Login System is live on Render!
echo.
echo 🌐 Frontend: %frontend_url%
echo 🔗 Backend API: %backend_url%/api
echo 🗄️ Database: MongoDB Atlas
echo.
echo 👤 Login Credentials:
echo    Employee ID: ADMIN001
echo    Password: admin123
echo.
echo ⚠️ IMPORTANT: Change the default admin password!
echo.
echo 🧪 Test your deployment:
echo 1. Visit %frontend_url%
echo 2. Login with admin credentials
echo 3. Try creating employees
echo.
echo 📊 Render Services:
echo - Free tier: 750 hours/month per service
echo - Auto-scaling included
echo - HTTPS included
echo - Global CDN
echo.
echo 🚀 Deployment successful! Your app is production-ready.
echo.
pause