<# 
Usage:
  pwsh -File .\install.ps1 [-Src <repo-root>] [-Dst <workspace-root>]
Defaults:
  -Src: script directory
  -Dst: current directory
#>

param(
  [string]$Src = (Split-Path -Parent $MyInvocation.MyCommand.Path),
  [string]$Dst = (Get-Location).Path
)
$ErrorActionPreference = "Stop"

$AgentsSrc  = Join-Path $Src ".agents"
$ClaudeSrc  = Join-Path $Src "agents"
if (-not (Test-Path $AgentsSrc)) { throw "Missing: $AgentsSrc" }
if (-not (Test-Path $ClaudeSrc)) { throw "Missing: $ClaudeSrc" }

# .agents -> workspace\.agents  (skip if exists)
$AgentsDst = Join-Path $Dst ".agents"
if (Test-Path $AgentsDst) {
  Write-Host "Skip: $AgentsDst already exists."
} else {
  Write-Host "Copy: $AgentsSrc -> $AgentsDst"
  Copy-Item -Path $AgentsSrc -Destination $AgentsDst -Recurse
}

# agents -> workspace\.claude\agents  (skip if exists)
$ClaudeDst = Join-Path (Join-Path $Dst ".claude") "agents"
if (Test-Path $ClaudeDst) {
  Write-Host "Skip: $ClaudeDst already exists."
} else {
  Write-Host "Copy: $ClaudeSrc -> $ClaudeDst"
  New-Item -ItemType Directory -Force -Path (Split-Path $ClaudeDst) | Out-Null
  Copy-Item -Path $ClaudeSrc -Destination $ClaudeDst -Recurse
}

Write-Host "Done."
