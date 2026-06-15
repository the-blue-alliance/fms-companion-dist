# PowerShell script to import an offline Docker image archive and start the Companion
# Requires Docker Desktop to be installed on Windows

$imageName = "phillopreiato/tba-offseason-companion:latest"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

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

Add-Type -AssemblyName System.Windows.Forms

$fileDialog = New-Object System.Windows.Forms.OpenFileDialog
$fileDialog.Title = "Select the saved TBA Companion Docker image archive"
$fileDialog.Filter = "Tar archives (*.tar)|*.tar|All files (*.*)|*.*"
$fileDialog.InitialDirectory = $scriptDir
$fileDialog.CheckFileExists = $true
$fileDialog.Multiselect = $false

if ($fileDialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
    Write-Host "No image archive selected. Offline install cancelled." -ForegroundColor Yellow
    exit 1
}

$imageArchivePath = $fileDialog.FileName

Write-Host "Importing Docker image archive..." -ForegroundColor Cyan
Write-Host $imageArchivePath -ForegroundColor Gray

docker import $imageArchivePath $imageName

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker image import failed." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Docker image imported as $imageName" -ForegroundColor Green

# Start the Companion
$startDockerScript = Join-Path $scriptDir "start-docker.ps1"

if (-not (Test-Path $startDockerScript)) {
    Write-Host "Error: start-docker.ps1 not found at $startDockerScript" -ForegroundColor Red
    exit 1
}

Write-Host "Starting the Companion..." -ForegroundColor Cyan
& $startDockerScript
