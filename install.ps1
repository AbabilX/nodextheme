# Murad AMOLED — Windows PowerShell installer
# One-liner:
#   irm https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.ps1 | iex
#
# Options:
#   irm ... | iex ;  # default VS Code
#   & ([scriptblock]::Create((irm ...))) -Target vscode
#   .\install.ps1 -Target all
#   .\install.ps1 -Target vscode -VsixPath .\murad-amoled.vsix

[CmdletBinding()]
param(
    [ValidateSet('vscode', 'cursor', 'all')]
    [string]$Target = 'vscode',

    [string]$VsixPath = '',

    [string]$GitHubRepo = $(if ($env:GITHUB_REPO) { $env:GITHUB_REPO } else { 'AbabilX/nodextheme' })
)

$ErrorActionPreference = 'Stop'
$ThemeName = 'Murad AMOLED'
$ApiUrl = "https://api.github.com/repos/$GitHubRepo/releases/latest"
$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("murad-amoled-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $TempDir | Out-Null
$CleanupVsix = $false
$DownloadedVsix = $null

Write-Host "→ Platform: Windows (PowerShell)"

function Find-LocalVsix {
    $roots = @()
    if ($PSScriptRoot) { $roots += $PSScriptRoot }
    $roots += (Get-Location).Path

    foreach ($root in $roots) {
        $fixed = Join-Path $root 'murad-amoled.vsix'
        if (Test-Path $fixed) { return $fixed }

        $match = Get-ChildItem -Path $root -Filter 'murad-amoled*.vsix' -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        if ($match) { return $match.FullName }
    }
    return $null
}

function Get-LatestVsixUrl {
    Write-Host "→ Fetching latest release from GitHub: $GitHubRepo"
    $release = Invoke-RestMethod -Uri $ApiUrl -Headers @{ 'User-Agent' = 'murad-amoled-installer' }
    $asset = $release.assets | Where-Object { $_.name -like '*.vsix' } | Select-Object -First 1
    if (-not $asset) {
        throw "No .vsix asset on latest release. Upload one at https://github.com/$GitHubRepo/releases"
    }
    return $asset.browser_download_url
}

function Install-IntoEditor {
    param(
        [string]$CommandName,
        [string]$Label,
        [string]$Path
    )

    $cmd = Get-Command $CommandName -ErrorAction SilentlyContinue
    if (-not $cmd) {
        Write-Host "✗ $Label CLI ('$CommandName') not found in PATH."
        return $false
    }

    Write-Host "→ Installing into ${Label}: $Path"
    & $cmd.Source --install-extension $Path --force
    if ($LASTEXITCODE -ne 0) {
        throw "$Label install failed (exit $LASTEXITCODE)"
    }
    return $true
}

try {
    if (-not $VsixPath) {
        $VsixPath = Find-LocalVsix
    }

    if (-not $VsixPath -or -not (Test-Path $VsixPath)) {
        $url = Get-LatestVsixUrl
        $name = Split-Path $url -Leaf
        $DownloadedVsix = Join-Path $TempDir $name
        Write-Host "→ Downloading $name"
        Invoke-WebRequest -Uri $url -OutFile $DownloadedVsix
        $VsixPath = $DownloadedVsix
        $CleanupVsix = $true
    }

    $installed = $false
    switch ($Target) {
        'vscode' {
            if (Install-IntoEditor -CommandName 'code' -Label 'VS Code' -Path $VsixPath) { $installed = $true }
        }
        'cursor' {
            if (Install-IntoEditor -CommandName 'cursor' -Label 'Cursor' -Path $VsixPath) { $installed = $true }
        }
        'all' {
            if (Install-IntoEditor -CommandName 'code' -Label 'VS Code' -Path $VsixPath) { $installed = $true }
            if (Install-IntoEditor -CommandName 'cursor' -Label 'Cursor' -Path $VsixPath) { $installed = $true }
        }
    }

    if (-not $installed) {
        Write-Host ""
        Write-Host "Install failed: editor CLI not found."
        Write-Host "  VS Code: Ctrl+Shift+P → Shell Command: Install 'code' command in PATH"
        Write-Host "  Cursor:  Ctrl+Shift+P → Shell Command: Install 'cursor' command in PATH"
        exit 1
    }

    Write-Host ""
    Write-Host "Done on Windows."
    Write-Host "Reload the window (Ctrl+Shift+P → Developer: Reload Window),"
    Write-Host "then pick theme: Preferences → Color Theme → $ThemeName"
}
finally {
    if ($CleanupVsix -and $DownloadedVsix -and (Test-Path $DownloadedVsix)) {
        Remove-Item -Force $DownloadedVsix -ErrorAction SilentlyContinue
    }
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
    }
}
