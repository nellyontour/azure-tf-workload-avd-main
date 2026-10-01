#!/usr/bin/env pwsh
#Requires -Version 7

<#
.SYNOPSIS
  Resets release-please to initial state after cloning from the template.

.DESCRIPTION
  Clears the CHANGELOG and resets the version manifest to 0.0.0 so that
  release-please starts fresh for the new workload repository.

  Run this once after customising the template. Commit the result.

.EXAMPLE
  ./helpers/Reset-ReleasePlease.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Split-Path $PSScriptRoot -Parent

# Reset CHANGELOG
$changelogPath = Join-Path $root 'CHANGELOG.md'
Set-Content -Path $changelogPath -Value @'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- Release notes are generated automatically by release-please. Do not edit manually. -->
---
'@

# Reset version manifest to 0.0.0
$manifestPath = Join-Path $root '.release-please-manifest.json'
Set-Content -Path $manifestPath -Value '{
    ".": "0.0.0"
}'

Write-Host ""
Write-Host release-please reset to 0.0.0" -ForegroundColor Green 
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review and update README.md with your workload description."
Write-Host "  2. Customise iac/main.tf, locals.naming.tf, and your .tfvars file."
Write-Host "  3. Commit: git add -A && git commit -m 'chore: initialise from workload-iac-terraform template'"
Write-Host ""
Write-Host "See docs/deploy/deployment.md for full setup instructions." -ForegroundColor Yellow
