$BINARY_NAME = "myapp"
$DSN = "host=localhost port=5432 user=postgres password=password dbname=concurrency sslmode=disable timezone=UTC connect_timeout=5"
$REDIS = "127.0.0.1:6379"

function Build {
    Write-Output "Building..."
    $env:CGO_ENABLED = "0"
    go build -ldflags="-s -w" -o $BINARY_NAME ./cmd/web
    Remove-Item env:CGO_ENABLED
    Write-Output "Built!"
}

function Run {
    Build
    Write-Output "Starting..."
    $env:DSN = $DSN
    $env:REDIS = $REDIS
    Start-Process -FilePath ".\$BINARY_NAME" -NoNewWindow
    Write-Output "Started!"
}

function Clean {
    Write-Output "Cleaning..."
    go clean
    Remove-Item $BINARY_NAME
    Write-Output "Cleaned!"
}

function Start {
    Run
}

function Stop {
    Write-Output "Stopping..."
    Get-Process | Where-Object {$_.Path -eq (Resolve-Path $BINARY_NAME)} | Stop-Process -Force
    Write-Output "Stopped!"
}

function Restart {
    Stop
    Start
}

function Test {
    Write-Output "Testing..."
    go test -v ./...
}

# Example usage: Uncomment the function call you wish to execute.

Run
# Clean
# Stop
# Restart
# Test
