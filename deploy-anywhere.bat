@echo off
echo ===========================================
echo  🌐 EMPLOYEE LOGIN SYSTEM - MULTI-CLOUD DEPLOYMENT
echo ===========================================
echo.
echo Choose your preferred cloud platform:
echo.
echo [1] Railway + Vercel (Recommended - Automated CI/CD)
echo [2] Render (All-in-One - Blueprint deployment)
echo [3] Netlify (Frontend + Functions)
echo [4] Fly.io (Global edge deployment)
echo [5] DigitalOcean App Platform (Managed cloud)
echo [6] Local Docker (Development only)
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" (
    echo.
    echo 🚂 Deploying to Railway + Vercel...
    echo ================================
    if exist "setup-automated-deployment.ps1" (
        powershell -ExecutionPolicy Bypass -File "setup-automated-deployment.ps1"
    ) else (
        echo ❌ Setup script not found
    )
    goto end
)

if "%choice%"=="2" (
    echo.
    echo 🌐 Deploying to Render...
    echo ====================
    if exist "deploy-render.bat" (
        call deploy-render.bat
    ) else (
        echo ❌ Render deployment script not found
    )
    goto end
)

if "%choice%"=="3" (
    echo.
    echo 🌍 Deploying to Netlify...
    echo ====================
    echo.
    echo Netlify Deployment Steps:
    echo 1. Go to https://netlify.com
    echo 2. Create account and login
    echo 3. Click "New site from Git"
    echo 4. Connect your GitHub repository
    echo 5. Configure build settings:
    echo    - Base directory: client
    echo    - Build command: npm run build
    echo    - Publish directory: build
    echo 6. Set environment variable:
    echo    - REACT_APP_API_URL = [Your backend API URL]
    echo.
    echo For backend, you can use Netlify Functions:
    echo 1. Install Netlify CLI: npm install -g netlify-cli
    echo 2. Login: netlify login
    echo 3. Deploy functions: netlify dev (for development)
    echo.
    pause
    goto end
)

if "%choice%"=="4" (
    echo.
    echo ✈️ Deploying to Fly.io...
    echo ===================
    echo.
    echo Fly.io Deployment Steps:
    echo 1. Go to https://fly.io
    echo 2. Create account and login
    echo 3. Install Fly CLI:
    echo    curl -L https://fly.io/install.sh ^| sh
    echo 4. Login: fly auth login
    echo 5. Launch app: fly launch
    echo    - Choose your app name
    echo    - Select region
    echo    - Choose PostgreSQL or skip DB setup
    echo 6. Set environment variables:
    echo    fly secrets set NODE_ENV=production
    echo    fly secrets set MONGO_URI=[your-mongodb-uri]
    echo    fly secrets set JWT_SECRET=[secure-secret]
    echo 7. Deploy: fly deploy
    echo.
    echo ✅ fly.toml configuration is ready in your project
    echo.
    pause
    goto end
)

if "%choice%"=="5" (
    echo.
    echo 🌊 Deploying to DigitalOcean App Platform...
    echo =========================================
    echo.
    echo DigitalOcean Deployment Steps:
    echo 1. Go to https://cloud.digitalocean.com
    echo 2. Create account and login
    echo 3. Go to "Apps" in left sidebar
    echo 4. Click "Create App"
    echo 5. Choose "GitHub" as source
    echo 6. Connect your GitHub account
    echo 7. Select your repository
    echo 8. Configure resources:
    echo    - Service 1 (Frontend):
    echo      * HTTP Port: 3000
    echo      * Source Directory: client
    echo      * Run Command: npm start
    echo    - Service 2 (Backend):
    echo      * HTTP Port: 5000
    echo      * Source Directory: server
    echo      * Run Command: npm start
    echo 9. Set environment variables for each service:
    echo    - NODE_ENV = production
    echo    - MONGO_URI = [your-mongodb-atlas-uri]
    echo    - JWT_SECRET = [secure-jwt-secret]
    echo    - CORS_ORIGIN = [frontend-url]
    echo    - REACT_APP_API_URL = [backend-url]/api
    echo 10. Click "Create Resources"
    echo.
    echo ✅ .do/app.yaml configuration is ready
    echo.
    pause
    goto end
)

if "%choice%"=="6" (
    echo.
    echo 🐳 Running with Docker (Local Development)...
    echo =========================================
    if exist "docker-compose.yml" (
        echo Starting Docker containers...
        echo This will run your app locally with:
        echo - MongoDB database
        echo - Node.js backend
        echo - React frontend
        echo.
        echo Access your app at:
        echo - Frontend: http://localhost:3000
        echo - Backend: http://localhost:5000
        echo.
        docker-compose up -d
        echo.
        echo ✅ Docker deployment started!
        echo Check http://localhost:3000
    ) else (
        echo ❌ docker-compose.yml not found
    )
    goto end
)

echo ❌ Invalid choice. Please select 1-6.
goto end

:end
echo.
echo 🎉 Deployment configuration complete!
echo =================================
echo.
echo Your Employee Login System is ready for deployment!
echo.
echo Default Login Credentials:
echo - Employee ID: ADMIN001
echo - Password: admin123
echo.
echo ⚠️ IMPORTANT: Change the default password after first login!
echo.
echo For automated deployment, use GitHub Actions:
echo 1. Push code to GitHub
echo 2. Go to Actions tab
echo 3. Run "Multi-Cloud Deployment" workflow
echo 4. Choose your platform
echo.
pause