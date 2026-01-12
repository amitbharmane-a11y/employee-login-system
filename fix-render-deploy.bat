@echo off
echo ===========================================
echo  🔧 RENDER BACKEND DIRECTORY FIX
echo ===========================================
echo.
echo This script fixes the Render backend directory issue
echo by creating a 'backend' directory that Render expects.
echo.
echo Press any key to continue...
pause >nul

echo.
echo STEP 1: Push fixes to GitHub
echo ============================
echo.

REM Check if git remote is configured
git remote -v | findstr "origin" >nul
if errorlevel 1 (
    echo ❌ No GitHub remote configured.
    echo Please run setup-github.bat first.
    pause
    exit /b 1
)

echo ✅ GitHub remote found
echo Pushing fixes...

git push origin main

if errorlevel 1 (
    echo ❌ Failed to push to GitHub
    echo Please check your repository URL and try again
    pause
    exit /b 1
)

echo ✅ Code pushed to GitHub successfully

echo.
echo STEP 2: Redeploy on Render
echo =========================
echo.
echo Now you need to redeploy on Render:
echo.
echo 1. Go to https://render.com/dashboard
echo 2. Find your "employee-login-system" Blueprint
echo 3. Click "Manual Deploy" → "Deploy latest commit"
echo 4. Wait for both services to redeploy
echo.
echo The backend will now find the 'backend/' directory!
echo.
echo Press any key when deployment is complete...
pause >nul

echo.
echo STEP 3: Update Environment Variables
echo ====================================
echo.
echo Make sure these are set in your Render services:
echo.
echo BACKEND SERVICE:
echo ================
echo NODE_ENV = production
echo PORT = 10000
echo MONGO_URI = [your MongoDB Atlas connection string]
echo JWT_SECRET = f6ff32a8907c3353cb10b378d1bf9dbf033bc73e15e104626ba24a389b8fc050
echo CORS_ORIGIN = [your frontend URL after deployment]
echo.
echo FRONTEND SERVICE:
echo =================
echo REACT_APP_API_URL = [your backend URL after deployment]/api
echo.
echo Press any key when environment variables are set...
pause >nul

echo.
echo ===========================================
echo  🎉 RENDER FIX COMPLETE!
echo ===========================================
echo.
echo Your Employee Login System should now deploy successfully!
echo.
echo 🌐 Frontend: https://your-frontend.onrender.com
echo 🔗 Backend: https://your-backend.onrender.com
echo 👤 Login: ADMIN001 / admin123
echo.
echo If you still get errors, delete and recreate the Blueprint.
echo.
pause