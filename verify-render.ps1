# PowerShell script to verify Render deployment
Write-Host "🔍 Verifying Employee Login System - Render Deployment" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green

# Function to test Render URL
function Test-RenderUrl {
    param([string]$url, [string]$name)

    try {
        $response = Invoke-WebRequest -Uri $url -TimeoutSec 15 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $name is accessible: $url" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ $name returned status code: $($response.StatusCode)" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "❌ $name is not accessible: $url" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to test API endpoint
function Test-RenderAPI {
    param([string]$url, [string]$name)

    try {
        $body = @{
            employeeId = "ADMIN001"
            password = "admin123"
        } | ConvertTo-Json

        $response = Invoke-WebRequest -Uri $url -Method POST -Body $body -ContentType "application/json" -TimeoutSec 20 -ErrorAction Stop

        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $name API is working: Login successful" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ $name API returned status code: $($response.StatusCode)" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "❌ $name API failed:" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Get Render URLs from user
Write-Host ""
$frontendUrl = Read-Host "Enter your Render frontend URL (e.g., https://employee-frontend.onrender.com)"
$backendUrl = Read-Host "Enter your Render backend URL (e.g., https://employee-backend.onrender.com)"

if (-not $frontendUrl -or -not $backendUrl) {
    Write-Host "❌ Both Render URLs are required. Exiting..." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔍 Testing Render Frontend..." -ForegroundColor Yellow
$frontendOk = Test-RenderUrl $frontendUrl "Render Frontend"

Write-Host ""
Write-Host "🔍 Testing Render Backend..." -ForegroundColor Yellow
$backendOk = Test-RenderUrl $backendUrl "Render Backend"

Write-Host ""
Write-Host "🔍 Testing Render API Login..." -ForegroundColor Yellow
$apiOk = Test-RenderAPI "$backendUrl/api/auth/login" "Render Backend"

Write-Host ""
Write-Host "📊 RENDER DEPLOYMENT VERIFICATION RESULTS" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

if ($frontendOk -and $backendOk -and $apiOk) {
    Write-Host "🎉 RENDER DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
    Write-Host "Your Employee Login System is live on Render!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Frontend: $frontendUrl" -ForegroundColor Green
    Write-Host "🔗 Backend: $backendUrl" -ForegroundColor Green
    Write-Host "👤 Login: ADMIN001 / admin123" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "⚠️ Remember to change the default admin password!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🚀 Render Features Active:" -ForegroundColor Cyan
    Write-Host "  • Automatic SSL/HTTPS" -ForegroundColor White
    Write-Host "  • Global CDN" -ForegroundColor White
    Write-Host "  • Auto-scaling" -ForegroundColor White
    Write-Host "  • Free tier (750 hours/month)" -ForegroundColor White
} else {
    Write-Host "❌ Some issues were found with your Render deployment:" -ForegroundColor Red
    if (-not $frontendOk) { Write-Host "  - Frontend service not responding" -ForegroundColor Red }
    if (-not $backendOk) { Write-Host "  - Backend service not responding" -ForegroundColor Red }
    if (-not $apiOk) { Write-Host "  - Database connection or API configuration" -ForegroundColor Red }
    Write-Host ""
    Write-Host "🔧 Troubleshooting Tips:" -ForegroundColor Yellow
    Write-Host "  1. Check Render service logs for errors" -ForegroundColor White
    Write-Host "  2. Verify MongoDB Atlas connection string" -ForegroundColor White
    Write-Host "  3. Ensure CORS_ORIGIN matches your frontend URL" -ForegroundColor White
    Write-Host "  4. Check REACT_APP_API_URL in frontend service" -ForegroundColor White
    Write-Host "  5. Wait a few minutes for services to fully start" -ForegroundColor White
}

Write-Host ""
Read-Host "Press Enter to exit"