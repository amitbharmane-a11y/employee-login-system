@echo off
echo ===========================================
echo  🚀 EMPLOYEE LOGIN SYSTEM DEPLOYMENT
echo ===========================================
echo.
echo This script will guide you through deploying
echo your Employee Login System to production.
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
echo STEP 4: Deploy Backend to Railway
echo ================================
echo.
echo 1. Go to https://railway.app
echo 2. Sign up/Login with GitHub
echo 3. Click "New Project"
echo 4. Click "Deploy from GitHub"
echo 5. Search for "employee-login-system"
echo 6. Click "Connect" next to your repository
echo 7. Railway will auto-detect it's Node.js
echo 8. Go to "Variables" in your project
echo 9. Add these environment variables:
echo.
echo    NODE_ENV = production
echo    PORT = 5000
echo    MONGO_URI = [Your MongoDB Atlas connection string]
echo    JWT_SECRET = employee-jwt-secret-production-2024-secure-key
echo    CORS_ORIGIN = [Leave empty for now, we'll update this]
echo.
echo 10. Click "Deploy"
echo.
echo Press any key when Railway deployment is complete...
pause >nul

echo.
echo STEP 5: Get Railway Backend URL
echo ===============================
echo.
echo 1. In Railway dashboard, go to your project
echo 2. Copy the domain (e.g., https://your-app.up.railway.app)
echo 3. This is your BACKEND_URL
echo.
echo Press any key when you have your backend URL...
pause >nul

echo.
echo STEP 6: Update Railway CORS Setting
echo ===================================
echo.
echo 1. In Railway dashboard, go to Variables
echo 2. Update CORS_ORIGIN to your frontend URL
echo    (We'll set this after Vercel deployment)
echo.
echo For now, set it to: https://your-frontend.vercel.app
echo (We'll update this with the actual URL later)
echo.
echo Press any key to continue...
pause >nul

echo.
echo STEP 7: Deploy Frontend to Vercel
echo ================================
echo.
echo 1. Go to https://vercel.com
echo 2. Sign up/Login with GitHub
echo 3. Click "New Project"
echo 4. Import your GitHub repository
echo 5. Configure project:
echo     - Framework Preset: Create React App
echo     - Root Directory: client
echo     - Build Command: npm run build
echo     - Output Directory: build
echo 6. Environment Variables:
echo     - REACT_APP_API_URL = [Your Railway backend URL]/api
echo 7. Click "Deploy"
echo.
echo Press any key when Vercel deployment is complete...
pause >nul

echo.
echo STEP 8: Update CORS with Actual Frontend URL
echo =============================================
echo.
echo 1. Copy your Vercel frontend URL
echo 2. Go back to Railway dashboard
echo 3. Update CORS_ORIGIN with your actual Vercel URL
echo 4. Redeploy Railway (it should auto-redeploy)
echo.
echo Press any key when CORS is updated...
pause >nul

echo.
echo ===========================================
echo  🎉 DEPLOYMENT COMPLETE!
echo ===========================================
echo.
echo Your Employee Login System is now live!
echo.
echo 🌐 Frontend URL: [Your Vercel URL]
echo 🔗 Backend API: [Your Railway URL]/api
echo 🗄️ Database: MongoDB Atlas
echo.
echo 👤 Login Credentials:
echo    Employee ID: ADMIN001
echo    Password: admin123
echo.
echo ⚠️ IMPORTANT: Change the default admin password!
echo.
echo 🧪 Test your deployment:
echo 1. Go to your Vercel frontend URL
echo 2. Login with admin credentials
echo 3. Try creating a new employee
echo 4. Test attendance features
echo.
echo 📚 Documentation:
echo - README.md: Complete project guide
echo - DEPLOYMENT-GUIDE.md: Detailed deployment info
echo.
echo Press any key to exit...
pause >nul