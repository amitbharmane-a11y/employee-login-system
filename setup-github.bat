@echo off
echo ===========================================
echo  🚀 EMPLOYEE LOGIN SYSTEM - GITHUB SETUP
echo ===========================================
echo.
echo This script will help you set up GitHub
echo repository and push all files.
echo.
echo Press any key to continue...
pause >nul

echo.
echo STEP 1: Create GitHub Repository
echo ===============================
echo.
echo 1. Go to: https://github.com/new
echo 2. Repository name: employee-login-system
echo 3. Description: Complete Employee Attendance Management System with React and Node.js
echo 4. Make it PUBLIC (required for deployment)
echo 5. DON'T initialize with README (we already have one)
echo 6. DON'T add .gitignore (we have our own)
echo 7. DON'T add license (optional)
echo 8. Click "Create repository"
echo.
echo Press any key when you've created the repository...
pause >nul

echo.
echo STEP 2: Get Repository URL
echo =========================
echo.
echo After creating the repository, copy the URL from the setup page.
echo It should look like: https://github.com/YOUR_USERNAME/employee-login-system.git
echo.
set /p repo_url="Enter your GitHub repository URL: "

echo.
echo STEP 3: Update Git Remote
echo ========================
echo.
git remote set-url origin %repo_url%
echo Remote URL updated to: %repo_url%

echo.
echo STEP 4: Push to GitHub
echo =====================
echo.
git push -u origin main

echo.
echo ===========================================
echo  🎉 GITHUB SETUP COMPLETE!
echo ===========================================
echo.
echo Your Employee Login System is now on GitHub!
echo.
echo Repository URL: %repo_url%
echo.
echo 🌟 Ready for deployment to Render/Railway/Vercel!
echo.
echo Next steps:
echo 1. Deploy to Render: ./deploy-render.bat
echo 2. Or deploy to Railway + Vercel: ./deploy.bat
echo.
echo Press any key to exit...
pause >nul