# PowerShell script to verify deployment
Write-Host "🔍 Verifying Employee Login System Deployment" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Function to test URL
function Test-DeploymentUrl {
    param([string]$url, [string]$name)

    try {
        $response = Invoke-WebRequest -Uri $url -TimeoutSec 10 -ErrorAction Stop
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
function Test-APIEndpoint {
    param([string]$url, [string]$name)

    try {
        $body = @{
            employeeId = "ADMIN001"
            password = "admin123"
        } | ConvertTo-Json

        $response = Invoke-WebRequest -Uri $url -Method POST -Body $body -ContentType "application/json" -TimeoutSec 15 -ErrorAction Stop

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

# Get URLs from user
Write-Host ""
$frontendUrl = Read-Host "Enter your Vercel frontend URL (e.g., https://your-app.vercel.app)"
$backendUrl = Read-Host "Enter your Railway backend URL (e.g., https://your-app.up.railway.app)"

if (-not $frontendUrl -or -not $backendUrl) {
    Write-Host "❌ Both URLs are required. Exiting..." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔍 Testing Frontend..." -ForegroundColor Yellow
$frontendOk = Test-DeploymentUrl $frontendUrl "Frontend"

Write-Host ""
Write-Host "🔍 Testing Backend..." -ForegroundColor Yellow
$backendOk = Test-DeploymentUrl $backendUrl "Backend"

Write-Host ""
Write-Host "🔍 Testing API Login..." -ForegroundColor Yellow
$apiOk = Test-APIEndpoint "$backendUrl/api/auth/login" "Backend"

Write-Host ""
Write-Host "📊 DEPLOYMENT VERIFICATION RESULTS" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

if ($frontendOk -and $backendOk -and $apiOk) {
    Write-Host "🎉 ALL SYSTEMS GO! Your deployment is working perfectly!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Frontend: $frontendUrl" -ForegroundColor Green
    Write-Host "🔗 Backend: $backendUrl" -ForegroundColor Green
    Write-Host "👤 Login: ADMIN001 / admin123" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "⚠️ Remember to change the default admin password!" -ForegroundColor Yellow
} else {
    Write-Host "❌ Some issues were found. Please check:" -ForegroundColor Red
    if (-not $frontendOk) { Write-Host "  - Frontend deployment" -ForegroundColor Red }
    if (-not $backendOk) { Write-Host "  - Backend deployment" -ForegroundColor Red }
    if (-not $apiOk) { Write-Host "  - Database connection or API setup" -ForegroundColor Red }
    Write-Host ""
    Write-Host "📖 Check the DEPLOYMENT-GUIDE.md for troubleshooting" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"