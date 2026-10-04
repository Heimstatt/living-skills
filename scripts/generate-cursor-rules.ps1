# Generate .cursor/rules/living-skills.mdc from TEAM.md
$RepoRoot = Split-Path -Parent $PSScriptRoot
$Header = Get-Content "$RepoRoot\.cursor\rules\living-skills-header.mdc" -Raw -Encoding UTF8
$TeamMd = Get-Content "$RepoRoot\TEAM.md" -Raw -Encoding UTF8
Set-Content "$RepoRoot\.cursor\rules\living-skills.mdc" ($Header + $TeamMd) -Encoding UTF8 -NoNewline
Write-Host "✓ .cursor/rules/living-skills.mdc regenerated"
