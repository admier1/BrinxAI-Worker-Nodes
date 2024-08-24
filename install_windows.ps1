# Exit immediately if a command exits with a non-zero status
$ErrorActionPreference = "Stop"

# Function to check if a command exists
function Test-Command {
    param (
        [string]$command
    )
    $commandExists = Get-Command $command -ErrorAction SilentlyContinue
    return $commandExists -ne $null
}

# Check if Docker is installed
if (-not (Test-Command "docker")) {
    Write-Host "Docker is not installed. Please install Docker and try again." -ForegroundColor Red
    exit 1
}

# Check if GPU is available
Write-Host "Checking GPU availability..."
$GPU_AVAILABLE = $false
if (Test-Command "nvidia-smi") {
    Write-Host "GPU detected. NVIDIA driver is installed."
    $GPU_AVAILABLE = $true
} else {
    Write-Host "No GPU detected or NVIDIA driver not installed."
}

# Prompt user for WORKER_PORT
$USER_PORT = Read-Host "Enter the port number for WORKER_PORT (default is 5011)"
if (-not $USER_PORT) {
    $USER_PORT = "5011"
}

# Create .env file with user-defined WORKER_PORT
Write-Host "Creating .env file..."
@"
WORKER_PORT=$USER_PORT
"@ | Out-File -FilePath .env -Encoding ascii

# Create docker-compose.yml file
Write-Host "Creating docker-compose.yml..."
$dockerComposeContent = @"
version: '3.8'

services:
  worker:
    image: admier/brinxai_nodes-worker:latest
    environment:
      - WORKER_PORT=$USER_PORT
    ports:
      - "$USER_PORT:$USER_PORT"
    volumes:
      - ./generated_images:/usr/src/app/generated_images
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - brinxai-network
"@

if ($GPU_AVAILABLE) {
    $dockerComposeContent += @"
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
    runtime: nvidia
"@
}

$dockerComposeContent += @"
networks:
  brinxai-network:
    driver: bridge
    name: brinxai-network
"@

$dockerComposeContent | Out-File -FilePath docker-compose.yml -Encoding ascii

# Start Docker containers using docker compose
Write-Host "Starting Docker containers..."
docker-compose up -d

Write-Host "Installation and setup completed successfully."
