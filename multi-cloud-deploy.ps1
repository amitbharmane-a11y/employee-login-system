# Multi-Cloud Automated Deployment Script
Write-Host "🌐 Multi-Cloud Employee Login System Deployment" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

Write-Host ""
Write-Host "Choose your deployment platform:" -ForegroundColor Cyan
Write-Host "1. Railway + Vercel (Recommended)" -ForegroundColor White
Write-Host "2. Render (All-in-One)" -ForegroundColor White
Write-Host "3. Netlify (Frontend + Functions)" -ForegroundColor White
Write-Host "4. Fly.io (Global Deployment)" -ForegroundColor White
Write-Host "5. DigitalOcean App Platform" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1-5)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🚂 Deploying to Railway + Vercel..." -ForegroundColor Green
        Write-Host "==================================" -ForegroundColor Green

        if (Test-Path "setup-automated-deployment.ps1") {
            & ".\setup-automated-deployment.ps1"
        } else {
            Write-Host "❌ Setup script not found. Please ensure all files are present." -ForegroundColor Red
        }
    }

    "2" {
        Write-Host ""
        Write-Host "🌐 Deploying to Render..." -ForegroundColor Green
        Write-Host "=======================" -ForegroundColor Green

        if (Test-Path "deploy-render.bat") {
            & ".\deploy-render.bat"
        } else {
            Write-Host "❌ Render deployment script not found." -ForegroundColor Red
        }
    }

    "3" {
        Write-Host ""
        Write-Host "🌍 Deploying to Netlify..." -ForegroundColor Green
        Write-Host "========================" -ForegroundColor Green

        # Check if Netlify CLI is installed
        try {
            $netlifyVersion = & netlify --version 2>$null
            Write-Host "✅ Netlify CLI found: $netlifyVersion" -ForegroundColor Green
        } catch {
            Write-Host "Installing Netlify CLI..." -ForegroundColor Yellow
            npm install -g netlify-cli
        }

        Write-Host ""
        Write-Host "Netlify Deployment Steps:" -ForegroundColor Cyan
        Write-Host "1. Go to https://netlify.com and create account" -ForegroundColor White
        Write-Host "2. Install Netlify CLI: npm install -g netlify-cli" -ForegroundColor White
        Write-Host "3. Login: netlify login" -ForegroundColor White
        Write-Host "4. Deploy: netlify deploy --prod" -ForegroundColor White
        Write-Host ""

        Read-Host "Press Enter after completing Netlify setup"

        Write-Host "Deploying frontend to Netlify..." -ForegroundColor Green
        Set-Location client
        netlify deploy --prod --dir=build
        Set-Location ..

        Write-Host ""
        Write-Host "For backend, you can use Netlify Functions:" -ForegroundColor Yellow
        Write-Host "1. Move server code to netlify/functions/" -ForegroundColor White
        Write-Host "2. Deploy functions with the frontend" -ForegroundColor White
    }

    "4" {
        Write-Host ""
        Write-Host "✈️ Deploying to Fly.io..." -ForegroundColor Green
        Write-Host "=====================" -ForegroundColor Green

        Write-Host "Fly.io Deployment Setup:" -ForegroundColor Cyan
        Write-Host "1. Go to https://fly.io and create account" -ForegroundColor White
        Write-Host "2. Install Fly CLI: iwr https://fly.io/install.ps1 -useb | iex" -ForegroundColor White
        Write-Host "3. Login: fly auth login" -ForegroundColor White
        Write-Host "4. Launch: fly launch" -ForegroundColor White
        Write-Host "5. Deploy: fly deploy" -ForegroundColor White
        Write-Host ""

        # Check if fly.toml exists
        if (Test-Path "fly.toml") {
            Write-Host "✅ Fly.io configuration found" -ForegroundColor Green
        } else {
            Write-Host "❌ fly.toml not found" -ForegroundColor Red
        }

        Read-Host "Press Enter after completing Fly.io setup"

        Write-Host "To deploy:" -ForegroundColor Green
        Write-Host "fly launch  # Follow prompts" -ForegroundColor White
        Write-Host "fly deploy  # Deploy changes" -ForegroundColor White
    }

    "5" {
        Write-Host ""
        Write-Host "🌊 Deploying to DigitalOcean App Platform..." -ForegroundColor Green
        Write-Host "===========================================" -ForegroundColor Green

        Write-Host "DigitalOcean App Platform Deployment:" -ForegroundColor Cyan
        Write-Host "1. Go to https://cloud.digitalocean.com" -ForegroundColor White
        Write-Host "2. Create account and project" -ForegroundColor White
        Write-Host "3. Go to Apps → Create App" -ForegroundColor White
        Write-Host "4. Connect your GitHub repository" -ForegroundColor White
        Write-Host "5. Configure services (frontend + backend)" -ForegroundColor White
        Write-Host "6. Set environment variables" -ForegroundColor White
        Write-Host "7. Deploy" -ForegroundColor White
        Write-Host ""

        Write-Host "DigitalOcean will auto-detect your services from:" -ForegroundColor Yellow
        Write-Host "- render.yaml or docker-compose.yml" -ForegroundColor White
        Write-Host "- package.json files" -ForegroundColor White
        Write-Host ""

        Read-Host "Press Enter to continue to DO deployment"

        Write-Host "Environment Variables needed:" -ForegroundColor Green
        Write-Host "NODE_ENV = production" -ForegroundColor White
        Write-Host "PORT = 8080" -ForegroundColor White
        Write-Host "MONGO_URI = [Your MongoDB Atlas URI]" -ForegroundColor White
        Write-Host "JWT_SECRET = [Secure JWT secret]" -ForegroundColor White
        Write-Host "CORS_ORIGIN = [Your frontend URL]" -ForegroundColor White
    }

    default {
        Write-Host "❌ Invalid choice. Please select 1-5." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "🎉 Multi-Cloud Deployment Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "Deployment Summary:" -ForegroundColor Cyan
switch ($choice) {
    "1" { Write-Host "🚂 Railway + Vercel - GitHub Actions automated deployment" -ForegroundColor White }
    "2" { Write-Host "🌐 Render - Blueprint multi-service deployment" -ForegroundColor White }
    "3" { Write-Host "🌍 Netlify - Frontend + Functions deployment" -ForegroundColor White }
    "4" { Write-Host "✈️ Fly.io - Global edge deployment" -ForegroundColor White }
    "5" { Write-Host "🌊 DigitalOcean - Managed cloud platform" -ForegroundColor White }
}

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Complete account setup for chosen platform" -ForegroundColor White
Write-Host "2. Set environment variables (MongoDB URI, JWT secret)" -ForegroundColor White
Write-Host "3. Deploy and test your application" -ForegroundColor White
Write-Host "4. Access your live Employee Login System!" -ForegroundColor White

Write-Host ""
Write-Host "Default Login Credentials:" -ForegroundColor Green
Write-Host "- Employee ID: ADMIN001" -ForegroundColor White
Write-Host "- Password: admin123" -ForegroundColor White
Write-Host "⚠️ Change password after first login!" -ForegroundColor Red

Write-Host ""
Read-Host "Press Enter to exit"