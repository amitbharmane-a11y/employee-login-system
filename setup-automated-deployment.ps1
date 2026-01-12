# Automated Deployment Setup Script
Write-Host "🚀 Setting up Automated Deployment" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green

Write-Host ""
Write-Host "This script will set up automated deployment using GitHub Actions" -ForegroundColor Yellow
Write-Host "You'll need to create accounts and tokens for each platform" -ForegroundColor Yellow

# Check prerequisites
Write-Host ""
Write-Host "📋 Checking Prerequisites..." -ForegroundColor Cyan

if (!(Test-Path ".github/workflows/auto-deploy.yml")) {
    Write-Host "❌ GitHub Actions workflow not found" -ForegroundColor Red
    exit 1
}

Write-Host "✅ GitHub Actions workflow ready" -ForegroundColor Green

# GitHub Secrets Setup
Write-Host ""
Write-Host "🔐 Step 1: GitHub Secrets Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Go to your GitHub repository → Settings → Secrets and variables → Actions" -ForegroundColor Yellow
Write-Host "Add these secrets:" -ForegroundColor Yellow
Write-Host ""

$secrets = @(
    "MONGODB_URI|Mongodb Atlas connection string",
    "JWT_SECRET|Secure JWT secret key",
    "RAILWAY_TOKEN|Railway CLI token",
    "VERCEL_TOKEN|Vercel CLI token",
    "VERCEL_FRONTEND_URL|Your Vercel frontend URL (after first deployment)"
)

foreach ($secret in $secrets) {
    $parts = $secret -split "\|"
    Write-Host "$($parts[0])" -ForegroundColor Green
    Write-Host "  Description: $($parts[1])" -ForegroundColor White
    Write-Host ""
}

Read-Host "Press Enter when you've added the GitHub secrets"

# Railway Setup
Write-Host ""
Write-Host "🚂 Step 2: Railway Setup" -ForegroundColor Cyan
Write-Host "=======================" -ForegroundColor Cyan

Write-Host ""
Write-Host "1. Go to https://railway.app" -ForegroundColor White
Write-Host "2. Create account and login" -ForegroundColor White
Write-Host "3. Install Railway CLI: npm install -g @railway/cli" -ForegroundColor White
Write-Host "4. Login: railway login" -ForegroundColor White
Write-Host "5. Create token: railway tokens create" -ForegroundColor White
Write-Host "6. Copy the token and add to GitHub as RAILWAY_TOKEN" -ForegroundColor White
Write-Host ""

$railwayReady = Read-Host "Have you completed Railway setup? (y/n)"
if ($railwayReady -ne "y") {
    Write-Host "Please complete Railway setup first" -ForegroundColor Red
    exit 1
}

# Vercel Setup
Write-Host ""
Write-Host "⚡ Step 3: Vercel Setup" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan

Write-Host ""
Write-Host "1. Go to https://vercel.com" -ForegroundColor White
Write-Host "2. Create account and login" -ForegroundColor White
Write-Host "3. Install Vercel CLI: npm install -g vercel" -ForegroundColor White
Write-Host "4. Login: vercel login" -ForegroundColor White
Write-Host "5. Get token from: https://vercel.com/account/tokens" -ForegroundColor White
Write-Host "6. Add token to GitHub as VERCEL_TOKEN" -ForegroundColor White
Write-Host ""

$vercelReady = Read-Host "Have you completed Vercel setup? (y/n)"
if ($vercelReady -ne "y") {
    Write-Host "Please complete Vercel setup first" -ForegroundColor Red
    exit 1
}

# MongoDB Setup
Write-Host ""
Write-Host "🗄️ Step 4: MongoDB Atlas Setup" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

Write-Host ""
Write-Host "1. Go to https://cloud.mongodb.com" -ForegroundColor White
Write-Host "2. Create account and project" -ForegroundColor White
Write-Host "3. Create M0 cluster (free)" -ForegroundColor White
Write-Host "4. Create user: employeeadmin" -ForegroundColor White
Write-Host "5. Allow access from anywhere (0.0.0.0/0)" -ForegroundColor White
Write-Host "6. Get connection string" -ForegroundColor White
Write-Host "7. Add to GitHub as MONGODB_URI" -ForegroundColor White
Write-Host ""

$mongoReady = Read-Host "Have you completed MongoDB Atlas setup? (y/n)"
if ($mongoReady -ne "y") {
    Write-Host "Please complete MongoDB Atlas setup first" -ForegroundColor Red
    exit 1
}

# Generate JWT Secret
Write-Host ""
Write-Host "🔑 Step 5: JWT Secret Generation" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$jwtSecret = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})
Write-Host ""
Write-Host "Generated JWT Secret:" -ForegroundColor Green
Write-Host "$jwtSecret" -ForegroundColor Yellow
Write-Host ""
Write-Host "Add this to GitHub as JWT_SECRET" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter when you've added the JWT secret to GitHub"

# Push and trigger deployment
Write-Host ""
Write-Host "🚀 Step 6: Trigger Automated Deployment" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Pushing code to trigger automated deployment..." -ForegroundColor Green

try {
    git add .
    git commit -m "🚀 Setup automated deployment with GitHub Actions

- Added automated deployment workflow
- Configured Railway backend deployment
- Configured Vercel frontend deployment
- Set up health checks and notifications
- Ready for production deployment"

    git push origin main

    Write-Host ""
    Write-Host "✅ Code pushed successfully!" -ForegroundColor Green
    Write-Host "GitHub Actions will now automatically deploy your application" -ForegroundColor Green

} catch {
    Write-Host "❌ Failed to push code: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Monitor deployment
Write-Host ""
Write-Host "📊 Step 7: Monitor Deployment" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

Write-Host ""
Write-Host "1. Go to your GitHub repository" -ForegroundColor White
Write-Host "2. Click 'Actions' tab" -ForegroundColor White
Write-Host "3. Watch the 'Auto Deploy to Production' workflow" -ForegroundColor White
Write-Host "4. Wait for all jobs to complete (10-15 minutes)" -ForegroundColor White
Write-Host ""

Write-Host "Expected Results:" -ForegroundColor Green
Write-Host "- ✅ Backend deployed to Railway" -ForegroundColor White
Write-Host "- ✅ Frontend deployed to Vercel" -ForegroundColor White
Write-Host "- ✅ Environment variables configured" -ForegroundColor White
Write-Host "- ✅ Health checks passed" -ForegroundColor White
Write-Host ""

Write-Host "🎉 Automated Deployment Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "Your application will be automatically deployed on every push to main branch!" -ForegroundColor Green
Write-Host ""
Write-Host "Manual trigger: Go to Actions → Auto Deploy to Production → Run workflow" -ForegroundColor Yellow

Write-Host ""
Read-Host "Press Enter to exit"