# Define environment variables
$env:DSN="host=localhost port=5432 user=postgres password=password dbname=concurrency sslmode=disable timezone=UTC connect_timeout=5"
$env:BINARY_NAME="myapp.exe"
$env:REDIS="127.0.0.1:6379"

function Build {
    Write-Host "Building..."
    go build -o $env:BINARY_NAME ./cmd/web
    Write-Host "Back end built!"
}

function Run {
    Build
    Write-Host "Starting..."
    Start-Process -WindowStyle Minimized -FilePath cmd.exe -ArgumentList "/c", $env:BINARY_NAME
    Write-Host "Back end started!"
}

function Clean {
    Write-Host "Cleaning..."
    Remove-Item $env:BINARY_NAME -ErrorAction Ignore
    go clean
    Write-Host "Cleaned!"
}

function Start {
    Run
}

function Stop {
    Write-Host "Stopping..."
    Stop-Process -Name $env:BINARY_NAME -Force -ErrorAction SilentlyContinue
    Write-Host "Stopped back end"
}

function Restart {
    Stop
    Start
}

function Test {
    Write-Host "Testing..."
    go test -v ./...
}

# To directly call a function from the command line arguments
switch ($args[0]) {
    "build" { Build }
    "run" { Run }
    "clean" { Clean }
    "start" { Start }
    "stop" { Stop }
    "restart" { Restart }
    "test" { Test }
    default { Write-Host "Invalid command." }
}
