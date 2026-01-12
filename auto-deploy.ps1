# PowerShell script for automated deployment
Write-Host "🚀 Automated Employee Login System Deployment" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green

# Check prerequisites
Write-Host ""
Write-Host "📋 Checking Prerequisites..." -ForegroundColor Yellow

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js" -ForegroundColor Red
    exit 1
}

# Check npm
try {
    $npmVersion = npm --version
    Write-Host "✅ npm: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm not found" -ForegroundColor Red
    exit 1
}

# Check Git
try {
    $gitVersion = git --version
    Write-Host "✅ Git available" -ForegroundColor Green
} catch {
    Write-Host "❌ Git not found. Please install Git" -ForegroundColor Red
    exit 1
}

# Check if we're in the right directory
if (!(Test-Path "render.yaml")) {
    Write-Host "❌ Not in project root directory. Please run from employee-login-system/" -ForegroundColor Red
    exit 1
}

Write-Host "✅ All prerequisites met" -ForegroundColor Green

# Setup MongoDB Atlas
Write-Host ""
Write-Host "🗄️ Step 1: MongoDB Atlas Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$mongoSetup = Read-Host "Have you set up MongoDB Atlas? (y/n)"
if ($mongoSetup -ne "y") {
    Write-Host ""
    Write-Host "Please complete MongoDB Atlas setup first:" -ForegroundColor Yellow
    Write-Host "1. Go to https://cloud.mongodb.com" -ForegroundColor White
    Write-Host "2. Create account and project" -ForegroundColor White
    Write-Host "3. Create M0 cluster (free)" -ForegroundColor White
    Write-Host "4. Create user: employeeadmin" -ForegroundColor White
    Write-Host "5. Allow access from anywhere (0.0.0.0/0)" -ForegroundColor White
    Write-Host "6. Get connection string" -ForegroundColor White
    Write-Host ""
    $mongoUri = Read-Host "Enter your MongoDB Atlas connection string"
} else {
    $mongoUri = Read-Host "Enter your MongoDB Atlas connection string"
}

# Setup Railway
Write-Host ""
Write-Host "🚂 Step 2: Railway Backend Deployment" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

$railwaySetup = Read-Host "Do you have Railway account and CLI token? (y/n)"
if ($railwaySetup -ne "y") {
    Write-Host ""
    Write-Host "Railway Setup Required:" -ForegroundColor Yellow
    Write-Host "1. Go to https://railway.app" -ForegroundColor White
    Write-Host "2. Create account" -ForegroundColor White
    Write-Host "3. Install Railway CLI: npm install -g @railway/cli" -ForegroundColor White
    Write-Host "4. Login: railway login" -ForegroundColor White
    Write-Host "5. Get token: railway tokens create" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter when Railway is set up"
}

Write-Host "Deploying backend to Railway..." -ForegroundColor Green

# Deploy backend (this would require Railway CLI to be authenticated)
Write-Host "Note: Complete Railway deployment manually for now:" -ForegroundColor Yellow
Write-Host "1. railway login" -ForegroundColor White
Write-Host "2. railway add --name employee-backend" -ForegroundColor White
Write-Host "3. railway up" -ForegroundColor White
Write-Host "4. Set environment variables in Railway dashboard" -ForegroundColor White

# Setup Vercel
Write-Host ""
Write-Host "⚡ Step 3: Vercel Frontend Deployment" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

$vercelSetup = Read-Host "Do you have Vercel account and CLI token? (y/n)"
if ($vercelSetup -ne "y") {
    Write-Host ""
    Write-Host "Vercel Setup Required:" -ForegroundColor Yellow
    Write-Host "1. Go to https://vercel.com" -ForegroundColor White
    Write-Host "2. Create account" -ForegroundColor White
    Write-Host "3. Install Vercel CLI: npm install -g vercel" -ForegroundColor White
    Write-Host "4. Login: vercel login" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter when Vercel is set up"
}

Write-Host "Deploying frontend to Vercel..." -ForegroundColor Green
Set-Location client

try {
    # This would require Vercel authentication
    Write-Host "Note: Complete Vercel deployment manually for now:" -ForegroundColor Yellow
    Write-Host "1. cd client" -ForegroundColor White
    Write-Host "2. vercel --prod" -ForegroundColor White
    Write-Host "3. Set REACT_APP_API_URL environment variable" -ForegroundColor White
} catch {
    Write-Host "Vercel deployment requires authentication" -ForegroundColor Yellow
}

Set-Location ..

# Final configuration
Write-Host ""
Write-Host "🔧 Step 4: Final Configuration" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Environment Variables Needed:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Railway Backend:" -ForegroundColor Green
Write-Host "NODE_ENV = production" -ForegroundColor White
Write-Host "PORT = 5000" -ForegroundColor White
Write-Host "MONGO_URI = $mongoUri" -ForegroundColor White
Write-Host "JWT_SECRET = employee-jwt-production-2024-secure" -ForegroundColor White
Write-Host "CORS_ORIGIN = [Your Vercel frontend URL]" -ForegroundColor White
Write-Host ""
Write-Host "Vercel Frontend:" -ForegroundColor Green
Write-Host "REACT_APP_API_URL = [Your Railway backend URL]/api" -ForegroundColor White

Write-Host ""
Write-Host "🎉 Deployment Setup Complete!" -ForegroundColor Green
Write-Host "============================" -ForegroundColor Green

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Complete Railway deployment manually" -ForegroundColor White
Write-Host "2. Complete Vercel deployment manually" -ForegroundColor White
Write-Host "3. Set environment variables in both platforms" -ForegroundColor White
Write-Host "4. Update CORS_ORIGIN with actual Vercel URL" -ForegroundColor White
Write-Host "5. Test your deployed application" -ForegroundColor White

Write-Host ""
Write-Host "Your app will be live at:" -ForegroundColor Green
Write-Host "- Frontend: https://your-app.vercel.app" -ForegroundColor White
Write-Host "- Backend: https://your-app.up.railway.app" -ForegroundColor White

Write-Host ""
Write-Host "Login Credentials:" -ForegroundColor Yellow
Write-Host "- Employee ID: ADMIN001" -ForegroundColor White
Write-Host "- Password: admin123" -ForegroundColor White

Write-Host ""
Read-Host "Press Enter to exit"