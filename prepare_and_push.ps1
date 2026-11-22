# ==============================================================================
# One-Step Setup & Push Script for https://github.com/ChinmoyDn818/Rajshahi-Multimodal-Traffic-TGCN
# Run this script in PowerShell from inside the unzipped repo folder AFTER
# creating an empty public repository named "Rajshahi-Multimodal-Traffic-TGCN" on GitHub.
# ==============================================================================

$ErrorActionPreference = "Stop"

$SourceCsvDir = "D:\RF-DETR (Thesis)\Extracted Frames\CSV1"
$DestCsvDir   = Join-Path $PSScriptRoot "data\csv_5min"
$RemoteUrl    = "https://github.com/ChinmoyDn818/Rajshahi-Multimodal-Traffic-TGCN.git"

Write-Host "1. Copying anonymized RF-DETR 5-minute flow CSVs..." -ForegroundColor Cyan
if (-not (Test-Path $SourceCsvDir)) {
    Write-Error "Source directory not found: $SourceCsvDir. Please edit `$SourceCsvDir in this script."
}

New-Item -ItemType Directory -Force -Path $DestCsvDir | Out-Null

$csvFiles = Get-ChildItem -Path $SourceCsvDir -Filter "*_flow_data.csv" | Where-Object {
    $_.Name.ToLower() -notmatch "_yolo_" -and $_.Name.ToLower() -notmatch "_backup_"
}

if ($csvFiles.Count -eq 0) {
    Write-Error "No matching RF-DETR *_flow_data.csv files found in $SourceCsvDir."
}

foreach ($file in $csvFiles) {
    Copy-Item -Path $file.FullName -Destination $DestCsvDir -Force
}
Write-Host "   Copied $($csvFiles.Count) anonymized RF-DETR CSV files to data\csv_5min\" -ForegroundColor Green

# Safety check: verify zero video files exist inside repo
$videos = Get-ChildItem -Path $PSScriptRoot -Recurse -Include *.mp4,*.avi,*.mov,*.mkv
if ($videos.Count -gt 0) {
    Write-Error "SAFETY STOP: Found video file(s) inside repo folder! Remove them before pushing."
}

Write-Host "2. Initializing Git repository and committing files..." -ForegroundColor Cyan
Set-Location $PSScriptRoot
if (-not (Test-Path ".git")) {
    git init
}
git branch -M main
git add .
git commit -m "Initial release: Rajshahi multimodal traffic count dataset, 3-seed T-GCN benchmarks & HCM 2010 delay proof"

Write-Host "3. Connecting remote and pushing to GitHub..." -ForegroundColor Cyan
$existingRemote = git remote
if ($existingRemote -contains "origin") {
    git remote set-url origin $RemoteUrl
} else {
    git remote add origin $RemoteUrl
}
git push -u origin main

Write-Host "`nDONE! Your public repository is live at: https://github.com/ChinmoyDn818/Rajshahi-Multimodal-Traffic-TGCN" -ForegroundColor Green
