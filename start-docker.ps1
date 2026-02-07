# PowerShell script to start Docker Engine and run docker compose up
# Requires Docker Desktop to be installed on Windows

Write-Host "Starting Docker Desktop..." -ForegroundColor Cyan

# Start Docker Desktop
$dockerDesktopPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

if (-not (Test-Path $dockerDesktopPath)) {
    Write-Host "Error: Docker Desktop not found at $dockerDesktopPath" -ForegroundColor Red
    Write-Host "Please ensure Docker Desktop is installed." -ForegroundColor Yellow
    exit 1
}

# Check if Docker is already running
$dockerProcess = Get-Process "Docker Desktop" -ErrorAction SilentlyContinue

if (-not $dockerProcess) {
    Write-Host "Launching Docker Desktop..." -ForegroundColor Yellow
    Start-Process $dockerDesktopPath
} else {
    Write-Host "Docker Desktop is already running." -ForegroundColor Green
}

# Wait for Docker Engine to be ready
Write-Host "Waiting for Docker Engine to initialize..." -ForegroundColor Yellow

$maxAttempts = 180  # Wait up to 180 seconds
$attempt = 0
$dockerReady = $false

while ($attempt -lt $maxAttempts) {
    try {
        $output = docker info 2>&1
        if ($LASTEXITCODE -eq 0) {
            $dockerReady = $true
            Write-Host "Docker Engine is ready!" -ForegroundColor Green
            break
        }
    } catch {
        # Docker not ready yet
    }
    
    $attempt++
    Write-Host "." -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
}

Write-Host ""  # New line after dots

if (-not $dockerReady) {
    Write-Host "Error: Docker Engine failed to start within the timeout period." -ForegroundColor Red
    Write-Host "Please check Docker Desktop and try again." -ForegroundColor Yellow
    exit 1
}

# Navigate to the script directory (where docker-compose.yaml is located)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "Running docker compose up..." -ForegroundColor Cyan

# Run docker compose up
docker compose up

Write-Host "Docker compose has stopped." -ForegroundColor Yellow
